function [opdm] = asm_sphere(initial_pdm,image,eigv,eigstd,PNS)
%Active Shape Model with Nested Spheres
ipdm = [initial_pdm(1:2:end) initial_pdm(2:2:end)];
%Create Gradient
[gx,gy] = gaussgradient(image,.3);
gi = (abs(gx)+abs(gy))/2;
normals = zeros(64,2);
%Find Normals
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
%Check Normals for Highest Gradient
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
%Unit Scalar
sv=sqrt(sum(gpdm(1:2:end).^2) + sum(gpdm(2:2:end).^2));
tpdm=gpdm/sv;
%Move to Shape Space
spdm=PNSs2e(tpdm,PNS);
%Apply Commensurated Log Value
csv=mean(sv)*log(sv/mean(sv));
epdm=[spdm;csv];
%Apply PCA
opdm=PCA(epdm,eigv,eigstd);
%Move out of Shape Space
opdm=PNSe2s(opdm(1:23),PNS);
opdm=opdm*sv;
%Add back Translation
opdm(1:2:end) = opdm(1:2:end)+xmean;
opdm(2:2:end) = opdm(2:2:end)+ymean;

end