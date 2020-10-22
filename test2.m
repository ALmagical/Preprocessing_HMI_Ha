clear variables;
close all;
import matlab.io.*
%计时
tic;
t1=clock;
path_ha='D:\Dataset\Filament_test\BBSO\20120703-06\bbso_halph_fl_20120703_190100.jpg';
path_mdi='C:\Users\11054\Desktop\hmi.M_45s.20120703_190045_TAI.2.magnetogram2.jpg';
path_save='D:\Dataset\Filament_test\OUT\';
numtot=0;  %记录处理的文件数
extname='*.jpg'; 
downsample_size=256;     %计算日面半径时的将图像缩小到的高度大小
i=0;
j=0;
filenum_ha=1;
for k=1:filenum_ha
    tic;
    t2=clock;
    ha=imread(path_ha);
    mdi=imread(path_mdi);
    file_save=strcat(path_save,'test_fusion5.jpg');
     %获取图像中日面的半径
    [h_ha,w_ha]=size(ha);
    [h_mdi,w_mdi,channal]=size(mdi);
    %将彩色的MDI图像转为灰度图
    if channal ~= 1
        mdi=rgb2gray(mdi);
    end
    %调整图像尺寸使其相一致
    if h_mdi>h_ha
        mdi=imresize(mdi,[h_ha,w_mdi]);
    elseif h_mdi<h_ha
        ha=imresize(ha,[h_mdi,w_ha]);
    end
    [h_mdi,w_mdi]=size(mdi);
    [h_ha,w_ha]=size(ha);
    if w_mdi>w_ha
        mdi=imresize(mdi,[h_mdi,w_ha]);
    elseif w_mdi<w_ha
        ha=imresize(ha,[h_ha,w_mdi]);
    end
    %figure('name','Ha');
    %imshow(ha);
    %figure('name','MDI');
    %imshow(mdi);
    %更新图像尺寸
    [h_ha,w_ha]=size(ha);
    [h_mdi,w_mdi]=size(mdi);
    [center_ha,radius_ha]=my_circlefit(ha,downsample_size,h_ha,w_ha);
    [center_mdi,radius_mdi]=my_circlefit(mdi,downsample_size,h_mdi,w_mdi);

    if isempty(center_ha)==0 && isempty(center_mdi)==0
        %求出原图中日面的半径
        downsample_ha_ratio=h_ha/downsample_size;
        downsample_mdi_ratio=h_mdi/downsample_size;
        center_ha=center_ha*downsample_ha_ratio;
        radius_ha=radius_ha*downsample_ha_ratio;
        center_mdi=center_mdi*downsample_mdi_ratio;
        radius_mdi=radius_mdi*downsample_mdi_ratio;
        disp(['Ha图像中日面中心坐标为(',num2str(center_ha(1)),',',num2str(center_ha(2)),'),日面半径为',num2str(radius_ha)]);
        disp(['MDI图像中日面中心坐标为(',num2str(center_mdi(1)),',',num2str(center_mdi(2)),'),日面半径为',num2str(radius_mdi)]);
        %将日面中心移至画面的中心
        dy_ha=round((h_ha)/2-center_ha(1));
        dx_ha=round((w_ha)/2-center_ha(2));
        ha=circshift(ha,[dy_ha,dx_ha]);
        dy_mdi=round((h_mdi)/2-center_mdi(1));
        dx_mdi=round((w_mdi)/2-center_mdi(2));
        mdi=circshift(mdi,[dy_mdi,dx_mdi]);
        %figure('name','平移结果');
        %subplot(1,2,1);
        %imshow(ha);
        %subplot(1,2,2);
        %imshow(mdi);
        %对Ha图像或MDI图像进行缩放，使两幅图像中日面半径相同，且日面中心位于画面中心
        r=radius_ha;
        if radius_mdi > radius_ha
            %关于im_adjust的功能和用法参见函数的说明
            ha=im_adjust(mdi,ha,radius_mdi,radius_ha);
            r=radius_mdi;
        elseif radius_mdi < radius_ha
            mdi=im_adjust(ha,mdi,radius_ha,radius_mdi);
            r=radius_ha;
        end
        %figure('name','处理后的图片');
        %subplot(1,2,1);
        %imshow(ha);
        %subplot(1,2,2);
        %imshow(mdi);
        [ha_ulc,max_ha]=removelimb2(ha,r);
        %ha_ulc=imadjust(ha_ulc,[0.3,0.9]);
        [mdi_ulc,max_mdi]=removelimb2(mdi,r);
        %阈值，用于获取磁图中的正极区域和负极区域
        threshold_neg=0.7;
        threshold_pos=1.3;
        
        im_fusion2(ha_ulc,mdi_ulc,file_save,max_ha,r,threshold_neg,threshold_pos);
        numtot=numtot+1;
        disp(['第',num2str(numtot),'张图片处理花费时间：',num2str(toc),'s']);
    end
end

time=etime(clock,t1);
secs=mod(time,60);
mins=fix(time/60);
hours=fix(mins/60);
mins=mod(mins,60);
disp(['程序总运行时间：',num2str(hours),' h ',num2str(mins),' m ',num2str(secs),' s']);