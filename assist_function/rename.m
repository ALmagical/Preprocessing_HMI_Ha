function rename(maindir,extname)
%�������ļ�
%��ָ��Ҫ���������ļ�������
%ʹ��parfor���д���Ҫ��Ϊ���еĻ�ֻ�轫parfor��Ϊfor
%�޸����ļ���������ʱֻ����newname���崦��������޸ļ���
%Author:@ALong_GXL
%Date:2020.11.15
%Ver:0.1.0
%%
import matlab.io.*
%��Ŀ¼
subdir=dir(maindir);
file_num=length(subdir);
if nargin==1
    extname='all';
end
parfor i=1:file_num
    % ����.��..�����ļ���
    if( isequal( subdir( i ).name, '.' )||...
        isequal( subdir( i ).name, '..'))               
        continue;
    end
    name=subdir(i).name;
    path_file=strcat(maindir,name);
    if isfolder(path_file)
        %���ļ��� 
        path_data=strcat(path_file,'\');
        %�ݹ���ã��Ա���Ŀ���ļ��е�ȫ�����ļ����ļ���
        rename(path_data,extname);
    else
        try
         %��ȡ�ļ���չ��
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
            disp([oldname, ' �ѱ�������Ϊ ', newname]);
        else
            disp([oldname, ' ������ʧ��!']);
        end
        catch
            %�ļ���׺������ȫƥ��ʱ���׳��쳣�������������������Ϣ
            warning([path_file,'����ʧ�ܡ�']);
        end
    end
end