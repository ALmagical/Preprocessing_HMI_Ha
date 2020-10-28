%根据Ha文件筛选对应的MDI文件
%适用于BBSO的Ha图像和JSOC的MDI图像
%Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg
%MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
%筛选时出现错误
%%
close all;
import matlab.io.*
%主目录
maindir_ha='D:\Dataset\JPG\BBSO\';
maindir_hmi='D:\Dataset\JPG\HMI\';
subdir_ha=dir(maindir_ha);
subdir_hmi=dir(maindir_hmi);
save_ha='D:\Dataset\Train_data\BBSO\';
save_hmi='D:\Dataset\Train_data\HMI\';
numtot=0;  %记录处理的文件数
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_hmi=length(subdir_hmi);
i=0;
j=0;
while( (0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_hmi))
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
        path_save_ha=strcat(save_ha,subdir_ha(i).name,'\');    %保存Ha文件的路径  
        path_save_hmi=strcat(save_hmi,subdir_hmi(i).name,'\'); %保存MDI文件的路径  

        %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
        direc_ha=dir(strcat(datapath_ha,extname));  %显示当前路径目录下的文件和文件夹
        direc_hmi=dir(strcat(datapath_hmi,extname));  
        filenum_ha=length(direc_ha);
        filenum_hmi=length(direc_hmi);
        %文件夹为空则结束
        if filenum_ha==0
            disp(['‘',datapath_ha,'’为空文件夹。']);
            j=j-1;       %控制mdi文件夹保持不变
            continue;
        end
        if filenum_hmi==0
            disp(['‘',datapath_hmi,'’为空文件夹。']);
            i=i-1;
            continue;
        end
        %存储路径下文件夹不存在时创建文件夹
        if ~exist(path_save_ha,'dir')
            mkdir(path_save_ha);
        end
        if ~exist(path_save_hmi,'dir')
            mkdir(path_save_hmi);
        end
        index_ha=1;
        index_hmi=1;
        while((0<=index_ha) && (index_ha<=filenum_ha) && (index_hmi>=0) && (index_hmi<=filenum_hmi))
            while ((0<=index_ha) && (index_ha<=filenum_ha) && (index_hmi>=0) && (index_hmi<=filenum_hmi))
                name_ha=direc_ha(index_ha).name;
                name_hmi=direc_hmi(index_hmi).name;
                savename_ha=strcat(path_save_ha,name_ha);
                savename_hmi=strcat(path_save_hmi,name_hmi);
                %文件已经存在
                if exist(savename_ha,'file')
                    index_ha=index_ha+1;
                end
                if exist(savename_hmi,'file')
                    index_hmi=index_hmi+1;
                end
                %Ha文件和MDI文件均不存在
                if ~exist(savename_ha,'file') || ~exist(savename_hmi,'file')
                    break;
                end
            end
            %解析Ha文件和MDI文件的名称以确定时间和日期
            %Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg
            %MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
            date_ha=str2double(name_ha(15:22));
            date_hmi=str2double(name_hmi(12:19));
            time_ha=str2double(name_ha(24:29));
            time_mdi=str2double(name_hmi(21:26));
            %将Ha和MDI图片的获取时间限制在正负5分钟
            if date_ha==date_hmi
                if abs(time_ha-time_mdi)<=500
                    copyfile(strcat(datapath_ha,name_ha),path_save_ha);
                    copyfile(strcat(datapath_hmi,name_hmi),path_save_hmi);
                    index_ha=index_ha+1;
                    index_hmi=index_hmi+1;
                    num_finish=num_finish+1;
                elseif time_ha<time_mdi
                    index_ha=index_ha+1;
                else
                    index_hmi=index_hmi+1;
                end
            elseif date_ha<date_hmi
              index_ha=index_ha+1;
            else
              index_hmi=index_hmi+1;
            end
        end
        disp([datapath_ha,'和',datapath_hmi,'下的',num2str(num_finish),'文件已处理完成']);
        numtot=numtot+num_finish;
     end
end
disp(['共计处理',num2str(numtot),'个文件']);