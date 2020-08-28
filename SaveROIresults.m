function SaveROIresults(Image, ROI, xMin, yMin, height, width, spineHead, k, location, spineId, index, angle)

binaryImage = zeros(size(Image));
binaryImage(yMin:(yMin+height), xMin:(xMin+width)) = spineHead;

binaryImage  = imbinarize(binaryImage, graythresh(binaryImage));
removedImage = bwmorph(binaryImage, 'remove');
borderImage  = Image;
borderImage(removedImage == 1) = 255;

borderImage1 = borderImage(yMin:(yMin+height), xMin:(xMin+width));

imwrite(borderImage1, fullfile(location,sprintf('spine%d',spineId),sprintf('border_roi_k_%d_%d.png',k,index)));
imwrite(spineHead, fullfile(location,sprintf('spine%d',spineId),sprintf('binary_roi_k_%d_%d.png',k, index)));
