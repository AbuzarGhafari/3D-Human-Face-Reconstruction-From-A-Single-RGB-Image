function filteredDataset = filterKdTreeDatasetByIndices(dataset, indicesToRemove)
    % Number of rows in the dataset
    numRows = size(dataset, 1);
    
    % Create a logical index array with all true values
    includeRows = true(numRows, 1);
    
    % Set the indices to remove to false
    includeRows(indicesToRemove) = false;
    
    % Filter the dataset to keep only the rows that are true in includeRows
    filteredDataset = dataset(includeRows, :);
end
