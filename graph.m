%���������� � 2 ����
kernel=5:2:29
trim=0:5:35
mSSIM=reshape(mSSIM, [8,13])
surf(kernel, trim, mSSIM) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
title('mSSIM-metric')
xlabel('kernel')
ylabel('trim')
zlabel('mSSIM')

CC=reshape(CC, [8,13])
surf(kernel, trim, CC) 
grid on 
title('��-metric')
xlabel('kernel')
ylabel('trim')
zlabel('��')

%���������� � 4 ����
kernel=15:4:135
trim=5:5:70
mSSIM=reshape(mSSIM, [14,63])
mSSIM(:,1:2:end)=[]
[kernel,trim]=meshgrid(kernel,trim)
surf(kernel, trim, mSSIM) 
grid on 
title('mSSIM-metric')
xlabel('kernel')
ylabel('trim')
zlabel('mSSIM')


CC=reshape(CC, [14,63])
CC(:,1:2:end)=[]
surf(kernel, trim, CC) 
grid on 
title('��-metric')
xlabel('kernel')
ylabel('trim')
zlabel('��')

%���������� � 8 ���
kernel=45:8:109
trim=80:15:200
mSSIM=reshape(mSSIM, [9,9])
[kernel,trim]=meshgrid(kernel,trim)
surf(kernel, trim, mSSIM) 
grid on 
title('mSSIM-metric')
xlabel('kernel')
ylabel('trim')
zlabel('mSSIM')

CC=reshape(CC, [9,9])
surf(kernel, trim, CC) 
grid on 
title('��-metric')
xlabel('kernel')
ylabel('trim')
zlabel('��')
