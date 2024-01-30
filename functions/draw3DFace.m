function draw3DFace(pt3d, windowTitle)

    % Translation Normalization
    pt3d = normalizeTranslate3D(pt3d);

%     figure('Name',windowTitle); 

    hold on;

    % face
    draw3DLine(pt3d, 1, 17, 'red');

    % Left Eye Brow
    draw3DLine(pt3d, 18, 22, 'black');
    % Right Eye Brow
    draw3DLine(pt3d, 23, 27, 'black');

    % Nose 
    draw3DLine(pt3d, 28, 36, 'blue');

    nose_index = 31;
    scatter3(pt3d(1,nose_index),...
                pt3d(2,nose_index),...
                pt3d(3,nose_index),...
                'MarkerEdgeColor',"r", ...
                'MarkerFaceColor',"k",...
                'LineWidth',1);

    % Left Eye
    draw3DLineCircle(pt3d, 37, 42, 'black');
    % Right Eye
    draw3DLineCircle(pt3d, 43, 48, 'black');

    % Lips
    draw3DLineCircle(pt3d, 49, 68, 'blue');


    % Add a title to the plot
    title('3D Face');

    grid on;
    hold off; 
    
end

