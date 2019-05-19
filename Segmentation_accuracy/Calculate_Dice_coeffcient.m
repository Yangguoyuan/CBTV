%{
Created on Sun Aug 2018

@author: Guoyuan Yang

Calculate the dice coeff in tissue maps.
%}

clc;
clear;
tissue={'csf','gm','wm'};
tissue_num=[0,1,2];
ref_cn='/guoyuan_data/make_template/sgementation_test/result_ch/ch_no_priori';
ch_cn='/guoyuan_data/make_template/sgementation_test/result_ch/ch_ch_pro';
ch_us='/guoyuan_data/make_template/sgementation_test/result_ch/ch_us_pro';

ref_us='/guoyuan_data/make_template/sgementation_test/result_us/us_no_priori';
us_ch='/guoyuan_data/make_template/sgementation_test/result_us/us_ch_pro';
us_us='/guoyuan_data/make_template/sgementation_test/result_us/us_us_pro';

ch_txt='/guoyuan_data/make_template/sgementation_test/data_num/chcp_num.txt';
us_txt='/guoyuan_data/make_template/sgementation_test/data_num/hcp_num.txt';
ch_num=textread(ch_txt,'%s',47);
us_num=textread(us_txt,'%s',50);
thre=0.4;
dice_cn_cn=ones(length(ch_num),length(tissue));
dice_cn_us=ones(length(ch_num),length(tissue));
dice_us_cn=ones(length(us_num),length(tissue));
dice_us_us=ones(length(us_num),length(tissue));
tiss_num=[0,1,2];
for i=1:length(tissue)
    for j=1:length(ch_num)
        
        sub_ref_ch=fullfile(ref_cn,char(ch_num(j)),['seg_pve_',num2str(tiss_num(i)),'.nii.gz']);
        sub_ch_ch=fullfile(ch_cn,char(tissue(i)),[char(tissue(i)),char(ch_num(j)),'.nii']);
        sub_ch_us=fullfile(ch_us,char(tissue(i)),[char(tissue(i)),char(ch_num(j)),'.nii']);
        
        ref_ch_m=MRIread(sub_ref_ch);
        ch_ch_m=MRIread(sub_ch_ch);
        ch_us_m=MRIread(sub_ch_us);
        
        ref_ch_m1=ref_ch_m.vol;
        ch_ch_m1=ch_ch_m.vol;
        ch_us_m1=ch_us_m.vol;
        
        ref_ch_m1(ref_ch_m1>thre)=1;
        ref_ch_m1(ref_ch_m1<=thre)=0;
        ch_ch_m1(ch_ch_m1>thre)=1;
        ch_ch_m1(ch_ch_m1<=thre)=0;
        ch_us_m1(ch_us_m1>thre)=1;
        ch_us_m1(ch_us_m1<=thre)=0;
        
        overlay1=ch_ch_m1+ref_ch_m1;
        overlay1(overlay1==1)=0;
        
        overlay2=ch_us_m1+ref_ch_m1;
        overlay2(overlay2==1)=0;
        
        sub_ref_us=fullfile(ref_us,char(us_num(j)),['seg_pve_',num2str(tiss_num(i)),'.nii.gz']);
        tissue_new=char(tissue(i));
        sub_us_ch=fullfile(us_ch,char(tissue(i)),[char(tissue(i)),char(us_num(j)),'.nii']);
        sub_us_us=fullfile(us_us,char(tissue(i)),[char(tissue(i)),char(us_num(j)),'.nii']);
        
        ref_us_m=MRIread(sub_ref_us);
        us_ch_m=MRIread(sub_us_ch);
        us_us_m=MRIread(sub_us_us);
        
        ref_us_m1=ref_us_m.vol;
        us_ch_m1=us_ch_m.vol;
        us_us_m1=us_us_m.vol;
        
        ref_us_m1(ref_us_m1>thre)=1;
        ref_us_m1(ref_us_m1<=thre)=0;
        us_ch_m1(us_ch_m1>thre)=1;
        us_ch_m1(us_ch_m1<=thre)=0;
        us_us_m1(us_us_m1>thre)=1;
        us_us_m1(us_us_m1<=thre)=0;
        
        overlay3=us_ch_m1+ref_us_m1;
        overlay3(overlay3==1)=0;
        
        overlay4=us_us_m1+ref_us_m1;
        overlay4(overlay4==1)=0;
        
        dice_cn_cn(j,i)=sum(sum(sum(overlay1)))/sum(sum(sum(ch_ch_m1+ref_ch_m1)));
        dice_cn_us(j,i)=sum(sum(sum(overlay2)))/sum(sum(sum(ch_us_m1+ref_ch_m1)));
        
        dice_us_cn(j,i)=sum(sum(sum(overlay3)))/sum(sum(sum(us_ch_m1+ref_us_m1)));
        dice_us_us(j,i)=sum(sum(sum(overlay4)))/sum(sum(sum(us_us_m1+ref_us_m1)));
        
    end
end
