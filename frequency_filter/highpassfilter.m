function H=highpassfilter(type,M,N,D0,n)
%参见： 数字图像处理第二版 P75
%HIGHPASSFILTER Computes frequency domain highpass filters
%%

if nargin==4
    n=1;
end

Hlp=lowpassfilter(type,M,N,D0,n);
H=1-Hlp;