function [yaw, pitch, roll, yaw_class, pitch_class, roll_class] = get_face_angles_and_classify(matFile)
    % Load the .mat file
    data = load(matFile);
    
    % Extract pose parameters (yaw, pitch, roll)
    poseParams = data.Pose_Para(1, :);
    yaw = rad2deg(poseParams(2));
    pitch = rad2deg(poseParams(3));
    roll = rad2deg(poseParams(4));

    % Classify the angles
    yaw_class = classify_angle(yaw);
    pitch_class = classify_angle(pitch);
    roll_class = classify_angle(roll);
end