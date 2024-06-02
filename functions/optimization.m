function optimization(sample_file, load_path, save_path)

    global result_data;
    
    load(join([load_path, sample_file], ''));
    result_data = result;
    
    % Projection Matrix Parameters
    optmSt.dir              = result_data.dir;
    optmSt.angle            = result_data.angle;
    
    % NOT USED
    optmSt.p                = 1.5; % findCameraMatrixParameter(result_data);
    optmSt.ex               = 300;
    optmSt.ey               = 300;
    
    % Optimization Values : 0.8, 0.5, 0.4
    
    % Optimization-2 Values : 2.0, 0.5 not used, 0.4
    
    % Optimization-3 Values : 2.0, 0.5 not used, 0.1

    % optmSt Options
    optmSt.estimatedPositions = result_data.gt_2d;
%     optmSt.estimatedPositions = double(projection3D(result_data.knn_avg_3d, result_data.dir, result_data.angle)');
    optmSt.tempoKNN         = 1024; 
    optmSt.k                = result_data.k;        % 256
    optmSt.nrOfSVPosePriorP = 40; 
    optmSt.nrOfPrinComps    = 40; 
    optmSt.temp             = 0;
    optmSt.w_control        = 0.8; % 0.8 
    optmSt.w_smoothness     = 0.5; % 0.5 
    optmSt.w_pose           = 0.4; % 0.4 
    optmSt.posLast          = [];
    optmSt.posLastLast      = [];
    optmSt.thirdLast        = [];
    optmSt.optLSQ           = optimset( 'Display','none',...    % none|iter
        'MaxFunEvals',100000,... % 10000
        'MaxIter',100000,...     % 50000
        'TolFun', 1e-9,...
        'TolX', 1e-9,...
        'LargeScale','off',...
        'Algorithm','levenberg-marquardt'); 
    
    lb = []; 
    ub = [];
   
    localModelPosePrior        = cast(result_data.knnFrame,'double'); % quat data
    [optmSt.coeffs,score]      = princomp2(localModelPosePrior);
    optmSt.meanVec             = mean(localModelPosePrior)';
    optmSt.meanVecPosePrior    = optmSt.meanVec;
    covMatPosePrior            = computeCovMat(localModelPosePrior(:,:),optmSt.nrOfSVPosePriorP);
    optmSt.invCovMatPosePrior  = inv(covMatPosePrior);
    
    numOfFrames=68;
    
    startValue       = score(1, 1:optmSt.nrOfPrinComps);
     
    % optimization 
    X = lsqnonlin(@(x) objfunLocal(x, optmSt, localModelPosePrior),startValue,lb,ub,optmSt.optLSQ);
    quatrecFrame(:,numOfFrames) = optmSt.coeffs(:,1:optmSt.nrOfPrinComps) * X' + optmSt.meanVec;        
    
    result = result_data;
    save(join([save_path, sample_file], ''), "result");   
    
%     disp(result);
%     figure(12);clf;
%     draw3DFace(result.gt_3d, 'black');hold on;
%     draw3DFace(result.optimized_3d, 'black');drawnow();hold on;
  
    fprintf("Done.\n");
end
 


% local Objective functions
function f = objfunLocal(x, optim, localModelPosePrior) 

    global result_data;
    
    pos_curr    = optim.coeffs(:,1:optim.nrOfPrinComps) * x' + optim.meanVec;
    
    % pose adjustment term
    diffVec_Pos = pos_curr - optim.meanVec;
    e_pose = diffVec_Pos' * optim.invCovMatPosePrior * diffVec_Pos;    
    e_pose = e_pose / sqrt(numel(diffVec_Pos));
    
    % control term 
    pos_curr_red = pos_curr; 
    pos_curr_red = reshape(pos_curr_red,3,[]);
    
    faceVertices = [pos_curr_red(1,:); pos_curr_red(2,:); pos_curr_red(3,:)]';    
    pos_curr_red = projection3D(faceVertices', optim.dir, optim.angle)';    
    
    e_control   = sqrt((optim.estimatedPositions - pos_curr_red).^2);        
    e_control   = reshape(e_control,2,numel(e_control)/2);
    e_control   = sqrt(sum(e_control.^2));
    e_control   = reshape(e_control,[],1);
    e_control   = e_control /sqrt( numel(e_control)); 

    % Function return vales 
    f = [optim.w_pose * e_pose;...
        optim.w_control * e_control;...
        ];
    
    
    optimized_3d = reshape(pos_curr, 3, []);
    
%     [errPrJnts, errPrFr, errPrAllFr] = H_errorHumanEva(optimized_3d, result_data.gt_3d);    
    % result_data.op_error = errPrAllFr;    
        
    result_data.op_error = compute_NME(optimized_3d, result_data.gt_3d, result_data.dir, result_data.angle); 
    result_data.knn_avg_error = compute_NME(result_data.knn_avg_3d, result_data.gt_3d, result_data.dir, result_data.angle);    
    result_data.optimized_3d = optimized_3d;
        
%     figure(12);clf;
%     draw3DFace(result_data.gt_3d, 'black');hold on;
%     draw3DFace(result_data.optimized_3d, 'black');drawnow();hold on;
    
end

% Compute Covariance Matrix
function covMat = computeCovMat(localModel,nrOfSVPosePrior)    
    [U,S,V]     = svd(localModel,'econ');
    singVal     = diag(S);
    totalNrOfSV = numel(singVal);
    sigma       = sum(singVal(nrOfSVPosePrior+1:end).^2)/(totalNrOfSV-nrOfSVPosePrior);
    S2          = diag([singVal(1:nrOfSVPosePrior)' sqrt(sigma)*ones(1,(totalNrOfSV-nrOfSVPosePrior))]);
    covMat      = V*S2*V'/(totalNrOfSV-1);
end
