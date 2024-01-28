function [pt3d] = normalizeTranslate3D(pt3d)

    global face_midpoint_index ...
            landmarks_count;
    
    T = [-pt3d(1, face_midpoint_index); ...
                    -pt3d(2, face_midpoint_index); ...
                    -pt3d(3, face_midpoint_index)]
    R = eye(3); 
    
    P = [R, T];
    
    for index = 1:landmarks_count
        
        point_3d = [pt3d(1, index), pt3d(2, index), pt3d(3, index), 1];

        translated_pt3d = P * point_3d';
        
        pt3d(1, index) = translated_pt3d(1);
        pt3d(2, index) = translated_pt3d(2);
        pt3d(3, index) = translated_pt3d(3);
        
    end   
    
end

