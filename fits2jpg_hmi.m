%%%
%将从HMI下载的fits格式的图片转为jpg
%%%
%%
function [isfail,final_img]=fits2jpg_hmi(file_read,file_save)
    import matlab.io.*
    isfail=nan;
    try
        final_img = fitsread(file_read,'image');
        %非线性变�? sigmoid
        final_img=final_img/50;
        final_img=uint8(sigmoid(final_img)*255);
        final_img=fliplr(final_img);     % fliplr( )：从左到右反转阵�?
        %imwrite(final_img,strcat(magneticjpg,Direc_m(Num).name(1:length(Direc_m(Num).name)-5),'.jpg'),'jpg','bitdepth',16,'Quality',100);
        imwrite(final_img,file_save,'jpg','Quality',100);
    catch erro
        disp(erro.message);
        isfail=1;
        return;
    end