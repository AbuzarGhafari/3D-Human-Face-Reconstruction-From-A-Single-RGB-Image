function [pt3d] = get3DOriginalLandmarks(path) 
            
    load('model/Model_Shape_Sim.mat');
    
    load(path);    

    pt3d = Fitted_Face(:, keypoints);        
    
end

