%%
%图像归一化
%%
function [result]=test_im_normalization(im)
    mean_im=mean2(im);
    std_im=std2(im);
    result=(im-mean_im)/std_im;