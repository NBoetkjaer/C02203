% Script for checking that the Sobel generated image is correct.
clc, clear all, close all

% Read original image 
pic = imread('pic1.pgm');
% Read ModelSim generated image.
result = imread('pic1.pgm16.bits_result.pgm');
% Add borders to src image. ('symmetric' ~ Pad array with mirror reflections of itself.)
picBorder = double(padarray(pic,[1,1],'symmetric'));

% X gradient filter kernel.
Gx = [-1 0 1;
	-2 0 2;
	-1 0 1];

% y gradient filter kernel.
Gy = [1	2 1;
	  0	0 0;
	 -1 -2 -1];
	 
% perform sobel filtering that mimics the operation performed in the VHDL accelerator.
% - Use |Dx| + |Dy| instead of sqrt(Dx^2 + Dy^2)
% - Divide by 8 and convert to uint8 using truncation (fix)
picSobel = fix((abs(conv2(picBorder, Gx, 'valid')) + abs(conv2(picBorder, Gy, 'valid')))/8);

% Calculate the difference from the reference and sum up the errors.
err = abs(picSobel - double(result));
picSobel =  uint8(picSobel);
error = sum(err(:))
if( error == 0 )
	display 'Verification passed.'
else
	display 'Verification failed.'
end
