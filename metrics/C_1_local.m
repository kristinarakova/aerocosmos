function c_1 = C_1_local(I1,I2)
c_1 = sum((I1(:) - I2(:)).^2) / sqrt(sum(I1(:).^2)*sum(I2(:).^2));
end