function [gradx,grady,dx,dy,dxx,dyy,dxy,C] = derivs(image)
%Take Dervatives of the Image
k1 = [-1 1];
k2 = [-1;1];
k3 = [1 -2 1];
k4 = [1;-2;1];
k5 = [1 -1;-1 1];
dx = conv2(image,k1,'same');
dy = conv2(image,k2,'same');
dxx = conv2(image,k3,'same');
dyy = conv2(image,k4,'same');
dxy = conv2(image,k5,'same');

[gradx,grady]=gradient(image);

[sx sy]=size(image);
H=zeros(2,2,sx,sy);
C=zeros(size(image));
%Calcuate Mean Curvature
for x=1:size(image(:))
H(:,:,x)=[dxx(x) dxy(x);dxy(x) dyy(x)];
e=eigs(H(:,:,x));
C(x)=(e(1)+e(2))/2;

end

