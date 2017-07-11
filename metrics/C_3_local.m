function c_3 = C_3_local(I1,I2)
m1 = mean(I1(:));
m2 = mean(I2(:));
if sqrt(sum((I1(:) - m1).^2)*sum((I2(:) - m2).^2))==0
    c_3 = 0;
else
    c_3 = sum(((I1(:) - m1) - (I2(:) - m2)).^2) / sqrt(sum((I1(:) - m1).^2)+sum((I2(:) - m2).^2));
   %c_4 = ((I1(:) - m1)' * (I2(:) - m2)) / sqrt(sum((I1(:)-m1).^2)*sum((I2(:)-m2).^2));
end
end