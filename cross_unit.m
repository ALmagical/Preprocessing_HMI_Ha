function unit=cross_unit(size) 
%%
%生成十字状的结构元
%size为偶数时如何处理
%%
%unitsize为结构元尺寸
if size<=0
    error('输入值为非正数，请检查输入。');
end
if mod(size,2)==0
    error('输入值为偶数，请检查输入。');
end
unit=zeros(size);
unit_zero=size;
unit_center=(size-1)/2;
for j=1:size
    unit_zero=unit_zero-1;
    control_zero=abs(unit_zero-unit_center);
    for k=1:size-control_zero
        if (k-control_zero)>0            
            unit(j,k)=1;
        end
    end
end