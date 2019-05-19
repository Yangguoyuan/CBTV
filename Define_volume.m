clc;
clear;

    sub_path='/guoyuan_data/make_template_hcp/show40_200/40/a_sub_average.nii';
    if exist(sub_path,'file') 
       mri_data=MRIread(sub_path);
       mean_data=mean(mean(mean(mean(abs(mri_data.vol)))))*3;
       all_deform(end+1)=mean_data;
    end
