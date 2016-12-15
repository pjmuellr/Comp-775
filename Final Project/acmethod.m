function [sx,sy] = acmethod(image, sx, sy, wa, wb, wg, wl, we, wt, N)


image=double(image);
%intensity value energy
img_nrg=image;
%Get Derivatives
[gradx,grady,dx,dy,dxx,dyy,dxy,C]=derivs(image);
%edge energy
edge_nrg = -1*sqrt((gradx .*gradx +grady .* grady));
%mean curvature 
curv_nrg = C;
%external energy
ext_nrg=(-wl*img_nrg + we*edge_nrg - wt*curv_nrg);

[fx,fy] = gradient(ext_nrg);
%Setting up the snake
sx = sx';
sy = sy';
[m, n] = size(sx);
[mm, nn] = size(fx);

%Stiffness Matrix
A = zeros(m,m);
b = [(2*wa + 6 *wb) -(wa + 4*wb) wb];
row = zeros(1,m);
row(1,1:3) = row(1,1:3) + b;
row(1,m-1:m) = row(1,m-1:m) + [wb -(wa + 4*wb)];
for i=1:m
    A(i,:) = row;
    row = circshift(row',1)';
end

[L, U] = lu(A + wg .* eye(m,m));
Ainv = inv(U) * inv(L);

kappa = .15

%Iterating the Snake

for i=1:N;
    
    ssx = wg*sx - kappa* interp2(fx, sx, sy);
    ssy = wg*sy - kappa* interp2(fy, sx, sy);
    
    sx = Ainv * ssx;
    sy = Ainv * ssy;
    
    imshow(image,[]);
    hold on;
    
    plot([sx; sx(1)], [sy; sy(1)],'r-');
    hold off
    pause(0.001)
end
%testmask=poly2mask(sx,sy,194,187);
    
