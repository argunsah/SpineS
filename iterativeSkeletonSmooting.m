function [skelD,bw1crop_temp] = iterativeSkeletonSmooting(MIP, CropMask)

total_bin_image = zeros(size(MIP));

MIP_0_1      = double(MIP);
MIP_0_1      = MIP_0_1/max(MIP_0_1(:));

thr_first    = graythresh(MIP_0_1);
imthr        = multithresh(MIP_0_1,15);

diffr        = abs(imthr-thr_first);
start_ind    = find(diffr == min(diffr));
start_ind    = round(start_ind / 2);

img_temp     = imbinarize(MIP_0_1,thr_first);

skelD        = zeros(size(MIP));
bw1crop_temp = zeros(size(MIP));

try
    for t = start_ind:15

        img         = imbinarize(MIP_0_1,imthr(t));
        dend        = img&CropMask; %img&temp&CropMask;
        boundaries  = bwboundaries(dend);
        bw          = zeros(size(dend));

        for k = 1:size(boundaries,1)

            thisBoundary = boundaries{k};

            if size(thisBoundary,1)>5

                x = thisBoundary(:, 2);
                y = thisBoundary(:, 1);

                windowWidth     = 21;

                if length(x) < windowWidth
                    windowWidth = 2*floor(length(x)/2) + 1; % Go Half and odd
                end

                polynomialOrder = 2;

                if length(x) >=windowWidth
                    smoothX = sgolayfilt(x, polynomialOrder, windowWidth);
                    smoothY = sgolayfilt(y, polynomialOrder, windowWidth);
                    bw      = bw | poly2mask(smoothX,smoothY,size(dend,1),size(dend,2));
                end
            end   
        end

        dend = bw;

        blacktemp       = zeros(size(dend));
        CC              = bwconncomp(dend);
        numPixels       = cellfun(@numel,CC.PixelIdxList);
        [biggest,idx]   = max(numPixels);

        blacktemp(CC.PixelIdxList{idx}) = 1;

        dend            = blacktemp;
        bw1crop         = logical(double(dend).*CropMask);
        bw1crop_temp    = bw1crop_temp + double(bw1crop);
        % After BW of MIP, Now we find Dendrite without Spines

        skel    = bwmorph(bw1crop,'skel',Inf);
        B       = bwmorph(skel, 'branchpoints');
        E       = bwmorph(skel, 'endpoints');

        [y,x] = find(E);
        B_loc = find(B);
        Dmask = false(size(skel));

        for k = 1:numel(x)
            D = bwdistgeodesic(skel,x(k),y(k));
            distanceToBranchPt = min(D(B_loc));
            Dmask(D < distanceToBranchPt) = true;
        end

        skelD_temp = skel - Dmask;
        skelD_temp = bwmorph(skelD_temp,'bridge');

        skelD = double(skelD_temp) + skelD;
    end
catch
    fprintf('%s','Signal Processing Toolbox is necessary');
end

   
%figure,imshow(skelD,[]);

%figure,imshow(img_temp+(skelD>0),[]);