function [metric_names, metric_values] = imerror(I_1, I_2, metric_params, input_metric_list)
% MSE,PSNR,CC, ERGAS,,Q, cwssim, MSSIM, SSIM, CM
% I_1,I_2,hlratio, level, or, guardb, K
% Function description:
% 1) CC = imerror(I_1,I_2) - default call computes correlation
% coeffitient between I_1 and I_2 input images,
% I_1, I_2 - single or double precision matrices;
% 2) [metric_1, ..., metric_n] = imerror(I_1,I_2, 'metric_1_name', ..., 'metric_n_name') - call with parameters 'metric_n_name'
% computes a set of metrics on I_1 and I_2 input images;
% 3) Each metric has its own set of inputs:
% metric_params = [hlratio, level, or, guardb, K], 
% hlratio - enhancement scale,
% [level, or, guardb, K] - parameters for CWSSIM calculation,
% default values [hlratio, level, or, guardb, K] = [4, 6,16,0,0].

if isempty(metric_params)
    hlratio = 4;
    level   = 6;
    or      = 16;
    guardb  = 0;
    K       = 5;
elseif numel(metric_params) == 1
    hlratio = metric_params(1);
elseif numel(metric_params) > 1
    hlratio = metric_params(1);
    level   = metric_params(2);
    or      = metric_params(3);
    guardb  = metric_params(4);
    K       = metric_params(5);
end
image_sizes = size(I_1);%RGB1
m1 = mean(I_1(:));%матожидание
m2 = mean(I_2(:));
sig1 = std(double(I_1(:)));%стандарное отклонение
sig2 = std(double(I_2(:)));
covar =cov(I_1(:), I_2(:));
% number of metrics
metrics_number = numel(input_metric_list);

if metrics_number == 0
    CC_Matrix = corrcoef(I_1(:), I_2(:));  % Коэффициент коррелляции, должен быть близким к 1
    CC = CC_Matrix(1,2);
    metric_values = {CC};
    metric_names = 'CC';
