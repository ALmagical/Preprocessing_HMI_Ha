%����Ha�ļ�ɸѡ��Ӧ��MDI�ļ�
%������BBSO��Haͼ���JSOC��MDIͼ��
%Ha�ļ�����ʾ����:bbso_halph_fl_20130520_160102.jpg
%MDI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
%ɸѡʱ���ִ���
%%
close all;
import matlab.io.*
%��Ŀ¼
maindir_ha='D:\Dataset\JPG\BBSO\';
maindir_hmi='D:\Dataset\JPG\HMI\';
subdir_ha=dir(maindir_ha);
subdir_hmi=dir(maindir_hmi);
save_ha='D:\Dataset\Train_data\BBSO\';
save_hmi='D:\Dataset\Train_data\HMI\';
numtot=0;  %��¼������ļ���
extname='*.jpg'; 
dirnum_ha=length(subdir_ha);
dirnum_hmi=length(subdir_hmi);
i=0;
j=0;
while( (0<=i) && (i<dirnum_ha) && (j>=0) && (j<dirnum_hmi))
    i=i+1;
    j=j+1;
    num_finish=0;
    if( isequal( subdir_ha( i ).name, '.' )||...
        isequal( subdir_ha( i ).name, '..')||...
        ~subdir_ha( i ).isdir)               % �������Ŀ¼������
        continue;
    end

    if( isequal( subdir_hmi( j ).name, '.' )||...
        isequal( subdir_hmi( j ).name, '..')||...
        ~subdir_hmi( j ).isdir)               % �������Ŀ¼������
        continue;
    end
    %�ж��ļ��������Ƿ�ƥ��
    if ((i<=dirnum_ha) && (j<=dirnum_hmi))
        false=0;
        %�ļ���������ʽʾ����2010
        while subdir_ha(i).name ~= subdir_hmi(j).name
            name_ha=subdir_ha(i).name;
            name_hmi=subdir_hmi(j).name;
            if str2double(name_ha)<str2double(name_hmi)
                i=i+1;
            elseif str2double(name_ha)>str2double(name_hmi)
                j=j+1;
            else
                disp(['�ļ������Ʋ�ƥ��',',Ha�ļ�������Ϊ:',subdir_ha(i)...
                    ,'MDI�ļ�������Ϊ:',subdir_hmi(j)],'�������ļ������ƣ�');
                false=1;
            end
        end
        if (false==1)
            continue;
        end
        datapath_ha=strcat(maindir_ha,subdir_ha(i).name,'\');  %��ȡHa�ļ���·��
        datapath_hmi=strcat(maindir_hmi,subdir_hmi(i).name,'\');%��ȡMDI�ļ���·��
        path_save_ha=strcat(save_ha,subdir_ha(i).name,'\');    %����Ha�ļ���·��  
        path_save_hmi=strcat(save_hmi,subdir_hmi(i).name,'\'); %����MDI�ļ���·��  

        %dir�������ָ���ļ����µ��������ļ��к��ļ�,���������һ��Ϊ�ļ��ṹ��������.
        direc_ha=dir(strcat(datapath_ha,extname));  %��ʾ��ǰ·��Ŀ¼�µ��ļ����ļ���
        direc_hmi=dir(strcat(datapath_hmi,extname));  
        filenum_ha=length(direc_ha);
        filenum_hmi=length(direc_hmi);
        %�ļ���Ϊ�������
        if filenum_ha==0
            disp(['��',datapath_ha,'��Ϊ���ļ��С�']);
            j=j-1;       %����mdi�ļ��б��ֲ���
            continue;
        end
        if filenum_hmi==0
            disp(['��',datapath_hmi,'��Ϊ���ļ��С�']);
            i=i-1;
            continue;
        end
        %�洢·�����ļ��в�����ʱ�����ļ���
        if ~exist(path_save_ha,'dir')
            mkdir(path_save_ha);
        end
        if ~exist(path_save_hmi,'dir')
            mkdir(path_save_hmi);
        end
        index_ha=1;
        index_hmi=1;
        while((0<=index_ha) && (index_ha<=filenum_ha) && (index_hmi>=0) && (index_hmi<=filenum_hmi))
            while ((0<=index_ha) && (index_ha<=filenum_ha) && (index_hmi>=0) && (index_hmi<=filenum_hmi))
                name_ha=direc_ha(index_ha).name;
                name_hmi=direc_hmi(index_hmi).name;
                savename_ha=strcat(path_save_ha,name_ha);
                savename_hmi=strcat(path_save_hmi,name_hmi);
                %�ļ��Ѿ�����
                if exist(savename_ha,'file')
                    index_ha=index_ha+1;
                end
                if exist(savename_hmi,'file')
                    index_hmi=index_hmi+1;
                end
                %Ha�ļ���MDI�ļ���������
                if ~exist(savename_ha,'file') || ~exist(savename_hmi,'file')
                    break;
                end
            end
            %����Ha�ļ���MDI�ļ���������ȷ��ʱ�������
            %Ha�ļ�����ʾ����:bbso_halph_fl_20130520_160102.jpg
            %MDI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
            date_ha=str2double(name_ha(15:22));
            date_hmi=str2double(name_hmi(12:19));
            time_ha=str2double(name_ha(24:29));
            time_mdi=str2double(name_hmi(21:26));
            %��Ha��MDIͼƬ�Ļ�ȡʱ������������5����
            if date_ha==date_hmi
                if abs(time_ha-time_mdi)<=500
                    copyfile(strcat(datapath_ha,name_ha),path_save_ha);
                    copyfile(strcat(datapath_hmi,name_hmi),path_save_hmi);
                    index_ha=index_ha+1;
                    index_hmi=index_hmi+1;
                    num_finish=num_finish+1;
                elseif time_ha<time_mdi
                    index_ha=index_ha+1;
                else
                    index_hmi=index_hmi+1;
                end
            elseif date_ha<date_hmi
              index_ha=index_ha+1;
            else
              index_hmi=index_hmi+1;
            end
        end
        disp([datapath_ha,'��',datapath_hmi,'�µ�',num2str(num_finish),'�ļ��Ѵ������']);
        numtot=numtot+num_finish;
     end
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);