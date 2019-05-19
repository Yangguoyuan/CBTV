#!/bin/bash

#Created on Sun Aug 2018

#@author: Guoyuan Yang

#Segmentation of brain into tissue of GW, WM, CSF without priority using FAST.

data_path='/guoyuan_data/make_template/sgementation_test/result_ch/ch_individual';
sub_list='/guoyuan_data/make_template/sgementation_test/data_num/chcp_num.txt';
dest_num='/guoyuan_data/make_template/sgementation_test/result_ch/ch_no_priori';
for sub in `cat ${sub_list}`
do
{
 sub_name=${sub}_brain.nii;
 sub_path=${data_path}/${sub_name}
     echo "---------------data path=${sub_name}-------------------"
     echo "---------------data path=${sub_path}-------------------"
   if [ -f "${sub_path}" ]
   then
   {
     echo "---------------data path=${sub_path}-------------------"
    mkdir -p ${dest_num}/${sub}
    cd ${dest_num}/${sub}
    fast -t 1 -o seg ${sub_path} &
   }
   fi
}
done 
    
