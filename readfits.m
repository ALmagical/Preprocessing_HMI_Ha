clear all; 
close all;

datapath_m='C:\Users\11054\Desktop\hmi_20190704\mdi\';  %读取fits文件的路径
magneticjpg='C:\Users\11054\Desktop\hmi_20190704\mdi\';%保存fits图的路径
extname_m='*.fits';
Direc_m=dir(strcat(datapath_m,extname_m));  %（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
%dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
filetot=length(Direc_m);
for Num=1:1
    file_m=strcat(datapath_m,Direc_m(Num).name);
    im_fits_m=fitsread(file_m,'image'); 
    im_fits_m = uint8((double(im_fits_m)+500)/(500+500)*255);
    im_fits_m=fliplr(im_fits_m);     % fliplr( )：从左到右反转阵列
    figure,imshow(im_fits_m,[]);%title('磁图原图');      
    print(gcf,'-dpng',strcat(magneticjpg,Direc_m(Num).name,'.jpg'));        % 保存磁图图片
   
    close all;
end 
