function output = freehand(image)
%Creating the Manual Freehand Mask
imshow(image)
H=imfreehand;
output=H.createMask();
close;
imshowpair(image,output);