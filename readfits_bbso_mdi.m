close all;
import matlab.io.*
maindir='C:\Users\11054\Desktop\';
subdir=dir(maindir);
maindir_save='C:\Users\11054\Desktop\';%保存fits图的路径
numtot=0;  %记录处理的文件数
for i=1:length(subdir)
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
    %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
    filetot=length(direc_m);
    i=i+filetot;
    if ~exist(path_save,'dir')
        mkdir(path_save);
    end
    disp(['正在处理',datapath_m,'下的文件，文件数共计',num2str(filetot)]);
    errornum=0;
    %batchsize=10;
    for Num=1:filetot
        file_name = strcat(datapath_m,direc_m(Num).name);
        try
           final_img = fitsread(file_name,'image');
        catch
           disp(['第',num2str(Num),'个文件处理失败']);
           errornum=errornum+1;
           continue;
        end
        %非线性变换 sigmoid
        final_img=final_img/50;
        final_img=uint8(sigmoid(final_img)*255);
        %end
        %final_img = uint8((double(final_img)+500)/(500+500)*255);
        final_img=fliplr(final_img);     % fliplr( )：从左到右反转阵列
        %imwrite(final_img,strcat(Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'));      % 保存磁图图片
        %imwrite(final_img,strcat(magneticjpg,Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'),'jpg','bitdepth',16,'Quality',100);
        imwrite(final_img,strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-5),'2.jpg'),'jpg','Quality',100);
        %fits.closeFile(fptr);
        %close all;
    end
    disp([datapath_m,'下的',num2str(filetot),'文件已处理完成']);
    disp(['其中成功',num2str(filetot-errornum),'个，失败',num2str(errornum),'个']);
    numtot=numtot+filetot;
end
disp(['共计处理',num2str(numtot),'个文件']);