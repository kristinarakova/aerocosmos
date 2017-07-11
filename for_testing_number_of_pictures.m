directory = 'C:\Users\k.rakova\Desktop\–акова  ристина\M4\M4_1\“естирование\test';
images = dir(directory); % структура, содержаща€ имена папок
size_of_dir = size(images); % размеры структуры
num_of_images = size_of_dir(1)-2; % -2, так как он добавл€ет две левые папки . и ..

metric_names = { 'Q_simple','SAM_simple','ERGAS_simple'};  % вектор-строка с именами метрик
size_of_metrics = size(metric_names);
num_of_metrics = size_of_metrics(2); % количество метрик
xlswrite('result.xls', metric_names, 1, 'B1'); %пишем в excel имена метрик в первую строку

result_matrix = cell(num_of_images, num_of_metrics+1); % конечна€ матрица с результатом

image_names = cell(num_of_images,1);
for i=3:(num_of_images+2)
    image_names{i-2} = images(i,1).name;
end
xlswrite('result.xls', image_names, 1, 'A2');
for i=3:(num_of_images+2)
    v = cell(1,num_of_metrics+1);
    %xlswrite('result.xls', images(i,1).name, 1, ['A' num2str(i-1)]);  %пишем в excel им€  метрик в первый столбец
    v = get_score(images(i,1).name, metric_names); % запускаем метод и считаем на нем метрики
    result_matrix(i,:) = v; % записываем результат в конечную матрицу
    % result_matrix(i,:) = v.'; , если v - вектор-столбец
    xlswrite('result.xls', v, 1, ['B' num2str(i-1)]); %записываем результат в файл
    %xlswrite('result.xls', v.', 1, ['B' num2str(i-1)]);, если v - вектор-столбец
end
