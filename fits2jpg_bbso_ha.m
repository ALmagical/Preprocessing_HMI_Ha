%%
%将从BBSO下载的fts格式的图片转换为JPG格式
%增强Ha图像对比度的测试程序
%
%%
function [isfail,img_adj]=fits2jpg_bbso_ha(file_read,file_save)
    import matlab.io.*
    isfail=nan;
    try
        fptr = fits.openFile(file_read);
        data = fits.readImg(fptr);
        data_max=max(max(data));
        data_min=min(min(data));
        data_gray=double((data-data_min))/double((data_max-data_min));
        data_gray=uint8(255*data_gray);
        %镜像翻转原图像
        final_img=flipud(data_gray);
        img_adj=final_img;
        imwrite(img_adj,file_save,'jpg','Quality',100);
        fits.closeFile(fptr);
    catch erro
        disp(erro.message);
        isfail=1;
        img_adj=nan;
        return;
    end