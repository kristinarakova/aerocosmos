function Q = Q_local(I1,I2)
                m1 = mean(I1(:));%матожидание
                m2 = mean(I2(:));
                sig1 = std(double(I1(:)));%стандарное отклонение
                sig2 = std(double(I2(:)));
                covar =cov(I1(:), I2(:));
                Q = (4 * m1 * m2 * covar(1,2))/((sig1^2 + sig2^2)*(m1^2 + m2^2)); 
end