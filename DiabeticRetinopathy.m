
clc; clear all; close all;
[baseName, folder] = uigetfile({'*.jpeg';'*.png';'*.jpg'},'select the source image');
fullFileName = fullfile(folder, baseName)
I=imread(fullFileName);
I=imresize(I,[512 512]);
figure,imshow(I);title('Original Img');
grayscale = rgb2gray(I);
figure,imshow(grayscale);title('Grayscale');

se=strel('disk',5);
se2=strel('disk',1);
C=imbothat(grayscale,se);

whiteThreshold=140;
blackThreshold=12;

C2 = C > blackThreshold;
C3 = grayscale > whiteThreshold & grayscale > blackThreshold;

[centers, radii] = imfindcircles(C3,[30 45], ...
	'Sensitivity',0.9700, ...
	'EdgeThreshold',0.81, ...
	'Method','TwoStage', ...
	'ObjectPolarity','Bright');
figure,imshow(I);title('Optical Disk');
viscircles(centers, radii,'EdgeColor','b');

x = 1:size(I,2);
y = 1:size(I,1);
[xx,yy] = meshgrid(x,y);
mask = hypot(xx - centers(1), yy - centers(2)) <= (radii(1)+10);
currentImg = C3 & ~mask;

figure,imshow(currentImg,[]);title('Potential Retinopathy');
figure,imshow(C3,[]);title('Thresholded Mask');
MC2 = medfilt2(C2);
EMC2= imerode(MC2,se2);
figure,imshow(EMC2,[]);title('Median + Erodion filter');
figure,imshow(C);title('Bottom-hat filter applied retina');

figure,imshow(I);title('Contoured Potential Retinopathy');hold on;
u= contour(currentImg,'b');

