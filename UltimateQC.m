%get image
[filename, user_canceled] = imgetfile;
if user_canceled == 1
    return
end
a = imread(filename);
%if no blueberries are detected in the image halt program
detector = vision.CascadeObjectDetector('blueberryDetector.xml');
bbox = step(detector,a);
if size(bbox,1) == 0
    imshow(a);
    title('There are no blueberries detected in image');
    return
end

%Improve/sharpen the image
berries = imsharpen(a);

%crop image to reduce outliers
TrayOnly = createMaskBetter(berries);
BW3 = bwpropfilt(TrayOnly,'area',1);
props = regionprops(BW3,'BoundingBox');
BerriesInsideBox = imcrop(berries, props.BoundingBox);

%Remove the background, get just the berries
%[~,maskedRGBImage] = createMask4(berries);
[~,maskedRGBImage] = createMask4(BerriesInsideBox);

%get just the immature berries color
[~,maskedImmatureImage] = immatureMask(BerriesInsideBox);

%Detect the circles and get the count
[centers,radii,count] = countBlueberries(maskedRGBImage);
[immcenters, immradii, immcount] = countImmature(maskedImmatureImage);
%%

%Show sharpened image to display the results on
%imshow(berries);
imshow(BerriesInsideBox);

%Draw the circle on the image
viscircles(immcenters,immradii);
viscircles(centers,radii,'LineStyle','--','Color','c','LineWidth',1,'EnhanceVisibility',false);

%title(sprintf('Number of berries: %d',count));
percent = (immcount/count)*100;
title([sprintf('Number of berries: %d Number of immature: %d Defects: %0.1f',count,immcount,percent),'%']);
