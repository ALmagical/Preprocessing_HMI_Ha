close all;
import matlab.io.*
maindir='D:\Dataset\FITS\HMI\';
subdir=dir(maindir);
maindir_save='D:\Dataset\JPG\HMI\';%保存fits图的路径
numtot=0;  %记录处理的文件数
for i=32:length(subdir)
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..'))
        continue;
    end
    extname_m='*.fits';  
    if subdir(i).isdir
        datapath_m=strcat(maindir,subdir(i).name,'\');  
        path_save=strcat(maindir_save,subdir(i).name,'\');    
        %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
    else
        %当前路径不是文件夹
        datapath_m=strcat(maindir);  
        path_save=strcat(maindir_save);
    end
    direc_m=dir(strcat(datapath_m,extname_m));  %（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
    filetot=length(direc_m);
    %i=i+filetot;
    disp(['正在处理',datapath_m,'下的文件，文件数共计',num2str(filetot)]);
    errornum=0;
    %batchsize=10;
    for Num=1:filetot
        file_name = strcat(datapath_m,direc_m(Num).name);
        
        file_name_save = direc_m(Num).name;
        if direc_m(Num).name(1:10)~="hmi.M_720s"
            file_name_save=strcat('hmi.M_720s',direc_m(Num).name);
        end
        %HMI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
        date=file_name_save(12:15);
        path_save=strcat(maindir_save,date,'\');
        if ~exist(path_save,'dir')
            mkdir(path_save);
        end
        file_save = strcat(path_save,file_name_save(1:length(direc_m(Num).name)-5),'.jpg');
        
        isfail=fits2jpg_hmi(file_name,file_save);
        if isfail==1
           disp(['第',num2str(Num),'个文件处理失败']);
           errornum=errornum+1;
           continue;
        end
    end
    disp([datapath_m,'下的',num2str(filetot),'文件已处理完成']);
    disp(['其中成功',num2str(filetot-errornum),'个，失败',num2str(errornum),'个']);
    numtot=numtot+filetot;
end
disp(['共计处理',num2str(numtot),'个文件']);