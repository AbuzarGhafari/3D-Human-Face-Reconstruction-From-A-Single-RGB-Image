function averageLandmarks = computeAverage_3DFaces(k, Idx)
    
    load("mat_files/pathMatrix.mat");
    
    PM = [];
    
    for i=1:k 
        
        pth = pathMatrix(Idx(i)); 
        newPth = replace(pth, "3d_dataset_normalized", "300W-3D/3d_dataset_gt");
        
        pt3d = get3DOriginalLandmarks(newPth);                
        pt3d = normalizeTranslate3D(pt3d);
        pt3d = normalizeOrientation3D(pt3d);   

        PM = [PM; {pt3d}]; 
    end

    % Initialize an accumulator matrix with zeros
    accumulator = zeros(3, 68);

    % Number of cell arrays
    numCells = numel(PM);

    % Iterate through each cell to sum up the landmarks
    for i = 1:numCells
        % Add the current cell's landmarks to the accumulator
        % Convert to 'single' if necessary to ensure compatibility
        accumulator = accumulator + single(PM{i});
    end

    % Compute the average by dividing the accumulator by the number of cells
    averageLandmarks = accumulator / numCells;

end

