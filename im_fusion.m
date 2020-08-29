function []=im_fusion(ha,mdi,savepath)
disp('In fusion');
range1=255;    
[B0,~]=removelimb(ha);      % removelimb：自定义函数，使图变得明亮、平滑
[B0_m,~]=removelimb(mdi);      % removelimb：自定义函数，使图变得明亮、平滑
%B0=ha;
%B0_m=mdi;
%     figure,imshow(B0,[]);title('黑子图平滑');       % B0：figure2
%     figure,imshow(B0_m,[]);title('磁图平滑');       % B0：figure2
%     

% % 叠图代码如下：%
%     [m n]=size(B0)
%     c(:,:,3)=B0;
%     c(:,:,1)=B0_m;
%     
% % 叠图代码如上：%
% c(:,:,2)=zeros(4096);

%     figure,imshow(c,[]);title('合成')      % im_fits:原图，figure1

[height,width]=size(B0);        % size()：获取数组的行数和列数
[height_m,width_m]=size(B0_m);        % size()：获取数组的行数和列数
for i=1:height
    for j=1:width
        if B0(i,j)==0
            B0(i,j)=1;               % 将黑子图中的背景(黑色部分)变白
        end
    end
end


figure,imshow(B0_m,[]);title('B0_m')      % im_fits:原图，figure1

B0_m1=B0_m;
for i=1:height_m
    for j=1:width_m
        if B0_m(i,j)<0.5
            B0_m(i,j)=1;               % 求负极区域
        else
            B0_m(i,j)=0; 
        end
    end
end

%      figure,imshow(B0_m,[]);title('磁图负极区域');       % B0：figure2
%      figure,imshow(B0,[]);title('黑子图平滑后');       % B0：figure2
%     


for i=1:height_m
    for j=1:width_m
        if B0_m1(i,j)>1.5
            B0_m1(i,j)=1;               % 求出正极
        else
            B0_m1(i,j)=0;
        end
    end
end
%       figure,imshow(B0,[]);title('将黑子图中的黑色部分变白')       % B0:figure3
%       figure,imshow(B0_m1,[]);title('磁图正极区域')               % B0_m1:正极

%     B0_m=bwareaopen(B0_m,20);       % 去掉小面积，面积小于20的连通区域直接去掉。
%     B0_m1=bwareaopen(B0_m1,20);

B2=wiener2(B0,[7,7]);       % wiener2：为了去噪
B2_m=wiener2(B0_m,[7,7]);       % wiener2：为了去噪
B2_m1=wiener2(B0_m1,[7,7]);       % wiener2：为了去噪

im_nor=image_normalization(B2,range1);      % image_normalization：归一化
im_nor_m=image_normalization(B2_m,range1);      % image_normalization：归一化
im_nor_m1=image_normalization(B2_m1,range1);      % image_normalization：归一化

%      figure,imshow(im_nor,[]);title('黑子图归一化')       % im_nor:归一化后的图，figure4
%      figure,imshow(im_nor_m,[]);title('磁图负极归一化')       % im_nor:归一化后的图，归一化后的取值范围：0-255
%      figure,imshow(im_nor_m1,[]);title('磁图正极归一化')       % im_nor:归一化后的图，归一化后的取值范围：0-255


%      a(:,:,3)=im_nor;
%      a(:,:,1)=im_nor_m;
%      a(:,:,2)=im_nor_m1;
% 
%     figure,imshow(a,[]);title('合成1');      % im_fits:原图，figure1


im_nor=im_nor/255;
im_nor_m=im_nor_m/255;
im_nor_m1=im_nor_m1/255;

%     b(:,:,3)=im_nor;
%     b(:,:,1)=im_nor_m;
%     b(:,:,2)=im_nor_m1;

%     figure,imshow(b,[]);title('合成2')      % im_fits:原图，figure1


%      figure,imshow(B0,[]);title('黑子图归一化1')       % im_nor1:
%      figure,imshow(B0_m,[]);title('磁图负极')       % im_nor:
%      figure,imshow(B0_m1,[]);title('磁图正极')       % im_nor1:



im_nor_umbra=imbinarize(B0,0.65);   % 本影阈值
im_nor_Penumbra=imbinarize(B0,0.75);    % 半影阈值

%im_nor_umbra=im2bw(B0,0.55);   % 本影阈值
% im_nor_Penumbra=im2bw(B0,0.80);    % 半影阈值
%     figure,imshow(im_nor_umbra,[]);title('黑子图本影')       % im_nor:黑子图本影
%     figure,imshow(im_nor_Penumbra,[]);title('黑子图半影')       % im_nor:黑子图本影
im_nor_umbra=~im_nor_umbra;         % im_nor:黑子图本影取反
im_nor_Penumbra=~im_nor_Penumbra;      % im_nor_b:黑子图半影取反

A4=im_nor_umbra&B0_m;         %负极与运算结果
A4_1=im_nor_umbra&B0_m1;        %正极与运算结果
%   A2=edge(im_nor_Penumbra,'sobel');       % 黑子图半影边缘
%     figure,imshow(A2);title('半影边缘');
[x3,y3]=find(im_nor_Penumbra==1);      % [x3,y3]：黑子图半影坐标

%     A3=edge(A4,'sobel');       % 磁图本影负极边缘
[x1,y1]=find(A4==1);      % [x1,y1]：磁图本影负极(黑色)坐标

%     A5=edge(A4_1,'sobel');      % 磁图本影正极边缘
[x2,y2]=find(A4_1==1);      % [x2,y2]：磁图本影正极(白色)坐标


figure,imshow(ha,[]);%title('黑子图原图1')      % im_fits:原图，figure1

hold on;
plot(y3,x3,'g.','MarkerSize',1e-16);           % 半影-绿色
hold on;  
plot(y1,x1,'b.','MarkerSize',1e-16);         % 本影-负极-蓝色
hold on;  
plot(y2,x2,'r.','MarkerSize',1e-16);         % 本影-正极-红色


print(gcf,'-dpng',savepath);        % 保存图片
end