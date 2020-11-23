%%
%将从BBSO下载的fts格式的图片转换为JPG格式
%增强Ha图像对比度的测试程序
%
%%
function [isfail,img_adj]=test_fits2jpg_bbso_ha(file_read,file_save)
    import matlab.io.*
    isfail=nan;
    try
        fptr = fits.openFile(file_read);
        data = fits.readImg(fptr);
        %[high,width]=size(data);
        data_max=max(max(data));
        data_min=min(min(data));
        data_gray=double((data-data_min))/double((data_max-data_min));
        data_gray=uint8(255*data_gray);
        %镜像翻转原图像
        final_img=flipud(data_gray);
        img_adj=final_img;
        %data_16=uint16(data);
        %img_adj=imadjust(final_img,[],[],1);
        %figure();
        %imshow(img_adj);
        %img_adj=test_im_try(img_adj);
        imwrite(img_adj,file_save,'jpg','Quality',100,'BitDepth',8);
        %16位的图像查看时还需要压缩到8位，因此没有必要使用16位的图像
        %imwrite(data_16,file_save,'png','BitDepth',16);
        fits.closeFile(fptr);
    catch erro
        disp(erro.message);
        isfail=1;
        img_adj=nan;
        return;
    end