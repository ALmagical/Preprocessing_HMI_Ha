function im_res=image_normalization(img,range)
%%
%��ͼ���һ����0-range
%�˴���ʾ��ϸ˵��
%%
img_gray = img;

[m,n]=size(img_gray);
for i=1:m
    for j=1:n
        d=img_gray(i,j);
        if d<=0
            d=0;
        elseif  d>1
                d=1;
        end
        img_gray(i,j)=d;
    end
end
% figure;imshow(img_gray,[]);      % grayImage��figure4
img_duble = range * (img_gray);
im_res=round(img_duble);     % round()���������뵽��ӽ�����
% figure;imshow(im_nor,[]);title('im_nor')        % im_nor��figure4
% im_nor=dblImageS255;
% % % Get a double image in the range 0 to +1
% % desiredMin = 0;
% % desiredMax = 1;
% % desiredRange = desiredMax - desiredMin;
% % dblImageS1 = desiredRange * (double(grayImage) - originalMinValue) / originalRange + desiredMin;
% %
% % figure;
% % imshow(dblImageS1);
%
% % Another way to normalazation, which only calls MATLAB function

end

