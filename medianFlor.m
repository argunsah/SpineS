function val = medianFlor(Icube)

tempMIP = max(double(Icube),[],3);
[skelD,bw1crop_temp] = iterativeSkeletonSmooting(tempMIP, ones(size(tempMIP)));

[I,J] = ind2sub(size(skelD),find(skelD>0));
val   = median(tempMIP(sub2ind(size(skelD),I,J)));