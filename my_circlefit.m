function [center,radius]=my_circlefit(img,downsample_size,h,w)
%%
%my_circlefit�����ҳ�����ͼ��img�д��ڵ�Բ������ֵΪԲ�������Բ�İ뾶
%�����п��ܴ��ڶ��Բ�����Բ����������ж�ԣ��뾶��ֵҲ���ܴ��ڶ��
%imgΪ����ͼ��downsample_sizeΪ��������н�ͼ�����ŵ��ĳߴ磬h��w�ֱ�Ϊͼ���
%�߶ȺͿ��
%%
%��˹�˲���ƽ��ͼ��
gaus_kernel = fspecial('gaussian',[5,5],1);
img_filter = imfilter(img,gaus_kernel,'replicate');
%�²��������ټ�����
downsample_ratio=h/downsample_size; %��ͼ����С��downsample_size
img_low=imresize(img_filter,[int16(h/downsample_ratio),int16(w/downsample_ratio)]);
%��ֵ��
img_edge=imbinarize(img_low);
[h_edge,w_edge]=size(img_edge);
r_range=min(h_edge,w_edge);
%����ʱ��
%figure();
%imshow(ha_edge);
%Բ��ϣ��ҳ�ͼ���д��ڵ�Բ��İ뾶��Բ��
[center,radius]=imfindcircles(img_edge,[int16(r_range*0.2),r_range],'Method','TwoStage','Sensitivity',0.9);%TwoStageָ����Ϸ���Ϊ����任