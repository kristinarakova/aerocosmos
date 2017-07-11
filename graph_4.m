%увеличение в 2 раза
kernel=25:10:105
trim=0:5:30
q_2=reshape(q_2, [7,9])
surf(kernel, trim, q_2) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('Q')
 
sam_2=reshape(sam_2, [7,9])
surf(kernel, trim, sam_2) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('SAM')
 
ergas_2=reshape(ergas_2, [7,9])
surf(kernel, trim, ergas_2) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')
 
%увеличение в 4 раза
kernel=35:10:145
trim=10:10:100
q_4=reshape(q_4, [10,12])
surf(kernel, trim, q_4) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('Q')
 
sam_4=reshape(sam_4, [10,12])
surf(kernel, trim, sam_4) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('SAM')
 
ergas_4=reshape(ergas_4, [10,12])
surf(kernel, trim, ergas_4) 
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
 
sam_8=reshape(sam_8, [9,9])
surf(kernel, trim, sam_8) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('SAM')
 
ergas_8=reshape(ergas_8, [9,9])
surf(kernel, trim, ergas_8) 
grid on 
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')