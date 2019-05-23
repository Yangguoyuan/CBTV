#!/bin/bash
data_path=/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_direct_CN_US/result/a_surface;
wb_command -volume-to-surface-mapping ${data_path}/DV_brodmann.nii ${data_path}/Q1-Q6_R440.L.midthickness.32k_fs_LR.surf.gii ${data_path}/US_CN_DV_L.shape.gii -trilinear &
wb_command -volume-to-surface-mapping ${data_path}/DV_brodmann.nii ${data_path}/Q1-Q6_R440.R.midthickness.32k_fs_LR.surf.gii ${data_path}/US_CN_DV_R.shape.gii -trilinear

  
 
