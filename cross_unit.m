function unit=cross_unit(size) 
%%
%����ʮ��״�ĽṹԪ
%sizeΪż��ʱ��δ���
%%
%unitsizeΪ�ṹԪ�ߴ�
if size<=0
    error('����ֵΪ���������������롣');
end
if mod(size,2)==0
    error('����ֵΪż�����������롣');
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