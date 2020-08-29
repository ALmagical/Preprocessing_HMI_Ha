function [center,radius]=my_circlefit(img,downsample_size,h,w)
%%
%my_circlefit用于找出输入图像img中存在的圆，返回值为圆心坐标和圆的半径
%画面中可能存在多个圆，因此圆心坐标可能有多对，半径的值也可能存在多个
%img为输入图像，downsample_size为计算过程中将图像缩放到的尺寸，h，w分别为图像的
%高度和宽度
%%
%高斯滤波以平滑图像
gaus_kernel = fspecial('gaussian',[5,5],1);
img_filter = imfilter(img,gaus_kernel,'replicate');
%下采样，减少计算量
downsample_ratio=h/downsample_size; %将图像缩小到downsample_size
img_low=imresize(img_filter,[int16(h/downsample_ratio),int16(w/downsample_ratio)]);
%二值化
img_edge=imbinarize(img_low);
[h_edge,w_edge]=size(img_edge);
r_range=min(h_edge,w_edge);
%调试时用
%figure();
%imshow(ha_edge);
%圆拟合，找出图像中存在的圆面的半径和圆心
[center,radius]=imfindcircles(img_edge,[int16(r_range*0.2),r_range],'Method','TwoStage','Sensitivity',0.9);%TwoStage指定拟合方法为霍夫变换