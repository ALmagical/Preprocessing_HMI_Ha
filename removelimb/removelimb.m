function [B0,dx,dy,B,limb,r]=removelimb(B)

B=double(B);

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

I0=imbinarize(B1,L1(T(1))); %0.2阀值截取二值图

% if M*N-sum(I0(:))<M*N/4 ; fprintf(' %s \n','图像好像不是全日面太阳像 ！！！');
%     Bout=zeros(M,N);
% else
bw = bwperim(I0,8);
clear I0;
[x,y]=find(bw);
[x0,y0,r] = circfit(x,y); %圆拟合

dx=round((M)/2-x0);
dy=round((N)/2-y0);
B=circshift(B,[dx,dy]); %平移图像到中心点

B0=imresize(B,[M1,N1]); %产生小图，缩小Level倍

an=round(M1/2); %图像半宽

imP = ImToPolar (B0, 0, 1, an, an); %转为极坐标

mp=median(imP'); %用中值滤波计算临边昏暗曲线

%  mp=smooth(mp,3); %9点平滑一下 

cut=meshgrid(mp,1:an);
cut=cut';

imR = PolarToIm (cut, 0, 1,an,an); %转回直角坐标系    

limb=imresize(imR,[M N],'bicubic');%limb

B0=(B./limb);
 
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
%figure();
%imshow(B0)

    
    





