function draw3DFaceColor(pt3d, color)


%     figure('Name',windowTitle); 

    hold on;

    % face
    draw3DLine(pt3d, 1, 17, color);

    % Left Eye Brow
    draw3DLine(pt3d, 18, 22, color);
    % Right Eye Brow
    draw3DLine(pt3d, 23, 27, color);

    % Nose 
    draw3DLine(pt3d, 28, 36, color);

%     nose_index = 31;
%     scatter3(pt3d(1,nose_index),...
%                 pt3d(2,nose_index),...
%                 pt3d(3,nose_index),...
%                 'MarkerEdgeColor',"r", ...
%                 'MarkerFaceColor',"k",...
%                 'LineWidth',1);

    % Left Eye
    draw3DLineCircle(pt3d, 37, 42, color);
    % Right Eye
    draw3DLineCircle(pt3d, 43, 48, color);
    
    left_eye = pt3d(:, 37: 42);
    left_eye_mean = mean(left_eye');
    right_eye = pt3d(:, 43: 48);
    right_eye_mean = mean(right_eye');
    
    
    scatter3(left_eye_mean(1),...
                left_eye_mean(2),...
                left_eye_mean(3),...
                'MarkerEdgeColor',"k", ...
                'MarkerFaceColor',"k",...
                'LineWidth',1);

            
    scatter3(right_eye_mean(1),...
                right_eye_mean(2),...
                right_eye_mean(3),...
                'MarkerEdgeColor',"k", ...
                'MarkerFaceColor',"k",...
                'LineWidth',1);

    % Lips
    draw3DLineCircle(pt3d, 49, 68, color);
    
%     scatter3(pt3d(1,:),...
%                 pt3d(2,:),...
%                 pt3d(3,:),...
%                 'MarkerEdgeColor',"r", ...
%                 'MarkerFaceColor',"k",...
%                 'LineWidth',0.5);


    grid off;
    hold off; 
    axis off;
    
end

