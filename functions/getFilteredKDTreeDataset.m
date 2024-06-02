function kdtree_chunk = getFilteredKDTreeDataset(pathMatrix, dataset_chunk, kdtree_chunk)

    indices = [];
    for fileIndex = 1:numel(dataset_chunk)    
        fprintf("%d, %s\n", fileIndex, dataset_chunk{fileIndex});
        indices = [indices; findFileIndexPathMatrix(pathMatrix, dataset_chunk{fileIndex})];
    end
    
    % Assuming your dataset is stored in kdtreeDataset
    kdtree_chunk = filterKdTreeDatasetByIndices(kdtree_chunk, indices);

end
