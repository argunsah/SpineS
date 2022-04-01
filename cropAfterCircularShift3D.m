% % Ali Ozgur Argunsah
% % 03.01.2014 CCU
% % Crop Images After Circular Shift Followed by Registration
% % v1
% 
% function imCropped = cropAfterCircularShift(im,maxx,maxy,minx,miny)
% 
% imSizeY = size(im,1);
% imSizeX = size(im,2);
% 
% x1 = 1;
% x2 = size(im,2);
% y1 = 1;
% y2 = size(im,2);
% 
% if miny < 0 & maxy < 0
%     y2 = imSizeY+maxy ;
% end
% if miny < 0 & maxy > 0
%     y1 = maxy;
%     y2 = imSizeY + miny;
% end
% if miny > 0 & maxy > 0
%     y1 = maxy;
% end
% 
% if minx < 0 & maxx < 0
%    x2 = imSizeX + minx;
% end
% if minx < 0 & maxx > 0
%    x1 = maxx;
%    x2 = imSizeX + minx;
% end
% if minx > 0 & maxx > 0
%    x1 = maxx;
% end
% 
% imCropped = im(y1:y2,x1:x2);

% Ali Ozgur Argunsah
% 21.04.2014 CCU
% Crop Images After Circular Shift Followed by Registration
% v2

function imCropped = cropAfterCircularShift3D(imStack,maxx,maxy,minx,miny)

imSizeY = size(imStack,1);
imSizeX = size(imStack,2);

x1 = 1;
x2 = size(imStack,2);
y1 = 1;
y2 = size(imStack,2);

if minx < 0 && maxx <= 0
    x1 = 1;
    x2 = imSizeX+minx;
end

if minx < 0 && maxx > 0
    x1 = maxx;
    x2 = imSizeX+minx;
end

if minx >= 0 && maxx > 0
    x1 = maxx+1;
    x2 = imSizeX;
end

if miny < 0 && maxy <= 0
    y1 = 1;
    y2 = imSizeY+miny;
end

if miny < 0 && maxy > 0
    y1 = maxy;
    y2 = imSizeY+miny;
end

if miny >= 0 && maxy > 0
    y1 = maxy+1;
    y2 = imSizeY;
end

if y1<1
    y1 = 1;
end

if x1<1
    x1 = 1;
end

imCropped = imStack(y1:y2,x1:x2,:);





