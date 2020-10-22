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
maindir_ha='D:\Dataset\Filament_test2\BBSO\';
maindir_mdi='D:\Dataset\Filament_test2\MDI\';
maindir_save='D:\Dataset\Filament_test2\OUT\';
subdir_ha=dir(maindir_ha);
subdir_mdi=dir(maindir_mdi);
numtot=0;  %记录处理的文件数
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_mdi=length(subdir_mdi);
downsample_size=256;     %计算日面半径时的将图像缩小到的高度大小
i=0;
j=0;
while((0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_mdi))
    i=i+1;
    j=j+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
        isequal( subdir_ha( i ).name, '..')||...
        ~subdir_ha( i ).isdir)               % 如果不是目录则跳过
        continue;
    end

    if( isequal( subdir_mdi( j ).name, '.' )||...
        isequal( subdir_mdi( j ).name, '..')||...
        ~subdir_mdi( j ).isdir)               % 如果不是目录则跳过
        continue;
    end
    %判断文件夹名称是否匹配
    if ((i<=dirnum_ha) && (j<=dirnum_mdi))
        false=0;
        %文件夹命名格式示例：20101014-16
        while subdir_ha(i).name ~= subdir_mdi(j).name
            name_ha=subdir_ha(i).name(1:8);
            name_mdi=subdir_mdi(j).name(1:8);
            if str2double(name_ha)<str2double(name_mdi)
                i=i+1;
            elseif str2double(name_ha)>str2double(name_mdi)
                j=j+1;
            else
                disp(['文件夹名称不匹配',',Ha文件夹名称为:',subdir_ha(i)...
                    ,'MDI文件夹名称为:',subdir_mdi(j)],'。请检查文件夹名称！');
                false=1;
            end
        end
        if (false==1)
            continue;
        end
        datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %读取Ha文件的路径
        datapath_mdi=strcat(maindir_mdi,subdir_mdi(i).name,'\');%读取MDI文件的路径
        path_save=strcat(maindir_save,subdir_ha(i).name,'\');    %保存文件的路径  

        %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
        direc_ha=dir(strcat(datapath_ha,extname));  %显示当前路径目录下的文件和文件夹
        direc_mdi=dir(strcat(datapath_mdi,extname));  
        filenum_ha=length(direc_ha);
        filenum_mdi=length(direc_mdi);
        %文件夹为空则结束
        if filenum_ha==0
            disp(['‘',datapath_ha,'’，为空文件夹。']);
            j=j-1;       %控制mdi文件夹保持不变
            continue;
        end
        if filenum_mdi==0
            disp(['‘',datapath_mdi,'’，为空文件夹。']);
            i=i-1;
            continue;
        end
        %存储路径下文件夹不存在时创建文件夹
        if ~exist(path_save,'dir')
            mkdir(path_save);
        end

        if filenum_ha~=filenum_mdi
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
                mdi=imread(strcat(datapath_mdi,direc_mdi(k).name));
                file_save=strcat(path_save,direc_ha(k).name(1:length(direc_ha(k).name)-4),'_fusion.jpg');
                if exist(file_save,'file')
                    continue;
                end
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
                    [mdi_ulc,max_mdi]=removelimb2(mdi,r);
                     %阈值，用于获取磁图中的正极区域和负极区域
                    threshold_neg=0.7;
                    threshold_pos=1.3;
                    im_fusion2(ha_ulc,mdi_ulc,file_save,max_ha,r,threshold_neg,threshold_pos);
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