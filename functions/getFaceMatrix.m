function [faceVertices] = getFaceMatrix(pt3d)

    x = pt3d(1,:);
    y = pt3d(2,:);
    z = pt3d(3,:);
    faceVertices = [x; y; z]';

end

