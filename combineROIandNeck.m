function compositeImage = combineROIandNeck(img,path,neck)

img = double(img);

se = strel('ball',2,2);

pathImg = zeros(size(img));
for i = 1:length(path(:,1))
    pathImg(round(path(i,1)),round(path(i,2))) = max(img(:));
    pathImg(floor(path(i,1)),floor(path(i,2))) = max(img(:));
    pathImg(ceil(path(i,1)) ,ceil(path(i,2)))  = max(img(:));
end
pathImg = imdilate(pathImg, se);


neckImg = zeros(size(img));
for i = 1:length(neck(:,1))
    neckImg(round(neck(i,1)),round(neck(i,2))) = max(img(:));
    neckImg(floor(neck(i,1)),floor(neck(i,2))) = max(img(:));
    neckImg(ceil(neck(i,1)) ,ceil(neck(i,2)))  = max(img(:));
end
neckImg = imdilate(neckImg, se);

A = img;
B = pathImg;
C = neckImg;

compositeImage = cat(3, B+A, A, C+A)/max(img(:));
% figure, imshow(compositeImage);
