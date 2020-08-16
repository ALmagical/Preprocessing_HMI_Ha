function img_result = Luminance_Correction_4(img)
%用于对图像的亮度不均匀进行矫正
%img为输入的图像
%算法细节参见论文《Automatic Solar Filament Segmentation and Characterization》
%2020-03-01
%modify 2020-08-09
%
[high,width]=size(img);
x=zeros(1,8);
y=zeros(1,8);
xy=zeros(4);
xf=zeros(1,4);
yf=zeros(1,4);
f=0;
img=double(img);
for i=1:high
    for j=1:width
        for k=1:8
            x(k)=x(k)+i^k;
            y(k)=y(k)+i^k;
        end
        for m=1:4
            for n=1:4
                xy(m,n)=xy(m,n)+(i^m)*(j^n);
            end
        end
        for k=1:4
            xf(k)=xf(k)+(i^k)*img(i,j);
            yf(k)=yf(k)+(i^k)*img(i,j);
        end    
        f=f+img(i,j);
    end
end
H=[x(2) x(3) x(4) x(5) xy(1,1) xy(1,2) xy(1,3) xy(1,4) x(1)
   x(3) x(4) x(5) x(6) xy(2,1) xy(2,2) xy(2,3) xy(2,4) x(2)
   x(4) x(5) x(6) x(7) xy(3,1) xy(3,2) xy(3,3) xy(3,4) x(3)
   x(5) x(6) x(7) x(8) xy(4,1) xy(4,2) xy(4,3) xy(4,4) x(4)
   xy(1,1) xy(2,1) xy(3,1) xy(4,1) y(2) y(3) y(4) y(5) y(1)
   xy(1,2) xy(2,2) xy(3,2) xy(4,2) y(3) y(4) y(5) y(6) y(2)
   xy(1,3) xy(2,3) xy(3,3) xy(4,3) y(4) y(5) y(6) y(7) y(3)
   xy(1,4) xy(2,4) xy(3,4) xy(4,4) y(5) y(6) y(7) y(8) y(4)
   x(1) x(2) x(3) x(4) y(1) y(2) y(3) y(4) width+high
    ];
%inv_H=inv(H);
w=[xf yf f];
w=w.';
alpha=H\w;
f_result=zeros(high,width);
for i=1:high
    for j=1:width
        for k=1:4
        f_result(i,j)=f_result(i,j)+alpha(k)*(i^k)+alpha(k+4)*(j^k);
        end
        f_result(i,j)=f_result(i,j)+alpha(9);
    end
end
%f_result=f_result-min(f_result);
%f_result=uint8(f_result);
alpha
img_result=uint8(img-f_result);
figure();
imshow(uint8(f_result));
