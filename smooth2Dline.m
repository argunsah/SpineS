function ShortestLineOut = smooth2Dline(ShortestLine,sr)

xInitial = ShortestLine(:,2);
yInitial = ShortestLine(:,1);

lengthX  = length(xInitial);

y = yInitial;
x = xInitial;

samplingRateIncrease    = sr;
newXSamplePoints        = linspace(min(x), max(x), lengthX * samplingRateIncrease);
originalXSamplePoints   = linspace(min(x), max(x), lengthX * 1);

smoothedY = pchip(x, y, newXSamplePoints);

% Now flip back
ySmooth = newXSamplePoints;
xSmooth = smoothedY;

x = xSmooth; 
v = ySmooth;

ShortestLineOut(:,2) = interp1(x,v,originalXSamplePoints);
ShortestLineOut(:,1) = originalXSamplePoints;
