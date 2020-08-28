function h = jointHisto(image_1, image_2)
%
% takes a pair of 8-bit greyscale images of equal size 
% and returns the 2d joint histogram.
% 

N = 256;

rows = size(image_1,1);
cols = size(image_1,2);

h = zeros(N,N);

for i=1:rows; 
    for j=1:cols;
        h(image_1(i,j)+1,image_2(i,j)+1)= h(image_1(i,j)+1,image_2(i,j)+1)+1;
    end
end

clearvars -except h;