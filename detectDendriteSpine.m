function spineHead = detectDendriteSpine(refinedImage)

% figure, imshow(refinedImage,[]);

[height width] = size(refinedImage);

midY = ceil(height/2);
midX = ceil(width/2);
mid  = (midX - 1)*height + midY;

BW = imbinarize(refinedImage, graythresh(refinedImage));
C  = bwconncomp(BW, 8);

distancesToMid = zeros(C.NumObjects, 1);

for i = 1:C.NumObjects
    
    listY = ceil(mod(C.PixelIdxList{i}, height));
    listX = ceil(C.PixelIdxList{i}./height);
    
    distancesToMid(i) = sqrt((mean(listX) - midX)^2 + (mean(listY) - midY)^2);  
end

minIndex = find(distancesToMid == min(distancesToMid));

spineHead = zeros(height, width);

spineHead(C.PixelIdxList{minIndex}) = 255;

%figure, imshow(spineHead,[]);

% delete dendrite from watershed image - Ali - 09.12.13

% unique_values = unique(L(dendrite==1));
% 
% for i = 1:length(unique_values)
%     L(L==unique_values(i))=1;
% end











