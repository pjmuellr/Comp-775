function [output,mask] = ACmain(oimage)
%Run the Active Contour Method
%Blur the image
h = fspecial('gaussian');
image=imfilter(oimage,h);
%Get initial mask
[bx, by]=boundary(image);
%Convert to LAB
lab_img=rgb2lab(image);
img_a=lab_img(:,:,2);
img_b=lab_img(:,:,3);
img_ab=0.75*img_a+0.25*img_b;
close;

[ox,oy]=snakes(img_ab,bx,by,.1,.05,1,.3,.7,.4,200);
%Output Mask
output=poly2mask(ox,oy,size(image,1),size(image,2));
%Initial Mask
mask=poly2mask(bx,by,size(image,1),size(image,2));


