function [CP_Ref,CP_Sen] = CMPC_match(m1,cmpc1,cmpc2,H,matchSize)

[im_RefH,im_RefW] = size(m1);

matchRad = round(matchSize/2);
marg=matchRad+2; % the boundary. we don't detect tie points out of the boundary

im1 = m1(marg:im_RefH-marg,marg:im_RefW-marg);% remove the pixel near the boundary
m1_points = detectFASTFeatures(im1,'MinContrast',0.05);
m1_points = m1_points.selectStrongest(500); 
points1 =[m1_points.Location(:,2),m1_points.Location(:,1)] + marg - 1;

pNum = size(points1,1); % the number of interest points

C = 1;% the number of matchs 

for n = 1: pNum
    
    % the x and y coordinates in the reference image
    X_Ref=points1(n,2);
    Y_Ref=points1(n,1);
    
    % transform the (x,y) of reference image to sensed image by the
    % geometric relationship of coarse matching result
    % to determine the search region
    tempCo = [X_Ref;Y_Ref;1];
    tempCo1 = H*tempCo;
    
    X_Sen_c1 = round(tempCo1(1));
    Y_Sen_c1 = round(tempCo1(2)); 

    % judge whether the transformed points are out the boundary of right image.
    if (X_Sen_c1 < marg+1 || X_Sen_c1 > size(cmpc2(:,:,1),2)-marg || Y_Sen_c1<marg+1 || Y_Sen_c1 > size(cmpc2(:,:,1),1)-marg)
        % if out the boundary, this produre enter the next cycle
        continue;
    end            
    
    % start match
    featureSub_Ref = single(cmpc1(Y_Ref-matchRad:Y_Ref+matchRad,X_Ref-matchRad:X_Ref+matchRad,:));
    featureSub_Sen = single(cmpc2(Y_Sen_c1-matchRad:Y_Sen_c1+matchRad,X_Sen_c1-matchRad:X_Sen_c1+matchRad,:));
    
    [max_i, max_j] = PhaseCorrelation_3D(featureSub_Ref, featureSub_Sen, matchRad);
    [a,~] = size(max_i);
    if a>1
        continue;
    end
     
    Y_match = Y_Sen_c1 + max_i;
    X_match = X_Sen_c1 + max_j;
    % end match
    
    C = C+1;
    CP_Ref(C,:) = [X_Ref,Y_Ref];
    CP_Sen(C,:) = [X_match,Y_match];
end




