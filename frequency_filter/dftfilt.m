function g=dftfilt(f,H,classout)
%参见：数字图像处理第二版 P65
%DFTFILT Performs frequency domain filtering
%%
[f,revertClass]=tofloat(f);

F=fft2(f,size(H,1),size(H,2));

g=ifft2(H.*F);

g=g(1:size(f,1),1:size(f,2));

if nargin==2 || strcmp(cassout,'original')
    g=revertClass(g);
elseif strcmp(classout,'fltpoint')
    return;
else
    error('Undefined class for the output image.');
end
