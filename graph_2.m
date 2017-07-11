%увеличение в 2 раза
kernel=5:2:31
trim=0:5:20
Q=reshape(Q, [5,14])
surf(kernel, trim, Q) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
title('Q-metric')
xlabel('kernel')
ylabel('trim')
zlabel('Q')

SAM=reshape(SAM, [5,14])
surf(kernel, trim, SAM) 
grid on 
title('SAM-metric')
xlabel('kernel')
ylabel('trim')
zlabel('SAM')

ERGAS=reshape(ERGAS, [5,14])
surf(kernel, trim, ERGAS) 
grid on 
title('ERGAS-metric')
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')

%увеличение в 4 раза
kernel=5:10:105
trim=0:10:70
Q=reshape(Q, [8,11])
surf(kernel, trim, Q) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
title('Q-metric')
xlabel('kernel')
ylabel('trim')
zlabel('Q')

SAM=reshape(SAM, [8,11])
surf(kernel, trim, SAM) 
grid on 
title('SAM-metric')
xlabel('kernel')
ylabel('trim')
zlabel('SAM')

ERGAS=reshape(ERGAS, [8,11])
surf(kernel, trim, ERGAS) 
grid on 
title('ERGAS-metric')
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')

%увеличение в 8 раз
kernel=45:8:109
trim=80:15:200
Q=reshape(Q, [9,9])
surf(kernel, trim, Q) 
[kernel,trim]=meshgrid(kernel,trim)
grid on 
title('Q-metric')
xlabel('kernel')
ylabel('trim')
zlabel('Q')

SAM=reshape(SAM, [9,9])
surf(kernel, trim, SAM) 
grid on 
title('SAM-metric')
xlabel('kernel')
ylabel('trim')
zlabel('SAM')

ERGAS=reshape(ERGAS, [9,9])
surf(kernel, trim, ERGAS) 
grid on 
title('ERGAS-metric')
xlabel('kernel')
ylabel('trim')
zlabel('ERGAS')
