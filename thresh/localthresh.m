function g=localthresh(f,nhood,a,b,meantype)
%参见： 数字图像处理第二版 P227
%LOCALTHRESH Computes Local thresholding
%%

f=tofloat(f);

SIG=stdfilt(f,nhood);

if nargin==5 && strcmp(meantype,'global')
    Mean=mean2(f);
else
    Mean=localmean(f,nhood);
end

g=~(f>a*SIG)&~(f>b*Mean);