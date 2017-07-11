function MSE = MSE_local(I1,I2)
MSE = mean((I1(:) - I2(:)).^2);
end