import matlab.io.*
maindir='C:\Users\11054\Desktop\test\source\';
subdir=dir(maindir);
maindir_save='C:\Users\11054\Desktop\test\out\';%保存fits图的路径
numtot=0;  %记录处理的文件数
for i=1:length(subdir)
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..')||...
        ~subdir( i ).isdir)               % 如果不是目录则跳过
        continue;
    end
    datapath_m=strcat(maindir,subdir(i).name,'\');  %读取fits文件的路径
    path_save=strcat(maindir_save,subdir(i).name,'\');%保存fits图的路径    
    extname_m='*.fts';  
    direc_m=dir(strcat(datapath_m,extname_m));  %（strcat：连接字符串函数）显示当前路径目录下的文件和文件夹
    %dir函数获得指定文件夹下的所有子文件夹和文件,并存放在在一种为文件结构体数组中.
    filetot=length(direc_m);
    if ~exist(path_save,'dir')
        mkdir(path_save);
    end
    disp(['正在处理',datapath_m,'下的文件，文件数共计',num2str(filetot)]);
    errornum=0;
    %batchsize=10;
    for Num=1:filetot
        %if exist(direc_m(Num).name,'file')
            %continue;
        %end
        file_name = strcat(datapath_m,direc_m(Num).name);
        file_save = strcat(path_save,direc_m(Num).name(1:length(direc_m(Num).name)-4),'.jpg');
        test_fits2jpg_bbso_ha(file_name,file_save);
    end
    disp([datapath_m,'下的',num2str(filetot),'文件已处理完成']);
    disp(['其中成功',num2str(filetot-errornum),'个，失败',num2str(errornum),'个']);
    numtot=numtot+filetot;
end
disp(['共计处理',num2str(numtot),'个文件']);