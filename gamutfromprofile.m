function [vertices, faces]=gamutfromprofile(profile)
% GAMUTFROMPROFILE: calculates the volume of usable gamut and device gamut 
% from an ICC CMYK or RGB profile according to ISO 18621-11 4.4.2
% 
% Note: The fucntion was modified to return the gamut description of the
% computed gamut surface
%
% Example: V=gamutfromprofile('profilename.icc')
% where 'profilename.icc' is the filename of the ICC profile whose gamut 
% volume is to be found.
%
% GAMUTFROMPROFILE calls the following external files:
% - RGBSurfaceTriangles.txt
% - CMYKSurfaceTriangles.txt
% - RGBGamutTarget_v2_beta.tif
% - CMYKGamutTarget_v2_beta.tif
% These files must all be on the current path, along with the profile to be
% evaluated.
%
%   Colour Engineering Toolbox
%   author:    © Phil Green
%   version:   2.0
%   date:  	   12-10-2021

% Read CIELAB profile for PCS side of conversion (warning off as Matlab
% misreads file size)
warning('off')
P1=iccread('profiles\CIELABD50.icc');
warning('on')

% Check if valid RGB or CMYK profile and read all input data		
P2=iccread(profile);
if isicc(P2)
		if strcmp(P2.Header.ColorSpace,'RGB')
			faces=double(load("data\RGBSurfaceTriangles.mat").data);
			device_data=imread('data\ISO 18621-11 Fig A1_RGB.tif');
		elseif strcmp(P2.Header.ColorSpace,'CMYK')
			faces=double(load("data\CMYKSurfaceTriangles.mat").data);
			device_data=imread('data\ISO 18621-11 Fig A1_CMYK.tif');
		else
			disp('Data colour space of profile must be RGB or CMYK');
		end
	
		% Normalise 8 or 16-bit data to [0,1] range and reshape to columns
		if max(device_data)>255
			norm_data=m2v(double(device_data)/65535);
		else
			norm_data=m2v(double(device_data)/255);
		end
		% Calculate device gamut
		C1 = makecform('icc', P2, P1, 'SourceRenderingIntent', 'AbsoluteColorimetric', 'DestRenderingIntent', 'AbsoluteColorimetric');
		device_lab=applycform(norm_data,C1);
		device_volume=gamutvol(device_lab,faces);
		%disp(strcat('Device gamut: ',num2str(device_volume)));
		
		% Perform round trip and calculate usable gamut for CMYK profile
		if strcmp(P2.Header.ColorSpace,'CMYK')
			C2=makecform('icc',P1, P2, 'SourceRenderingIntent', 'AbsoluteColorimetric', 'DestRenderingIntent', 'AbsoluteColorimetric');
			usable_device=applycform(device_lab,C2);
			usable_lab=applycform(usable_device,C1);
			usable_volume=gamutvol(usable_lab,faces);
			disp(strcat('Usable gamut: ',num2str(usable_volume)));
        else
            usable_lab = device_lab;
			usable_volume=device_volume;
            disp(strcat('Usable gamut: ',num2str(usable_volume)));
        end
        vertices = usable_lab;
else
    disp('A valid ICC profile is required')
end

function V = m2v(data)
% M2V: Converts rxcxn matrix of colour data to n columns. 
% The order of the data in the resulting columns is r1,r2,...rn
%
% Example: M2V(CMY) where CMY is a 3D matrix 
% arranged row x column x colour.
%
%   Colour Engineering Toolbox
%   author:    © Phil Green
%   version:   1.1
%   date:  	   17-01-2001

% Input matrix and get size
LMN=data;
[r,c,n]=size(LMN);

% Prepare empty matrix
V=zeros((r/100)*(c/100),n);

% Transpose and reshape to vectors
point_cnt = 1;
for i=1:100:r
    for j=1:100:c
        V(point_cnt,:) = LMN(i,j,:);
        point_cnt = point_cnt + 1;
    end
end

