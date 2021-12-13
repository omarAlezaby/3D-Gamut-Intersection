# 3D-Gamut-Intersection
A function to caculate the volume of intersection and the intersection gamut description of 2 different 3D gamuts.


# Pre-Requisites
## Matlab
To be able to use this code you need to install [Matlab](https://se.mathworks.com/). No additional Adds-on is required.

# Installation
Clone the code on you local device.
```
git clone https://github.com/omarAlezaby/3D-Gamut-Intersection.git
```
or dowenload the zip file directly.

# Functions

## gamutfromprofile(profile)
Function used to create a gamut surface description from ICC profile

```matlab
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
```

## point_inside
Function used to find if a point lie inside a gamut surface or not, and the intersection coordinate beween a line segment and gamut surface.
```matlab
function [inside, coord] = point_inside(orig, point, faces, vertcies)

% Point_Inside: find if the point is inside a gamut surface or not and
% find the intersection point with the gamut surface of the given line
% segment
% Input:
%   - orig: (3 x 1) The origin point of the line segment
%   - point: (3 x 1) The end point of the line segment
%   - faces: (N x 3) Faces of the gamut surface that is used for intersection
%   - vertcies: (M x 3) The versticies of the gamut surface that is used for
%   the intersection
%
% Output:
%   - inside: (bool) The point is inside or outside the gamut surface
%   - coord: (H x 3) the points of intersection between the line
%   segment and the gamut surface.
```

## intersection_gamut
calcualte the intersection gamut between two given 3D gamuts by giving the gamut boundry description of the two gamuts as vertices and faces.
```matlab
function [intr_faces, intr_vertices] = intersection_gamut(gam1_faces, gam1_vertices, gam2_faces, gam2_vertices)

% calcualte the intersection gamut between two given 3D gamuts
% it dosen't matter the used space as long as the both gamuts are in the
% same space

% Input: 
% gam1_tri_boundry: the boundry triangllations of the first gamut 
%       (Nx3 matrix where N is the number of faces in the gamut)
% gam1_p_boundry: the boundry points of the first gamut
%       (Mx3 matrix where M is the number of boundry points in the gamut)
% gam2_tri_boundry: the boundry triangllations of the second gamut
%       (Hx3 matrix where H is the number of faces in the gamut)
% gam2_p_boundry: the boundry points of the second gamut
%       (Lx3 matrix where L is the number of boundry points in the gamut)
%
% Output:
% intr_tri_boundry: the boundry triangllations of the intersection gamut
%       (Wx3 matrix where W is the number of faces in the gamut)
% intr_p_boundry: the boundry points of the intersection gamut
%       (Dx3 matrix where D is the number of boundry points in the gamut)
```
## Intersection_Profile
calcualte the intersection gamut between the gamuts of 2 devices by providing the ICC profile path of the two devices. 
The ICC profiles have to be created according to ISO 18621-11 4.4.2
```matlab
function [intr_faces, intr_vertices] = Intersection_Profile(profile_1, profile_2)
% calcualte the intersection gamut between the gamuts of 2 provided ICC
% profiles

% Input: 
% - profile_1: str, the path of the first profile, the profile should be
% created according to ISO 15076-1
% - profile_2: str, the path of the second profile, the profile should be
% created according to ISO 15076-1

% Output:
% - intr_tri_boundry: the boundry triangllations of the intersection gamut
%       (Wx3 matrix where W is the number of faces in the gamut)
% - intr_p_boundry: the boundry points of the intersection gamut
%       (Dx3 matrix where D is the number of boundry points in the gamut)
```

# Test The functions

```matlab
profile_1 = "profiles/sRGB_v4_ICC_preference.icc";
profile_2 = "profiles/PSOsc-b_paper_v3_FOGRA54.icc"; 

[vertices_1, faces_1]=gamutfromprofile(profile_1);


figure, trisurf(faces_1,vertices_1(:,2),vertices_1(:,3),vertices_1(:,1), 'FaceColor','cyan','FaceAlpha',0.3);

[vertices_2, faces_2]=gamutfromprofile(profile_2);
figure, trisurf(faces_2,vertices_2(:,2),vertices_2(:,3),vertices_2(:,1), 'FaceColor','cyan','FaceAlpha',0.3);

% run the first intersection version function

[faces_intr, vertices_intr] = intersection_gamut(faces_2, vertices_2, faces_1, vertices_1);
figure, trisurf(faces_intr,vertices_intr(:,2),vertices_intr(:,3),vertices_intr(:,1), 'FaceColor','cyan','FaceAlpha',0.3);


% run the second version intersection function

[faces_intr, vertices_intr] = intersection_profile(profile_2, profile_1);
figure, trisurf(faces_intr,vertices_intr(:,2),vertices_intr(:,3),vertices_intr(:,1), 'FaceColor','cyan','FaceAlpha',0.3);

```

