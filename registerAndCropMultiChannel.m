% Register Stack to First Time Stack

function [Icube,Icube_ch2,bty,btx] = registerAndCropMultiChannel(Icube,firstCube,Icube_ch2)

firstTimePoint        = double(max(firstCube,[],3))/double(max(firstCube(:)));
nTimePoint            = double(max(Icube,[],3))/double(max(Icube(:)));
firstTimePoint_ch2    = double(max(Icube_ch2,[],3))/double(max(Icube_ch2(:)));

usfac = 100;
[output, Greg, Greg2] = dftregistrationMultiChannel(fft2(firstTimePoint),fft2(nTimePoint),fft2(firstTimePoint_ch2),usfac);

bty = output(3);
btx = output(4);

zSize = size(Icube,3);

for z = 1:zSize
    Icube(:,:,z)     = circshift(Icube(:,:,z)    ,[round(output(3)) round(output(4))]);
    Icube_ch2(:,:,z) = circshift(Icube_ch2(:,:,z),[round(output(3)) round(output(4))]);
end