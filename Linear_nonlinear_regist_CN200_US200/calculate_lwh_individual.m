%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate the brain template size in length, width and height.
%}
clc;clear;
data_path='/disk2/guoyuan/make_template/template_all/child';
    length=[];
    width=[];
    height=[];
for i=1:1
    sub_name=fullfile(data_path,'CN200.nii.gz');
    nii_str = MRIread(sub_name);
    [l,w,h] = size(nii_str.vol);
    tra_mat = nii_str.vol(:,:,79);   % z=79 means AC-PC plane
    cor_mat = nii_str.vol(111,:,:);

    
    length_level=10;
    width_level=10;
    height_level=10;
    
    % calculate the length
    for j=1:l
        length_sum(j)=sum(tra_mat(j,:));
    end
    
    for j=1:l
        if length_sum(j)>length_level
            l_min=j;
            break;
        end
    end
    for j=1:l
        if length_sum(l-j+1)>length_level
            l_max=l-j+1;
            break;
        end
    end
    length(end+1)=l_max-l_min;
    
    % calculate the width
    for j=1:w
        width_sum(j)=sum(tra_mat(:,j));
    end
    
    for j=1:w
        if width_sum(j)>width_level
            w_min=j;
            break;
        end
    end
    for j=1:w
        if width_sum(w-j+1)>width_level
            w_max=w-j+1;
            break;
        end
    end
    width(end+1)=w_max-w_min;
    
    % calculate the height
    for j=1:h
        heigth_sum(j)=sum(cor_mat(1,:,j));
    end
    
    for j=1:h
        if heigth_sum(j)>height_level
            h_min=j;
            break;
        end
    end
    for j=1:h
        if heigth_sum(h-j+1)>height_level
            h_max=h-j+1;
            break;
        end
    end
   height(end+1)=h_max-h_min;
    
end
length_mean=mean(length);
length_std=std(length);

width_mean=mean(width);
width_std=std(width);

height_mean=mean(height);
height_std=std(height);

save('brain_size_9_11.mat','length_mean','length_std','width_mean','width_std','height_mean','height_std');
