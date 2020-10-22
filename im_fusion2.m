function []=im_fusion2(ha,mdi,savepath,max_ha,r,threshold_neg,threshold_pos)
disp('In fusion');
ha=ha/max_ha;
%对比度调整，动态调整应该比较好，固定的阈值会使得部分图片变得更加糟糕
%ha=imadjust(ha,[0.35,0.95]);
[h,w]=size(ha);        % size()：获取数组的行数和列数
mdi_pos=mdi;
mdi_neg=mdi;
for i=1:h
    for j=1:w
        if mdi(i,j)<threshold_neg
            mdi_neg(i,j)=1;
        else
            mdi_neg(i,j)=0;
        end
        if mdi(i,j)>threshold_pos
            mdi_pos(i,j)=1;
        else
            mdi_pos(i,j)=0;
        end
    end
end

%figure,imshow(ha,[]);title('将黑子图中的黑色部分变白');    
%figure,imshow(mdi_pos,[]);title('磁图正极区域');          % mdi_pos:正极
%figure,imshow(mdi_neg,[]);title('磁图负极区域');          % mdi_neg:负极

%B0_m=bwareaopen(B0_m,20);       % 去掉小面积，面积小于20的连通区域直接去掉
%B0_m1=bwareaopen(B0_m1,20);

%滤波后影响结果
%filter_size=[7,7];
%ha=wiener2(ha,filter_size);       % wiener2：为了去噪
%mdi_neg=wiener2(mdi_neg,filter_size);       % wiener2：为了去噪
%mdi_pos=wiener2(mdi_pos,filter_size);       % wiener2：为了去噪

% 叠加
R=ha;
G=ha;
B=ha;
center_y=h/2;
center_x=w/2;
r_2=r*r;
BW=disk(h,w,r); %掩膜用于将日面外的部分变为黑色

for i=1:h
    for j=1:w
        if (i-center_y)^2+(j-center_x)^2>r_2
            BW(i,j)=0;
        end
    end
end
R=R.*~mdi_pos;
R=R.*BW;
R(isnan(R)) = 0;
G=G.*~mdi_pos;
G=G.*~mdi_neg;
G=G.*BW;
G(isnan(G)) = 0;
B=B.*~mdi_neg;
B=B.*BW;
B(isnan(B)) = 0;

result=zeros(h,w,3);
result(:,:,1)=R;
result(:,:,2)=G;
result(:,:,3)=B;
%figure('name','合成结果');
%imshow(result);
imwrite(result,savepath,'jpg','Quality',100);