% Ali Ozgur Argunsah, February, 2014
% Automatic FWHM from segmented images
% inputs: dendrite image at time t
%         binary segmented spine at time t and k
%         last input for image resporting ('true' or 'false')
% cf: conversion factor from pixels to nanometers

function [fwhm_val_axis1 fwhm_val_axis2 fwhm_val_axis3 g1 g2 g3] = AutoFWHM_v2(MIPim,border_roi,dend,report,theta0,cf)

perim = (border_roi==255);

s  = regionprops(perim, 'Orientation', 'Centroid','MajorAxisLength','MinorAxisLength','EquivDiameter','Area','PixelIdxList');

[~,index] = max([s.Area]);

if theta0 == 0
    
    theta = deg2rad(s(index).Orientation);
    theta2 = deg2rad(s(index).Orientation+30);
    theta3 = deg2rad(s(index).Orientation-30);
else
    theta = deg2rad(theta0);
    theta2 = deg2rad(theta0+30);
    theta3 = deg2rad(theta0-30);
end

% Find Center Point of Spine

spn = double(MIPim).*double(imdilate(border_roi,strel('ball',5,5))).*~dend;
[cy_1, cx_1] = find(spn==max(max(spn)));

cx_1 = mean(cx_1);
cy_1 = mean(cy_1);

cx =  (s(index).Centroid(1) + cx_1)/2;
cy =  (s(index).Centroid(2) + cy_1)/2;

if strcmp(report,'true')
    figure, 
    imshow(MIPim,[]);
    hold on, plot(cx ,cy ,'.r');
end

divFactor = 1.5;

extra_black = s(index).MajorAxisLength/divFactor;

x1 = cx + (s(index).MajorAxisLength/divFactor + extra_black)*cos(theta) ;
y1 = cy + (s(index).MajorAxisLength/divFactor + extra_black)*sin(theta) ;

x2 = cx - (s(index).MajorAxisLength/divFactor + extra_black)*cos(theta) ;
y2 = cy - (s(index).MajorAxisLength/divFactor + extra_black)*sin(theta) ;

x1_2 = cx + (s(index).MajorAxisLength/divFactor + extra_black)*cos(theta2) ;
y1_2 = cy + (s(index).MajorAxisLength/divFactor + extra_black)*sin(theta2) ;

x2_2 = cx - (s(index).MajorAxisLength/divFactor + extra_black)*cos(theta2) ;
y2_2 = cy - (s(index).MajorAxisLength/divFactor + extra_black)*sin(theta2) ;

x1_3 = cx + (s(index).MajorAxisLength/divFactor + extra_black)*cos(theta3) ;
y1_3 = cy + (s(index).MajorAxisLength/divFactor + extra_black)*sin(theta3) ;

x2_3 = cx - (s(index).MajorAxisLength/divFactor + extra_black)*cos(theta3) ;
y2_3 = cy - (s(index).MajorAxisLength/divFactor + extra_black)*sin(theta3) ;

if strcmp(report,'true')
    hold on, line([x1 x2],[y1 y2]);
    hold on, line([x1_2 x2_2],[y1_2 y2_2]);
    hold on, line([x1_3 x2_3],[y1_3 y2_3]);     
end

p1 = improfile(MIPim,[x1 x2],[y1 y2],'bicubic');
p2 = improfile(MIPim,[x1_2 x2_2],[y1_2 y2_2],'bicubic');
p3 = improfile(MIPim,[x1_3 x2_3],[y1_3 y2_3],'bicubic');

% minValue = min(min(MIPim(20:end-20,20:end-20)))
% 
% p1(1:floor(extra_black/2)) = minValue;
% p1((end-floor(extra_black/2)):end) = minValue;
% 
% p2(1:floor(extra_black/2)) = minValue;
% p2((end-floor(extra_black/2)):end) = minValue;
% 
% p3(1:floor(extra_black/2)) = minValue;
% p3((end-floor(extra_black/2)):end) = minValue;


% if strcmp(report,'true')
%     figure, plot(p1);
% %     figure, plot(r2);
% end

len1 = 1:length(p1);
len2 = 1:length(p2);
len3 = 1:length(p3);

[f1, g1, fwhm_val_axis1] = gaussFit1d_Ali_3(len1,p1',cf);
[f2, g2, fwhm_val_axis2] = gaussFit1d_Ali_3(len2,p2',cf);
[f3, g3, fwhm_val_axis3] = gaussFit1d_Ali_3(len3,p3',cf);

