function Q = Q_metric(img1,img2, window_sizes, overlap_sizes)
q = 0;
number_of_steps = 0;
image_sizes = size(img1);


for y = 1:overlap_sizes(1):overlap_sizes(1)*fix((image_sizes(1) - window_sizes(1))/overlap_sizes(1))+1
    for x = 1:overlap_sizes(2):overlap_sizes(2)*fix((image_sizes(2) - window_sizes(2))/overlap_sizes(2))+1
        I1 = img1(y:y+window_sizes(1)-1, x:x+window_sizes(2)-1,:);
        I2 = img2(y:y+window_sizes(1)-1, x:x+window_sizes(2)-1,:);
        q = q + Q_local(I1,I2);
        number_of_steps = number_of_steps + 1;
    end
end

Q = q / number_of_steps;
end