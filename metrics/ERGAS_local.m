function ERGAS = ERGAS_local(I1,I2,hlratio)
                [h w c]=size(I1);
                sum=0;
                
                for band=1:c
                    i1 = I1(:,:,band);
                    i2 = I2(:,:,band);
                    m1 = mean(i1(:));
                    MSE = mean((i1(:) - i2(:)).^2);
                    sum = sum + MSE/m1^2;
                end    
                
                ERGAS = 100 * hlratio * sqrt(sum/c);  
end