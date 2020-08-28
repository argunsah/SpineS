function stats = graphBased(imMedian, waterShedSegmentation, k, imageFixed, xMin, yMin, height_, width_, location, spineId, index_, angle, binDendPiece, xPixelSize)

if (sum(double(waterShedSegmentation(:)))/255) > ((size(waterShedSegmentation,1)*size(waterShedSegmentation,2))/2)
    skelTemp        = bwmorph(binDendPiece,'skel',Inf);
    [lb,center]     = adaptcluster_kmeans(imMedian);
    lb              = lb - 1;

    A = zeros(size(imMedian));
    r = round(size(imMedian,1)/8);
    P = round(size(imMedian)/2);
    
    [m n] = size(A);
    
    X = bsxfun(@plus,(1:m)',zeros(1,n));
    Y = bsxfun(@plus,(1:n),zeros(m,1));

    B = sqrt(sum(bsxfun(@minus,cat(3,X,Y),reshape(P,1,1,[])).^2,3)) <= r;

    waterShedSegmentation = ((((lb > 0) - binDendPiece) > 0) & B)*255;
end

new_dend    = binDendPiece;

% ac_val      = round(10*(0.0193/xPixelSize));     
% new_dend2   = activecontour(double(imMedian),new_dend,ac_val  ,'Chan-Vese','ContractionBias',.3,'SmoothFactor',2.5); 
% new_dend3   = activecontour(double(imMedian),new_dend,ac_val*5,'Chan-Vese','ContractionBias',.3,'SmoothFactor',2.5); 
% 
% sd1         = double(sum(new_dend(:)));
% sd2         = double(sum(new_dend2(:)));
% sd3         = double(sum(new_dend3(:)));
% 
% if sd3>sd1/2
%     new_dend = new_dend2 & new_dend3;
% end

[height width]      = size(imMedian);
imMedian            = double(imMedian);

indices             = find(waterShedSegmentation == 255);
intensities         = imMedian(indices);

stdDevOfIntensities = std2(intensities);
numberOfPixels      = length(indices);

SM_ind              = zeros(numberOfPixels, 8);
SM_weight           = zeros(numberOfPixels, 8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Construct Similarity Graph %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:numberOfPixels
    
    ind = indices(i);
    neighborsInd = [find(indices == (ind - height - 1)),...
        find(indices == (ind - height)),...
        find(indices == (ind - height + 1)),...
        find(indices == (ind - 1)),...
        find(indices == (ind + 1)),...
        find(indices == (ind + height - 1)),...
        find(indices == (ind + height)),...
        find(indices == (ind + height + 1))];
    %neighborsIntensities = imMedian(neighborsInd);
    
    SM_ind(i, 1:length(neighborsInd)) = neighborsInd;
    SM_weight(i, 1:length(neighborsInd)) = exp((-1)*power(imMedian(ind) -...
        imMedian(indices(neighborsInd(neighborsInd ~= 0))),2)/stdDevOfIntensities);   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GraphBased Segmentation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

degreeOfFreedom  = sum((SM_weight ~= 0)');
sumOfWeights     = sum(SM_weight');

attachments(:,1) = 1:numberOfPixels;
attachments(:,2) = sumOfWeights' ./ degreeOfFreedom';

clear degreeOfFreedom;
clear sumOfWeights;

queue       = CQueue(cell(200, 1));
labels      = zeros(numberOfPixels, 1);
clusterId   = 1;
markedCount = 0;

while(markedCount < numberOfPixels)
    
   [obs, order] = sort(attachments(:, 2), 'descend');
   attachments  = attachments(order, :);
   
   clear order; % sort attachment in descending order
   clear obs;
   
    d = attachments(1,1); % the object having the highest attachment
        
    queue.push(d); % add seed to the queue
    
    while(queue.isempty() ~= 1)
       
        d = queue.pop();
        
        if(labels(d) == 0)
            labels(d)   = clusterId;
            markedCount = markedCount + 1;
            attachments(attachments(:, 1) == d,2) = -1;
            
            neighbors = find(SM_ind(d,:) ~= 0);
            
            counter      = 0;
            newNeighbors = [];
            
            for i = 1:length(neighbors)
               if(labels(SM_ind(d, neighbors(i))) == 0)
                   counter = counter + 1;
                   newNeighbors(counter) = neighbors(i);
               end
            end
            
            if(~isempty(newNeighbors))
                
                for i = 1:length(newNeighbors)
                    
                    strWeight = SM_weight(d, neighbors(i));
                    neighInd  = SM_ind(d, neighbors(i));
                    
                    nextNeighbors        = SM_ind(neighInd, :) ~= 0;
                    nextNeighborsWeights = SM_weight(neighInd, nextNeighbors);
                    
                    maxWeight = max(nextNeighborsWeights);
                    
                    if(strWeight >= maxWeight)
                        queue.push(neighInd);
                    end
                end
            end 
        end 
    end
    clusterId = clusterId + 1;
end

clear SM_ind
clear SM_weight

numberOfCluster = length(unique(labels));

% Control for Number of Clusters
if numberOfCluster < 10
    numberOfCluster = 10;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%To visualize segmentation after graph-based clustering%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tempImage = zeros(size(imMedian));
% 
% for i = 1:numberOfCluster
%    tempImage(indices(find(labels == i))) = i; 
% end
% figure,
% imshow(label2rgb(tempImage));
% clear tempImage

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hierarchical Clustering %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clusterSums  = zeros(numberOfCluster, 1);
clusterSizes = zeros(numberOfCluster, 1);
clusterMeans = zeros(numberOfCluster, 4);

for i = 1:numberOfCluster
    intensForHier   = intensities((labels == i));
    clusterSums(i)  = sum(intensForHier);
    clusterSizes(i) = length(intensForHier);
end

clusterMeans(:, 1) = 1:numberOfCluster;
clusterMeans(:, 3) = clusterSums;
clusterMeans(:, 4) = clusterSizes;

for i = 1:(numberOfCluster - k)
    
    clusterMeans(:, 2) = clusterMeans(:, 3) ./ clusterMeans(:, 4);
    [obs, order]       = sort(clusterMeans(:, 2), 'ascend');
    clusterMeans       = clusterMeans(order, :);
    
    clear order;
    clear obs;
    
    differences               = abs(diff(clusterMeans(: , 2)));
    [minDifference minIndex1] = min(differences);
    minIndex2                 = minIndex1 + 1;
    
    clusterId1 = clusterMeans(minIndex1, 1);
    clusterId2 = clusterMeans(minIndex2, 1);
    
    clusterMeans(minIndex1, 3)  = clusterMeans(minIndex1, 3) + clusterMeans(minIndex2, 3);
    clusterMeans(minIndex1, 4)  = clusterMeans(minIndex1, 4) + clusterMeans(minIndex2, 4);
    clusterMeans                = [clusterMeans(1:minIndex1, :);
    clusterMeans((minIndex2 + 1):end, :)];
       
    if(clusterId1 < clusterId2)
       clusterMeans((clusterMeans(:, 1) == clusterId2), 1) = clusterId1;
       labels((labels == clusterId2)) = clusterId1;
    else
       clusterMeans((clusterMeans(:, 1) == clusterId1), 1) = clusterId2;
       labels((labels == clusterId1)) = clusterId2;
    end
end

labelsTemp = unique(labels);

for i = 1:length(labelsTemp)
   labels((labels == labelsTemp(i))) = i;
   clusterMeans((clusterMeans(:, 1) == labelsTemp(i)), 1) = i;
end

clusterMeans(:, 2)  = clusterMeans(:, 3) ./ clusterMeans(:, 4);
[obs, order]        = sort(clusterMeans(:, 2), 'descend'); 
clusterMeans        = clusterMeans(order, :); 

clear order;
clear obs;

finalLabels = zeros(numberOfPixels, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear tempImage
clear tempImageFixed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tempSpine = [];

for j = 0:(k - 1)
    if(j == 0)
        for i = 1:k
           finalLabels((labels == i)) = 1; 
        end
    else
        backgroundClusterIndex = clusterMeans(k - j + 1, 1);
        for i = 1:k
            if(i == backgroundClusterIndex)
                finalLabels((labels == i)) = 2;
            elseif(unique(finalLabels((labels == i))) ~= 2)
                finalLabels((labels == i)) = 1;
            end
        end
    end
    
    spineIndices    = indices((finalLabels == 1));
    tempImage       = zeros(size(imMedian));
    tempImageBinary = zeros(size(imMedian));

    tempImageBinary(spineIndices)   = 1;
    
    tempImageBinary = (tempImageBinary-new_dend)>0;
    tempImage(tempImageBinary==1) = 255;
    
    stats{index_,spineId,k - j}     = binarySpineCandidateProperties(tempImageBinary,spineId,k - j);
    
    tempSpine(:,:,j+1)  = tempImage;
    tempSpine2(:,:,j+1) = (j+1)*double(tempImage);
end

for j = 0:(k - 1)
    saveResultsForAll_k(imageFixed, uint8(imMedian), xMin, yMin, height_, width_, squeeze(tempSpine(:,:,j+1)), k - j, location, spineId, index_, angle);
    SaveROIresults(imageFixed     , uint8(imMedian), xMin, yMin, height_, width_, squeeze(tempSpine(:,:,j+1)), k - j, location, spineId, index_, angle);
end







