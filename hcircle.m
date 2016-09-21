function [acc,centers] = hcircle(image,gradient_sd,r,tresh,intensity_polarity,sigma_mean,sigma_sd,parzen)
%Hough Transform for Circles with given Radius
%By Peter Mueller

image = mat2gray(image);
%Get Derivatives of the Images
[gy,gx] = gaussgradient(image,gradient_sd);
%Determine Magnitude
gi = sqrt(abs(gx).^2+abs(gy).^2);

%Find Pixels with High enough Magnitude i.e. Edge Pixels
[ey,ex] = find(gi > tresh);

%Create Accumulator
acc = zeros(size(gi));
numRow = size(gi,1);
numCol = size(gi,2);

%For Each Edge Pixel, determine its angle and where it votes for the center
%Using built in matlab sigmoid function to determine vote strength
for cnt = 1:numel(ex)
    angle = atan2(-(gy(ey(cnt),ex(cnt))),(gx(ey(cnt),ex(cnt))));
    angle = angle + pi*(intensity_polarity);
    x2 =round( ey(cnt) + r*(cos(angle)));
    y2 = round( ex(cnt) - r*(sin(angle)));
    if and(and(x2 < numRow,x2 > 0),and(y2 < numCol,y2 > 0))
        vote = sigmf(sqrt(abs(ex(cnt)).^2+abs(ey(cnt)).^2),[sigma_mean sigma_sd]);
        acc(x2,y2) = acc(x2,y2) + vote;
        
    end
end

%Blur the accumulator using a guassian with parzen standard devation
gauss = fspecial('gaussian', [6 6], parzen);
acc_blurred = imfilter(acc, gauss, 'replicate');
c=0;
centers = {};

%Ask user to check for circles, each loop will determine the strongest
%circle and plot it, record the x,y values of the center, then remove the
%votes for that circle.

while true
    button = questdlg('Find Circles?',' ','Yes','No','Yes');
    if strcmp('No',button);
        break
    end
    
    %Determine circle with most votes
    c=c+1;
    max_value = 0;
    for i=1:size(acc,1)
        for j=1:size(acc,2)
            if acc_blurred(i,j)> max_value
                max_value = acc_blurred(i,j);
                max_cord = [j i];
            end
        end
    end
    
    %Record Center Cordinates
    centers{c,1} = max_cord(1);
    centers{c,2} = max_cord(2);
        
    imshow(image);
    hold on
    
    %Remove votes for found circle
    for i=max_cord(1)-round(r/2):max_cord(1)+round(r/2)
        for j=max_cord(2)-round(r/2):max_cord(2)+round(r/2)
            if (j>0 && j<=size(acc,1) && i>0 && i<size(acc,2))
                acc_blurred(j,i) = 0;                
            end
        end
        
        %Plotting the Found Circle
        ang=0:0.01:2*pi;
        xp=r*cos(ang);
        yp=r*sin(ang);
        p = plot(max_cord(1)+xp,max_cord(2)+yp);
        set(p,'LineWidth',2)
        
        hold on
    end
end
