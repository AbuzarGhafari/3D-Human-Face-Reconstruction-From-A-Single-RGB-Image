function [lastKMinDistances] = getNearestNeighbours(k, testImage)

    global dataset_path ...
        projected_dataset_path ...
        dataset_sub_directories ...
        angles ...
        directions;
 
    source_img_pt2d = testImage;

    dataset_3d_path = {};
    projection_2d_path = {};
    direction = {};
    angle = {};
    distance = [];
    
    count = 0;
    
    for sub_dir = 1:numel(dataset_sub_directories)
        
        % Load 2D Projected Dataset
        path = join([projected_dataset_path, dataset_sub_directories(sub_dir), "/"], '');

        fileNames = getDatasetFiles(path); 
        
        for file = 1:numel(fileNames)

            % Sample Image
            sample_name = cell2mat(fileNames(file));    
            projection_2d_sample_path = [projected_dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
            projection_2d_sample_path = join(projection_2d_sample_path, '');         
            load(projection_2d_sample_path);
            
            dataset_3d_sample_path = [dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
            dataset_3d_sample_path = join(dataset_3d_sample_path, '');         
            
            for direct = 1:numel(directions)

                data2d = projections_2d_data(:, direct);

                for p = 1:numel(data2d)
                    
                    disp(projection_2d_sample_path);
                    
                    count = count + 1;
                    
                    disp(count);

                    dataset_3d_path{end+1} = dataset_3d_sample_path;
                    
                    projection_2d_path{end+1} = projection_2d_sample_path;                    

                    direction{end+1} = directions(direct);
                    
                    angle{end+1} = angles(p);

                    dist = euclideanDistance2D(source_img_pt2d, data2d{p});

                    distance = [distance; dist];

                end  

            end
            
        end
          
    end    
    
    
    dataset_3d_path = dataset_3d_path';
    projection_2d_path = projection_2d_path';
    direction = direction';
    angle = angle';
    
    euclideanDistancesTable = table(dataset_3d_path, projection_2d_path, direction, angle , distance);

    % Sort the table by 'distances' column in ascending order
    sortedeuclideanDistancesTable= sortrows(euclideanDistancesTable, 'distance');

    % Get the last k rows (minimum distances)
    lastKMinDistances = sortedeuclideanDistancesTable(1:k, :);
    
    
end

