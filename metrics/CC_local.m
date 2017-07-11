function cc = CC_local(I1,I2)
CC_Matrix = corrcoef(I1(:), I2(:));
cc = CC_Matrix(1,2);
end