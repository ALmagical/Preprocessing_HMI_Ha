function []=cat_two_images(input_a, input_b, outputdir, extname)

import matlab.io.*

tic;
start=clock;

if input_a(length(input_a))~="\"
    input_a=strcat(input_a, '\');
end
if input_b(length(input_b))~="\"
    input_b=strcat(input_b, '\');
end
if outputdir(length(outputdir))~="\"
    outputdir=strcat(outputdir, '\');
end

file_a=dir(strcat(input_a, extname));
file_b=dir(strcat(input_b, extname));

num_file_a=length(file_a);
num_file_b=length(file_b);

if num_file_a==0
    disp(['‘',input_a,'’，不存在指定文件。']);
    return
end
if num_file_b==0
    disp(['‘',input_b,'’，不存在指定文件。']);
    return
end
if num_file_a~=num_file_b
    disp('图像数量不匹配');
    disp(['未处理',input_a,';',input_b]);
else
    if ~exist(outputdir, 'dir')
        mkdir(outputdir)
    end
    %     if( isequal( file_a(indx_a).name, '.' )||...
    %             isequal( file_a(indx_a).name, '..'))              
    %         continue;
    %     end
    %     if( isequal( file_b(indx_b).name, '.' )||...
    %             isequal( file_b(indx_b).name, '..'))              
    %         continue;
    %     end
    parfor k=1:num_file_a
        tic;
        img_a=imread(strcat(input_a, file_a(k).name));
        img_b=imread(strcat(input_b, file_b(k).name));
        [h, w, c]=size(img_a);
        if c==1
            img=zeros(h,w,3)
            img(:,:,1)=img_a;
            img(:,:,2)=img_a;
            img(:,:,3)=img_a;
            img_a=img;
        end
        [h, w, c]=size(img_b);
        if c==1
            img=zeros(h,w,3)
            img(:,:,1)=img_b;
            img(:,:,2)=img_b;
            img(:,:,3)=img_b;
            img_b=img;
        end
        result=cat(2,img_a,img_b);
        imwrite(result,strcat(outputdir,file_a(k).name),'jpg','Quality',100);
    end
end
time=etime(clock,start);
secs=mod(time,60);
mins=fix(time/60);
hours=fix(mins/60);
mins=mod(mins,60);
disp(['总运行时间：',num2str(hours),' h ',num2str(mins),' m ',num2str(secs),' s']);
