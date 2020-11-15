function [U,V]=dftuv(M,N)
%参见： 数字图像处理第二版 P69
%DFTUV Computes meshgrid frequency matrices
%%
u=single(0:(M-1));
v=single(0:(N-1));

idx=find(u > M/2);
u(idx)=u(idx)-M;
idy=find(v >N/2);
v(idy)=v(idy)-N;

[V,U]=meshgrid(v,u);