function [xs ,ys] = boundary(image)
hold on
imshow(image);

%Create a inital Mask
[sx, sy] = getpts;

n = size(sx,1);
n=n+1;
sxy=[];
sxy=[sx sy];
sxy=sxy';
sxy(:,n) = [sxy(1,1);sxy(2,1)];

% Smooth out mask
t = 1:n;
ts = 1: 0.1: n;
xys = spline(t,sxy,ts);

xs = xys(1,:);
ys = xys(2,:);