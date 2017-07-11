function c_2 = C_2_local(I1,I2)
c_2 = sum(I1(:) - I2(:)) / sqrt(sum(I1(:).^2)*sum(I2(:).^2));
end