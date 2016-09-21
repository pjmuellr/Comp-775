function b_img = circleimagecreator(radius,number,intensities,polarity,gauss_sigma,noise)
%Creates an 200x200 image of randomly generated circles
%Radius is radius of the circles
%Number determines number of circles
%intensities is a array of values of possible intensities for the circles
%polarity changes if the circles are light on dark (0) or dark on light (1)
%gauss_sigma determines the sigma of the guass blur applied
%noise is the signal to noise ratio of noise applied, Lower is more noise

%Initalize image
img = zeros(200,200);

%Generate Circles
for n=1:number
    y = randi(200);
    x = randi(200);
    in = datasample(intensities,1);
    for i = 1:200
        for j = 1:200
            d=sqrt((i-x)^2+(j-y)^2);
            if d < radius
                img(i,j)=img(i,j)+in;
            end
        end
    end
end

%Apply Polarity
img = 1*polarity-img;
%Apply Noise
n_img = awgn(img,noise); 
%Apply Blur
blur = fspecial('gaussian',[3 3],gauss_sigma);
b_img = imfilter(n_img,blur);
%Display Image
imshow(b_img);

end

    
    
    