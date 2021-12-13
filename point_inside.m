function [inside, coord] = point_inside(orig, point, faces, vertcies)
    % point with lightness axis last
    %Find the minmum and maxmum L* in each triangle
    
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
    
    % find vectors for two edges sharing vert0
    edge1 = vert1-vert0;    
    edge2 = vert2-vert0;
    
    % and the vector to the origin
    o  = orig -vert0;       
    
    % pre-calculate the cross products outside the inner loop
    e2e1 = cross(edge2, edge1, 2);
    e2o = cross(edge2, o, 2);
    oe1 = cross(o, edge1, 2);
    
    % and the one determinant which does not involve 'dir'
    e2oe1 = sum(edge2.*oe1, 2);
    
    dir= (point - orig)';
    
    idet = 1./(e2e1*dir); % denominator for all calculations
    u = e2o*dir.*idet;   % 1st barycentric coordinate
    v = oe1*dir.*idet;   % 2nd barycentric coordinate
    t = e2oe1.*idet;     % 'position on the line' coordinate
    
    %Find the tiles for which the ray passes within their edges
    %The triangle perimiter is defined by edges u=0, v=0 and u+v=1
    %plus the addition of a tolerance to deal with round-off errors
    ix= u>=0 & v>=0 & u+v<=1 & t>=0 & t<=1;
    %If no tile was found, add some tolerance and try again.
    if (sum(ix)==0)
        ix= u>=-0.001 & v>=-0.001& u+v<=1.001 & t>=0 & t<=1;
    end
    num_int = sum(ix);
    inside = mod(sum(ix), 2) == 0;
    if inside == 0
        coord = orig + t(ix) * dir';
    else
        coord = [];
    end
end