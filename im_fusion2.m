%%%%
%�������������͵���Ϊuint8
%%%%
%%
function []=im_fusion2(ha,mdi,savepath,r,threshold_neg,threshold_pos)
disp('In fusion');
%�Աȶȵ�������̬����Ӧ�ñȽϺã��̶�����ֵ��ʹ�ò���ͼƬ��ø������                 
%ha=imadjust(ha,[0.35,0.95]);
[h,w]=size(ha);        % size()����ȡ���������������
mdi_pos=zeros(h,w);
mdi_neg=zeros(h,w);
% ha_light=zeros(h,w);
% ha_dark=zeros(h,w);
%������ֵ���㷽��
mdi_mean=mean(mdi,'all');
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
%figure,imshow(mdi,[]);title('������ͼ�еĺ�ɫ���ֱ��');    
%figure,imshow(mdi_pos,[]);title('��ͼ��������');          % mdi_pos:����
%figure,imshow(mdi_neg,[]);title('��ͼ��������');          % mdi_neg:����

%B0_m=bwareaopen(B0_m,20);       % ȥ��С��������С��20����ͨ����ֱ��ȥ��
%B0_m1=bwareaopen(B0_m1,20);

%�˲���Ӱ����
%filter_size=[7,7];
%ha=wiener2(ha,filter_size);       % wiener2��Ϊ��ȥ��
%mdi_neg=wiener2(mdi_neg,filter_size);       % wiener2��Ϊ��ȥ��
%mdi_pos=wiener2(mdi_pos,filter_size);       % wiener2��Ϊ��ȥ��

% ����
R=im2double(ha);
G=R;
B=R;

%Ha=zeros(h,w,3);
%Ha(:,:,1)=R;
%Ha(:,:,2)=R;
%Ha(:,:,3)=R;
center_y=h/2;
center_x=w/2;
r=r-5;
r_2=r*r;
%BW=disk(h,w,r); %��Ĥ���ڽ�������Ĳ��ֱ�Ϊ��ɫ
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
result=imadd(result,Ha);
%figure('name','�ϳɽ��');
%imshow(result1);
imwrite(result,savepath,'jpg','Quality',100);