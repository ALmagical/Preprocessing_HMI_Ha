function img_result = Luminance_Correction_2(img)
%用于对图像的亮度不均匀进行矫正
%img为输入的图像
%算法细节参见论文《Automatic Solar Filament Segmentation and Characterization》
%2020-03-01
%modify 2020-08-09
%
[high,width]=size(img);
x_c=high/2;
y_c=width/2;
x=zeros(1,4);
y=zeros(1,4);
xy=zeros(2);
xf=zeros(1,2);
yf=zeros(1,2);
f=0;
img=double(img);
for i=1:high
    for j=1:width
        for k=1:4
            x(k)=x(k)+i^k;
            y(k)=y(k)+i^k;
        end
        for m=1:2
            for n=1:2
                xy(m,n)=xy(m,n)+(i^m)*(j^n);
            end
        end
        for k=1:2
            xf(k)=xf(k)+(i^k)*img(i,j);
            yf(k)=yf(k)+(i^k)*img(i,j);
        end    
        f=f+img(i,j);
    end
end
H=[x(2) x(3) xy(1,1) xy(1,2) x(1)
   x(3) x(4) xy(2,1) xy(2,2) x(2)
   xy(1,1) xy(2,1) y(2) y(3) y(1)
   xy(1,2) xy(2,2) y(3) y(4) y(2)
   x(1) x(2) y(1) y(2) width+high
    ];
%inv_H=inv(H);
w=[xf yf f];
w=w.';
alpha=H\w;
f_result=zeros(high,width);
for i=1:high
    for j=1:width
        for k=1:2
        f_result(i,j)=f_result(i,j)+alpha(k)*abs((i-x_c)^k)-alpha(k+2)*abs((j-y_c)^k);
        end
        f_result(i,j)=f_result(i,j)+alpha(5);
    end
end
%f_result=f_result-min(f_result);
%f_result=uint8(f_result);
alpha
img_result=uint8(img-f_result);
figure();
imshow(uint8(f_result));