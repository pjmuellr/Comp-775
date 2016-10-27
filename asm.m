function [gpdm] = asm(initial_pdm,image,meanpdm,eigv,eigstd)
%Active Shape Modeling
%Split X Y values into different columns
ipdm = [initial_pdm(1:2:end) initial_pdm(2:2:end)];
%Create Gradient
[gx,gy] = gaussgradient(image,.3);
gi = (abs(gx)+abs(gy))/2;
%Find Normals
normals = zeros(64,2);
for i = 1:64
    if i == 1
        normals(1,:)=findnormal(ipdm(2,:),ipdm(64,:));
    elseif i == 64
        normals(64,:)=findnormal(ipdm(1,:),ipdm(63,:));
    else
        normals(i,:)=findnormal(ipdm(i+1,:),ipdm(i-1,:));
    end
end
npdm = zeros(64,2);
%Look above and below the gradient for place with highest gradient
for p = 1:64
    max_i = 100;
    check=0;
    for v = -2:1:2
        tx = (ipdm(p,1)+v*(normals(p,1)));
        ty = (ipdm(p,2)+v*(normals(p,2)));
        i=interp2(gi,(ipdm(p,1)+v*(normals(p,1))),(ipdm(p,2)+v*(normals(p,2))));
        if i > max_i
            max_i=i;
            npdm(p,:) = [tx ty];
            check=1;
        end
        if check==0 && v==2
            npdm(p,:) = [tx ty];
        end
        
    end
    
end

%convert back to 128x1 matrix
npdm2 = npdm';
gpdm = zeros(128,1);

for i=1:128
    gpdm(i)=npdm2(i);
end

%find center of mass
xmean=mean(gpdm(1:2:end));
ymean=mean(gpdm(2:2:end));
%center pdm
gpdm(1:2:end)=gpdm(1:2:end)-xmean;
gpdm(2:2:end)=gpdm(2:2:end)-ymean;
%subtract from meanpdm
gpdm=gpdm-meanpdm;
%Preform PCA
newPDM = PCA( gpdm, eigv, eigstd );
%Add back Mean
gpdm = newPDM+meanpdm;
%Add back Translation
gpdm(1:2:end) = gpdm(1:2:end)+xmean;
gpdm(2:2:end) = gpdm(2:2:end)+ymean;
end


