function compare3DFace(gt_pt3d, pt3d )



%     figure('Name',windowTitle); 

    hold on;

    % face
    draw3DLine(pt3d, 1, 17, 'red');

    % Left Eye Brow
    draw3DLine(pt3d, 18, 22, 'red');
    % Right Eye Brow
    draw3DLine(pt3d, 23, 27, 'red');

    % Nose 
    draw3DLine(pt3d, 28, 36, 'red');

    nose_index = 31;
%     scatter3(pt3d(1,nose_index),...
%                 pt3d(2,nose_index),...
%                 pt3d(3,nose_index),...
%                 'MarkerEdgeColor',"r", ...
%                 'MarkerFaceColor',"k",...
%                 'LineWidth',1);

    % Left Eye
    draw3DLineCircle(pt3d, 37, 42, 'red');
    % Right Eye
    draw3DLineCircle(pt3d, 43, 48, 'red');
    
    left_eye = pt3d(:, 37: 42);
    left_eye_mean = mean(left_eye');
    right_eye = pt3d(:, 43: 48);
    right_eye_mean = mean(right_eye');
    
    
    scatter3(left_eye_mean(1),...
                left_eye_mean(2),...
                left_eye_mean(3),...
                'MarkerEdgeColor',"r", ...
                'MarkerFaceColor',"r",...
                'LineWidth',1);

            
    scatter3(right_eye_mean(1),...
                right_eye_mean(2),...
                right_eye_mean(3),...
                'MarkerEdgeColor',"r", ...
                'MarkerFaceColor',"r",...
                'LineWidth',1);

    % Lips
    draw3DLineCircle(pt3d, 49, 68, 'red');
    
    
    
    
    %     ===========================================
    % face
    draw3DLine(gt_pt3d, 1, 17, 'black');

    % Left Eye Brow
    draw3DLine(gt_pt3d, 18, 22, 'black');
    % Right Eye Brow
    draw3DLine(gt_pt3d, 23, 27, 'black');

    % Nose 
    draw3DLine(gt_pt3d, 28, 36, 'black');

    nose_index = 31;
%     scatter3(gt_pt3d(1,nose_index),...
%                 gt_pt3d(2,nose_index),...
%                 gt_pt3d(3,nose_index),...
%                 'MarkerEdgeColor',"r", ...
%                 'MarkerFaceColor',"k",...
%                 'LineWidth',1);

    % Left Eye
    draw3DLineCircle(gt_pt3d, 37, 42, 'black');
    % Right Eye
    draw3DLineCircle(gt_pt3d, 43, 48, 'black');
    
    left_eye = gt_pt3d(:, 37: 42);
    left_eye_mean = mean(left_eye');
    right_eye = gt_pt3d(:, 43: 48);
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
    draw3DLineCircle(gt_pt3d, 49, 68, 'black');


    % Add a title to the plot
    title("Avg. & GT Compare 3D Faces");
    
%     legend('Avg. NN', 'GT'); % Add a legend

    grid on;
    hold off; 
    
end

