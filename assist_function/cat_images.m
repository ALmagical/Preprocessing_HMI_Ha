function []=cat_images(inputdirs, outputdir, extname)
%%
%用于拼接多幅图像
%单层文件夹
%extname 文件后缀名，即文件类型，只支持单类型
%inputdirs 输入文件夹，为一个数组
%outputdir 输出文件夹
%%
tic;
t_start=clock;
num_img=length(inputdirs);
disp(['需要将',str(num_img),'幅图像拼合在一起']);
disp(['要拼接的图像所在文件夹为：',inputdirs]);
num_tot=0;
row=floor(sqrt(num_img));
col=floor(num_img/row);
num_file=zeros(1,num_img);
dir_input=[];
%num_extname=length(extname);
for i=1:num_img
    dir_input=[dir_input,dir(strcat(inputdirs(i),extname))];
    num_file(i)=length(dir_input(i));
    if num_file(i)==0
        error(strcat('‘',inputdirs(i),'’，为空文件夹。'));
    end
    if num_file(i)~=num_file(1)
       error('输入文件夹中文件数目不相同，请检查文件夹是否正确。');
    end
end

