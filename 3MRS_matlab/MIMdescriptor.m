function [des] = MIMdescriptor(im, kps,eo, patch_size, s,o)

KPS=kps'; %keypoints
[yim,xim,~] = size(im);

CS = zeros(yim, xim, o); %convolution sequence
for j=1:o
    for i=1:s
        CS(:,:,j)=CS(:,:,j)+abs(eo{i,j});
    end
end
[~, MIM] = max(CS,[],3); % maximum index map

des = zeros(36*o, size(KPS,2)); %descriptor (size: 6��6��o)
kps_to_ignore = zeros(1,size(KPS,2));

for k = 1: size(KPS,2)
    x = round(KPS(1, k));
    y = round(KPS(2, k));
    
    x1 = max(1,x-floor(patch_size/2));
    y1 = max(1,y-floor(patch_size/2));
    x2 = min(x+floor(patch_size/2),size(im,2));
    y2 = min(y+floor(patch_size/2),size(im,1));
    
    if y2-y1 ~= patch_size || x2-x1 ~= patch_size
        kps_to_ignore(k)=1;
        continue;
    end
    
    patch = MIM(y1:y2,x1:x2); %local MIM patch for feature description
    [ys,xs]=size(patch);
    
    ns=6;
    CDes = zeros(ns,ns,o);  %descriptor vector
    
    % histogram vectors
    for j = 1:ns
        for i = 1:ns
            clip = patch(round((j-1)*ys/ns+1):round(j*ys/ns),round((i-1)*xs/ns+1):round(i*xs/ns));
            CDes(j,i,:) = permute(hist(clip(:), 1:o), [1 3 2]);
        end
    end
    
    CDes=CDes(:);
    
    if norm(CDes) ~= 0
        CDes = CDes /norm(CDes);
    end

    
    des(1:36*o,k)=CDes;
end
des = struct('kps', KPS(:,kps_to_ignore ==0)', 'des', des(:,kps_to_ignore==0)');


