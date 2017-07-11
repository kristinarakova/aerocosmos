function score = get_score(image, metric_names)
%Считываем изображения
image_aero_path = 'C:\Users\k.rakova\Desktop\Ракова Кристина\M4\M4_1\Тестирование\test\';
addpath(image_aero_path);

% Комментарий для гитхаба

% home = 'C:\Users\Кристина\Desktop\Учеба\АЭРОКОСМОС\M4_1\M4_1';
% home1 = 'C:\Users\Кристина\Desktop\Учеба\АЭРОКОСМОС\M4_1\home\home\';
% addpath(home);
% addpath(home1);

%ДЛЯ 8-МИ КАНАЛЬНОГО
% %-------------------------------------------------------------------------
% image_path = [image_aero_path image];
% input_metric_list = metric_names;
% addpath(image_path)
% pan_image = im2single(imread('pan.tif'));
% EtalonIm_8 = im2single(imread('mul.tif'));
% [h w c] =size(EtalonIm_8);
% 
% EtalonIm_3 = zeros(h,w,3, 'single');
% EtalonIm_3(:,:,1)=EtalonIm_8(:,:,5);
% EtalonIm_3(:,:,2)=EtalonIm_8(:,:,3);
% EtalonIm_3(:,:,3)=EtalonIm_8(:,:,2);
%-------------------------------------------------------------------------

% ДЛЯ КАЖДОГО КАНАЛА ОТДЕЛЬНО
%-------------------------------------------------------------------------
% image_path = [image_aero_path image];
% input_metric_list = metric_names;
% addpath(image_path)
% 
% pan_image = im2single(imread('pan.tif'));
% [H W C] = size(pan_image);
% 
% EtalonIm_big = zeros(H, W, 3, 'single');
% EtalonIm_big(:,:,1) = im2single(imread('5.tif'));
% EtalonIm_big(:,:,2) = im2single(imread('3.tif'));
% EtalonIm_big(:,:,3) = im2single(imread('2.tif'));
% 
% [H W C] = size(pan_image); 
% EtalonIm_3 = imresize(EtalonIm_big, [H/4 W/4], 'bilinear');
% [h w c] = size(EtalonIm_3);

% --------------------------------------------------------------------------

% ДЛЯ КАЖДОГО КАНАЛА ОТДЕЛЬНО Moscow
%-------------------------------------------------------------------------
image_path = [image_aero_path image];
input_metric_list = metric_names;
addpath(image_path)

pan_image = im2single(imread('pan.tif'));
r = im2single(imread('5.tif'));
g = im2single(imread('3.tif'));
b = im2single(imread('2.tif'));
[H W] = size (r);

EtalonIm_3 = zeros(H, W, 3, 'single');
EtalonIm_3(:,:,1) = im2single(imread('5.tif'));
EtalonIm_3(:,:,2) = im2single(imread('3.tif'));
EtalonIm_3(:,:,3) = im2single(imread('2.tif'));

[h w c] = size(EtalonIm_3);

% --------------------------------------------------------------------------

multi_image = imresize(EtalonIm_3, [h/8 w/8], 'bilinear'); 

[H1 W1 C1] = size(multi_image);
[H W C] = size(pan_image);

%Процедура слияния
multi_image = aerocosmos_enhance(multi_image);

multi = imresize(multi_image, [H W], 'lanczos3');
pan_d = im2double(pan_image);
multi_d = im2double(multi);

%Вводим параметры и метрики
metrics_lib_path = '.\metrics\';
addpath(metrics_lib_path);

exp_const_interval=1000;
kernel_size_interval=145;%по нечетным 
trim_by_interval=170;

metric_params = H1/H;

number_of_metrics = numel(input_metric_list);
sim_matrix = cell(number_of_metrics+1, numel(exp_const_interval)*numel(kernel_size_interval)*numel(trim_by_interval));

[h1 w1 c1] = size(EtalonIm_3);

iteration_number = 1;
    for kernel_size_index = 1:numel(kernel_size_interval)%для каждого значения обоих параметров считается массив из метода+ошибки
        for exp_const_index = 1:numel(exp_const_interval)
            for trim_by_index = 1:numel(trim_by_interval)
            kernel_size = kernel_size_interval(kernel_size_index);
            exp_const = exp_const_interval(exp_const_index);
            trim_by = trim_by_interval(trim_by_index);
            OutIm = aerocosmos_pansharpen(multi_d, pan_d, kernel_size, exp_const,trim_by);
            OutImResize = imresize(OutIm, [h1 w1], 'bilinear');
            EtalonIm_3 = aerocosmos_enhance(EtalonIm_3);
            [metric_names, metric_values] = imerror(EtalonIm_3,OutImResize, metric_params, input_metric_list);
            
            for mertic_index =1:number_of_metrics
                sim_matrix{mertic_index, iteration_number} = metric_values{mertic_index};%записываем ошибку данной метрики на данной итерации
            end
            sim_matrix{number_of_metrics+1, iteration_number} = [kernel_size, exp_const, trim_by];%в последнюю строку записываем параметры
            iteration_number = iteration_number + 1;
            end
        end
    end


% opt_metric_list=cell(number_of_metrics, 3);

% for metric_index =1:number_of_metrics
%     opt_metric_list{metric_index,1}=input_metric_list{metric_index};
%     [best_error, best_index] = max([sim_matrix{metric_index,:}]);
%     opt_metric_list{metric_index,2}=best_error;
%     opt_metric_list{metric_index,3}=sim_matrix{number_of_metrics+1,best_index};
% end    
score = sim_matrix.'
end