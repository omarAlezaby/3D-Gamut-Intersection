function V=gamutvol(vertices, faces)
% GAMUTVOL: Computes volume of gamut from an array of vertices on the gamut
% surface and an array of indices representing the unique triangulation of 
% the surface.
%
% The method used is according to ISO 18621-11 4.4.2
%
% Example: V=gamutvol(vertices, faces)
% where 'vertices' is an nx3 array of CIELAB values [L*, a*, b*] and
% 'faces' is an mx3 array of indices into 'vertices'. Each row in 'faces'
% contains the three indices of the vertices which defines one of the
% planar faces on the gamut surface
%
%   Colour Engineering Toolbox
%   author:    © Phil Green
%   version:   2.0
%   date:  	   04-06-2021

% get number of faces
[m,~]=size(faces);

% pre-allocate array
v=zeros(m,1);

% find gamut centroid at average of white and black points
[~,j]=min(vertices(:,1));
[~,k]=max(vertices(:,1));
d=(vertices(j,:)+vertices(k,:))./2;

% calculate volume of each tetrahedron
for i=1:m
    a=vertices(faces(i,1),:)-d;
    b=vertices(faces(i,2),:)-d;
    c=vertices(faces(i,3),:)-d;
    v(i)=-dot(a,cross(b,c))/6;
end

% sum to find total volume
V=sum(v);

