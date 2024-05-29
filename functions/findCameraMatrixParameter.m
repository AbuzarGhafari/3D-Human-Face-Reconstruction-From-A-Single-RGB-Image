function optimal_p = findCameraMatrixParameter(result)

N = 68; % Number of landmarks

landmarks_3D_gt = result.knn_avg_3d;

landmarks_2D_gt = result.gt_2d;

initial_p = 10.0; % Initial intrinsic matrix parameter (p)

% Optimization function
objective_func = @(p) projection_error(p, landmarks_3D_gt, landmarks_2D_gt, result.dir, result.angle);


% Optimize intrinsic matrix parameter p
optimal_p = fminsearch(objective_func, initial_p);

% Display results
fprintf('Optimal p: %.4f\n', optimal_p);

end

% Objective Function
function error = projection_error(p, landmarks_3D, landmarks_2D_gt, dir, angle)
    
    projected_points = projection3D(landmarks_3D', dir, angle, p, 1, 1)';    
                
    % Calculate the Euclidean error
    errors = vecnorm(projected_points - landmarks_2D_gt, 2, 2);
    
    error = mean(errors); % Mean projection error
    
%     fprintf("%f: %f\n", p, error);
end



% Projection Function
function projected_points = project_landmarks(landmarks_3D, intrinsic_matrix, projectionMatrix, R, t)
    % Apply rotations and translation
    rotated_vertices = (R * landmarks_3D' + t')';
    
    % Apply projection
    projected_vertices = projectionMatrix * rotated_vertices';
    projected_points_2D = (intrinsic_matrix * [projected_vertices; ones(1, size(projected_vertices, 2))])';
    
    % Keep only the 2D coordinates
    projected_points = projected_points_2D(:, 1:2);
end
