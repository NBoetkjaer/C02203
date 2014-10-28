% Read original image
pic = imread('pic1.pgm');
% Read ModelSim generated image.
result = imread('pic1.pgm16.bits_result.pgm');
% Add borders to src image.
picBorder = int16(padarray(pic,[1,1],'symmetric'));
% X gradient filter kernel.
Gx = [	-1	0	1;
		-2	0	2;
		-1	0	1];
% y gradient filter kernel.
Gy = [	 1	 2	 1;
		 0	 0	 0;
		-1	-2	-1];
	 
% perform sobel filtering that mimics the operation performed in the VHDL accelerator.
% - Use truncation (fix) 
% - Use |Dx| + |Dy| instead of sqrt(Dx^2 + Dy^2)
% - Divide by 8 and convert to uint8.
picSobel =  uint8(fix((abs(conv2(picBorder, Gx, "valid")) + abs(conv2(picBorder, Gy, "valid")))/8));

% Calculate the difference from the reference and sum up the errors.
err = abs(picSobel - result);
error = sum(err(:))
if( error == 0 )
	display "Verification passed."
else
	display "Verification failed."
end
