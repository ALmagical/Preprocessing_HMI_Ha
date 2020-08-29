close all;
import matlab.io.*
maindir='C:\Users\11054\Desktop\BBSO\Fits\';
subdir=dir(maindir);
maindir_save='C:\Users\11054\Desktop\BBSO\Jpg\';%保存fits图的路径
numtot=0;  %记录处理的文件数
for i=1:length(subdir)
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    datapath_m=strcat(maindir,subdir(i).name,'\');  %读取fits文件的路径
    path_save=strcat(maindir_save,subdir(i).name,'\');%保存fits图的路径    
    extname_m='*.fts';  
    direc_m=dir(strcat(datapath_m,extname_m));  %（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
    %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
    filetot=length(direc_m);
    if ~exist(path_save,'dir')
        mkdir(path_save);
    end
    disp(['正在处理',datapath_m,'下的文件，文件数共计',num2str(filetot)]);
    errornum=0;
    %batchsize=10;
    for Num=1:filetot
        if exist(direc_m(Num).name,'file')
            continue;
        end
        file_name = strcat(datapath_m,direc_m(Num).name);
        fptr = fits.openFile(file_name);
        info = fitsinfo(file_name);
        data = fits.readImg(fptr);
        [high,width]=size(data);
        %data=data+32768;
        %data_log=log(double(data));
        data_log=data;
        data_max=max(max(data_log));
        data_min=min(min(data_log));
        data_gray=double((data_log-data_min))/double((data_max-data_min));
        data_gray=uint8(255*data_gray);
        %data_gray=uint16(data);
        %data_gray=data;
        %镜像翻转原图像
        final_img=flipud(data_gray);
        imwrite(final_img,strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-4),'.jpg'),'jpg','Quality',100);
        fits.closeFile(fptr); 
        %close all;
    end
    disp([datapath_m,'下的',num2str(filetot),'文件已处理完成']);
    disp(['其中成功',num2str(filetot-errornum),'个，失败',num2str(errornum),'个']);
    numtot=numtot+filetot;
end
disp(['共计处理',num2str(numtot),'个文件']);