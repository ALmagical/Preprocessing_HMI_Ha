function mean=localmean(f,nhood)
%参见： 数字图像处理第二版 P227
%LOCALMEAN Computes an array of local means
%%

if nargin==1
    nhood=ones(3)/9;
else
    nhood=nhood/sum(nhood(:));
end
mean=imfilter(tofloat(f),nhood,'replicate');