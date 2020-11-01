%%%
%将时间差为60s的HA图像和MDI图像进行配准
%配准：将对应图片中太阳圆面的中心调整为画面中心，并使图片中日面的半径的相同
%对配准后的HA图像和HMI图像进行叠加 
%目前默认保存Ha图像和MDI图像的文件夹中文件顺序能够对应上
%即相同(相近)日期的Ha和MDI图片在文件夹中的位序是相同的
%%%
clear variables;
close all;
import matlab.io.*
%计时
tic;
t1=clock;
maindir_ha='D:\Dataset\Train_data\BBSO\';
maindir_hmi='D:\Dataset\Train_data\HMI\';
maindir_save_fusion='D:\Dataset\Train_data\OUT\FUSION\';
maindir_save_ha='D:\Dataset\Train_data\OUT\Ha\';
maindir_save_hmi='D:\Dataset\Train_data\OUT\HMI\';
subdir_ha=dir(maindir_ha);
subdir_hmi=dir(maindir_hmi);
numtot=0;  %记录处理的文件数
extname_ha='*.fts'; 
extname_hmi='*.fits';
dirnum_ha=length(subdir_ha);
dirnum_hmi=length(subdir_hmi);
downsample_size=256;     %计算日面半径时的将图像缩小到的高度大小
i=0;
j=0;
while((0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_hmi))
    i=i+1;
    j=j+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
        isequal( subdir_ha( i ).name, '..')||...
        ~subdir_ha( i ).isdir)               % 如果不是目录则跳过
        continue;
    end

    if( isequal( subdir_hmi( j ).name, '.' )||...
        isequal( subdir_hmi( j ).name, '..')||...
        ~subdir_hmi( j ).isdir)               % 如果不是目录则跳过
        continue;
    end
    %判断文件夹名称是否匹配
    if ((i<=dirnum_ha) && (j<=dirnum_hmi))
        false=0;
        %文件夹命名格式示例：2010
        while subdir_ha(i).name ~= subdir_hmi(j).name
            name_ha=subdir_ha(i).name;
            name_hmi=subdir_hmi(j).name;
            if str2double(name_ha)<str2double(name_hmi)
                i=i+1;
            elseif str2double(name_ha)>str2double(name_hmi)
                j=j+1;
            else
                disp(['文件夹名称不匹配',',Ha文件夹名称为:',subdir_ha(i)...
                    ,'MDI文件夹名称为:',subdir_hmi(j)],'。请检查文件夹名称！');
                false=1;
            end
        end
        if (false==1)
            continue;
        end
        datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %读取Ha文件的路径
        datapath_hmi=strcat(maindir_hmi,subdir_hmi(i).name,'\');%读取MDI文件的路径
        %保存文件的路径  
        path_save_fusion=strcat(maindir_save_fusion,subdir_ha(i).name,'\');
        path_save_ha=strcat(maindir_save_ha,subdir_ha(i).name,'\');
        path_save_hmi=strcat(maindir_save_hmi,subdir_hmi(i).name,'\');
        
        %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
        direc_ha=dir(strcat(datapath_ha,extname_ha));  %显示当前路径目录下的文件和文件夹
        direc_hmi=dir(strcat(datapath_hmi,extname_hmi));  
        filenum_ha=length(direc_ha);
        filenum_hmi=length(direc_hmi);
        %文件夹为空则结束
        if filenum_ha==0
            disp(['‘',datapath_ha,'’，为空文件夹。']);
            j=j-1;       %控制mdi文件夹保持不变
            continue;
        end
        if filenum_hmi==0
            disp(['‘',datapath_hmi,'’，为空文件夹。']);
            i=i-1;
            continue;
        end
        %存储路径下文件夹不存在时创建文件夹
        if ~exist(path_save_fusion,'dir')
            mkdir(path_save_fusion);
        end
        if ~exist(path_save_ha,'dir')
            mkdir(path_save_ha);
        end
        if ~exist(path_save_hmi,'dir')
            mkdir(path_save_hmi);
        end
        if filenum_ha~=filenum_hmi
            disp('Ha图像和MDI图像数量不匹配');
            disp(['未处理',datapath_ha]);
        else
        %无用
        %生成类高斯结构元，用于后续在图像上绘制边框
        %unit=cross_unit(5);

            for k=1:filenum_ha
                tic;
                t2=clock;
                ha=imread(strcat(datapath_ha,direc_ha(k).name));
                hmi=imread(strcat(datapath_hmi,direc_hmi(k).name));
                file_save_fusion=strcat(path_save_fusion,direc_ha(k).name(1:length(direc_ha(k).name)-4),'_fusion.jpg');
                file_save_ha=strcat(path_save_ha,direc_ha(k).name(1:length(direc_ha(k).name)-4),'.jpg');
                file_save_hmi=strcat(path_save_hmi,direc_hmi(k).name(1:length(direc_ha(k).name)-4),'.jpg');
%               if exist(file_save_fusion,'file')
%                   continue;
%               end
                 %获取图像中日面的半径
                [h_ha,w_ha]=size(ha);
                [h_hmi,w_hmi,c_hmi]=size(hmi);
                %将彩色的MDI图像转为灰度图
                if c_hmi ~= 1
                    hmi=rgb2gray(hmi);
                end
                %调整图像尺寸使其相一致
                if h_hmi>h_ha
                    hmi=imresize(hmi,[h_ha,w_hmi]);
                elseif h_hmi<h_ha
                    ha=imresize(ha,[h_hmi,w_ha]);
                end
                [h_hmi,w_hmi]=size(hmi);
                [h_ha,w_ha]=size(ha);
                if w_hmi>w_ha
                    hmi=imresize(hmi,[h_hmi,w_ha]);
                elseif w_hmi<w_ha
                    ha=imresize(ha,[h_ha,w_hmi]);
                end
                %figure('name','Ha');
                %imshow(ha);
                %figure('name','MDI');
                %imshow(mdi);
                %更新图像尺寸
                [h_ha,w_ha]=size(ha);
                [h_hmi,w_hmi]=size(hmi);
                [center_ha,radius_ha]=my_circlefit(ha,downsample_size,h_ha,w_ha);
                [center_hmi,radius_hmi]=my_circlefit(hmi,downsample_size,h_hmi,w_hmi);

                if isempty(center_ha)==0 && isempty(center_hmi)==0
                    %求出原图中日面的半径
                    downsample_ha_ratio=h_ha/downsample_size;
                    downsample_mdi_ratio=h_hmi/downsample_size;
                    center_ha=center_ha*downsample_ha_ratio;
                    radius_ha=radius_ha*downsample_ha_ratio;
                    center_hmi=center_hmi*downsample_mdi_ratio;
                    radius_hmi=radius_hmi*downsample_mdi_ratio;
                    disp(['Ha图像中日面中心坐标为(',num2str(center_ha(1)),',',num2str(center_ha(2)),'),日面半径为',num2str(radius_ha)]);
                    disp(['MDI图像中日面中心坐标为(',num2str(center_hmi(1)),',',num2str(center_hmi(2)),'),日面半径为',num2str(radius_hmi)]);
                    %将日面中心移至画面的中心
                    dy_ha=round((h_ha)/2-center_ha(1));
                    dx_ha=round((w_ha)/2-center_ha(2));
                    ha=circshift(ha,[dy_ha,dx_ha]);
                    dy_hmi=round((h_hmi)/2-center_hmi(1));
                    dx_hmi=round((w_hmi)/2-center_hmi(2));
                    hmi=circshift(hmi,[dy_hmi,dx_hmi]);
                    %figure('name','平移结果');
                    %subplot(1,2,1);
                    %imshow(ha);
                    %subplot(1,2,2);
                    %imshow(mdi);
                    %对Ha图像或MDI图像进行缩放，使两幅图像中日面半径相同，且日面中心位于画面中心
                    r=radius_ha;
                    if radius_hmi > radius_ha
                        %关于im_adjust的功能和用法参见函数的说明
                        ha=im_adjust(hmi,ha,radius_hmi,radius_ha);
                        r=radius_hmi;
                    elseif radius_hmi < radius_ha
                        hmi=im_adjust(ha,hmi,radius_ha,radius_hmi);
                        r=radius_ha;
                    end
                    %figure('name','处理后的图片');
                    %subplot(1,2,1);
                    %imshow(ha);
                    %subplot(1,2,2);
                    %imshow(mdi);
                    [ha_ulc,max_ha]=removelimb2(ha,r);
                    [hmi_ulc,max_hmi]=removelimb2(hmi,r);
                     %阈值，用于获取磁图中的正极区域和负极区域
                    threshold_neg=0.4;
                    threshold_pos=1.8;
                    ha_ulc=ha_ulc/max_ha;
                    hmi_ulc=hmi_ulc/max_hmi;
                    ha_ulc=im2uint8(ha_ulc);
                    hmi_ulc=im2uint8(hmi_ulc);
                    test_im_fusion2(ha_ulc,hmi_ulc,file_save_fusion,r,threshold_neg,threshold_pos);
                    imwrite(ha,file_save_ha,'jpg','Quality',100);
                    imwrite(hmi,file_save_hmi,'jpg','Quality',100);
                    numtot=numtot+1;
                    disp(['第',num2str(numtot),'张图片处理花费时间：',num2str(toc),'s']);
                end
            end
        end
    end
end
time=etime(clock,t1);
secs=mod(time,60);
mins=fix(time/60);
hours=fix(mins/60);
mins=mod(mins,60);
disp(['程序总运行时间：',num2str(hours),' h ',num2str(mins),' m ',num2str(secs),' s']);