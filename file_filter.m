%根据Ha文件筛选对应的MDI文件，将获取时间相近的文件筛选出来并复制到目标文件夹
%Ha文件名（示例）:bbso_halph_fl_20130520_160102.fts
%MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.fits
%由于是根据文件名称里的日期和时间进行的筛选，
%因此仅适用于BBSO的Ha图像和JSOC的HMI图像
%参数说明
%共有8个输入参数，对应两个不同数据的信息
%maindir：要进行筛选的文件路径
%extname：需要筛选的的文件的后缀名，设置为-1时表示不考虑文件的后缀名
%filetype：用于区分数据来源，不同数据源的文件命名格式存在不同，
%目前仅分为BBSO和HMI
%save_path：目标文件夹
%Author：@ALong_GXL
%Date:2020.11.01
%Ver:0.3.0
%%
function []=file_filter(maindir_a,maindir_b,extname_a,extname_b,...
    filetype_a,filetype_b,save_path_a,save_path_b)
import matlab.io.*
%主目录
subdir_a=dir(maindir_a);
subdir_b=dir(maindir_b);

dirnum_a=length(subdir_a);
dirnum_b=length(subdir_b);
i=1;
j=1;
numtot=0;
while( (0<i) && (i<=dirnum_a) && (0<j) && (j<=dirnum_b))
    % 跳过.和..两个文件夹
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
    %一个文件夹中索引超出文件总数后直接跳出
    if j>dirnum_b
        break;
    end
    if i>dirnum_a
        break;
    end
    name_a=subdir_a(i).name;
    path_a=strcat(maindir_a,name_a);
    if isfolder(path_a)
         %子文件夹 
        path_a_new=strcat(path_a,'\');
        save_path_a_new=strcat(save_path_a,name_a);
        %递归调用，以遍历目标文件夹的全部子文件和文件夹
        file_filter(path_a_new,maindir_b,extname_a,extname_b,...
    filetype_a,filetype_b,save_path_a_new,save_path_b);
        %递归结束要改变外层的索引
        i=i+1;
        j=j+1;
    end
    %递归结束后索引可能已经越界
    if j>dirnum_b
        break;
    end
    if i>dirnum_a
        break;
    end
    name_b=subdir_b(j).name;
    path_b=strcat(maindir_b,name_b);
    if isfolder(path_b)
         %子文件夹 
        path_b_new=strcat(path_b,'\');
        save_path_b_new=strcat(save_path_b,name_b);
        %递归调用，以遍历目标文件夹的全部子文件和文件夹
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
        %获取文件扩展名
        [~,~,file_extname_a]=fileparts(path_a);
        [~,~,file_extname_b]=fileparts(path_b);
        try
            %判断文件扩展名
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
        %解析Ha文件和MDI文件的名称以确定时间和日期
        %Ha文件名（示例）:bbso_halph_fl_20130520_160102.jpg
        %MDI文件名（示例）:hmi.M_720s.20101014_190000_TAI.1.magnetogram.jpg
            %判断文件是否已经存在
            if isfile(strcat(save_path_a,'\',name_a))
                disp([strcat(save_path_a,'\',name_a),"已存在"]);
                i=i+1;
                if isfile(strcat(save_path_b,'\',name_b))
                    disp([strcat(save_path_b,'\',name_b),"已存在"]);
                    j=j+1;
                end
                continue;
            end
            if isfile(strcat(save_path_b,'\',name_b))
                disp([strcat(save_path_b,'\',name_b),"已存在"]);
                j=j+1;
                if isfile(strcat(save_path_a,'\',name_a))
                    disp([strcat(save_path_a,'\',name_a),"已存在"]);
                    i=i+1;
                end
                continue;
            end
            %判断文件类型
            if filetype_a=="BBSO"
                date_a=str2double(name_a(15:22));
                time_a=str2double(name_a(24:29));
            elseif filetype=="HMI"
                date_a=str2double(name_a(12:19));
                time_a=str2double(name_a(21:26));
            else
                error("请输入正确的文件类型。");
            end
            if filetype_b=="BBSO"
                date_b=str2double(name_b(15:22));
                time_b=str2double(name_b(24:29));
            elseif filetype_b=="HMI"
                date_b=str2double(name_b(12:19));
                time_b=str2double(name_b(21:26));
            else
                error("请输入正确的文件类型。");
            end
            %对获取时间为0点的进行特殊处理
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
            %将Ha和MDI图片的获取时间限制在正负5分钟
                if abs(time_a-time_b)<=500
                    %存储路径下文件夹不存在时创建文件夹
                    if ~exist(save_path_a,'dir')
                        mkdir(save_path_a);
                    end
                    %存储路径下文件夹不存在时创建文件夹
                    if ~exist(save_path_b,'dir')
                        mkdir(save_path_b);
                    end
                    copyfile(path_a,save_path_a);
                    copyfile(path_b,save_path_b);
                    i=i+1;
                    j=j+1;
                    numtot=numtot+1;
                    disp([path_a,'和',path_b,'已处理完成']);
                elseif time_a<time_b
                    i=i+1;
                else
                    j=j+1;
                end
            end
        catch
             warning([path_a,'处理失败。']);
             warning([path_b,'处理失败。']);
        end
        %disp([path_a,'和',path_b,'已处理完成']);
        %numtot=numtot+num_finish;
     end
end
disp(['共计处理',num2str(numtot),'个文件']);