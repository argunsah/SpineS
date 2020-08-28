function meanSL = meanOfTwoLines(ShortestLine,ShortestLine2)

nSL  = numel(ShortestLine)/2;
nSL2 = numel(ShortestLine2)/2;

clear sL;
clear meanSL;

if nSL > nSL2
    [idx, dist] = knnsearch(ShortestLine,ShortestLine2,'dist','cityblock');
    sL(:,2) = ShortestLine(idx,2);
    sL(:,1) = ShortestLine(idx,1);
    
    meanSL(:,2) = (sL(:,2) + ShortestLine2(:,2))/2;
    meanSL(:,1) = (sL(:,1) + ShortestLine2(:,1))/2; 
else
    [idx, dist] = knnsearch(ShortestLine2,ShortestLine,'dist','cityblock');
    sL(:,2) = ShortestLine2(idx,2);
    sL(:,1) = ShortestLine2(idx,1);
    
    meanSL(:,2) = (sL(:,2) + ShortestLine(:,2))/2;
    meanSL(:,1) = (sL(:,1) + ShortestLine(:,1))/2;  
end