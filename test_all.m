
%Считываем изображения
image_aero_path = 'C:\Users\k.rakova\Desktop\Ракова Кристина\M4\M4_1\Тестирование\cut_aero\';
image_exrta_path = 'C:\Users\k.rakova\Desktop\Ракова Кристина\M4\M4_1\Тестирование\cut_extra\';
addpath(image_aero_path);
addpath(image_exrta_path);

%ДЛЯ 4-Х КАНАЛЬНОГО  - ВСЕ КАНАЛЫ
% -------------------------------------------------------------------------
image = [image_aero_path '042_RP_Egypt_Pyramids'];
addpath(image);

pan_image = im2single(imread('_G_10.tif'));
[H W C] = size(pan_image);

EtalonIm_4 = zeros(H/3, W/3, 4, 'single');
EtalonIm_4(:,:,1) = im2single(imread('_G_21.tif'));
EtalonIm_4(:,:,2) = im2single(imread('_G_22.tif'));
EtalonIm_4(:,:,3) = im2single(imread('_G_23.tif'));
EtalonIm_4(:,:,4) = im2single(imread('_G_33.tif'));


[h w c] = size(EtalonIm_4);

multi_image = imresize(EtalonIm_4, [h/2 w/2], 'bilinear'); 

[H1 W1 C1] = size(multi_image);
[H W C] = size(pan_image);

%Процедура слияния
multi_image = aerocosmos_enhance(multi_image);

multi = imresize(multi_image, [H W], 'lanczos3');
%multi = imresize(multi_image, [H W], 'nearest');

pan_d = im2double(pan_image);
multi_d = im2double(multi);

%Вводим параметры и метрики

exp_const_interval=1000;
kernel_size_interval=7:2:25;%по нечетным 
trim_by_interval=0:5:15;
metric_params = H1/H;
input_metric_list = { 'Q_simple', 'SAM_simple','ERGAS_simple'};

number_of_metrics = numel(input_metric_list);
sim_matrix = cell(number_of_metrics+1, numel(exp_const_interval)*numel(kernel_size_interval)*numel(trim_by_interval));

[h1 w1 c1] = size(EtalonIm_4);

% out=aerocosmos_pansharpen(EtalonIm_big, pan_image, kernel_size, exp_const,trim_by);
% imwrite(im2uint16(EtalonIm_big), '1.png');
% imwrite(im2uint16(out), '2.png');


iteration_number = 1;
    for kernel_size_index = 1:numel(kernel_size_interval)%для каждого значения обоих параметров считается массив из метода+ошибки
        for exp_const_index = 1:numel(exp_const_interval)
            for trim_by_index = 1:numel(trim_by_interval)
            kernel_size = kernel_size_interval(kernel_size_index);
            exp_const = exp_const_interval(exp_const_index);
            trim_by = trim_by_interval(trim_by_index);
            OutIm = aerocosmos_pansharpen(multi_d, pan_d, kernel_size, exp_const,trim_by);
            OutImResize = imresize(OutIm, [h1 w1], 'bilinear');
            EtalonIm_4 = aerocosmos_enhance(EtalonIm_4);
            [metric_names, metric_values] = imerror(EtalonIm_4,OutImResize, metric_params, input_metric_list);
            
            for mertic_index =1:number_of_metrics
                sim_matrix{mertic_index, iteration_number} = metric_values{mertic_index};%записываем ошибку данной метрики на данной итерации
            end
            sim_matrix{number_of_metrics+1, iteration_number} = [kernel_size, exp_const, trim_by];%в последнюю строку записываем параметры
            iteration_number = iteration_number + 1;
            end
        end
    end
%sim_matrix=sim_matrix.';

% opt_metric_list=cell(number_of_metrics, 3);
% 
% for metric_index =1:number_of_metrics
%     opt_metric_list{metric_index,1}=input_metric_list{metric_index};
%     [best_error, best_index] = max([sim_matrix{metric_index,:}]);
%     opt_metric_list{metric_index,2}=best_error;
%     opt_metric_list{metric_index,3}=sim_matrix{number_of_metrics+1,best_index};
% end    
