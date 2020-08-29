%根据Ha文件筛选对应的MDI文件
%适用于BBSO的Ha图像和JSOC的MDI图像
%Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg
%MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
%%
close all;
import matlab.io.*
maindir_ha='D:\Dataset\Filament\JPG\BBSO\';
maindir_mdi='D:\Dataset\Filament\JPG\MDI\';
subdir_ha=dir(maindir_ha);
subdir_mdi=dir(maindir_mdi);
save_ha='D:\Dataset\Filament_test\BBSO\';
save_mdi='D:\Dataset\Filament_test\MDI\';
numtot=0;  %记录处理的文件数
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_mdi=length(subdir_mdi);
i=0;
j=0;
while( (0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_mdi))
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
        path_save_ha=strcat(save_ha,subdir_ha(i).name,'\');    %保存Ha文件的路径  
        path_save_mdi=strcat(save_mdi,subdir_mdi(i).name,'\'); %保存MDI文件的路径  

        %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
        direc_ha=dir(strcat(datapath_ha,extname));  %显示当前路径目录下的文件和文件夹
        direc_mdi=dir(strcat(datapath_mdi,extname));  
        filenum_ha=length(direc_ha);
        filenum_mdi=length(direc_mdi);
        %文件夹为空则结束
        if filenum_ha==0
            disp(['‘',datapath_ha,'’为空文件夹。']);
            j=j-1;       %控制mdi文件夹保持不变
            continue;
        end
        if filenum_mdi==0
            disp(['‘',datapath_mdi,'’为空文件夹。']);
            i=i-1;
            continue;
        end
        %存储路径下文件夹不存在时创建文件夹
        if ~exist(path_save_ha,'dir')
            mkdir(path_save_ha);
        end
        if ~exist(path_save_mdi,'dir')
            mkdir(path_save_mdi);
        end
        index_ha=1;
        index_mdi=1;
        while((0<=index_ha) && (index_ha<=filenum_ha) && (index_mdi>=0) && (index_mdi<=filenum_mdi))
            while ((0<=index_ha) && (index_ha<=filenum_ha) && (index_mdi>=0) && (index_mdi<=filenum_mdi))
                name_ha=direc_ha(index_ha).name;
                name_mdi=direc_mdi(index_mdi).name;
                savename_ha=strcat(path_save_ha,name_ha);
                savename_mdi=strcat(path_save_mdi,name_mdi);
                %文件已经存在
                if exist(savename_ha,'file')
                    index_ha=index_ha+1;
                end
                if exist(savename_mdi,'file')
                    index_mdi=index_mdi+1;
                end
                %Ha文件和MDI文件均不存在
                if ~exist(savename_ha,'file') || ~exist(savename_mdi,'file')
                    break;
                end
            end
            %解析Ha文件和MDI文件的名称以确定时间和日期
            %Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg
            %MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
            data_ha=str2double(name_ha(15:22));
            data_mdi=str2double(name_mdi(12:19));
            time_ha=str2double(name_ha(24:29));
            time_mdi=str2double(name_mdi(21:26));
            %将Ha和MDI图片的获取时间限制在正负3分钟
            if data_ha==data_mdi
                if abs(time_ha-time_mdi)<=300
                    copyfile(strcat(datapath_ha,name_ha),path_save_ha);
                    copyfile(strcat(datapath_mdi,name_mdi),path_save_mdi);
                    index_ha=index_ha+1;
                    index_mdi=index_mdi+1;
                    num_finish=num_finish+1;
                elseif time_ha<time_mdi
                    index_ha=index_ha+1;
                else
                    index_mdi=index_mdi+1;
                end
            elseif data_ha<data_mdi
              index_ha=index_ha+1;
            else
              index_mdi=index_mdi+1;
            end
        end
        disp([datapath_ha,'和',datapath_mdi,'下的',num2str(num_finish),'文件已处理完成']);
        numtot=numtot+num_finish;
     end
end
disp(['共计处理',num2str(numtot),'个文件']);