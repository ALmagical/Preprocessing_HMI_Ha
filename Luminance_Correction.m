function img_result = Luminance_Correction(img)
%用于对图像的亮度不均匀进行矫正
%img为输入的图像
%算法细节参见论文《Automatic Solar Filament Segmentation and Characterization》
%2020-03-01
%modify 2020-08-09
%
[high,width]=size(img);
x_c=high/2;
y_c=width/2;
x_2=0;
x_y=0;
x=0;
y=0;
y_2=0;
x_f=0;
y_f=0;
f=0;
img=double(img);
for i=1:high
    for j=1:width
        %%%%%
        x_2=x_2+i^2;
        y_2=y_2+j^2;
        x_y=x_y+i*j;
        x=x+i;
        y=y+j;
        x_f=x_f+i*img(i,j);
        y_f=y_f+j*img(i,j);
        f=f+img(i,j);
        %%%%%
        %x_2=x_2+(abs(i-x_c))^2;
        %y_2=y_2+(abs(j-y_c))^2;
        %x_y=x_y+abs(i-x_c)*abs(j-y_c);
        %x=x+abs(i-x_c);
        %y=y+abs(j-y_c);
        %x_f=x_f+abs(i-x_c)*img(i,j);
        %y_f=y_f+abs(j-y_c)*img(i,j);
        %f=f+img(i,j);
    end
end
H=[x_2 x_y x;x_y y_2 y;x y high+width];
%inv_H=inv(H);
w=[x_f;y_f;f];
alpha=H\w;
f_result=zeros(high,width);
for i=1:high
    for j=1:width
        f_result(i,j)=alpha(1)*abs((i-x_c))-alpha(2)*abs((j-y_c))+alpha(3);
    end
end
%f_result=f_result-min(f_result);
%f_result=uint8(f_result);
alpha
img_result=uint8(img-f_result);
%figure();
%imshow(uint8(f_result));


    

