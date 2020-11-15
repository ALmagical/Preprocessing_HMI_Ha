function H=lowpassfilter(type,M,N,D0,n)
%参见： 数字图像处理第二版 P71
%LOWPASSFILTER computes frequency domain lowpass filters
%%
[U,V]=dftuv(M,N);

D=hypot(U,V);

switch type
    case 'ideal'
        H=single(D<D0);
    case 'btw'
        if nargin==4
            n=1;
        end
        H=1./(1+(D./D0).^(2*n));
    case 'gaussian'
        H=exp(-(D.^2)./(2*(D0^2)));
    otherwise
        error('Unknown filter type.');
end