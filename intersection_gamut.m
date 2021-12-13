function [intr_tri_boundry, intr_p_boundry] = intersection_gamut(gam1_tri_boundry, gam1_p_boundry, gam2_tri_boundry, gam2_p_boundry)
% calcualte the intersection gamut between two given 3D gamuts gamuts
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


%% do process for one gamut, get the points inside and the intersection wiht points outside

% for gam1 as gamut and gam2 as points

gam1_c_point = mean(gam1_p_boundry);

% points inside gamut
test_points= num2cell(gam2_p_boundry, 2); 
[inside_gam1, ~] = cellfun(@(x) point_inside(gam1_c_point, x, gam1_tri_boundry,gam1_p_boundry), test_points, 'UniformOutput',false);
inside_gam1 = cell2mat(inside_gam1)==1;

outside_gam1 = gam2_p_boundry(~inside_gam1, :);

% find face edges to test
edges = [];
for i=1:size(gam2_tri_boundry,1)
    edges = [edges; [gam2_tri_boundry(i,1), gam2_tri_boundry(i,2)]];
    edges = [edges; [gam2_tri_boundry(i,2), gam2_tri_boundry(i,3)]];
    edges = [edges; [gam2_tri_boundry(i,3), gam2_tri_boundry(i,1)]];
end

% get intersection points
org_points= num2cell(gam2_p_boundry(edges(:, 1),:), 2); 
out_points= num2cell(gam2_p_boundry(edges(:, 2),:), 2); 
[have_int, inter_points_gam1] = cellfun(@(x,y) point_inside(x, y, gam1_tri_boundry,gam1_p_boundry), org_points, out_points, 'UniformOutput',false);

inter_points_gam1 = cell2mat(inter_points_gam1);
have_int = cell2mat(have_int);
%inter_points_gam1 = inter_points_gam1(have_int == 1, :);

%% do process for one gamut, get the points inside and the intersection wiht points outside

% for gam2 as gamut and gam1 as points
gam2_c_point = mean(gam2_p_boundry);

% points inside gamut
test_points= num2cell(gam1_p_boundry, 2); 
[inside_gam2, ~] = cellfun(@(x) point_inside(gam2_c_point, x, gam2_tri_boundry,gam2_p_boundry), test_points, 'UniformOutput',false);
inside_gam2 = cell2mat(inside_gam2)==1;
outside_gam2 = gam1_p_boundry(~inside_gam2, :);

% find face edges to test
edges = [];
for i=1:size(gam1_tri_boundry,1)
    edges = [edges; [gam1_tri_boundry(i,1), gam1_tri_boundry(i,2)]];
    edges = [edges; [gam1_tri_boundry(i,2), gam1_tri_boundry(i,3)]];
    edges = [edges; [gam1_tri_boundry(i,3), gam1_tri_boundry(i,1)]];
end

% get intersection
org_points= num2cell(gam1_p_boundry(edges(:, 1),:), 2); 
out_points= num2cell(gam1_p_boundry(edges(:, 2),:), 2); 
[have_int, inter_points_gam2] = cellfun(@(x,y) point_inside(x, y, gam2_tri_boundry,gam2_p_boundry), org_points, out_points, 'UniformOutput',false);

inter_points_gam2 = cell2mat(inter_points_gam2);
have_int = cell2mat(have_int);
%inter_points_gam2 = inter_points_gam2(have_int == 1, :);

%% intersection points
inter_boundry_points = [gam1_p_boundry(inside_gam2, :); gam2_p_boundry(inside_gam1, :); inter_points_gam1; inter_points_gam2];
% get the gamut for the intersection points
intr_GBD = alphaShape(inter_boundry_points, 40);
disp(strcat('inter gamut: ',num2str(intr_GBD.volume)));
[intr_tri_boundry, intr_p_boundry] = boundaryFacets(intr_GBD);
