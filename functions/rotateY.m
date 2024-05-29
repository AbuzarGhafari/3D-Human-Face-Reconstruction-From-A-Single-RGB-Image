function rotatedPoints = rotateY(points, theta)
    % Create the rotation matrix around the Y axis
    R = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
    
    % Apply the rotation to the points
    % Assuming 'points' is a 3xN matrix
    rotatedPoints = R * points;
end