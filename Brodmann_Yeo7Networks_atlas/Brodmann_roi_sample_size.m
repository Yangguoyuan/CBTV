% calculate the deformation_value in bordmann areas
clc;
clear;

%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate the deformation_value in Bordmann areas
%}

deform_path='/guoyuan_data/make_template_hcp/MNI_Brodmann/transform/deformation_map/reslice_deform/reslice_deform';
num_sub_adult=[20 40 60 80 100 150 200 250 300 350 400];

 bordmann=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann','rBrodmann.img');
 data=ones(length(num_sub_adult),48);
 brod_matrix=MRIread(bordmann);
 for i=1:length(num_sub_adult)
    sub_num=fullfile(deform_path,['sub_ba_',num2str(num_sub_adult(i)),'Warp.nii']);
    sub_matrix=MRIread(sub_num);
    for j=1:48
        brod_new=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/brodmann_atlas',['brodmann_area',num2str(j,'%03d'),'.nii']);
        %brod_matrix=MRIread(bordmann);
        bordmann_matrix=brod_matrix.vol;
        bordmann_matrix(bordmann_matrix~=j)=0;
        bordmann_matrix(bordmann_matrix==j)=1;
        brod_matrix.vol=bordmann_matrix;
        MRIwrite(brod_matrix,brod_new);
        data(i,j)=sum(sum(sum((sub_matrix.vol).*bordmann_matrix)))/sum(sum(sum(bordmann_matrix)));
    end
 end
        
