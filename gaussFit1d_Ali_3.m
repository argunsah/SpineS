% cf is conversion factor from pixel to nanometers
% Use 1 for now
% Ali

function [fitted_y, g, fwhm] = gaussFit1d_Ali_3(x,y,cf)

warning('OFF')
% Normalize y

y = y/max(y);

fun = {@(ab,x) exp(-ab(1)*(x-ab(2)).^2),@(ab,x) x, 1};
    
a_0 = 1/sqrt(2*pi*(std(y).^2));
b_0 = mean(x);

abstart = [a_0, b_0, 0.001];
[d,e] = fminspleas(fun,abstart,x,y);

fitted_y = e(1)*exp(-d(1)*(x-d(2)).^2)+e(2)*x+e(3);
% figure, plot(x,y,'.'), hold on, plot(x,fitted_y,'r')

g = corr(y',fitted_y');

fwhm = real(2*sqrt(2*log(2))*sqrt(1/(2*d(1))));

fwhm;
