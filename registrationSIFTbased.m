function [ROI imRoi roiCoords] = registrationSIFTbased(imageFixed, imageMoving, imRoi, imROIprevious, numberOfSpines,dend)
%
% This is a tester for 2D registration. We first apply landmark-based
% registration between fixed and moving images. Then, spine level
% registration is applied to put spine region in the middle of the ROI 
% using the information in the 1st time point.
%
% author: E. Erdil 
% date: 28.02.2013

% update: Mac OS X part, 15.11.2013 Ali
% update: Adapthisteq, 21.04.14 (instead feeding images directly into landmark,
% added adapthisteq, Ali
% mac toolbox address: http://www.cs.ucla.edu/~vedaldi/

% update: Registration changed from SIFT to Subpixel FFT based
% Registration, August 2019, Ali.

%bestTransformation = landmarkBasedRegistration(adapthisteq(imageMoving), adapthisteq(imageFixed));
% apply sift registration to moving image

usfac = 100;
[output, Greg] = dftregistration(fft2(adapthisteq(imageFixed)),fft2(adapthisteq(imageMoving)),usfac);

se          = translate(strel(1), [round(output(3)) round(output(4))]);
imageMoving = imdilate(imageMoving,se);

% apply sift registration to ROI
for i = 1:numberOfSpines
    imRoi{i} = imdilate(imRoi{i},se);
end

% SPINE-LEVEL REGISTRATION
%rangeOfTranslation = -5:1:5;
rangeOfTranslation = -16:2:16; % Should there be a control here ?

dendPart  = uint8(0.25*double(imageFixed.*uint8(dend)));
spinePart = imageFixed.*uint8(~dend);

ImageFixedModified = uint8(dendPart+spinePart);

for i = 1:numberOfSpines
    try
        coords = spineLevelRegistration(imROIprevious{i,1}, imRoi{i}, ImageFixedModified, rangeOfTranslation);
    catch ali
        ali
    end
    xMin = coords(1);
    xMax = coords(2);
    yMin = coords(3);
    yMax = coords(4);

    imRoi{i} = zeros(size(imageFixed));
    imRoi{i}(yMin:yMax, xMin:xMax) = 255;
    imRoi{i} = im2bw(imRoi{i}, graythresh(imRoi{i}));

    ROI{i,1} = imageFixed(yMin:yMax, xMin:xMax);

    roiCoords{i} = [xMin yMin (yMax - yMin) (xMax - xMin)];
end

end