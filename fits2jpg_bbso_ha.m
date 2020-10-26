%%
%将从BBSO下载的fts格式的图片转换为JPG格式
%增强Ha图像对比度的测试程序
%
%%
function []=fits2jpg_bbso_ha(file_read,file_save)
    import matlab.io.*
    fptr = fits.openFile(file_read);
    info = fitsinfo(file_read);
    data = fits.readImg(fptr);
    %[high,width]=size(data);
    data_max=max(max(data));
    data_min=min(min(data));
    data_gray=double((data-data_min))/double((data_max-data_min));
    data_gray=uint8(255*data_gray);
    %镜像翻转原图像
    final_img=flipud(data_gray);
    %img_max=max(final_img(:));
    %img_min=min(final_img(:));
    img_adj=imadjust(final_img,[],[],2);
    %img_max_adj=max(img_adj(:));
    %img_min_adj=min(img_adj(:));
    %figure();
    %imshow(img_adj);
    imwrite(img_adj,file_save,'jpg','Quality',100);
    fits.closeFile(fptr); 