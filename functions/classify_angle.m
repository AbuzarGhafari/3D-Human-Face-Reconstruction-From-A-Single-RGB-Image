function [angle_class, angle_class_id ]= classify_angle(angle)
    % Classify angle into specific ranges
    abs_angle = abs(angle);
    if abs_angle >= 0 && abs_angle < 30
        angle_class = '0 to 30';
        angle_class_id = 1;
    elseif abs_angle >= 30 && abs_angle < 60
        angle_class = '30 to 60';
        angle_class_id = 2;
    elseif abs_angle >= 60 && abs_angle <= 90
        angle_class = '60 to 90';
        angle_class_id = 3;
    else
        angle_class = 'Out of Range';
        angle_class_id = -1;
    end
end