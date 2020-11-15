function rename(maindir,extname)
%重命名文件
%可指定要重命名的文件的类型
%使用parfor并行处理，要改为串行的话只需将parfor改为for
%修改新文件命名规则时只需在newname定义处对齐进行修改即可
%Author:@ALong_GXL
%Date:2020.11.15
%Ver:0.1.0
%%
import matlab.io.*
%主目录
subdir=dir(maindir);
file_num=length(subdir);
if nargin==1
    extname='all';
end
parfor i=1:file_num
    % 跳过.和..两个文件夹
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..'))               
        continue;
    end
    name=subdir(i).name;
    path_file=strcat(maindir,name);
    if isfolder(path_file)
        %子文件夹 
        path_data=strcat(path_file,'\');
        %递归调用，以遍历目标文件夹的全部子文件和文件夹
        rename(path_data,extname);
    else
        try
         %获取文件扩展名
        [~,~,file_extname]=fileparts(path_file);       
        if ~strcmp(extname,'all')
            if ~strcmp(extname,file_extname)
                error('The extend name of file is wrong.');
            end
        end
        oldname=path_file;
        newname=strcat(name(1:(length(name)-4)),'_fusion.jpg');
        % help rename in dos:
        %   RENAME [drive:][path]filename1 filename2
        %   REN [drive:][path]filename1 filrname2
        %   Note that you cannot specify a new drive or path for your
        %   destination file.
        command=['rename' 32 oldname 32 newname];
        status=dos(command);
        if status == 0
            disp([oldname, ' 已被重命名为 ', newname]);
        else
            disp([oldname, ' 重命名失败!']);
        end
        catch
            %文件后缀名不完全匹配时会抛出异常，在命令行输出警告信息
            warning([path_file,'处理失败。']);
        end
    end
end