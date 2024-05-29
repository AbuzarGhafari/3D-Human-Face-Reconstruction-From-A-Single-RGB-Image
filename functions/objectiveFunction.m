function err = objectiveFunction(params, landmarks3D, landmarks2D)
    % Unpack transformation parameters
    % Assuming params = [rotation angles, translation, scale]
    rotAngles = params(1:3);
    translation = params(4:5);
    scale = params(6);
    
    % Apply rotation
    R = eul2rotm(rotAngles); % Convert Euler angles to rotation matrix
    landmarks3D = R * landmarks3D;
        
    % Apply Scale 
    landmarks3D = landmarks3D * scale;
    
    % Apply translation 
    T = [translation, 0];
    R = eye(3);     
    P = [R, T'];     
    points = [landmarks3D; ones(1, 68)];
    landmarks3D = P * points;
        
    pt2d = projectFace3D(landmarks3D', 'x', 0);
    
    % Compute error
    err = pt2d' - landmarks2D;
    err = err(:); % Flatten to make it a vector
end

