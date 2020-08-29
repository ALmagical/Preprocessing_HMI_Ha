%����Ha�ļ�ɸѡ��Ӧ��MDI�ļ�
%������BBSO��Haͼ���JSOC��MDIͼ��
%Ha�ļ�����ʾ����:bbso_halph_fl_20130520_160102.jpg
%MDI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
%%
close all;
import matlab.io.*
maindir_ha='D:\Dataset\Filament\JPG\BBSO\';
maindir_mdi='D:\Dataset\Filament\JPG\MDI\';
subdir_ha=dir(maindir_ha);
subdir_mdi=dir(maindir_mdi);
save_ha='D:\Dataset\Filament_test\BBSO\';
save_mdi='D:\Dataset\Filament_test\MDI\';
numtot=0;  %��¼������ļ���
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_mdi=length(subdir_mdi);
i=0;
j=0;
while( (0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_mdi))
    i=i+1;
    j=j+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
        isequal( subdir_ha( i ).name, '..')||...
        ~subdir_ha( i ).isdir)               % �������Ŀ¼������
        continue;
    end

    if( isequal( subdir_mdi( j ).name, '.' )||...
        isequal( subdir_mdi( j ).name, '..')||...
        ~subdir_mdi( j ).isdir)               % �������Ŀ¼������
        continue;
    end
    %�ж��ļ��������Ƿ�ƥ��
    if ((i<=dirnum_ha) && (j<=dirnum_mdi))
        false=0;
        %�ļ���������ʽʾ����20101014-16
        while subdir_ha(i).name ~= subdir_mdi(j).name
            name_ha=subdir_ha(i).name(1:8);
            name_mdi=subdir_mdi(j).name(1:8);
            if str2double(name_ha)<str2double(name_mdi)
                i=i+1;
            elseif str2double(name_ha)>str2double(name_mdi)
                j=j+1;
            else
                disp(['�ļ������Ʋ�ƥ��',',Ha�ļ�������Ϊ:',subdir_ha(i)...
                    ,'MDI�ļ�������Ϊ:',subdir_mdi(j)],'�������ļ������ƣ�');
                false=1;
            end
        end
        if (false==1)
            continue;
        end
        datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %��ȡHa�ļ���·��
        datapath_mdi=strcat(maindir_mdi,subdir_mdi(i).name,'\');%��ȡMDI�ļ���·��
        path_save_ha=strcat(save_ha,subdir_ha(i).name,'\');    %����Ha�ļ���·��  
        path_save_mdi=strcat(save_mdi,subdir_mdi(i).name,'\'); %����MDI�ļ���·��  

        %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
        direc_ha=dir(strcat(datapath_ha,extname));  %��ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
        direc_mdi=dir(strcat(datapath_mdi,extname));  
        filenum_ha=length(direc_ha);
        filenum_mdi=length(direc_mdi);
        %�ļ���Ϊ�������
        if filenum_ha==0
            disp(['��',datapath_ha,'��Ϊ���ļ��С�']);
            j=j-1;       %����mdi�ļ��б��ֲ���
            continue;
        end
        if filenum_mdi==0
            disp(['��',datapath_mdi,'��Ϊ���ļ��С�']);
            i=i-1;
            continue;
        end
        %�洢·�����ļ��в�����ʱ�����ļ���
        if ~exist(path_save_ha,'dir')
            mkdir(path_save_ha);
        end
        if ~exist(path_save_mdi,'dir')
            mkdir(path_save_mdi);
        end
        index_ha=1;
        index_mdi=1;
        while((0<=index_ha) && (index_ha<=filenum_ha) && (index_mdi>=0) && (index_mdi<=filenum_mdi))
            while ((0<=index_ha) && (index_ha<=filenum_ha) && (index_mdi>=0) && (index_mdi<=filenum_mdi))
                name_ha=direc_ha(index_ha).name;
                name_mdi=direc_mdi(index_mdi).name;
                savename_ha=strcat(path_save_ha,name_ha);
                savename_mdi=strcat(path_save_mdi,name_mdi);
                %�ļ��Ѿ�����
                if exist(savename_ha,'file')
                    index_ha=index_ha+1;
                end
                if exist(savename_mdi,'file')
                    index_mdi=index_mdi+1;
                end
                %Ha�ļ���MDI�ļ���������
                if ~exist(savename_ha,'file') || ~exist(savename_mdi,'file')
                    break;
                end
            end
            %����Ha�ļ���MDI�ļ���������ȷ��ʱ�������
            %Ha�ļ�����ʾ����:bbso_halph_fl_20130520_160102.jpg
            %MDI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
            data_ha=str2double(name_ha(15:22));
            data_mdi=str2double(name_mdi(12:19));
            time_ha=str2double(name_ha(24:29));
            time_mdi=str2double(name_mdi(21:26));
            %��Ha��MDIͼƬ�Ļ�ȡʱ������������3����
            if data_ha==data_mdi
                if abs(time_ha-time_mdi)<=300
                    copyfile(strcat(datapath_ha,name_ha),path_save_ha);
                    copyfile(strcat(datapath_mdi,name_mdi),path_save_mdi);
                    index_ha=index_ha+1;
                    index_mdi=index_mdi+1;
                    num_finish=num_finish+1;
                elseif time_ha<time_mdi
                    index_ha=index_ha+1;
                else
                    index_mdi=index_mdi+1;
                end
            elseif data_ha<data_mdi
              index_ha=index_ha+1;
            else
              index_mdi=index_mdi+1;
            end
        end
        disp([datapath_ha,'��',datapath_mdi,'�µ�',num2str(num_finish),'�ļ��Ѵ������']);
        numtot=numtot+num_finish;
     end
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);