% Register Stack to First Time Stack

function [Icube,bty,btx] = registerAndCrop(Icube,firstCube)

firstTimePoint = double(max(firstCube,[],3))/double(max(firstCube(:)));
nTimePoint     = double(max(Icube,[],3))/double(max(Icube(:)));

usfac = 100;
[output, Nerd] = dftregistration(fft2(firstTimePoint),fft2(nTimePoint),usfac);
        
bty = output(3);
btx = output(4);

zSize = size(Icube,3);

for z = 1:zSize
    Icube(:,:,z) = circshift(Icube(:,:,z),[round(output(3)) round(output(4))]);
end