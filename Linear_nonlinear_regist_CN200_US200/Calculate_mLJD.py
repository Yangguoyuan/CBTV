#!/usr/bin/env python2.7

"""
Created on Tue May  2019

@author: Guoyuan Yang
"""

import numpy as np
import sys
from sys import argv
import nibabel as nib
import nibabel.gifti as nibgif
import os
import copy
import csv

#===============================================================================
# Calculate the Jacobian at each voxel
#===============================================================================
def Jac(x):
 
    height, width, depth, num_channel = x.shape
    num_voxel = (height)*(width)*(depth)
 
    dx = np.reshape(x[1:,:-1,:-1,:]-x[:-1,:-1,:-1,:], [num_voxel, num_channel])
    dy = np.reshape(x[:-1,1:,:-1,:]-x[:-1,:-1,:-1,:], [num_voxel, num_channel])
    dz = np.reshape(x[:-1,:-1,1:,:]-x[:-1,:-1,:-1,:], [num_voxel, num_channel])
    J = np.stack([dx, dy, dz], 2)
    return np.reshape(J, [height-1, width-1, depth-1, 3, 3])
 
def Jac_5(x):
 
    height, width, depth, num_channel = x.shape
    num_voxel = (height-4)*(width-4)*(depth-4)
 
    dx = np.reshape((x[:-4,2:-2,2:-2,:]-8*x[1:-3,2:-2,2:-2,:] + 8*x[3:-1,2:-2,2:-2,:] - x[4:,2:-2,2:-2,:])/12.0, [num_voxel, num_channel])
    dy = np.reshape((x[2:-2,:-4,2:-2,:]-8*x[2:-2,1:-3,2:-2,:] + 8*x[2:-2,3:-1,2:-2,:] - x[2:-2,4:,2:-2,:])/12.0, [num_voxel, num_channel])
    dz = np.reshape((x[2:-2,2:-2,:-4,:]-8*x[2:-2,2:-2,1:-3,:] + 8*x[2:-2,2:-2,3:-1,:] - x[2:-2,2:-2,4:,:])/12.0, [num_voxel, num_channel])
    J = np.stack([dx, dy, dz], 2)
 
    return np.reshape(J, [height-4, width-4, depth-4,3,3])
 
#==============================================================================
# Calculate the Determinent of Jacobian of the transformation
#==============================================================================
 
def Get_Ja(displacement):
 
    '''
    '''
  
    D_y = (displacement[:,1:,:-1,:-1,:] - displacement[:,:-1,:-1,:-1,:])
    D_x = (displacement[:,:-1,1:,:-1,:] - displacement[:,:-1,:-1,:-1,:])
    D_z = (displacement[:,:-1,:-1,1:,:] - displacement[:,:-1,:-1,:-1,:])
    
    D1 = (D_x[...,0]+1) * ( (D_y[...,1]+1)*(D_z[...,2]+1) - D_z[...,1]*D_y[...,2])
    D2 = (D_x[...,1]) *   (D_y[...,0]*(D_z[...,2]+1)      - D_y[...,2]*D_z[...,0])
    D3 = (D_x[...,2]) *   (D_y[...,0]*D_z[...,1]          - (D_y[...,1]+1)*D_z[...,0])
    D = np.abs(D1-D2+D3)
 
    return D
# script for calculating average of gifti sulcal depth maps
chtoch_path_adult='/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/chtoch';
chtous_path_adult='/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/chtous';
ustous_path_adult='/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/ustous';
ustoch_path_adult='/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/ustoch';

chcp_csv_file="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/data_num/chcp_num.txt";
hcp_csv_file="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/data_num/hcp_num.txt";

csvFile = open(hcp_csv_file,"r")       # Should be changed in each dataset
reader = csv.reader(csvFile)
result = {}
for item in reader:
    result[item[0]]=item[0]
    print(item[0])
csvFile.close()
print(result)
for csv_name in sorted(result.values()):
    chtoch_nii_data=str(chtoch_path_adult) + "/" + str(csv_name) + "1Warp.nii.gz"
    chtous_nii_data=str(chtous_path_adult) + "/" + str(csv_name) + "1Warp.nii.gz"
    ustous_nii_data=str(ustous_path_adult) + "/" + str(csv_name) + "1Warp.nii.gz"
    ustoch_nii_data=str(ustoch_path_adult) + "/" + str(csv_name) + "1Warp.nii.gz"
    toch_nii_data1="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/ustoch/new_sub_1_22_1068241Warp.nii.gz" 
    tous_nii_data1="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/ustous/new_sub_1_22_1068241Warp.nii.gz" 
    
    save_chtoch_data="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/log_jacobian/chtoch/"  + str(csv_name) + "_log_jacobian.nii.gz"    
    save_chtous_data="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/log_jacobian/chtous/"  + str(csv_name) + "_log_jacobian.nii.gz" 
    save_ustoch_data="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/log_jacobian/ustoch/"  + str(csv_name) + "_log_jacobian.nii.gz" 
    save_ustous_data="/guoyuan_data/make_template_child/Richard_template/for_compare_new/show_defrom/data/log_jacobian/ustous/"  + str(csv_name) + "_log_jacobian.nii.gz"  
    
    n1_img=nib.load(ustous_nii_data)                       # Should be changed in each dataset
    n1_img_new=nib.load(tous_nii_data1)                  # Should be changed in each dataset
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
    D_zeros=np.float32(D_zeros)
    D_log_abs_reshape_final=D_zeros
    affine_matrix=n1_img_new.affine
    new_img=nib.Nifti1Image(D_log_abs_reshape_final,affine_matrix)
    nib.save(new_img,save_ustous_data)                   # Should be changed in each dataset
