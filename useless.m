for i=1:h
    for j=1:w
        if (i-center_y)^2+(j-center_x)^2<r_2
            if mdi_neg==1
                R(i,j)=0;
                G(i,j)=0;
                B(i,j)=255;
            end
            if mdi_pos==1
                R(i,j)=255;
                G(i,j)=0;
                B(i,j)=0;
            end
       % end
    end
    end
[x_mdi_neg,y_mdi_neg]=find(mdi_neg==1);
R(x_mdi_neg,y_mdi_neg)=0;
G(x_mdi_neg,y_mdi_neg)=0;
B(x_mdi_neg,y_mdi_neg)=255;

[x_mdi_pos,y_mdi_pos]=find(mdi_pos==1);
R(x_mdi_pos,y_mdi_pos)=0;
G(x_mdi_pos,y_mdi_pos)=0;
B(x_mdi_pos,y_mdi_pos)=255;

function []=im_fusion2(ha,mdi,savepath,max_ha,r)
disp('In fusion');
range=255;
ha=ha/max_ha;
[h,w]=size(ha);        % size()����ȡ���������������
mdi_pos=mdi;
mdi_neg=mdi;
for i=1:h
    for j=1:w
        %if ha(i,j)==0
            %ha(i,j)=1;               % ������ͼ�еı���(��ɫ����)���
        %end
        if mdi(i,j)<0.5
            mdi_neg(i,j)=1;
        else
            mdi_neg(i,j)=0;
        end
        if mdi(i,j)>1.5
            mdi_pos(i,j)=1;
        else
            mdi_pos(i,j)=0;
        end
    end
end

figure,imshow(ha,[]);title('������ͼ�еĺ�ɫ���ֱ��');    
figure,imshow(mdi_pos,[]);title('��ͼ��������');          % mdi_pos:����
figure,imshow(mdi_neg,[]);title('��ͼ��������');          % mdi_neg:����

%B0_m=bwareaopen(B0_m,20);       % ȥ��С��������С��20����ͨ����ֱ��ȥ��
%B0_m1=bwareaopen(B0_m1,20);
filter_size=[7,7];
ha=wiener2(ha,filter_size);       % wiener2��Ϊ��ȥ��
mdi_neg=wiener2(mdi_neg,filter_size);       % wiener2��Ϊ��ȥ��
mdi_pos=wiener2(mdi_pos,filter_size);       % wiener2��Ϊ��ȥ��

ha_nor=image_normalization(ha,range);      % image_normalization����һ��
mdi_neg_nor=image_normalization(mdi_neg,range);      % image_normalization����һ��
mdi_pos_nor=image_normalization(mdi_pos,range);      % image_normalization����һ��

% ����
R=ha;
G=ha;
B=ha;
[x_mdi_neg,y_mdi_neg]=find(mdi_neg==1);
R(x_mdi_neg,y_mdi_neg)=0;
G(x_mdi_neg,y_mdi_neg)=0;
B(x_mdi_neg,y_mdi_neg)=255;

[x_mdi_pos,y_mdi_pos]=find(mdi_pos==1);
R(x_mdi_pos,y_mdi_pos)=0;
G(x_mdi_pos,y_mdi_pos)=0;
B(x_mdi_pos,y_mdi_pos)=255;

[x_ha,y_ha]=find(ha==0);
R(x_ha,y_ha)=0;
G(x_ha,y_ha)=0;
B(x_ha,y_ha)=0;
result=zeros(h,w,3);
result(:,:,1)=R;
result(:,:,2)=G;
result(:,:,3)=B;
figure('name','�ϳɽ��');
imshow(result);