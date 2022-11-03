
I1 = rgb2gray(I11_rec);
I2 = rgb2gray(I12_rec);

dispmap = disparityPersonal(I1,I2);
d2 = disparityBM(I1,I2);

subplot(121);
imshow(dispmap, [1, 64]);
title('Disparity map using diparityPersonal');
impixelinfo;
colormap jet;
colorbar;

subplot(122);
imshow(d2, [1, 64]);
title('Disparity map using diparityBM');
impixelinfo;
colormap jet;
colorbar;

function dispmap = disparityPersonal(image1,image2)

dispmap = ones(size(image1),'single');
window_size = 50;
half_sample_size = 18;
[height, width] = size(image1);
for y = half_sample_size+1:height-half_sample_size
    for x = half_sample_size+window_size+1:width-half_sample_size
        sample_left = image1(y-half_sample_size:y+half_sample_size, x-half_sample_size:x+half_sample_size);
        offset_optimum = 0;
        SAD_optimum = 100000000000;
        for offset = -window_size+1:-1
            sample_right = image2(y-half_sample_size:y+half_sample_size, x-half_sample_size+offset:x+half_sample_size+offset);
            SAD = sum(sum(abs(sample_right-sample_left)));
            if SAD < SAD_optimum
                SAD_optimum = SAD;
                offset_optimum = offset;
            end
        end
        dispmap(y, x) = abs(offset_optimum);
    end
end

end