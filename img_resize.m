%%%
%将时间差为60s的HA图像和MDI图像进行配准
%配准：将对应图片中太阳圆面的中心调整为画面中心，并使图片中日面的半径的相同
%对配准后的HA图像和HMI图像进行叠加   ？？？稍后将程序整合下
%目前默认保存Ha图像和MDI图像的文件夹中文件顺序能够对应上
%即相同(相近)日期的Ha和MDI图片在文件夹中的位序是相同的
%%%
clear variables;
close all;
%计时
tic;
t1=clock;
path_ha='C:\Users\11054\Desktop\hmi_20190704\ic\';%保存ha图的路径
path_mdi='C:\Users\11054\Desktop\hmi_20190704\mdi\';%HMI图片路径
path_save='C:\Users\11054\Desktop\hmi_20190704\out\';%存储结果
extname_m='*.jpg';
%读取文件列表
%（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
Direc_ha=dir(strcat(path_ha,extname_m));
Direc_mdi=dir(strcat(path_mdi,extname_m));
filenum_ha=length(Direc_ha);
filenum_hmi=length(Direc_mdi);
downsample_size=256;     %计算日面半径时的将图像缩小到的高度大小
if filenum_ha~=filenum_hmi
    disp('Ha图像和MDI图像数量不匹配');
