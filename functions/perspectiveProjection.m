function [projections_2d_data] = perspectiveProjection(pt3d)
    % Apply Perspective Projection on Face 3D Points
    
    global directions ...
            angles ...
            landmarks_count ...
            face_midpoint_index;        
    
    x = pt3d(1,:);
    y = pt3d(2,:);
    z = pt3d(3,:);
    faceVertices = [x; y; z]';
    
    translation = [-pt3d(1, face_midpoint_index); ...
                    -pt3d(2, face_midpoint_index); ...
                    -pt3d(3, face_midpoint_index)];
     
    projections_2d_data = [];

    for direction = 1:numel(directions)   

        data2d = [];
        
%         if (directions(direction) == 'y')
%             angles = y_angles;
%         elseif (directions(direction) == 'x')
%             angles = x_angles;
%         end

        for angle = 1:numel(angles)

            pt2d = [];

%             for index = 1:landmarks_count
% 
%                 point_3d = [pt3d(1, index), pt3d(2, index), pt3d(3, index), 1];
%                 
%                 point_2d = conv3Dto2D(point_3d, angles(angle), directions(direction), translation);
%                 
%                 pt2d = [pt2d, [point_2d(1); point_2d(2)]];        
% 
%             end
            if (directions(direction) == 'y') && (angles(angle) <= 90 && angles(angle) >= -90) 
                pt2d = projectFace3D(faceVertices, directions(direction), angles(angle));
            elseif (directions(direction) == 'x') && (angles(angle) <= 45 && angles(angle) >= -45) 
                pt2d = projectFace3D(faceVertices, directions(direction), angles(angle));
            end
                    
            if ~isempty(pt2d) 
                % 0 1 Normalize Data
                pt2d = zeroOneNormalize2D(pt2d')';        
            end
             
            
            
            data2d = [data2d; {pt2d}];            

        end 

        projections_2d_data = [projections_2d_data, data2d];

    end
end