else
    metric_values    = cell(1, metrics_number);
    metric_names = cell(1, metrics_number);
    for i=1:metrics_number
        metric_name = input_metric_list{i};%дан список из метрик
                switch metric_name
            case 'MSE'
                MSE = mean((I_1(:) - I_2(:)).^2);
                metric_values{i}    = MSE;
                metric_names{i} = 'MSE';%использованную метрику запишем в массив
            case 'mMSE'
                window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                
                %Normalized cross-correlation:
                mMSE = mMSE_metric(I_1,I_2, window_sizes, overlap_sizes); 
                
                metric_values{i}    = mMSE;
                metric_names{i} = 'mMSE';
            case 'PSNR'
                Imax = double(max(I_1(:)));
                MSE = mean((I_1(:) - I_2(:)).^2);
                PSNR = 10 * log10(Imax*Imax/MSE);
                metric_values{i}    = PSNR;
                metric_names{i} = 'PSNR';
            case 'CC'
                window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                
                %Normalized cross-correlation:
                CC = CC_metric(I_1,I_2, window_sizes, overlap_sizes); 
               
                metric_values{i} = CC;
                metric_names{i} = 'CC';
            case 'Q' % Универсальный индекс качества, [-1,1], ->1
                window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                Q = Q_metric(I_1,I_2, window_sizes, overlap_sizes); 
                metric_values{i} = Q;
                metric_names{i} = 'Q';
            case 'ERGAS'
                 window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                
                ERGAS = ERGAS_metric(I_1,I_2, window_sizes, overlap_sizes,hlratio);  % Общая относительная безразмерная погрешность синтеза
                metric_values{i} = ERGAS;
                metric_names{i} = 'ERGAS';
            case 'CWSSIM'
              cwssim = 0;                                                  % Complex wavelt SSIM
              % cwssim_index shpould be calculated for each channel separately
              if numel(image_sizes) == 3
                  for channel_index = 1:image_sizes(3)
                      cwssim_channel = cwssim_index(I_1(:,:,channel_index), I_2(:,:,channel_index), level, or, guardb, K);
                      cwssim = cwssim + cwssim_channel;
                  end
                  cwssim = cwssim/image_sizes(3);
              elseif numel(image_sizes) == 2
                  cwssim = cwssim_index(I_1, I_2, level, or, guardb, K);
              end
              metric_values{i} = cwssim;
              metric_names{i} = 'CWSSIM';
            case 'MSSIM'
                window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                MSSIM = mSSIM(I_1,I_2, window_sizes, overlap_sizes);
                metric_values{i} = MSSIM;
                metric_names{i} = 'MSSIM';
            case 'SSIM'
                SSIM = ssim(I_1,I_2);
                metric_values{i} = SSIM;
                metric_names{i} = 'SSIM';
            case 'C3'
                window_sizes  = [7, 7];
                overlap_sizes = [1, 1];
                
                %Normalized mean-squared differences:
                C3 = C_3_metric(I_1,I_2, window_sizes, overlap_sizes);

                metric_values{i} = C3;
                metric_names{i} = 'C3';
            case 'C4'
                window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                
                %Normalized cross-correlation:
                C4 = C_4_metric(I_1,I_2, window_sizes, overlap_sizes); 
               
                metric_values{i} = C4;
                metric_names{i} = 'C4';
            case 'MSE_C4'                
                MSE = mean((I_1(:) - I_2(:)).^2);
                
                window_sizes  = [7, 7];
                overlap_sizes = [1, 1];
                
                %Normalized cross-correlation:
                C4 = C_4_metric(I_1,I_2, window_sizes, overlap_sizes);
                
                if(MSE ~= 0)
                    MSE_C4 = C4/MSE;
                else
                    MSE_C4 = 0;
                end
                
                metric_values{i} = MSE_C4;
                metric_names{i} = 'MSE_C4';
            case 'NCD'
                %Normalized colour difference:
                I1_luv =  colorspace('Luv<-RGB',I_1);
                I2_luv =  colorspace('Luv<-RGB',I_2);
                NCD = sqrt((I1_luv(:) - I2_luv(:))' * (I1_luv(:) - I2_luv(:))) / sqrt((I1_luv(:))'*I1_luv(:));
                
                metric_values{i} = NCD;
                metric_names{i} = 'NCD';
            case 'MI'
                MI = mutualInfCalc(I_1, I_2);
                metric_values{i} = MI;
                metric_names{i} = 'MI';
            case  'SAM'
                 window_sizes  = [20, 20];
                overlap_sizes = [1, 1];
                
                SAM = SAM_metric(I_1,I_2, window_sizes, overlap_sizes); 
                metric_values{i} = SAM;
                metric_names{i} = 'SAM';
                
                           
            case    'SAM_simple'
                [h w c]=size(I_1);
                sum=0;
                a=zeros(1,c);
                b=zeros(1,c);
                for k=1:h
                    for j=1:w
                        for l=1:c
                    a(l) = I_1(k,j,l);
                    b(l) = I_2(k,j,l);              
                        end
                        n1 = norm(a(:), 2);
                        n2 = norm(b(:), 2);
                        if a==0|b==0
                        sum=sum+0;
                        else    
                        sum = sum + acos((((a(:))'*b(:))/(n1*n2)))*180/(2*pi) ;
                        end
                    end  
                end  
                
                SAM_simple = sum/(h*w);
                metric_values{i} = SAM_simple;
                metric_names{i} = 'SAM_simple';
            case 'ERGAS_simple'
                
                [h w c]=size(I_1);
                sum=0;
                
                for band=1:c
                    i1 = I_1(:,:,band);
                    i2 = I_2(:,:,band);
                    m1 = mean(i1(:));
                    MSE = mean((i1(:) - i2(:)).^2);
                    sum = sum + MSE/m1^2;
                end    
                
                ERGAS_simple = 100 * hlratio * sqrt(sum/c);   % Общая относительная безразмерная погрешность синтеза
                metric_values{i} = ERGAS_simple;
                metric_names{i} = 'ERGAS_simple';     
                
             case 'Q_simple'
                
                m1 = mean(I_1(:));%матожидание
                m2 = mean(I_2(:));
                sig1 = std(double(I_1(:)));%стандарное отклонение
                sig2 = std(double(I_2(:)));
                covar =cov(I_1(:), I_2(:));
                Q_simple = (4 * m1 * m2 * covar(1,2))/((sig1^2 + sig2^2)*(m1^2 + m2^2));
                metric_values{i} = Q_simple;
                metric_names{i} = 'Q_simple'; 
               
                        
        end
    end
end
end