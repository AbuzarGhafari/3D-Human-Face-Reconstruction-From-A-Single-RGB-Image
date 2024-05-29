function [sample_2d_gt, sample_3d_gt, yaw_class, yaw_class_id] = loadGroundTruthData(sample_file)

    % Load 2D Data
    load(join(["dataset/AFLW2000/2D_dataset_gt/" sample_file], ''));    
   
    % Reflection matrix for reflecting around the x-axis
    Rx = [1, 0; 0, -1];
    % Perform the reflection
    M = Rx * M;
    % Translation Normalization
    sample_2d_gt = normalizeTranslate2D(M);
    
    % Load 3D Data
    load(join(["dataset/AFLW2000/3d_dataset_gt/" sample_file], ''));

    sample_3d_gt = pt3d_68;
    sample_3d_gt(2, :) = -sample_3d_gt(2, :); 

    sample_3d_gt = normalizeTranslate3D(sample_3d_gt);
    sample_3d_gt = normalizeOrientation3D(sample_3d_gt); 
    
    % Get Yaw Angle
    poseParams = Pose_Para(1, :);
    yaw = rad2deg(poseParams(2));
    [yaw_class, yaw_class_id] = classify_angle(yaw);
    
%     file = join(["dataset/AFLW2000/3d_dataset_gt/" fileNames{fileIndex}], '');
%     
%     [yaw, pitch, roll, yaw_class, pitch_class, roll_class] = get_face_angles_and_classify(file);
    
end

