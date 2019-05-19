clc;clear;

%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate the deformation_value in Bordmann areas (asymmetric)
%}

 mni152=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann','MNI152_T1_1mm_brain.nii');
 data=ones(2,48);
 brod_matrix_new=MRIread(mni152);
 num_sub_adult={'merge_ch_us1Warp.nii.gz','merge_us_ch1Warp.nii.gz'};
 [x,y,z]=size(brod_matrix_new.vol);
 sub_vol=zeros(x,y,z);
 sub_vol1=zeros(x,y,z);
 for i=1:length(num_sub_adult)
     new_deform=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_affine_dv_CN_US/deformation_field',char(num_sub_adult(i)));
     sub_matrix=MRIread(new_deform);
     sub_vol=sub_matrix.vol+sub_vol;
 end
 sub_vol=sub_vol/2;
 brodmann_LR={'brodmann_L','brodmann_R'};
 
 for i=1:length(brodmann_LR)
      bordmann=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/calculate_left_right/brodmann_template_LR',char(brodmann_LR(i)));
      brod_matrix=MRIread(bordmann);
      save_brod=brod_matrix;
      brod_matrix_new1=brod_matrix.vol;
    for j=1:48

        bordmann_matrix=brod_matrix.vol;
        bordmann_matrix(bordmann_matrix~=j)=0;
        bordmann_matrix(bordmann_matrix==j)=1;

        
        data(i,j)=sum(sum(sum((sub_vol).*bordmann_matrix)))/(sum(sum(sum(bordmann_matrix)))+1);
        
        brod_matrix_new1(brod_matrix_new1==j)=data(i,j);
        save_brod.vol=bordmann_matrix;
        save_bord_path=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/brodmann_atlas/brodman_L_R',[char(brodmann_LR(i)),'are',num2str(j,'%02d'),'.nii']);
        MRIwrite(save_brod,save_bord_path);
        
    end
    dv_new=fullfile('/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/calculate_left_right/a_affine_def_compare_cn_us',[char(brodmann_LR(i)),'.nii']);
    brod_matrix_new.vol=brod_matrix_new1;
    MRIwrite(brod_matrix_new,dv_new)
    sub_vol1=sub_vol1+brod_matrix_new1;
 end
 dv_new1='/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/calculate_left_right/a_affine_def_compare_cn_us/DV_brodmann_asym.nii'
 brod_matrix_new.vol=sub_vol1;
 MRIwrite(brod_matrix_new,dv_new1);
 
