function [des_m1,des_m2,eo1,eo2,m1] = CoarseMatchingFDD(im1,im2,s,o,patch_size)

%% PC-FAST
[m1,~,~,~,~,eo1,~,~] = phasecong3(im1,s,o,3,'mult',1.6,'sigmaOnf',0.75,'g', 3, 'k',1);
[m2,~,~,~,~,eo2,~,~] = phasecong3(im2,s,o,3,'mult',1.6,'sigmaOnf',0.75,'g', 3, 'k',1);

a=max(m1(:)); b=min(m1(:)); m1=(m1-b)/(a-b);
a=max(m2(:)); b=min(m2(:)); m2=(m2-b)/(a-b);

m1_points = detectFASTFeatures(m1,'MinContrast',0.05);
m2_points = detectFASTFeatures(m2,'MinContrast',0.05);
m1_points=m1_points.selectStrongest(5000);   %number of keypoints can be set by users
m2_points=m2_points.selectStrongest(5000);

%% Index-Map-Baed descriptor
[des_m1] = MIMdescriptor(im1, m1_points.Location,eo1, patch_size, s,o);
[des_m2] = MIMdescriptor(im2, m2_points.Location,eo2, patch_size, s,o);






