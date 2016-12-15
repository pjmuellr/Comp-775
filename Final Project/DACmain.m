function output = DACmain(oimage,mask)
%Runs the Chan Vese Active Contour Method
%Apply a blur
h = fspecial('gaussian');
image=imfilter(oimage,h);
%Convert to LAB
lab_img=rgb2lab(image);
gray=rgb2gray(image);
img_a=lab_img(:,:,2);
img_b=lab_img(:,:,3);
img_ab=img_a+img_b;

%Run method and perform closing
coutput=activecontour(img_ab,mask);
se = strel('disk',5);
output = imclose(coutput,se);

subplot(1,2,1);
imshowpair(image,output);
subplot(1,2,2);
imshow(image);

