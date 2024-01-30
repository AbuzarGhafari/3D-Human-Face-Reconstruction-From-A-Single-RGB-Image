function [pt2d] = normalizeTranslate2D(pt2d)

    global face_midpoint_index ...
            landmarks_count;
    
    T = [-pt2d(1, face_midpoint_index); ...
                    -pt2d(2, face_midpoint_index)];
    R = eye(2); 
    
    P = [R, T];
    
    for index = 1:landmarks_count
        
        point_2d = [pt2d(1, index), pt2d(2, index), 1];

        translated_pt2d = P * point_2d';
        
        pt2d(1, index) = translated_pt2d(1);
        
        pt2d(2, index) = translated_pt2d(2); 
        
    end   
    
end

