function ShortestLine = findShorttestPath(spineStack, SourcePoint3D, neckBasePoint)

StartPoint         = [neckBasePoint(1),neckBasePoint(2),neckBasePoint(3)]';

spineStack_medfilt = medfilt3(spineStack,[3 3 3]);

a = 1e-1;
b = 1.1e-1;

r1 = a + (b-a).*rand(length(spineStack(:)),1);
r2 = a + (b-a).*rand(length(spineStack(:)),1);

r1 = reshape(r1,size(spineStack));
r2 = reshape(r2,size(spineStack));

SourcePoint3D_multi = [SourcePoint3D,SourcePoint3D+[0 1 0],SourcePoint3D+[0 -1 0],SourcePoint3D+[+1 0 0],SourcePoint3D+[-1 0 0],...
    SourcePoint3D+[0 1 -1],SourcePoint3D+[0 -1 -1],SourcePoint3D+[+1 0 -1],SourcePoint3D+[-1 0 -1],...
    SourcePoint3D+[0 1 +1],SourcePoint3D+[0 -1 1],SourcePoint3D+[+1 0 1],SourcePoint3D+[-1 0 1]];
StartPoint_multi    = [StartPoint,StartPoint+[0 1 0],StartPoint+[0 -1 0],StartPoint+[+1 0 0],StartPoint+[-1 0 0],...
    StartPoint+[0 1 -1],StartPoint+[0 -1 -1],StartPoint+[+1 0 1],StartPoint+[-1 0 -1],...
    StartPoint+[0 1 1],StartPoint+[0 -1 1],StartPoint+[+1 0 1],StartPoint+[-1 0 1]];

DistanceMap3D_1 = msfm(double(spineStack_medfilt+r1).^3, SourcePoint3D_multi,true,true)+1e-8;
DistanceMap3D_2 = msfm(double(spineStack_medfilt+r2).^3, StartPoint_multi   ,true,true)+1e-8;

% imEq_1            = max(DistanceMap3D_1,[],3);
% imEq_2            = max(DistanceMap3D_2,[],3);
% 
% imEMaxima_1       = imextendedmax(imEq_1,max(DistanceMap3D_1(:)));
% imEMaxima_2       = imextendedmax(imEq_2,max(DistanceMap3D_2(:)));
% 
% imEMaxima_1       = imfill(imEMaxima_1, 'holes');
% imEMaxima_2       = imfill(imEMaxima_2, 'holes');
% 
% imEMaxima_1       = imdilate(imEMaxima_1,ones(5,5))+eps;
% imEMaxima_2       = imdilate(imEMaxima_1,ones(5,5))+eps;

% for ddd = 1:size(DistanceMap3D_1,3)
%     DistanceMap3D_1(:,:,ddd) = double(imEMaxima_1).*DistanceMap3D_1(:,:,ddd)+eps;
%     DistanceMap3D_2(:,:,ddd) = double(imEMaxima_2).*DistanceMap3D_2(:,:,ddd)+eps;
% end

% Find Shortest Path btw Spine Center and candidate branching
% point coordinates

clear ShortestLine;

ShortestLine_1 = shortestpath(DistanceMap3D_1,StartPoint+.1,2);
ShortestLine_2 = shortestpath(DistanceMap3D_2,SourcePoint3D+.1,2);
ShortestLine   = meanOfTwoLines3D(ShortestLine_1,ShortestLine_2);

% % 
% figure, imshow(max(spineStack,[],3),[]);
% hold on, plot3(ShortestLine(:,2),ShortestLine(:,1),ShortestLine(:,3),'-r');
% axis equal on;

% figure, imshow(max(temp,[],3),[]);