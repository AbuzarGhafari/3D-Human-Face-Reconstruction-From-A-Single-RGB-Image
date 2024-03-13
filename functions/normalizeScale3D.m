function [rescaledLandmarks] = normalizeScale3D(data)
  
 
    OldMin = min(data, [], 'all');
    OldMax = max(data, [], 'all');
 
    NewMin = -100;
    NewMax = 100;
 
    rescaledLandmarks = ((data - OldMin) / (OldMax - OldMin)) * (NewMax - NewMin) + NewMin;


end

