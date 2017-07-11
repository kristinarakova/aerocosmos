function SAM = SAM_local(I1,I2)
               [h w c]=size(I1);
               
                for i=1:h
                    for j=1:w
                    a=zeros(1,3);
                    b=zeros(1,3);
                    a(1) = I1(i,j,1);
                    a(2) = I1(i,j,2);
                    a(3) = I1(i,j,3);
                    
                    b(1) = I2(i,j,1);
                    b(2) = I2(i,j,2);
                    b(3) = I2(i,j,3); 
                    
                    n1 = norm(a(:), 2);
                    n2 = norm(b(:), 2);
                    SAM= acos((((a(:))'*b(:))/(n1*n2)))*180/(2*pi) ;
                    end  
                end
                
end                