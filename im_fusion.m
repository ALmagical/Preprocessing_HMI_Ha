function []=im_fusion(ha,mdi,savepath)
disp('In fusion');
range1=255;    
[B0,~]=removelimb(ha);      % removelimb���Զ��庯����ʹͼ���������ƽ��
[B0_m,~]=removelimb(mdi);      % removelimb���Զ��庯����ʹͼ���������ƽ��
%B0=ha;
%B0_m=mdi;
%     figure,imshow(B0,[]);title('����ͼƽ��');       % B0��figure2
%     figure,imshow(B0_m,[]);title('��ͼƽ��');       % B0��figure2
%     

% % ��ͼ�������£�%
%     [m n]=size(B0)
%     c(:,:,3)=B0;
%     c(:,:,1)=B0_m;
%     
% % ��ͼ�������ϣ�%
% c(:,:,2)=zeros(4096);

%     figure,imshow(c,[]);title('�ϳ�')      % im_fits:ԭͼ��figure1

[height,width]=size(B0);        % size()����ȡ���������������
[height_m,width_m]=size(B0_m);        % size()����ȡ���������������
for i=1:height
    for j=1:width
        if B0(i,j)==0
            B0(i,j)=1;               % ������ͼ�еı���(��ɫ����)���
        end
    end
end


figure,imshow(B0_m,[]);title('B0_m')      % im_fits:ԭͼ��figure1

B0_m1=B0_m;
for i=1:height_m
    for j=1:width_m
        if B0_m(i,j)<0.5
            B0_m(i,j)=1;               % �󸺼�����
        else
            B0_m(i,j)=0; 
        end
    end
end

%      figure,imshow(B0_m,[]);title('��ͼ��������');       % B0��figure2
%      figure,imshow(B0,[]);title('����ͼƽ����');       % B0��figure2
%     


for i=1:height_m
    for j=1:width_m
        if B0_m1(i,j)>1.5
            B0_m1(i,j)=1;               % �������
        else
            B0_m1(i,j)=0;
        end
    end
end
%       figure,imshow(B0,[]);title('������ͼ�еĺ�ɫ���ֱ��')       % B0:figure3
%       figure,imshow(B0_m1,[]);title('��ͼ��������')               % B0_m1:����

%     B0_m=bwareaopen(B0_m,20);       % ȥ��С��������С��20����ͨ����ֱ��ȥ����
%     B0_m1=bwareaopen(B0_m1,20);

B2=wiener2(B0,[7,7]);       % wiener2��Ϊ��ȥ��
B2_m=wiener2(B0_m,[7,7]);       % wiener2��Ϊ��ȥ��
B2_m1=wiener2(B0_m1,[7,7]);       % wiener2��Ϊ��ȥ��

im_nor=image_normalization(B2,range1);      % image_normalization����һ��
im_nor_m=image_normalization(B2_m,range1);      % image_normalization����һ��
im_nor_m1=image_normalization(B2_m1,range1);      % image_normalization����һ��

%      figure,imshow(im_nor,[]);title('����ͼ��һ��')       % im_nor:��һ�����ͼ��figure4
%      figure,imshow(im_nor_m,[]);title('��ͼ������һ��')       % im_nor:��һ�����ͼ����һ�����ȡֵ��Χ��0-255
%      figure,imshow(im_nor_m1,[]);title('��ͼ������һ��')       % im_nor:��һ�����ͼ����һ�����ȡֵ��Χ��0-255


%      a(:,:,3)=im_nor;
%      a(:,:,1)=im_nor_m;
%      a(:,:,2)=im_nor_m1;
% 
%     figure,imshow(a,[]);title('�ϳ�1');      % im_fits:ԭͼ��figure1


im_nor=im_nor/255;
im_nor_m=im_nor_m/255;
im_nor_m1=im_nor_m1/255;

%     b(:,:,3)=im_nor;
%     b(:,:,1)=im_nor_m;
%     b(:,:,2)=im_nor_m1;

%     figure,imshow(b,[]);title('�ϳ�2')      % im_fits:ԭͼ��figure1


%      figure,imshow(B0,[]);title('����ͼ��һ��1')       % im_nor1:
%      figure,imshow(B0_m,[]);title('��ͼ����')       % im_nor:
%      figure,imshow(B0_m1,[]);title('��ͼ����')       % im_nor1:



im_nor_umbra=imbinarize(B0,0.65);   % ��Ӱ��ֵ
im_nor_Penumbra=imbinarize(B0,0.75);    % ��Ӱ��ֵ

%im_nor_umbra=im2bw(B0,0.55);   % ��Ӱ��ֵ
% im_nor_Penumbra=im2bw(B0,0.80);    % ��Ӱ��ֵ
%     figure,imshow(im_nor_umbra,[]);title('����ͼ��Ӱ')       % im_nor:����ͼ��Ӱ
%     figure,imshow(im_nor_Penumbra,[]);title('����ͼ��Ӱ')       % im_nor:����ͼ��Ӱ
im_nor_umbra=~im_nor_umbra;         % im_nor:����ͼ��Ӱȡ��
im_nor_Penumbra=~im_nor_Penumbra;      % im_nor_b:����ͼ��Ӱȡ��

A4=im_nor_umbra&B0_m;         %������������
A4_1=im_nor_umbra&B0_m1;        %������������
%   A2=edge(im_nor_Penumbra,'sobel');       % ����ͼ��Ӱ��Ե
%     figure,imshow(A2);title('��Ӱ��Ե');
[x3,y3]=find(im_nor_Penumbra==1);      % [x3,y3]������ͼ��Ӱ����

%     A3=edge(A4,'sobel');       % ��ͼ��Ӱ������Ե
[x1,y1]=find(A4==1);      % [x1,y1]����ͼ��Ӱ����(��ɫ)����

%     A5=edge(A4_1,'sobel');      % ��ͼ��Ӱ������Ե
[x2,y2]=find(A4_1==1);      % [x2,y2]����ͼ��Ӱ����(��ɫ)����


figure,imshow(ha,[]);%title('����ͼԭͼ1')      % im_fits:ԭͼ��figure1

hold on;
plot(y3,x3,'g.','MarkerSize',1e-16);           % ��Ӱ-��ɫ
hold on;  
plot(y1,x1,'b.','MarkerSize',1e-16);         % ��Ӱ-����-��ɫ
hold on;  
plot(y2,x2,'r.','MarkerSize',1e-16);         % ��Ӱ-����-��ɫ


print(gcf,'-dpng',savepath);        % ����ͼƬ
end