function compareNearestNeighbours(fileIndex)

    load("mat_files/kd_tree_data.mat");
    load("mat_files/pathMatrix.mat");
    load('model/Model_Shape_Sim.mat');
    
    Mdl = KDTreeSearcher(kdtree);

    fileNames = getDatasetFiles("dataset/AFLW2000/2D_dataset_normalized/"); 
       
%     numel(fileNames)
%     for fileIndex = start_index:end_index

    fprintf("Sample Image Index: %d\n", fileIndex);

    [pathstr, file_name, ext] = fileparts(fileNames{fileIndex});

    errors = [];

    errors_p = [];

    % [Idx, D, gt_path] = getNearestNeighbours(sub_dir, fileIndex, k);

    load(join(["dataset/AFLW2000/2D_dataset_normalized/", fileNames{fileIndex}], '')); 

    Y = M(:)';

    gt_path = join(["dataset/AFLW2000/3d_dataset_gt/", fileNames{fileIndex}], '');       
    load(gt_path);            
    gt_pt3d = pt3d_68;

    % Reflection matrix for reflecting around the x-axis
    Rx = [1, 0, 0; 0, -1, 0; 0, 0, -1]; 

    % Perform the reflection
    % pt3d = Rx * pt3d;
    gt_pt3d = Rx * gt_pt3d;
    
    % Reflect around y-axis
    gt_pt3d(1, :) = -gt_pt3d(1, :); 

    %gt_pt3d = pt3d;    
    gt_pt3d = normalizeTranslate3D(gt_pt3d);
    gt_pt3d = normalizeOrientation3D(gt_pt3d);  
    % gt_pt3d = normalizeScale3D(gt_pt3d);     
    % gt_pt3d = normalizeTranslate3D(gt_pt3d); 

    averageLandmarksArr = [];
    gt_pt3dArr = [];

    fprintf("Finding Nearest Neighbours:\n");
    k_s = [];
    k_sc = [];
 
    for i=5:9

        k = 2^i;
        k_s = [k_s, k];
        k_sc = [k_sc, {k}];

        fprintf("K: %d\n", k);

        [Idx, D] = knnsearch(Mdl, Y, 'K', k);

        averageLandmarks = computeAverage_3DFaces(k, Idx, pathMatrix);          

        averageLandmarksArr = [averageLandmarksArr, {averageLandmarks}];
        
        gt_pt3dArr = [gt_pt3dArr, {gt_pt3d}];

        [errPrJnts, errPrFr, errPrAllFr] = H_errorHumanEva(averageLandmarks, gt_pt3d);        

        errors = [errors, {errPrAllFr}];            
        
        errors_p = [errors_p, errPrAllFr];

    end

    fprintf("Saving .mat file..\n");        
    summary = [k_sc' averageLandmarksArr' gt_pt3dArr' errors'];        
    sample_path = join(["results/3D_AVG_GT_Compare/AFLW2000/", file_name, ".mat"], '');
    save(sample_path,"summary");   
    
    

    % ==============================================================
    fprintf("Generating Image..\n");
    fig = figure('Name', gt_path, 'Visible', 'off'); % 
    figWidth = 1100;
    figHeight = 500;
    set(fig, 'Position', [100, 100, figWidth, figHeight]);

    subplot(1, 2, 1);
    plot(k_s, errors_p,'--rs','LineWidth',2,...
                   'MarkerEdgeColor','k',...
                   'MarkerFaceColor','g',...
                   'MarkerSize',8)

    xlabel('k');
    ylabel('Errors');
    title('Errors vs. k');
    grid on; 

    subplot(1, 2, 2);

    % black = GT, red = Avg. NN
    compare3DFace(gt_pt3d, averageLandmarks, "comparison");

    sample_path = join(["results/3D_AVG_GT_Compare/AFLW2000/", file_name, ".png"], '');
    exportgraphics(fig, sample_path, 'Resolution', 300);  

    
    
    
    fprintf("Completed.\n");
    return;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    % ==============================================================
     
    fig = figure('Name', 'Errors'); 
    figWidth = 1600;
    figHeight = 1050;
    set(fig, 'Position', [50, 50, figWidth, figHeight]);

    for i=2:numel(overall_errors(1,:))

        ER = overall_errors(:, i);

        subplot(3,3,i-1);

        plot(ER,'o', ...
            'LineWidth',1,...
            'MarkerSize',5,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor',[0.85,0.85,0.75]);

        hold on;
        
        [r c] = size(ER);
        x = ceil(r/2);
        
        plot(x, mean(ER),'s', ...
            'LineWidth',2,...
            'MarkerSize',8,...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor',[0.85,0.5,0.75]);

        xlabel(join(['k = ', num2str(2^i), ' NN'], ''));
        ylabel("Error")

        
        avg_error = join(["Avg. Error ", num2str(mean(ER))], '');
        x = ceil(r/3);
        
        text(x, max(ER), avg_error,'Color','red','FontSize',12);
        
    end
 
    sample_path = join(["3D_AVG_GT_Compare/AFLW2000/errors.png"], '');
    exportgraphics(fig, sample_path, 'Resolution', 300);


end

