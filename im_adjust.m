function im_result=im_adjust(im_a,im_b,radius_a,radius_b)
%˵�������������ڽ������ߴ���ͬͼ���е�����(Բ��)��С����Ϊһ��
%Ҫ��radius_a>radius_b��������ͼ��a�е�����(Բ��)ֱ����Ҫ��������ͼ��b�е�����(Բ��)
%�������ͼ��b���зŴ������(Բ��)������Ϊ��������ģ���ͼ����вü���ʹ����ͼ��ߴ�һ��
%������벻����Ҫ�󣬳���ʲô����������������ͼ��b��Ϊ�������
%%
im_result=im_b;
radius_ratio=radius_a/radius_b;
if radius_ratio > 1  %������Ϊ1ʱ���е�����Ϊ1�Ļ��������κβ���
    [h_a,w_a]=size(im_a);
    [h_b,w_b]=size(im_b);
    im_b=imresize(im_b,radius_ratio);
    if radius_ratio>1
        x_min=h_b*abs(radius_ratio-1)/2;
        y_min=w_b*abs(radius_ratio-1)/2;
        im_result=imcrop(im_b,[x_min,y_min,w_a-1,h_a-1]); %imcrop�����ĸ�����Ϊx��y����Сֵ�Լ�ͼ��Ŀ�Ⱥ͸߶�
    end
end
%figure('name','������С���ͼ��');
%imshow(im_result);