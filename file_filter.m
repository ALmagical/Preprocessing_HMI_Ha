%����Ha�ļ�ɸѡ��Ӧ��MDI�ļ�������ȡʱ��������ļ�ɸѡ���������Ƶ�Ŀ���ļ���
%Ha�ļ�����ʾ����:bbso_halph_fl_20130520_160102.fts
%MDI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.fits
%�����Ǹ����ļ�����������ں�ʱ����е�ɸѡ��
%��˽�������BBSO��Haͼ���JSOC��HMIͼ��
%����˵��
%����8�������������Ӧ������ͬ���ݵ���Ϣ
%maindir��Ҫ����ɸѡ���ļ�·��
%extname����Ҫɸѡ�ĵ��ļ��ĺ�׺��������Ϊ-1ʱ��ʾ�������ļ��ĺ�׺��
%filetype����������������Դ����ͬ����Դ���ļ�������ʽ���ڲ�ͬ��
%Ŀǰ����ΪBBSO��HMI
%save_path��Ŀ���ļ���
%Author��@ALong_GXL
%Date:2020.11.01
%Ver:0.3.0
%%
function []=file_filter(maindir_a,maindir_b,extname_a,extname_b,...
    filetype_a,filetype_b,save_path_a,save_path_b)
import matlab.io.*
%��Ŀ¼
subdir_a=dir(maindir_a);
subdir_b=dir(maindir_b);

dirnum_a=length(subdir_a);
dirnum_b=length(subdir_b);
i=1;
j=1;
numtot=0;
while( (0<i) && (i<=dirnum_a) && (0<j) && (j<=dirnum_b))
    % ����.��..�����ļ���
    if( isequal( subdir_a( i ).name, '.' )||...
        isequal( subdir_a( i ).name, '..'))           
        i=i+1;
        continue;
    end

    if( isequal( subdir_b( j ).name, '.' )||...
        isequal( subdir_b( j ).name, '..'))
        j=j+1;
        continue;
    end
    %һ���ļ��������������ļ�������ֱ������
    if j>dirnum_b
        break;
    end
    if i>dirnum_a
        break;
    end
    name_a=subdir_a(i).name;
    path_a=strcat(maindir_a,name_a);
    if isfolder(path_a)
         %���ļ��� 
        path_a_new=strcat(path_a,'\');
        save_path_a_new=strcat(save_path_a,name_a);
        %�ݹ���ã��Ա���Ŀ���ļ��е�ȫ�����ļ����ļ���
        file_filter(path_a_new,maindir_b,extname_a,extname_b,...
    filetype_a,filetype_b,save_path_a_new,save_path_b);
        %�ݹ����Ҫ�ı���������
        i=i+1;
        j=j+1;
    end
    %�ݹ���������������Ѿ�Խ��
    if j>dirnum_b
        break;
    end
    if i>dirnum_a
        break;
    end
    name_b=subdir_b(j).name;
    path_b=strcat(maindir_b,name_b);
    if isfolder(path_b)
         %���ļ��� 
        path_b_new=strcat(path_b,'\');
        save_path_b_new=strcat(save_path_b,name_b);
        %�ݹ���ã��Ա���Ŀ���ļ��е�ȫ�����ļ����ļ���
        file_filter(maindir_a,path_b_new,extname_a,extname_b,...
    filetype_a,filetype_b,save_path_a,save_path_b_new);
        i=i+1;
        j=j+1;
    end
    if j>dirnum_b
        break;
    end
    if i>dirnum_a
        break;
    end
    if isfile(path_a)&&isfile(path_b)
        %��ȡ�ļ���չ��
        [~,~,file_extname_a]=fileparts(path_a);
        [~,~,file_extname_b]=fileparts(path_b);
        try
            %�ж��ļ���չ��
            if extname_a~=-1
                if file_extname_a~=extname_a
                    i=i+1;
                    continue;
                end
            end
            if extname_b~=-1
                if file_extname_b~=extname_b
                    j=j+1;
                    continue;
                end
            end
        %����Ha�ļ���MDI�ļ���������ȷ��ʱ�������
        %Ha�ļ�����ʾ����:bbso_halph_fl_20130520_160102.jpg
        %MDI�ļ�����ʾ����:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
            %�ж��ļ��Ƿ��Ѿ�����
            if isfile(strcat(save_path_a,'\',name_a))
                disp([strcat(save_path_a,'\',name_a),"�Ѵ���"]);
                i=i+1;
                if isfile(strcat(save_path_b,'\',name_b))
                    disp([strcat(save_path_b,'\',name_b),"�Ѵ���"]);
                    j=j+1;
                end
                continue;
            end
            if isfile(strcat(save_path_b,'\',name_b))
                disp([strcat(save_path_b,'\',name_b),"�Ѵ���"]);
                j=j+1;
                if isfile(strcat(save_path_a,'\',name_a))
                    disp([strcat(save_path_a,'\',name_a),"�Ѵ���"]);
                    i=i+1;
                end
                continue;
            end
            %�ж��ļ�����
            if filetype_a=="BBSO"
                date_a=str2double(name_a(15:22));
                time_a=str2double(name_a(24:29));
            elseif filetype=="HMI"
                date_a=str2double(name_a(12:19));
                time_a=str2double(name_a(21:26));
            else
                error("��������ȷ���ļ����͡�");
            end
            if filetype_b=="BBSO"
                date_b=str2double(name_b(15:22));
                time_b=str2double(name_b(24:29));
            elseif filetype_b=="HMI"
                date_b=str2double(name_b(12:19));
                time_b=str2double(name_b(21:26));
            else
                error("��������ȷ���ļ����͡�");
            end
            %�Ի�ȡʱ��Ϊ0��Ľ������⴦��
            if time_a==0
                time_a=240000;
                date_a=date_a-1;
            end
            if time_b==0
                time_b=240000;
                date_b=date_b-1;
            end
            if date_a>date_b
                j=j+1;
                continue;
            elseif date_a<date_b
                i=i+1;
                continue;
            else
            %��Ha��MDIͼƬ�Ļ�ȡʱ������������5����
                if abs(time_a-time_b)<=500
                    %�洢·�����ļ��в�����ʱ�����ļ���
                    if ~exist(save_path_a,'dir')
                        mkdir(save_path_a);
                    end
                    %�洢·�����ļ��в�����ʱ�����ļ���
                    if ~exist(save_path_b,'dir')
                        mkdir(save_path_b);
                    end
                    copyfile(path_a,save_path_a);
                    copyfile(path_b,save_path_b);
                    i=i+1;
                    j=j+1;
                    numtot=numtot+1;
                    disp([path_a,'��',path_b,'�Ѵ������']);
                elseif time_a<time_b
                    i=i+1;
                else
                    j=j+1;
                end
            end
        catch
             warning([path_a,'����ʧ�ܡ�']);
             warning([path_b,'����ʧ�ܡ�']);
        end
        %disp([path_a,'��',path_b,'�Ѵ������']);
        %numtot=numtot+num_finish;
     end
end
disp(['���ƴ���',num2str(numtot),'���ļ�']);