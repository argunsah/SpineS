function spineSeedPoint = refineNeckBasePointLocation(spineStack,StartPoint,SourcePoint3D,seg_Dend_ROI)

a = 1e-1;
b = 1.01e-1;

r1 = a + (b-a).*rand(length(spineStack(:)),1);
r2 = a + (b-a).*rand(length(seg_Dend_ROI(:)),1);
r3 = a + (b-a).*rand(length(seg_Dend_ROI(:)),1);

r1 = reshape(r1,size(spineStack));
r2 = reshape(r2,size(seg_Dend_ROI));
r3 = reshape(r3,size(seg_Dend_ROI));

DistanceMap3D = msfm(double(spineStack).^4+r1,...
    [StartPoint(2);StartPoint(1);StartPoint(3)],true,true);

% imEq      = max(DistanceMap3D,[],3);
% imEMaxima = imextendedmax(imEq,max(DistanceMap3D(:)));
% imEMaxima = imfill(imEMaxima, 'holes');
% imEMaxima = imdilate(imEMaxima,ones(5,5))+r2;
% 
% for ddd = 1:size(DistanceMap3D,3)
%     DistanceMap3D(:,:,ddd)=double(imEMaxima).*DistanceMap3D(:,:,ddd)+r3;
% end

% Find Shortest Path btw Spine Center and candidate branching
% point coordinates

clear ShortestLine;

ShortestLine = shortestpath(DistanceMap3D,...
    [SourcePoint3D(2);SourcePoint3D(1);SourcePoint3D(3)],...
    [StartPoint(2);StartPoint(1);StartPoint(3)],1);
% 
% figure, imshow(max(spineStack,[],3),[]);
% hold on; scatter3(SourcePoint3D(1),SourcePoint3D(2),SourcePoint3D(3),'.r');
% hold on; scatter3(StartPoint(1),StartPoint(2),StartPoint(3),'.b');

ShortestLine = floor(ShortestLine);
ShortestLine = unique(ShortestLine,'rows');

neckLenFigTemp = zeros(size(seg_Dend_ROI));

for sl = 1:length(ShortestLine(:,2))
    neckLenFigTemp((ShortestLine(sl,1)),(ShortestLine(sl,2))) = ...
        neckLenFigTemp((ShortestLine(sl,1)),(ShortestLine(sl,2))) + 1;
end

spineSeedPoint = findIntersectionOfImageLines(neckLenFigTemp,seg_Dend_ROI,...
    [SourcePoint3D(2);SourcePoint3D(1);SourcePoint3D(3)]);



