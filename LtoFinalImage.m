function [final_image] = LtoFinalImage(I,L)

numberOfObjects = max(max(L));
means(:, 1)     = 0:numberOfObjects;
means(:, 2)     = zeros((numberOfObjects + 1), 1);

for i = 0:numberOfObjects 
    ind = find(L == i);
    len = length(ind);
    means(i + 1, 2) = sum(I(ind))/len;
end

[obs, order]    = sort(means(:, 2), 'descend');
means           = means(order, :);
clear order;
clear obs;

final_image = zeros(size(L));

for i = 1:numberOfObjects 
    %figure, imshow(L == means(i, 1));
    
    imTemp = (L == means(i, 1));
    imTempRemove = bwmorph(imTemp, 'remove');
    
    lengthImTemp = length(find(imTemp == 1));
    lengthImTempRemove = length(find(imTempRemove == 1));
    
    if(lengthImTemp ~= lengthImTempRemove)
        final_image = final_image + (L == means(i, 1));
    end
end