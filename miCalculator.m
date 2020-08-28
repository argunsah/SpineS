function h = miCalculator(image_1, image_2, metric)
%
% takes a pair of 8-bit greyscale images, then returns MI or NMI
%
% depends on jointHisto.m
%

a = jointHisto(image_1,image_2); % calculating joint histogram for two images
[r, c] = size(a);
b = a ./ (r * c); % normalized joint histogram
y_marg = sum(b); %sum of the rows of normalized joint histogram
x_marg = sum(b'); %sum of columns of normalized joint histogram

% Marginal entropy for image 1
Hy=0;
for i=1:c;    %  col
      if( y_marg(i)==0 )
         %do nothing
      else
         Hy = Hy + -(y_marg(i)*(log2(y_marg(i)))); 
      end
end

% Marginal entropy for image 2
Hx=0;
for i=1:r;    %rows
   if( x_marg(i)==0 )
         %do nothing
  else
     Hx = Hx + -(x_marg(i)*(log2(x_marg(i)))); 
  end   
end

% Joint entropy
h_xy = -sum(sum(b.*(log2(b+(b==0))))); 

% Mutual information
h = Hx + Hy - h_xy;

% Normalized mutual information
if strcmp(metric, 'NMI')
    % h = (Hx + Hy)/h_xy;
    h = 2*h / (Hx + Hy);
end

clearvars -except h;

