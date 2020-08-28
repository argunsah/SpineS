% Make ROI %10 smaller everytime it hits to a border, recursively
% Ali Ozgur Argunsah, 2016.

function newRectSize = rectSizeFind(x,y,xSize,ySize,rectSize) 

p1 = x - floor(rectSize/2);
p2 = y - floor(rectSize/2);
p3 = ceil(x+rectSize/2); 
p4 = ceil(y+rectSize/2);  

if p1<0 || p2<0 || p3>ySize || p4>xSize
    newRectSize = 0.95*rectSize;
    newRectSize = rectSizeFind(x,y,xSize,ySize,newRectSize);
    rectSize    = newRectSize;
else
    newRectSize = rectSize;
end