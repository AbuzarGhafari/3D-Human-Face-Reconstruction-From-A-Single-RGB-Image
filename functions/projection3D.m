function [projectedPoints] = projection3D(vertices, direction, angle)

    if direction == 'x'
        % Ensure the rotation angles are within the allowed ranges
        angle = max(min(angle, 90), -90);  % Clamp to [-90, 90] degrees
        % Convert degrees to radians
        angle = deg2rad(angle);
        % Rotation matrices
        R = [1, 0, 0; 0, cos(angle), -sin(angle); 0, sin(angle), cos(angle)];
    elseif direction == 'y'
        angle = max(min(angle, 180), -180); % Clamp to [-180, 180] degrees
        angle = deg2rad(angle);
        R = [cos(angle), 0, sin(angle); 0, 1, 0; -sin(angle), 0, cos(angle)];
    end
    
    projectionMatrix = [1, 0, 0; 0, 1, 0];    

%     % Apply rotations
    rotatedVertices =  (R * vertices);
    
    H = rotatedVertices;
    
% 
%     % Apply projection
    projectedPoints =  ( projectionMatrix * H)';
end