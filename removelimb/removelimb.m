function [B0,dx,dy,r]=removelimb(B)

B=double(B);

% figure('name','input');
% imshow(uint8(B));
[M,N]=size(B);
%Level=round((M/1024));
Level=1;
M1=round(M/Level);
N1=round(M/Level);

BM=(max(B(:))-min(B(:)));
Bmin=min(B(:));

B1=(B-Bmin)/BM;
[H,L1]=imhist(B1,100);
%[H,L1]=hist(B1(:),100);
T=find(H(20:50)==min(H(20:50)))+19;
figure('name','hist');
plot(H);
I0=imbinarize(B1,L1(T(1))); %0.2��ֵ��ȡ��ֵͼ

% if M*N-sum(I0(:))<M*N/4 ; fprintf(' %s \n','ͼ�������ȫ����̫���� ������');
%     Bout=zeros(M,N);
% else
bw = bwperim(I0,8);
clear I0;
[x,y]=find(bw);
%r_range_ha=min(M,N);
%[center,radius]=imfindcircles(B,[int16(r_range_ha*0.2),r_range_ha],'Method','TwoStage','Sensitivity',0.9);
%x0=center(1);
%y0=center(2);
%r=radius;
[x0,y0,r] = circfit(x,y); %Բ���

%%%��������
dx=round((M)/2-x0);
dy=round((N)/2-y0);
B=circshift(B,[dx,dy]); %ƽ��ͼ�����ĵ�

%figure('name','B');
%imshow(B);

B0=imresize(B,[M1,N1]); %����Сͼ����СLevel��

an=round(M1/2); %ͼ����

imP = ImToPolar (B0, 0, 1, an, an); %תΪ������

%figure('name','imp');
%imshow(imP);

mp=median(imP'); %����ֵ�˲������ٱ߻谵����

%  mp=smooth(mp,3); %9��ƽ��һ�� 

cut=meshgrid(mp,1:an);
cut=cut';
%figure('name','cut');
%imshow(cut);

imR = PolarToIm (cut, 0, 1,an,an); %ת��ֱ������ϵ    

%figure('name','imr');
%imshow(imR);

limb=imresize(imR,[M N],'bicubic');%limb

B0=(B./limb);

%figure('name','B0');
%imshow(B0);

BW=disk(M,N,r);
r1=1*r-5;
r1=r1*r1;
for i=1:M
    for j=1:N
        if (i-M/2)^2+(j-M/2)^2>r1
            BW(i,j)=0;
        end
    end
end
B0=B0.*BW;
B0(isnan(B0)) = 0;
B0=circshift(B0,[-dx,-dy]);
B0=B0/max(B0(:));
%figure('name','B0_fin');
%imshow(B0)

    
    





