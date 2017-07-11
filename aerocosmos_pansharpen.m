function [ output_image] = aerocosmos_pansharpen(multi_image_, pan_image_, kernel_size, exp_const, trim_by )

precision   = 'single';
multi_image = im2single(multi_image_);
pan_image   = im2single(pan_image_);
[H W C] = size(multi_image);

numerator   = zeros(size(multi_image), precision);
denominator = zeros(size(pan_image), precision);

energy_sum    = zeros(size(pan_image), precision);
energy_sum_sq = zeros(size(pan_image), precision);
pan_sum       = zeros(size(pan_image), precision);
pan_sum_sq    = zeros(size(pan_image), precision);

multi_energy = sqrt(sum(multi_image .^ 2, 3));
multi_image = multi_image ./ (0.00001 + repmat(multi_energy, [1 1 C]));

%kernel_size = 25;
%trim_by = 4;
n = kernel_size - 1 + 2 .* trim_by; 
k = 1 : n; 
untrimmed_row = [1 cumprod((n - k + 1) ./ k)]';
row = untrimmed_row(1 + trim_by : end - trim_by);
% row = ones([1 kernel_size]);
kernel = single(row * row' ./ (sum(row) .^ 2));

pad_size = (kernel_size - 1) / 2;

multi_pad  = padarray(multi_image, [pad_size pad_size], 'symmetric', 'both');
pan_pad    = padarray(pan_image, [pad_size pad_size], 'symmetric', 'both');%отображенное зеркально по краям
energy_pad = padarray(multi_energy, [pad_size pad_size], 'symmetric', 'both');
radiometric_kernel_size = single(std(pan_image(:)) ./ 1);
kernel_sum = single(0);
x_range = 1 : W;
y_range = 1 : H;
h = waitbar(0, 'Слияние изображений...');
progress = 0.0;
for i = -pad_size : pad_size
    for j = -pad_size : pad_size
        
        multi_shifted  = multi_pad  (pad_size + j + y_range, pad_size + i + x_range, :); %сдвинутые рамки
        pan_shifted    = pan_pad    (pad_size + j + y_range, pad_size + i + x_range, :); 
        energy_shifted = energy_pad (pad_size + j + y_range, pad_size + i + x_range, :); 
        
        spatial_probability = kernel(1 + pad_size + j, 1 + pad_size + i);
        
        energy_sum    = energy_sum    + energy_shifted * spatial_probability;
        energy_sum_sq = energy_sum_sq + (energy_shifted * spatial_probability) .^ 2;
        pan_sum       = pan_sum             + pan_shifted * spatial_probability;
        pan_sum_sq    = pan_sum_sq          + (pan_shifted * spatial_probability) .^ 2;
        kernel_sum    = kernel_sum          + spatial_probability;

        normalized_difference = (pan_shifted - pan_image) ./ radiometric_kernel_size;
        radiometric_probability = single(exp(-exp_const*sum(normalized_difference .^ 2, 3)));
        total_probability = radiometric_probability .* spatial_probability;
        denominator = denominator + total_probability;
        numerator = numerator + multi_shifted .* repmat(total_probability, [1 1 C]);
 
        progress = progress + 1 ./ numel(kernel);
        waitbar(progress, h);
    end
end

% multy_energy = sum(multi_image .^ 2, 3);
pan_energy   = sqrt(sum(pan_image .^ 2, 3));

energy_var = (energy_sum_sq - (energy_sum .^ 2) ./ numel(kernel));
pan_var    = (pan_sum_sq    - (pan_sum    .^ 2) ./ numel(kernel));
corr       = sqrt((energy_var + 0.00001) ./ (pan_var + 0.00001));
energy_mean = energy_sum ./ kernel_sum;
pan_mean    = pan_sum ./ kernel_sum;

restored_energy = energy_mean + corr .* (pan_energy - pan_mean);

energy_swap = 1 ./ restored_energy;
res = numerator ./ (0.00001 + repmat(denominator .* energy_swap, [1 1 C]));

output_image = min(1, max(0, res));

close(h);

end

