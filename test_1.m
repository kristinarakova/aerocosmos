clear all;
%Считываем изображения
image_aero_path = 'C:\Users\k.rakova\Desktop\Ракова Кристина\M4\M4_1\Тестирование\cut_aero\';
image_exrta_path = 'C:\Users\k.rakova\Desktop\Ракова Кристина\M4\M4_1\Тестирование\cut_extra';
addpath(image_aero_path);
addpath(image_exrta_path);

%-------------------------------------------------------------------------
%ДЛЯ 8-МИ КАНАЛЬНОГО
%-------------------------------------------------------------------------
% pan_image = im2single(imread('pan.tif'));
% EtalonIm_8 = im2single(imread('mul.tif'));
% [h w c] =size(EtalonIm_8);
% 
% EtalonIm_3 = zeros(h,w,3, 'single');
% EtalonIm_3(:,:,1)=EtalonIm_8(:,:,5);
% EtalonIm_3(:,:,2)=EtalonIm_8(:,:,3);
% EtalonIm_3(:,:,3)=EtalonIm_8(:,:,2);
% [h w c] = size(EtalonIm_3);
%-------------------------------------------------------------------------
%Для RGB
%-------------------------------------------------------------------------
%  pan_image = im2single(imread('base_pan1.tiff'));
%  EtalonIm_3 = im2single(imread('RGB1.tiff'));
%  [h w c] = size(EtalonIm_3);
% -------------------------------------------------------------------------
% ДЛЯ КАЖДОГО КАНАЛА ОТДЕЛЬНО
%-------------------------------------------------------------------------
% image = [image_aero_path '001_РП_Gelendzik_field'];
% addpath(image);
% 
% pan_image = im2single(imread('pan.tiff'));
% [H W C] = size(pan_image);
% 
% EtalonIm_big = zeros(H, W, 3, 'single');
% EtalonIm_big(:,:,1) = im2single(imread('r.tiff'));
% EtalonIm_big(:,:,2) = im2single(imread('g.tiff'));
% EtalonIm_big(:,:,3) = im2single(imread('b.tiff'));
% 
% EtalonIm_3 = imresize(EtalonIm_big, [H/3 W/3], 'bilinear');
% [h w c] = size(EtalonIm_3);

%--------------------------------------------------------------------------
% ДЛЯ КАЖДОГО КАНАЛА ОТДЕЛЬНО Moscow
%-------------------------------------------------------------------------
% image = [image_aero_path '040_WV-3_Moscow_Natoinal_Guard_base'];
% addpath(image);
% 
% pan_image = im2single(imread('0.tif'));
% 
% EtalonIm_3(:,:,1) = im2single(imread('5.tif'));
% EtalonIm_3(:,:,2) = im2single(imread('3.tif'));
% EtalonIm_3(:,:,3) = im2single(imread('2.tif'));
% 
% [h w c] = size(EtalonIm_3);
%-------------------------------------------------------------------------
multi_image = imresize(EtalonIm_3, [h/2 w/2], 'bilinear'); 

[H1 W1 C1] = size(multi_image);
[H W C] = size(pan_image);

%Процедура слияния
multi_image = aerocosmos_enhance(multi_image);

multi = imresize(multi_image, [H W], 'lanczos3');
%multi = aerocosmos_enhance(multi);
pan_d = im2double(pan_image);
multi_d = im2double(multi);

%Вводим параметры и метрики
metrics_lib_path = '.\metrics\';
addpath(metrics_lib_path);

exp_const_interval=1000;
kernel_size_interval=1:2:21;%по нечетным 
trim_by_interval=0;

metric_params = H1/H;
input_metric_list = {'Q_simple', 'SAM_simple','ERGAS_simple'};

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
           % OutIm = aerocosmos_enhance(OutIm);
            OutImResize = imresize(OutIm, [h1 w1], 'bilinear');
            OutImResize = aerocosmos_enhance(OutImResize);
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
    sim_matrix=sim_matrix.';
 
