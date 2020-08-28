
function [final_image_1,final_image_2,final_image_3,Ix,Iy] = imsegmWaterShed(I, skelPiece, dendPiece)
%
% A method for single spine detection
% M. Yagci + E. Erdil v.0.2. 31.05.12
% + Ali Ozgur Argunsah march 2014
% depends on shapeprops.m, moments.m

method    = 'nearest';
[Ix,Iy]   = size(I);

if Ix < 200
    newSize   = 200;
    I         = imresize(I,[newSize newSize],method);
    skelPiece = imresize(skelPiece,[newSize newSize],method);
    dendPiece = imresize(dendPiece,[newSize newSize],method);
end

imEq = adapthisteq(medfilt2(I,[11 11]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extended maxima transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imHMaxima = imhmax(imEq, 5)

imEMaxima = imextendedmax(imEq,5);
imEMaxima = imfill(imEMaxima|skelPiece, 'holes');

% imEMaxima = imdilate(imEMaxima,ones(5,5)); changed dec 2017

% iemMiddle = (detectDendriteSpine(double(imEMaxima))/255);
% % 
% % se = strel('ball',5,5);
% % erodedI = imerode(,se);
% 
% imEMaxima = logical(iemMiddle);

%figure; imshow(imEMaxima);%title('Iemax')  % TEST EXTENDED MAX TRANSFORM

% isSpineFound = 1; 
% 
% C = bwconncomp(imEMaxima, 8);
% 
% if(size(C.PixelIdxList, 2) < 2)
%    isSpineFound = 0;
% end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% morphological operations to find ROI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% otsu
imBW = imbinarize(imEq, graythresh(imEq));
% figure; imshow(imBW) % TEST

% roi selection
imBW = imdilate(imBW | imEMaxima, ones(5,5));
% imBW = imBW | imEMaxima;
% figure; imshow(imBW) % TEST

% find boundaries
imBW      = imfill(imBW,'holes');
imBWPerim = bwperim(imBW);

% figure, visualizer(I, imEMaxima | imBWPerim, 0.4, ''); % TEST

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add more spines manually
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  options.Interpreter = 'tex';
%  options.Default = 'No';
%  qstring = 'Do you want to choose more spines manually?';
%  choice = questdlg(qstring,'Manual selection','Yes','No',options);
% %choice = 'No';
% while(strcmp(choice, 'Yes'))
%     imMoreMaxima = roipoly;
%     imEMaxima = imEMaxima | imMoreMaxima;
%     visualizer(I, imEMaxima | imBWPerim, 0.4, ''); % TEST
%     choice = questdlg(qstring,'Manual selection','Yes','No',options);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% watersheds (segmentation phase 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% complement the image
imEqComp         = imcomplement(imEq);

% make background and imEMaxima ==> only maxima
imEqCompModified = imimposemin(imEqComp, ~imBW | imEMaxima);

% figure; imshow(imEqCompModified); title('imEqCompModified')  % TEST
% apply watershed transform.

%L = watershed(imEqCompModified);
L1 = watershed(double(imEqCompModified).^1);
L2 = watershed(double(imEqCompModified).^2);
L3 = watershed(double(imEqCompModified).^4);

final_image_1 = LtoFinalImage(I,L1);
final_image_2 = LtoFinalImage(I,L2);
final_image_3 = LtoFinalImage(I,L3);

% if Ix < 200
%     final_image_1 = imresize(final_image_1,[Ix Iy],method);
%     final_image_2 = imresize(final_image_2,[Ix Iy],method);
%     final_image_3 = imresize(final_image_3,[Ix Iy],method);
% end

% figure, imshow(label2rgb(L)); title('final')
% figure, imshow(label2rgb(L2)); title('final')

%figure, imshow(label2rgb(L));
%final_image = L;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detect spine, show axis, print props to screen %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
% numberOfObjects = max(max(L));
% means(:, 1)     = 0:numberOfObjects;
% means(:, 2)     = zeros((numberOfObjects + 1), 1);
% 
% for i = 0:numberOfObjects 
%     ind = find(L == i);
%     len = length(ind);
%     means(i + 1, 2) = sum(I(ind))/len;
% end
% 
% [obs, order]    = sort(means(:, 2), 'descend');
% means           = means(order, :);
% clear order;
% clear obs;
% 
% final_image = zeros(size(L));
% 
% for i = 1:numberOfObjects 
%     %figure, imshow(L == means(i, 1));
%     
%     imTemp = (L == means(i, 1));
%     imTempRemove = bwmorph(imTemp, 'remove');
%     
%     lengthImTemp = length(find(imTemp == 1));
%     lengthImTempRemove = length(find(imTempRemove == 1));
%     
%     if(lengthImTemp ~= lengthImTempRemove)
%         final_image = final_image + (L == means(i, 1));
%     end
% end






% 
% % final_image = imresize(final_image,[Ix Iy],method);
% % figure, imagesc(final_image);
% 
% % obj1 = (L == means(1, 1));
% % obj2 = (L == means(2, 1));
% % %obj3 = (L == means(3, 1));
% % final_image = obj1 + obj2;
% % %final_image = obj3 * 256;
% 
% 
% 
% 