else
    %生成类高斯结构元，用于后续在图像上绘制边框
    unitsize=5;  %结构元尺寸
    unit=zeros(unitsize);
    unit_zero=unitsize;
    unit_center=(unitsize-1)/2;
    for j=1:unitsize
        unit_zero=unit_zero-1;
        control_zero=abs(unit_zero-unit_center);
        for k=1:unitsize-control_zero
            if (k-control_zero)>0            
                unit(j,k)=1;
            end
        end
    end

    for i=1:filenum_ha
        tic;
        t2=clock;
        ha=imread(strcat(path_ha,Direc_ha(i).name));
        mdi=imread(strcat(path_mdi,Direc_mdi(i).name));
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
        figure('name','Ha');
        imshow(ha);
        figure('name','MDI');
        imshow(mdi);
        %更新图像尺寸
        [h_ha,w_ha]=size(ha);
        [h_mdi,w_mdi]=size(mdi);
        %可以将这部分改为function
        gaus_kernel = fspecial('gaussian',[5,5],1);
        ha_filter = imfilter(ha,gaus_kernel,'replicate');
        mdi_filter = imfilter(mdi,gaus_kernel,'replicate');
        %移除Ha图像的临边昏暗
        %[ha_ulc,~]=removelimb(ha_filter);
        %[mdi_ulc,~]=removelimb(mdi_filter);
        %figure();
        %imshow(ha_ulc);
        ha_ulc=ha_filter;
        mdi_ulc=mdi_filter;
        %下采样
        downsample_ha_ratio=h_ha/downsample_size; %将图像缩小到downsample_size
        downsample_mdi_ratio=h_mdi/downsample_size;
        ha_low=imresize(ha_ulc,[int16(h_ha/downsample_ha_ratio),int16(w_ha/downsample_ha_ratio)]);
        mdi_low=imresize(mdi_filter,[int16(h_mdi/downsample_mdi_ratio),int16(w_mdi/downsample_mdi_ratio)]);
        %二值化
        ha_edge=imbinarize(ha_low);
        mdi_edge=imbinarize(mdi_low);
        [h_edge_ha,w_edge_ha]=size(ha_edge);
        [h_edge_mdi,w_edge_mdi]=size(ha_edge);
        r_range_ha=min(h_edge_ha,w_edge_ha);
        r_range_mdi=min(h_edge_mdi,w_edge_mdi);
        figure();
        subplot(1,2,1);
        imshow(ha_edge);
        subplot(1,2,2);
        imshow(mdi_edge);
        %圆拟合，将ha图像中的日面与hmi图像中的日面缩放到相同大小
        [center_ha,radius_ha]=imfindcircles(ha_edge,[int16(r_range_ha*0.2),r_range_ha],'Method','TwoStage','Sensitivity',0.9);%TwoStage指定拟合方法为霍夫变换
        [center_mdi,radius_mdi]=imfindcircles(mdi_edge,[int16(r_range_mdi*0.2),r_range_mdi],'Method','TwoStage','Sensitivity',0.9);
        
        if isempty(center_ha)==0 && isempty(center_mdi)==0
            %求出原图中日面的半径
            center_ha=center_ha*downsample_ha_ratio;
            radius_ha=radius_ha*downsample_ha_ratio;
            center_mdi=center_mdi*downsample_mdi_ratio;
            radius_mdi=radius_mdi*downsample_mdi_ratio;
            disp(['Ha图像中日面中心坐标为(',num2str(center_ha(1)),',',num2str(center_ha(2)),'),日面半径为',num2str(radius_ha)]);
            disp(['MDI图像中日面中心坐标为(',num2str(center_mdi(1)),',',num2str(center_mdi(2)),'),日面半径为',num2str(radius_mdi)]);
            %ha=ha_ulc;
            %mdi=mdi_ulc;
            %将日面中心移至画面的中心
            dy_ha=round((h_ha)/2-center_ha(1));
            dx_ha=round((w_ha)/2-center_ha(2));
            ha=circshift(ha,[dy_ha,dx_ha]);
            dy_mdi=round((h_mdi)/2-center_mdi(1));
            dx_mdi=round((w_mdi)/2-center_mdi(2));
            mdi=circshift(mdi,[dy_mdi,dx_mdi]);
            figure('name','平移结果');
            subplot(1,2,1);
            imshow(ha);
            subplot(1,2,2);
            imshow(mdi);
            %对Ha图像或MDI图像进行缩放，使两幅图像中日面半径相同，且日面中心位于画面中心
            if radius_mdi > radius_ha
                %关于im_adjust的功能和用法参见函数的说明
                ha=im_adjust(mdi,ha,radius_mdi,radius_ha);
            elseif radius_mdi < radius_ha
                mdi=im_adjust(ha,mdi,radius_ha,radius_mdi);
            end
            figure('name','处理后的图片');
            subplot(1,2,1);
            imshow(ha);
            subplot(1,2,2);
            imshow(mdi);
            im_fusion(ha,mdi,strcat(path_save,Direc_ha(i).name(1:length(Direc_ha(i).name)-4),'fusion2.jpg'));
            R=ha_ulc;
            G=ha_ulc;
            B=ha_ulc;
            theta=0:0.001:2*pi+0.1;
            Circle1=center_ha(1)+radius_ha*cos(theta);
            Circle2=center_ha(2)+radius_ha*sin(theta);
            y_int=int16(Circle1);
            x_int=int16(Circle2);
            for j=1:length(x_int)
                for m=-(unit_center-1):unit_center+1
                    for n=-(unit_center-1):unit_center+1
                        if unit(m+unit_center,n+unit_center)==1
                            if 0<(x_int(j)+m) && (x_int(j)+m)<=h_ha && 0<(y_int(j)+n) && (y_int(j)+n)<=w_ha
                              R(x_int(j)+m,y_int(j)+n)=255;
                              G(x_int(j)+m,y_int(j)+n)=0;
                              B(x_int(j)+m,y_int(j)+n)=0;
                            end
                        end
                    end
                end
            end
            result=zeros(h_ha,w_ha,3);
            result(:,:,1)=R;
            result(:,:,2)=G;
            result(:,:,3)=B;
            %figure();
            %imshow(result);
            imwrite(result,strcat(path_save,Direc_ha(i).name(1:length(Direc_ha(i).name)-4),'.jpg'),'jpg','Quality',100);
            %plot(Circle1,Circle2,'r');
            %axis equal
            %viscircles(center,radius,'EdgeColor','r');
            %set(gcf, 'PaperPositionMode', 'manual');
            %set(gcf, 'PaperUnits', 'points');
            %set(gcf, 'PaperPosition', [0 0 h_ha w_ha]);
            %print(gcf,'-dpng',strcat(path_save,Direc_ha(i).name));
            disp(['第',num2str(i),'张图片处理花费时间：',num2str(toc),'s']);
        end
    end
end
disp(['程序总运行时间：',num2str(etime(clock,t1)),'s']);