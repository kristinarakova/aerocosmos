function C_3 = C_3_metric(img1,img2, window_sizes, overlap_sizes)
c_3 = 0;
number_of_steps = 0;
image_sizes = size(img1);
number_of_bands = image_sizes(3);
for band_num = 1:number_of_bands
    for y = 1:overlap_sizes(1):overlap_sizes(1)*fix((image_sizes(1) - window_sizes(1))/overlap_sizes(1))+1
        for x = 1:overlap_sizes(2):overlap_sizes(2)*fix((image_sizes(2) - window_sizes(2))/overlap_sizes(2))+1
            I1 = img1(y:y+window_sizes(1)-1, x:x+window_sizes(2)-1,band_num);
            I2 = img2(y:y+window_sizes(1)-1, x:x+window_sizes(2)-1,band_num);
            c_3 = c_3 + C_3_local(I1,I2);
            if c_3 == Inf
                display('error');
            end
            number_of_steps = number_of_steps + 1;
            I1 = [];
            I2 = [];
        end
    end
end
C_3 = c_3 / number_of_steps;
end