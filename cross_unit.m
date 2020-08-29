function unit=cross_unit(unitsize) 
%%
%生成十字状的结构元
%%
%unitsize为结构元尺寸
unit=zeros(unitsize);
unit_zero=unitsize;
unit_center=(unitsize-1)/2;
for j=1:unitsize
    unit_zero=unit_zero-1;
    control_zero=abs(unit_zero-unit_center);
    for k=1:unitsize-control_zero
        if (k-control_zero)>0            
            unit(j,k)=1;
        end
    end
end