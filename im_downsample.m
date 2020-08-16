clear variables;
close all;
path_hmi='C:\Users\11054\Desktop\hmi_20190704\hmi\';  %读取hmi文件的路径
path_ha='C:\Users\11054\Desktop\hmi_20190704\ha\jpg\';%保存ha图的路径
extname_m='*.jpg';
%读取文件列表
Direc_hmi=dir(strcat(path_hmi,extname_m));  %（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
Direc_ha=dir(strcat(path_ha,extname_m));
filenum_hmi=length(Direc_hmi);
filenum_ha=length(Direc_ha);
if filenum_hmi ~=filenum_ha
    print("Ha图像数量与HMI图像数量不匹配");
else
    for i=1:filenum_ha     
        hmi=imread(strcat(path_hmi,Direc_hmi(i).name));
        ha=imread(strcat(path_ha,Direc_ha(i).name));
        figure('name','HMI');
        imshow(hmi(:,:,1));
        f_ha=figure('name','Ha');
        imshow(ha);
        %获取图像中日面的半径
        [h_hmi,w_hmi]=size(hmi(:,:,1));
        [h_ha,w_ha]=size(ha);
        %
        gaus_kernel = fspecial('gaussian',[10,10],1);
        ha_filter = imfilter(ha,gaus_kernel,'replicate');
        %
        ha_ulc=Luminance_Correction(ha_filter);
        figure('name','亮度不均匀矫正');
        imshow(ha_ulc);
         %下采样
        downsample_ratio=h_ha/512; %将图像缩小为512×512
        ha_low=imresize(ha_ulc,[int16(h_ha/downsample_ratio),int16(w_ha/downsample_ratio)]);
        %二值化
        ha_edge=imbinarize(ha_low);
        %ha_edge=edge(ha_bi,'Canny');
        figure();
        imshow(ha_edge);
        [h_haedge,w_haedge]=size(ha_edge);
        r_range=min(h_haedge,w_haedge);
        %圆拟合，将ha图像中的日面与hmi图像中的日面缩放到相同大小
        [center,radius]=imfindcircles(ha_edge,[int16(r_range*0.2),r_range],'Method','TwoStage','Sensitivity',0.9);%TwoStage指定拟合方法为霍夫变换
        center=center*downsample_ratio;
        radius=radius*downsample_ratio;
        %调整图像尺寸使其相一致
        if h_hmi>h_ha
            hmi=imresize(hmi,[h_ha,w_hmi]);
        elseif h_hmi<h_ha
                ha=imresize(ha,[h_hmi,w_ha]);
        end
        [h_hmi,w_hmi]=size(hmi(:,:,1));
        [h_ha,w_ha]=size(ha);
        if w_hmi>w_ha
            hmi=imresize(hmi,[h_hmi,w_ha]);
        elseif w_hmi<w_ha
                ha=imresize(ha,[h_ha,w_hmi]);
        end
       
        figure(f_ha);
        viscircles(center,radius,'EdgeColor','r')
    end
end