function saveResultsForAll_k(Image, ROI, xMin, yMin, height, width, spineHead, k, location, spineId, index, angle)


imwrite(ROI, fullfile(location,sprintf('spine%d',spineId),sprintf('ROI_%d.png',index)));
binaryImage = zeros(size(Image));
binaryImage(yMin:(yMin+height), xMin:(xMin+width)) = spineHead;
imwrite(binaryImage, fullfile(location,sprintf('spine%d',spineId),sprintf('binary_k_%d_%d.png',k,index)));


binaryImage  = imbinarize(binaryImage, graythresh(binaryImage));
removedImage = bwmorph(binaryImage, 'remove');
borderImage  = Image;
borderImage(removedImage == 1) = 255;
imwrite(borderImage, fullfile(location,sprintf('spine%d',spineId),sprintf('border_k_%d_%d.png',k,index)));
