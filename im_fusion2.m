function []=im_fusion2(ha,mdi,savepath,max_ha,r,threshold_neg,threshold_pos)
disp('In fusion');
ha=ha/max_ha;
%�Աȶȵ�������̬����Ӧ�ñȽϺã��̶�����ֵ��ʹ�ò���ͼƬ��ø������
%ha=imadjust(ha,[0.35,0.95]);
[h,w]=size(ha);        % size()����ȡ���������������
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

%figure,imshow(ha,[]);title('������ͼ�еĺ�ɫ���ֱ��');    
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
R=ha;
G=ha;
B=ha;
center_y=h/2;
center_x=w/2;
r_2=r*r;
BW=disk(h,w,r); %��Ĥ���ڽ�������Ĳ��ֱ�Ϊ��ɫ

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
%figure('name','�ϳɽ��');
%imshow(result);
imwrite(result,savepath,'jpg','Quality',100);