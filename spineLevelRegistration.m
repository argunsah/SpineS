function bestROI = spineLevelRegistration(imROIprevious, imROIcurrent, imageNew, rangeOfTranslation)

    metric  = 'MI';
    bestROI = [0 0 0 0]; % xMin xMax yMin yMax

    [imHeight imWidth] = size(imageNew);

    allIndices  = find(imROIcurrent == 1);

    xMinCurrent = min(ceil(allIndices./imHeight));
    yMinCurrent = min(mod(allIndices,imHeight));

    xMaxCurrent = max(ceil(allIndices./imHeight));
    yMaxCurrent = max(mod(allIndices,imHeight));

    imROInew = zeros((yMaxCurrent - yMinCurrent + 1), (xMaxCurrent - xMinCurrent + 1));

    bestMI = 0;

    rangeOfTranslationX = rangeOfTranslation;
    rangeOfTranslationY = rangeOfTranslation;

    negativeMoveX = xMinCurrent - 1;

    if(negativeMoveX < abs(rangeOfTranslation(1)))
        rangeXstart = -1*negativeMoveX;
    else
        rangeXstart = rangeOfTranslation(1);
    end

    positiveMoveX = size(imageNew, 2) - xMaxCurrent;

    if(positiveMoveX < rangeOfTranslation(length(rangeOfTranslation)))
        rangeXend = positiveMoveX;
    else
        rangeXend = rangeOfTranslation(length(rangeOfTranslation));
    end
    rangeOfTranslationX = rangeXstart:rangeXend;

    negativeMoveY = yMinCurrent - 1;

    if(negativeMoveY < abs(rangeOfTranslation(1)))
        rangeYstart = -1*negativeMoveY;
    else
        rangeYstart = rangeOfTranslation(1);
    end

    positiveMoveY = size(imageNew, 1) - yMaxCurrent;

    if(positiveMoveY < rangeOfTranslation(length(rangeOfTranslation)))
        rangeYend = positiveMoveY;
    else
        rangeYend = rangeOfTranslation(length(rangeOfTranslation));
    end

    rangeOfTranslationY = rangeYstart:rangeYend;

    for i = rangeOfTranslationX
        for j = rangeOfTranslationY   
            
            xMinTemp = xMinCurrent + i;
            if(xMinTemp < 1)
                xMinTemp = 1;
            end
            
            xMaxTemp = xMaxCurrent + i;
            if(xMaxTemp > size(imageNew, 2))
                xMaxTemp = size(imageNew, 2);
            end
            
            yMinTemp = yMinCurrent + j;
            if(yMinTemp < 1)
                yMinTemp = 1;
            end
            
            yMaxTemp = yMaxCurrent + j;
            if(yMaxTemp > size(imageNew, 1))
                yMaxTemp = size(imageNew, 1);
            end

            imROInew = imageNew(yMinTemp:yMaxTemp, xMinTemp:xMaxTemp);

            if((size(imROInew, 1) ~= size(imROIprevious, 1)) || (size(imROInew, 2) ~= size(imROIprevious, 2)))

                diffY = size(imROIprevious, 1) - size(imROInew, 1);
                diffX = size(imROIprevious, 2) - size(imROInew, 2);

                tempY = floor(diffY / 2);
                tempX = floor(diffX / 2);

                yMinTemp = yMinTemp - tempY;
                yMaxTemp = yMaxTemp + (diffY - tempY);
                if(yMinTemp < 1)
                    dummy = 1 - yMinTemp;
                    yMinTemp = 1;
                    yMaxTemp = yMaxTemp + dummy;
                end
                
                if(yMaxTemp > size(imageNew, 1))
                    dummy = yMaxTemp - size(imageNew, 1);
                    yMaxTemp = size(imageNew, 1);
                    yMinTemp = yMinTemp - dummy;
                end

                xMinTemp = xMinTemp - tempX;
                xMaxTemp = xMaxTemp + (diffX - tempX);

                if(xMinTemp < 1)
                    dummy = 1 - xMinTemp;
                    xMinTemp = 1;
                    xMaxTemp = xMaxTemp + dummy;
                end
                
                if(xMaxTemp > size(imageNew, 1))
                    dummy = xMaxTemp - size(imageNew, 1);
                    xMaxTemp = size(imageNew, 1);
                    xMinTemp = xMinTemp - dummy;
                end
            end

            imROInew = imageNew(yMinTemp:yMaxTemp, xMinTemp:xMaxTemp);
            MI       = miCalculator(imROIprevious, imROInew, metric);

            if(MI > bestMI)
                bestMI  = MI;
                bestROI = [xMinTemp xMaxTemp yMinTemp yMaxTemp];  
            end
        end  
    end
end