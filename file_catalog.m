%将文件复制到新的目录结构下
%源目录结构无限制
%新目录结构对数据的获取时间按年份进行划分
%目前适用于BBSO的Ha图像和JSOC的HMI_720s的磁图
%参数说明
%maindir：要调整的源文件所在的路径
%extname：需要移动的文件的后缀名，设置为-1时表示移动全部文件
%type：用于区分数据来源，不同数据源的文件命名格式存在不同，目前仅分为BBSO和HMI
%save_path：目标文件夹
%Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg
%MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
%Author:@ALong_GXL
%Date:2020.10.30 
%Ver:0.1.0
%%
function []=file_catalog(maindir,extname,type,save_path)
import matlab.io.*
%主目录
subdir=dir(maindir);
file_num=length(subdir);
parfor i=1:file_num
    % 跳过.和..两个文件夹
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..'))               
        continue;
    end
    name=subdir(i).name;
    path_file=strcat(maindir,name);
    if isfolder(path_file)
        %子文件夹 
        path_data=strcat(path_file,'\');
        %递归调用，以遍历目标文件夹的全部子文件和文件夹
        file_catalog(path_data,extname,type,save_path);
    else
        %获取文件扩展名
        [~,~,file_extname]=fileparts(path_file);
        try
            %判断文件扩展名是否正确
            if extname~=-1
                if file_extname~=extname
                    continue;
                end
            else
    %解析Ha文件和MDI文件的名称以确定文件获取的日期
    %Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg/fts
    %HMI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg/fits
                if type=="BBSO"
                    date=name(15:22);
                elseif type=="HMI"
                    %HMI磁图部分下载时文件名会缺失一部分，此处进行了补全
                    if name(1:10)~="hmi.M_720s"
                    name=strcat('hmi.M_720s',direc_m(Num).name);
                    end
                    date=name(12:19);
                else
                    error("请输入正确的文件类型。");
                end
                year=date(1:4);
                path_save=strcat(save_path,year,'\');
                %需要复制的文件已经在目标路径中
                if isfile(strcat(path_save,name))
                    %disp([strcat(path_save,name),"已存在"]);
                    continue;
                end
                %存储路径下文件夹不存在时创建文件夹
                if ~isfolder(path_save)
                    mkdir(path_save);
                end
                %复制文件到目标路径
                if copyfile(path_file,path_save)==0
                    disp([path_file,"复制文件失败"]);
                end 
            end
        catch
            %文件后缀名不完全匹配时会抛出异常，在命令行输出警告信息
            warning([path_file,'处理失败。']);
        end
    end
end