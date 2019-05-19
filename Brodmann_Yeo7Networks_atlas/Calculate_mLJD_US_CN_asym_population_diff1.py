#!/usr/bin/env python2.7

"""
Created on Tue May  2019

@author: Guoyuan Yang

Calculate the logarithmically transformed Jacobian determinant (LJD).
"""

import numpy as np
import sys
from sys import argv
import nibabel as nib
import nibabel.gifti as nibgif
import os
import copy
import csv

# script for calculating average of gifti sulcal depth maps
affine_path_adult='/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_affine_dv_CN_US/deformation_field';


affine_nii_data="/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_affine_dv_CN_US/deformation_field/" + "us_ch1Warp.nii.gz"
direct_nii_data="/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_direct_CN_US/result/" + "regist_cn_us1Warp.nii.gz"
nii_data1="/guoyuan_data/make_template_hcp/MNI_Brodmann/DV_between_temp/a_direct_CN_US/result/merge_regist_cn_us1Warp.nii.gz" 
save_affine_data="/guoyuan_data/make_template_hcp/MNI_Brodmann/Jacobian_between_temp/log_Jacobian/affine" + "/sub_us_ch_jacobian.nii.gz"
save_direct_data="/guoyuan_data/make_template_hcp/MNI_Brodmann/Jacobian_between_temp/log_Jacobian/direct" + "/sub_ch_us_jacobian.nii.gz"
n1_img=nib.load(direct_nii_data)                       # Should be changed in each dataset
n1_img_new=nib.load(nii_data1)                  
n1_data=n1_img.get_data()
n1_data_sque=np.squeeze(n1_data)
#==============================================================================
# Calculate the Determinent of Jacobian of the transformation
#==============================================================================
x=n1_data_sque
height, width, depth, num_channel = x.shape
num_voxel = (height-1)*(width-1)*(depth-1)
 
dx = np.reshape(x[1:,:-1,:-1,:]-x[:-1,:-1,:-1,:],[num_voxel, num_channel])
dy = np.reshape(x[:-1,1:,:-1,:]-x[:-1,:-1,:-1,:],[num_voxel, num_channel])
dz = np.reshape(x[:-1,:-1,1:,:]-x[:-1,:-1,:-1,:],[num_voxel, num_channel])
J = np.stack([dx, dy, dz], 2)
np.reshape(J, [height-1, width-1, depth-1, 3, 3])

D1=((dx[:,0]+1) * (dy[:,1]+1) * (dz[:,2]+1)-(dx[:,0]+1) * dy[:,2] * dz[:,1])
D2=(dx[:,1] * dy[:,2] * dz[:,0] - dx[:,2] * (dy[:,1]+1) * dz[:,0])
D3=(dx[:,2] * dy[:,0] * dz[:,1] - dx[:,1] * dy[:,0] * (dz[:,2]+1))
D_abs = np.abs(D1+D2+D3)
D_log_abs=np.abs(np.log10(D_abs))
D_log_abs_reshape=np.reshape(D_log_abs,[height-1, width-1, depth-1])
#==============================================================================
# Add the zeros to match the origianl matrix
#==============================================================================
D_zeros=np.zeros((height,width, depth))
D_zeros[:height-1,:width-1,:depth-1]=D_log_abs_reshape
D_log_abs_reshape_final=D_zeros
affine_matrix=n1_img_new.affine
D_log_abs_reshape_final=np.float32(D_log_abs_reshape_final)
new_img=nib.Nifti1Image(D_log_abs_reshape_final,affine_matrix)
nib.save(new_img,save_direct_data)                   # Should be changed in each dataset
