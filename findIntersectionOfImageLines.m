function intersectionPoint = findIntersectionOfImageLines(neckLenFigTemp,seg_Dend_ROI,spineCenter)

difference = (neckLenFigTemp+seg_Dend_ROI) > 1;

% figure, imshow(seg_Dend_ROI,[])
% figure, imshow(neckLenFigTemp,[])

[y,x] = find(bwmorph(difference,'endpoints'));

d1 = sqrt((x(1)-spineCenter(1))^2+(y(1)-spineCenter(2))^2);
d2 = sqrt((x(2)-spineCenter(1))^2+(y(2)-spineCenter(2))^2);

if d1<d2
    intersectionPoint = [y(2) x(2)];
else
    intersectionPoint = [y(1) x(1)];
end

% 
% [y1,x1] = find(neckLenFigTemp);
% [y2,x2] = find(seg_Dend_ROI_perim);
% 
% %fit linear polynomial
% p1 = polyfit(x1,y1,1);
% p2 = polyfit(x2,y2,1);
% %calculate intersection
% figure,
% x_intersect = fzero(@(x) polyval(p1-p2,x),3);
% y_intersect = polyval(p1,x_intersect);
% line(x1,y1);
% hold on;
% line(x2,y2);
% plot(x_intersect,y_intersect,'r*')