function [spherespace,PNS]=makespherespace(pdms)
%Make Sphere Space
sv = zeros(1,24);
%Compute Unit Scalars
for i=1:24
    sv(i)=sqrt(sum(pdms(1:2:end,i).^2) + sum(pdms(2:2:end,i).^2));
end
%Move to Unit Circle
npdm=zeros(128,24);
for i=1:24
    npdm(:,i)=pdms(:,i)/sv(i);
end
%Convert to Shapespace
[resmat, PNS] = PNSmain(npdm);
epdm=zeros(size(resmat));
%Apply Unit Scalar
for i=1:24
    epdm(:,i)=resmat(:,i)*sv(i);
end
%Find Commensurated Value
csv=mean(sv)*log(sv/mean(sv));
opdm=zeros(24,24);
%Add final tuple
for i=1:24
    opdm(:,i)=[epdm(:,i);csv(:,i)];
end
spherespace=opdm;
end



