function PQ=paddedsize(AB,CD,PARAM)
%参见： 数字图像处理第二版 P62
%PADDEDSIZE Cmputes padded sizes useful for FFT-based filtering
%%

if nargin==1
    PQ=2*AB;
elseif nargin==2 && ~ischar(CD)
    PQ=AB+CD-1;
    PQ=2*ceil(PQ/2);
elseif margin==2
    m=max(AB);
    
    P=2^nextpow2(2*m);
    PQ=[P,P];
elseif nargin==3 && strcmpi(PARAM,'pwr2')
    m=max([AB,CD]);
    
    P=2^nextpow2(2*m);
    PQ=[P,P];
else
    erroe('Weong number of inputs.');
end