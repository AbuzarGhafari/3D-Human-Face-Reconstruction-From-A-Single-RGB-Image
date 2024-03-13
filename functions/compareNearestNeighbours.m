function compareNearestNeighbours(sub_dir, no_of_figs, no_of_examples) 
 
    global dataset_sub_directories;   

    load("kd_tree_data.mat");
    load("pathMatrix.mat");

    parent_dir = "2d_dataset/"; 
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path); 
    
    overall_errors = [];
    
    for fileIndex = 1:numel(fileNames)
        
        disp(fileIndex);
        
        file = cell2mat(fileNames(fileIndex));   
        
        [pathstr, file_name, ext] = fileparts(file);

        errors = [];

        for i=1:10

            k = 2^i;

            [Idx, D, gt_path] = getNearestNeighbours(sub_dir, fileIndex, k);

            averageLandmarks = computeAverage_3DFaces(k, Idx, pathMatrix);          
            
            pt3d = get3DOriginalLandmarks(gt_path);            

            gt_pt3d = pt3d;    
            gt_pt3d = normalizeTranslate3D(gt_pt3d);
            gt_pt3d = normalizeOrientation3D(gt_pt3d);  
            gt_pt3d = normalizeScale3D(gt_pt3d);     
            gt_pt3d = normalizeTranslate3D(gt_pt3d);               

            [errPrJnts, errPrFr, errPrAllFr] = H_errorHumanEva(averageLandmarks, gt_pt3d);        

            errors = [errors, errPrAllFr];

        end

        disp(gt_path);
        
        overall_errors = [overall_errors; errors];
        
        if fileIndex <= no_of_figs

            fig = figure('Name', gt_path, 'Visible', 'off');
            figWidth = 1100;
            figHeight = 500;
            set(fig, 'Position', [100, 100, figWidth, figHeight]);

            subplot(1, 2, 1);
            plot(errors,'--rs','LineWidth',2,...
                           'MarkerEdgeColor','k',...
                           'MarkerFaceColor','g',...
                           'MarkerSize',8)

            xlabel('k = 2^x');
            ylabel('Errors');
            title('Errors vs. k = 2^x');
            grid on; 

            subplot(1, 2, 2);

            % black = GT, red = Avg. NN
            compare3DFace(gt_pt3d, averageLandmarks);

            sample_path = join(["3D_AVG_GT_Compare/", dataset_sub_directories(sub_dir), "/", file_name, ".png"], '');
            exportgraphics(fig, sample_path, 'Resolution', 300);  
            
        end
        
        if fileIndex > no_of_examples
        
            disp("Closed.");
            return;

        end

    end 
    
    errors_path = join(["3D_AVG_GT_Compare/", dataset_sub_directories(sub_dir), "/overall_errors"], '');
    save(errors_path,"overall_errors");
    


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
 
    sample_path = join(["3D_AVG_GT_Compare/", dataset_sub_directories(sub_dir), "/", "errors", ".png"], '');
    exportgraphics(fig, sample_path, 'Resolution', 300);


end

