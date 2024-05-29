function draw3DFaceOnly(pt3d, color)

    hold on;

    % face
    draw3DLine(pt3d, 1, 17, color);

    % Left Eye Brow
    draw3DLine(pt3d, 18, 22, color);
    % Right Eye Brow
    draw3DLine(pt3d, 23, 27, color);

    % Nose 
    draw3DLine(pt3d, 28, 36, color);

    % Left Eye
    draw3DLineCircle(pt3d, 37, 42, color);
    % Right Eye
    draw3DLineCircle(pt3d, 43, 48, color);
    
    left_eye = pt3d(:, 37: 42);
    left_eye_mean = mean(left_eye');
    right_eye = pt3d(:, 43: 48);
    right_eye_mean = mean(right_eye');
    
    % Lips
    draw3DLineCircle(pt3d, 49, 68, color);
    
    grid off;
    axis off;
    
end

