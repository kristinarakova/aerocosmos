function c_4 = C_4_local(I1,I2)
m1 = mean(I1(:));
m2 = mean(I2(:));
if sqrt(sum((I1(:)-m1).^2)*sum((I2(:)-m2).^2)) == 0
    c_4 = 0;
else
    c_4 = ((I1(:) - m1)' * (I2(:) - m2)) / sqrt(sum((I1(:)-m1).^2)*sum((I2(:)-m2).^2));
end
end