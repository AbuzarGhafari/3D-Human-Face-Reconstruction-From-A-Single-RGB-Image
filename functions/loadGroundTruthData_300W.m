function [sample_2d_gt, sample_3d_gt] = loadGroundTruthData_300W(sample_file)


    % Load 2D Data
    
    % List of directories
    directories = {'AFW', ...
                   'HELEN', ...
                   'IBUG', ...
                   'LFPW'};
    directory = '';

    % File name to look for
    fileName = sample_file;

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
    end

    M = pt2d;
   
    % Reflection matrix for reflecting around the x-axis
    Rx = [1, 0; 0, -1];
    % Perform the reflection
    M = Rx * M;
    % Translation Normalization
    sample_2d_gt = normalizeTranslate2D(M);
    
    sample_2d_gt = pt2d;
    
    % Load 3D Data    
    pt3d = get3DOriginalLandmarks(join(['dataset/300W-3D/3d_dataset_gt/' directory '/' sample_file], ''));
    sample_3d_gt = pt3d;
    
    
    sample_3d_gt = normalizeTranslate3D(sample_3d_gt);
    sample_3d_gt = normalizeOrientation3D(sample_3d_gt); 
    
    
end

