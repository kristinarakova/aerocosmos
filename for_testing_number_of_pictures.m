directory = 'C:\Users\k.rakova\Desktop\������ ��������\M4\M4_1\������������\test';
images = dir(directory); % ���������, ���������� ����� �����
size_of_dir = size(images); % ������� ���������
num_of_images = size_of_dir(1)-2; % -2, ��� ��� �� ��������� ��� ����� ����� . � ..

metric_names = { 'Q_simple','SAM_simple','ERGAS_simple'};  % ������-������ � ������� ������
size_of_metrics = size(metric_names);
num_of_metrics = size_of_metrics(2); % ���������� ������
xlswrite('result.xls', metric_names, 1, 'B1'); %����� � excel ����� ������ � ������ ������

result_matrix = cell(num_of_images, num_of_metrics+1); % �������� ������� � �����������

image_names = cell(num_of_images,1);
for i=3:(num_of_images+2)
    image_names{i-2} = images(i,1).name;
end
xlswrite('result.xls', image_names, 1, 'A2');
for i=3:(num_of_images+2)
    v = cell(1,num_of_metrics+1);
    %xlswrite('result.xls', images(i,1).name, 1, ['A' num2str(i-1)]);  %����� � excel ���  ������ � ������ �������
    v = get_score(images(i,1).name, metric_names); % ��������� ����� � ������� �� ��� �������
    result_matrix(i,:) = v; % ���������� ��������� � �������� �������
    % result_matrix(i,:) = v.'; , ���� v - ������-�������
    xlswrite('result.xls', v, 1, ['B' num2str(i-1)]); %���������� ��������� � ����
    %xlswrite('result.xls', v.', 1, ['B' num2str(i-1)]);, ���� v - ������-�������
end
