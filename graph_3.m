%увеличение в 2 раза
kernel=5:2:31
trim=0:5:20
Q_2=reshape(Q_2, [5,14])
surf(kernel, trim, Q_2) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('Q')
 
SAM_2=reshape(SAM_2, [5,14])
surf(kernel, trim, SAM_2) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('SAM')
 
ERGAS_2=reshape(ERGAS_2, [5,14])
surf(kernel, trim, ERGAS_2) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')
 
%увеличение в 4 раза
kernel=5:10:105
trim=5:10:65
Q_4=reshape(Q_4, [7,11])
surf(kernel, trim, Q_4) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('Q')
 
SAM_4=reshape(SAM_4, [7,11])
surf(kernel, trim, SAM_4) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('SAM')
 
ERGAS_4=reshape(ERGAS_4, [7,11])
surf(kernel, trim, ERGAS_4) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')
 
%увеличение в 8 раз
kernel=45:8:109
trim=80:15:200
Q_8=reshape(Q_8, [9,9])
surf(kernel, trim, Q_8) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('Q')
 
SAM_8=reshape(SAM_8, [9,9])
surf(kernel, trim, SAM_8) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('SAM')
 
ERGAS_8=reshape(ERGAS_8, [9,9])
surf(kernel, trim, ERGAS_8) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')