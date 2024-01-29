function [projections_2d_data] = perspectiveProjection(pt3d)
    % Apply Perspective Projection on Face 3D Points
    
    global directions ...
            angles ...
            landmarks_count ...
            face_midpoint_index;
         
    % 0 1 Normalize Data
    pt3d = zeroOneNormalize3D(pt3d);
    
    translation = [-pt3d(1, face_midpoint_index); ...
                    -pt3d(2, face_midpoint_index); ...
                    -pt3d(3, face_midpoint_index)];
     
    projections_2d_data = [];

    for direction = 1:numel(directions)   

        data2d = [];

        for angle = 1:numel(angles)

            pt2d = [];

            for index = 1:landmarks_count

                point_3d = [pt3d(1, index), pt3d(2, index), pt3d(3, index), 1];

                point_2d = conv3Dto2D(point_3d, angles(angle), directions(direction), translation);
                
                pt2d = [pt2d, [point_2d(1); point_2d(2)]];        

            end
            
            
            % 0 1 Normalize Data
            pt2d = zeroOneNormalize2D(pt2d);

            data2d = [data2d; {pt2d}];
            


        end 

        projections_2d_data = [projections_2d_data, data2d];

    end
end

