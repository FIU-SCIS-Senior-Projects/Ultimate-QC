%{
How to train a detector
First use the training image labeler app
open detectBlueberry.mat
select ROIs regions of interest
save to a mat file
export ROIs as positiveInstances
then continue with the code below
%}

%{
imDir = fullfile('C:','Users','yourcomputername','Documents','MATLAB','Images');
addpath(imDir);
positiveInstances = matfile('detectBlueberry.mat');
negativeFolder = fullfile('C:','Users','yourcomputername','Documents','MATLAB','nonBlueberries2');
trainCascadeObjectDetector('blueberryDetector.xml',positiveInstances,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
%}

[filename, user_canceled] = imgetfile;
if user_canceled == 1
    return
end
detector = vision.CascadeObjectDetector('blueberryDetector.xml');
img = imread(filename);
bbox = step(detector,img);
detectedImg = insertShape(img,'rectangle',bbox, 'color','cyan');
%or
%detectedImg = insertShape(img,'rectangle',bbox);
%or
%detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'berry');
figure, imshow(detectedImg);
%rmpath(imDir);
