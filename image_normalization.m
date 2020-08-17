function im_nor=image_normalization(B0,range1)
%UNTITLED3 将图像归一化到0-4096
%   此处显示详细说明
oriImage =B0;
% % grayImage = rgb2gray(oriImage);
grayImage = B0;
% figure;imshow(grayImage,[]);title('grayImage')         % grayImage：figure4
% %  [height,width]=size(grayImage);
% %     for i=1:height
% %         for j=1:width
% %             if grayImage(i,j)==0
% %                 grayImage(i,j)=1024;
% %             end
% %         end
% %     end
% %     figure,imshow(grayImage,[]);
% %     title('grayImage')
% originalMinValue = double(min(min(grayImage)));
% originalMaxValue = double(max(max(grayImage)));
% originalRange = originalMaxValue - originalMinValue;

% % Get a double image in the range 0 to +255
% desiredMin = 0;
% desiredMax =range;
% desiredRange = desiredMax - desiredMin;
% dblImageS255 = desiredRange * (double(grayImage) - originalMinValue) / originalRange + desiredMin;


[m,n]=size(grayImage);
for i=1:m
    for j=1:n
        d= grayImage(i,j);
        if d<=0
            d=0;
        else if  d>1
                d=1;
            else  d=d;
            end
        end
        grayImage(i,j)=d;
    end
end
% figure;imshow(grayImage,[]);      % grayImage：figure4
dblImageS255 = range1 * (grayImage);
im_nor=round(dblImageS255);     % round()：用于舍入到最接近的数
% figure;imshow(im_nor,[]);title('im_nor')        % im_nor：figure4
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

