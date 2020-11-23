%%%%
%将输入数据类型调整为uint8
%%%%
%%
function [result]=im_fusion2(ha,mdi,r,threshold_neg,threshold_pos)
%disp('In fusion');
%对比度调整，动态调整应该比较好，固定的阈值会使得部分图片变得更加糟糕                 
ha=imadjust(ha,[],[],1.5);
[h,w]=size(ha);        % size()：获取数组的行数和列数
mdi_pos=zeros(h,w);
mdi_neg=zeros(h,w);
% ha_light=zeros(h,w);
% ha_dark=zeros(h,w);
%调整均值计算方法
%不计算0
mdi_mean=mean2(mdi(mdi>0));
% ha_mean=mean(ha,'all');
thresh_mdi_neg=mdi_mean*threshold_neg;
thresh_mdi_pos=mdi_mean*threshold_pos;
% thresh_ha_light=ha_mean*1.7;
% thresh_ha_dark=ha_mean*1.3;
for i=1:h
    for j=1:w
        if mdi(i,j)<thresh_mdi_neg
            mdi_neg(i,j)=1;
        elseif mdi(i,j)>thresh_mdi_pos
            mdi_pos(i,j)=1;
        end
    end
end

%ha
% for i=1:h
%     for j=1:w
%         if ha(i,j)<thresh_ha_dark
%             ha_dark(i,j)=1;
%         elseif ha(i,j)>thresh_ha_light
%             ha_light(i,j)=1;
%         end
%     end
% end
%figure();
%imshow(ha_dark);
%title('ha_dark');
%figure();
%imshow(ha_light);
%title('ha_light');
%figure,imshow(mdi,[]);title('将黑子图中的黑色部分变白');    
%figure,imshow(mdi_pos,[]);title('磁图正极区域');          % mdi_pos:正极
%figure,imshow(mdi_neg,[]);title('磁图负极区域');          % mdi_neg:负极

%B0_m=bwareaopen(B0_m,20);       % 去掉小面积，面积小于20的连通区域直接去掉
%B0_m1=bwareaopen(B0_m1,20);

%滤波后影响结果
filter_size=[3,3];
%ha=wiener2(ha,filter_size);       % wiener2：为了去噪
%mdi_neg=wiener2(mdi_neg,filter_size);       % wiener2：为了去噪
%mdi_pos=wiener2(mdi_pos,filter_size);       % wiener2：为了去噪
ha=medfilt2(ha,filter_size);
mdi_neg=medfilt2(mdi_neg,filter_size);
mdi_pos=medfilt2(mdi_pos,filter_size);
% 叠加
R=im2double(ha);
G=R;
B=R;

Ha=zeros(h,w,3);
Ha(:,:,1)=R*0.5;
Ha(:,:,2)=Ha(:,:,1);
Ha(:,:,3)=Ha(:,:,1);
center_y=h/2;
center_x=w/2;
r=r-5;
r_2=r*r;
%BW=disk(h,w,r); %掩膜用于将日面外的部分变为黑色
BW=zeros(h,w);

for i=1:h
    for j=1:w
        if (i-center_y)^2+(j-center_x)^2<r_2
            BW(i,j)=1;
        end
    end
end
%%%
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
result=imadd(result*0.2,Ha*0.8);
%调整对比度或者gamma
result=imadjust(result,[],[],0.7);
%figure('name','合成结果');
%imshow(result1);
%imwrite(result,savepath,'jpg','Quality',100);