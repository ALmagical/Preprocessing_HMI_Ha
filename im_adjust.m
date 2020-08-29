function im_result=im_adjust(im_a,im_b,radius_a,radius_b)
%说明：本函数用于将两幅尺寸相同图像中的日面(圆面)大小调整为一致
%要求：radius_a>radius_b，即输入图像a中的日面(圆面)直径是要大于输入图像b中的日面(圆面)
%输出：对图像b进行放大后将日面(圆面)中心作为画面的中心，对图像进行裁剪，使两幅图像尺寸一致
%如果输入不符合要求，程序什么都不做，并将输入图像b作为结果返回
%%
im_result=im_b;
radius_ratio=radius_a/radius_b;
if radius_ratio > 1  %比例不为1时进行调整，为1的话不进行任何操作
    [h_a,w_a]=size(im_a);
    [h_b,w_b]=size(im_b);
    im_b=imresize(im_b,radius_ratio);
    if radius_ratio>1
        x_min=h_b*abs(radius_ratio-1)/2;
        y_min=w_b*abs(radius_ratio-1)/2;
        im_result=imcrop(im_b,[x_min,y_min,w_a-1,h_a-1]); %imcrop后面四个参数为x，y的最小值以及图像的宽度和高度
    end
end
%figure('name','调整大小后的图像');
%imshow(im_result);