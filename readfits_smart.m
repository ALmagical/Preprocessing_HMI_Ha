clear all; 
close all;
import matlab.io.*
datapath_m='M:\Dataset\filament\smart\';  %读取fits文件的路径
path_save='C:\Users\11054\Desktop\smart201110\jpg\';%保存fits图的路径
extname_m='*.fits';
Direc_m=dir(strcat(datapath_m,extname_m));  %（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
%dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
filetot=length(Direc_m);
%batchsize=10;
for Num=1:filetot
    file_name = strcat(datapath_m,Direc_m(Num).name);
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
    %figure,imshow(final_img,[]);%title('磁图原图'); 
    %print('-djpeg',strcat(magneticjpg,Direc_m(Num).name,'.jpg'));
    %imwrite(final_img,strcat(Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'));      % 保存磁图图片
    %imwrite(final_img,strcat(magneticjpg,Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'),'jpg','bitdepth',16,'Quality',100);
    imwrite(final_img,strcat(path_save,Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'),'jpg','Quality',100);
    fits.closeFile(fptr);
    %close all;
end 
