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
    
    
    
    % find the triangles that have the possiplity of intersecting with the
    % line segment
    Max_L=max(max(vertcies(faces(:,1),3),vertcies(faces(:,2),3)),vertcies(faces(:,3),3));
    Min_L=min(min(vertcies(faces(:,1),3),vertcies(faces(:,2),3)),vertcies(faces(:,3),3));
    
    Max_a=max(max(vertcies(faces(:,1),1),vertcies(faces(:,2),1)),vertcies(faces(:,3),1));
    Min_a=min(min(vertcies(faces(:,1),1),vertcies(faces(:,2),1)),vertcies(faces(:,3),1));
    
    Max_b=max(max(vertcies(faces(:,1),2),vertcies(faces(:,2),2)),vertcies(faces(:,3),2));
    Min_b=min(min(vertcies(faces(:,1),2),vertcies(faces(:,2),2)),vertcies(faces(:,3),2));
    
    IX=max(orig(3),point(3))>=Min_L&min(orig(3),point(3))<=Max_L;
    IX=IX&max(orig(1),point(1))>=Min_a&min(orig(1),point(1))<=Max_a;
    IX=find(IX&max(orig(2),point(2))>=Min_b&min(orig(2),point(2))<=Max_b);
    
    vert0=vertcies(faces(IX,1),:);
    vert1=vertcies(faces(IX,2),:);
    vert2=vertcies(faces(IX,3),:);
    
    % 2 edges of the face from V0
    edge1 = vert1-vert0;    
    edge2 = vert2-vert0;
    
    % vector from the origin point and V0
    o  = orig -vert0;
    
    % Calculate the direction of the line segment
    dir= (point - orig)';
    
    % pre-calculate the cross products
    e2e1 = cross(edge2, edge1, 2);
    e2o = cross(edge2, o, 2);
    oe1 = cross(o, edge1, 2);
    
    % the calculation that don't reqire the dir
    e2oe1 = sum(edge2.*oe1, 2);
    
    idet = 1./(e2e1*dir); % denominator for all calculations
    u = e2o*dir.*idet;   % 1st barycentric coordinate
    v = oe1*dir.*idet;   % 2nd barycentric coordinate
    t = e2oe1.*idet;     % 'position on the line' coordinate
    
    % find the intersections that lie inside the face (u>=0 & v>=0 &
    % u+v<=1)
    % and between the line segment end points (t>=0 & t<=1)
    ix= u>=0 & v>=0 & u+v<=1 & t>=0 & t<=1;
    %If no intersection found, add some tolerance and try again.
    if (sum(ix)==0)
        ix= u>=-0.001 & v>=-0.001& u+v<=1.001 & t>=0 & t<=1;
    end
    % If the number of intersections is even that meeans the test point is
    % inside the gamut surface
    num_int = sum(ix);
    inside = mod(sum(ix), 2) == 0;
    % return the intersection points with the gamut surface
    if sum(ix) > 0
        coord = orig + t(ix) * dir';
    else
        coord = [];
    end
end