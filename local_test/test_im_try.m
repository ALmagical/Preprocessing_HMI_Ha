%%
%%%
%%
im_1=imread('D:\Dataset\Test\OUT\BBSO\2010\bbso_halph_fl_20100503_221323.jpg');
figure('Name','image_1');
imshow(im_1);
im_1=imadjust(im_1,[],[],0.5);
im_2=imfilter(im_1,fspecial('average',5));
im_3=imfilter(im_2,fspecial('average',3));
im_bif=bilateralFilter(im2double(im_3));
im_1=imread('D:\Dataset\Test\OUT\BBSO\2010\bbso_halph_fl_20100503_221323.jpg');
figure('Name','bilateralFilter');
imshow(im_bif);