function [yaw_class, yaw_class_id] = findYawClassId(fileName)


    % Load 2D Data    
    % List of directories
    directories = {'AFW', ...
                   'HELEN', ...
                   'IBUG', ...
                   'LFPW'};
    directory = '';

    % Initialize a variable to track if the file has been loaded
    fileLoaded = false;

    % Loop through each directory
    for i = 1:length(directories)
        % Construct the full file path
        filePath = fullfile(join(["dataset/300W-3D/2D_dataset_gt/" directories{i}], '') , fileName);

        % Check if the file exists
        if exist(filePath, 'file') == 2
            % Load the file
            load(filePath);
            disp(['File loaded successfully from: ' directories{i}]);
            fileLoaded = true;
            directory = directories{i};
            break;  % Exit the loop once the file is found and loaded
        end
    end

    % Check if the file was not loaded
    if ~fileLoaded
        disp('File does not exist in any of the provided directories.');
        return;
    end
    
    % Get Yaw Angle
    poseParams = Pose_Para(1, :);
    yaw = rad2deg(poseParams(2));
    [yaw_class, yaw_class_id] = classify_angle(yaw);
    
    
    
end

