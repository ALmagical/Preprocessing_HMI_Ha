%%
%%%
%%
function g1=test_im_try(im)

% figure('Name','image_1');
% imshow(im_1);
im_1=imadjust(im,[],[],1.5);
% figure('Name','image_1_adjust');
% imshow(im_1,[]);
%空域滤波
%im_2=imfilter(im_1,fspecial('average',5));
%im_3=imfilter(im_2,fspecial('average',3));
% figure('Name','image_2');
% imshow(im_2,[]);
% figure('Name','image_3');
% imshow(im_3,[]);
%im_bif=bilateralFilter(im2double(im_3));
% figure('Name','bilateralFilter');
% imshow(im_bif,[]);

im_1=im2double(im_1);
%g_bif=bilateralFilter(im2double(g2));

%频域滤波
PQ=paddedsize(size(im_1));
D0=0.05*PQ(1);
H1=highpassfilter('gaussian',PQ(1),PQ(2),D0);
H2=0.5+2*H1;
g1=dftfilt(im_1,H2);

g2=imfilter(g1,fspecial('laplacian',0.2));
g3=g1-g2;
g3(g3<0)=0;
g4=imfilter(g3,fspecial('gaussian',[9,9],0.5));
g4=imfilter(g4,fspecial('gaussian',[3,3],0.5));
g5=bilateralFilter(im2double(g4));
g5=im2uint8(g5);
figure('Name','im_1');
subplot(1,2,1);
imshow(im_1,[]);
subplot(1,2,2);
h1_im=imhist(im_1,256);
h1_im(1)=0;
bar(h1_im);
% figure('Name','g1');
% subplot(1,2,1);
% imshow(g1,[]);
% subplot(1,2,2);
% h1=imhist(g1,256);
% h1(1)=0;
% bar(h1);
% figure('Name','g2');
% subplot(1,2,1);
% imshow(g2,[]);
% subplot(1,2,2);
% h2=imhist(g2,256);
% h2(1)=0;
% bar(h2);
% figure('Name','g3');
% subplot(1,2,1);
% imshow(g3,[]);
% subplot(1,2,2);
% h3=imhist(g3,256);
% h3(1)=0;
% bar(h3);
% figure('Name','g4');
% subplot(1,2,1);
% imshow(g4,[]);
% subplot(1,2,2);
% h4=imhist(g4,256);
% h4(1)=0;
% bar(h4);
% figure('Name','g5');
% subplot(1,2,1);
% imshow(g5,[]);
% subplot(1,2,2);
% h5=imhist(g5,256);
% h5(1)=0;
% bar(h5);

% %边缘改进的全局阈值
% g5=tofloat(g5);
% s_x=fspecial('sobel');
% s_y=s_x';
% g5_x=imfilter(g5,s_x,'replicate');
% g5_y=imfilter(g5,s_y,'replicate');
% gard_g5=sqrt(g5_x.*g5_x+g5_y.*g5_y);
% gard_g5=gard_g5/max(gard_g5(:));
% h_gard_g5=imhist(gard_g5);
% %Q_g5=precentile2i(h_gard_g5,0.999);
% Q_g5=h_gard_g5/sum(h_gard_g5);
% c5=cumsum(Q_g5);
% idx=find(c5>=0.999,1,'first');
% Q_g5=(idx-1)/(numel(Q_g5)-1);
% makerg5=gard_g5>Q_g5;
% g6=g5.*makerg5;
% h6=imhist(g6);
% h6(1)=0;
% figure('Name','g6_hist');
% bar(h6);

%局部阈值
g7=localthresh(im_1,ones(3),30,1.5);
%SIG_1=stdfilt(tofloat(im_1),ones(5));
figure('Name','g7');
imshow(g7,[]);
g8=localthresh(g5,ones(3),30,1.5);
figure('Name','g8');
imshow(g8,[]);

%均值滤波
g9=imfilter(im_1,fspecial('average',[13,13]),'replicate');
figure('name','avg_13'),imshow(g9);
g10=imfilter(im_1,fspecial('average',[5,5]),'replicate');
figure('name','avg_5'),imshow(g10);
% im_2=im_1-im_1.*g9;
% figure('name','im_2');
% imshow(im_2);
% im_3=g5-g5.*g10;
% figure('name','im_3');
% imshow(im_3,[]);
%中值滤波
g11=medfilt2(im_1,[5,5]);
figure('name','中值滤波_5');
imshow(g11,[]);
g11=medfilt2(im_1,[13,13]);
figure('name','中值滤波_13');
imshow(g11,[]);
a=1;




% figure('Name','Highpassfilter');
% imshow(g1,[]);
%L1=lowpassfilter('gaussian',PQ(1),PQ(2),D0);
%g2=dftfilt(im_1,L1);
% figure('Name','Lowpassfilter');
% imshow(g2,[]);
%g3=abs(im2double(g1)-im2double(g2));
% figure('Name','Highpass-Lowpass');
% imshow(g3,[]);