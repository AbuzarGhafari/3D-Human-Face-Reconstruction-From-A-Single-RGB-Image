function optimization(sample_file)

    global result_data;
    
    load(join(["results/pre-optimization/AFLW/", sample_file], ''));
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
    optmSt.tempoKNN         = 1024; 
    optmSt.k                = result_data.k;        % 256
    optmSt.nrOfSVPosePriorP = 40; 
    optmSt.nrOfPrinComps    = 40; 
    optmSt.temp             = 0;
    optmSt.w_control        = 2.0; % 0.8 
    optmSt.w_smoothness     = 0.5; % 0.5 
    optmSt.w_pose           = 0.1; % 0.4 
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
    save(join(["results/optimization-cm/AFLW/", sample_file], ''), "result");   
    
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
    pos_curr_red = projection3D(faceVertices', optim.dir, optim.angle, optim.p, optim.ex, optim.ey)';    
    
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
        
    result_data.op_error = compute_NME(optimized_3d, result_data.gt_3d, result_data.dir, result_data.angle, optim.p, optim.ex, optim.ey); 
    result_data.knn_avg_error = compute_NME(result_data.knn_avg_3d, result_data.gt_3d, result_data.dir, result_data.angle, 0, 0, 0);    
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

function [coeff, score, latent, tsquare] = princomp2(x,econFlag)
    %PRINCOMP Principal Components Analysis.
    %   COEFF = PRINCOMP(X) performs principal components analysis on the N-by-P
    %   data matrix X, and returns the principal component coefficients, also
    %   known as loadings.  Rows of X correspond to observations, columns to
    %   variables.  COEFF is a P-by-P matrix, each column containing coefficients
    %   for one principal component.  The columns are in order of decreasing
    %   component variance.
    %
    %   PRINCOMP centers X by subtracting off column means, but does not
    %   rescale the columns of X.  To perform PCA with standardized variables,
    %   i.e., based on correlations, use PRINCOMP(ZSCORE(X)).  To perform PCA
    %   directly on a covariance or correlation matrix, use PCACOV.
    %
    %   [COEFF, SCORE] = PRINCOMP(X) returns the principal component scores,
    %   i.e., the representation of X in the principal component space.  Rows
    %   of SCORE correspond to observations, columns to components.
    %
    %   [COEFF, SCORE, LATENT] = PRINCOMP(X) returns the principal component
    %   variances, i.e., the eigenvalues of the covariance matrix of X, in
    %   LATENT.
    %
    %   [COEFF, SCORE, LATENT, TSQUARED] = PRINCOMP(X) returns Hotelling's
    %   T-squared statistic for each observation in X.
    %
    %   When N <= P, SCORE(:,N:P) and LATENT(N:P) are necessarily zero, and the
    %   columns of COEFF(:,N:P) define directions that are orthogonal to X.
    %
    %   [...] = PRINCOMP(X,'econ') returns only the elements of LATENT that are
    %   not necessarily zero, i.e., when N <= P, only the first N-1, and the
    %   corresponding columns of COEFF and SCORE.  This can be significantly
    %   faster when P >> N.
    %
    %   See also BARTTEST, BIPLOT, CANONCORR, FACTORAN, PCACOV, PCARES, ROTATEFACTORS.

    %   References:
    %     [1] Jackson, J.E., A User's Guide to Principal Components,
    %         Wiley, 1988.
    %     [2] Jolliffe, I.T. Principal Component Analysis, 2nd ed.,
    %         Springer, 2002.
    %     [3] Krzanowski, W.J., Principles of Multivariate Analysis,
    %         Oxford University Press, 1988.
    %     [4] Seber, G.A.F., Multivariate Observations, Wiley, 1984.

    %   Copyright 1993-2006 The MathWorks, Inc.
    %   $Revision: 2.9.2.10 $  $Date: 2007/08/03 21:42:41 $

    % When X has more variables than observations, the default behavior is to
    % return all the pc's, even those that have zero variance.  When econFlag
    % is 'econ', those will not be returned.

    
    if nargin < 2, econFlag = 0; end

    [n,p] = size(x);
    if isempty(x)
        pOrZero = ~isequal(econFlag, 'econ') * p;
        coeff = zeros(p,pOrZero); 
        coeff(1:p+1:end) = 1;
        score = zeros(n,pOrZero);
        latent = zeros(pOrZero,1);
        tsquare = zeros(n,1);
        return
    end

    % Center X by subtracting off column means
    x0 = x - repmat(mean(x,1),n,1);
    r = min(n-1,p); % max possible rank of X0

    % The principal component coefficients are the eigenvectors of
    % S = X0'*X0./(n-1), but computed using SVD.
    [U,sigma,coeff] = svd(x0,econFlag); % put in 1/sqrt(n-1) later

    if nargout < 2
        % When econFlag is 'econ', only (n-1) components should be returned.
        % See comment below.
        if (n <= p) && isequal(econFlag, 'econ')
            coeff(:,n) = [];
        end

    else
        % Project X0 onto the principal component axes to get the scores.
        if n == 1 % sigma might have only 1 row
            sigma = sigma(1);
        else
            sigma = diag(sigma);
        end
        score = U .* repmat(sigma',n,1); % == x0*coeff
        sigma = sigma ./ sqrt(n-1);

        % When X has at least as many variables as observations, eigenvalues
        % n:p of S are exactly zero.
        if n <= p
            % When econFlag is 'econ', nothing corresponding to the zero
            % eigenvalues should be returned.  svd(,'econ') won't have
            % returned anything corresponding to components (n+1):p, so we
            % just have to cut off the n-th component.
            if isequal(econFlag, 'econ')
                sigma(n,:) = []; % make sure this shrinks as a column
                coeff(:,n) = [];
                score(:,n) = [];

            % Otherwise, set those eigenvalues and the corresponding scores to
            % exactly zero.  svd(,0) won't have returned columns of U
            % corresponding to components (n+1):p, need to fill those out.
            else
                sigma(n:p,1) = 0; % make sure this extends as a column
                score(:,n:p) = 0;
            end
        end

        % The variances of the pc's are the eigenvalues of S = X0'*X0./(n-1).
        latent = sigma.^2;

        % Hotelling's T-squared statistic is the sum of squares of the
        % standardized scores, i.e., Mahalanobis distances.  When X appears to
        % have column rank < r, ignore components that are orthogonal to the
        % data.
        if nargout == 4
            if n > 1
                q = sum(sigma > max(n,p).*eps(sigma(1)));
                if q < r
                    warning('stats:princomp:colRankDefX', ...
                            ['Columns of X are linearly dependent to within machine precision.\n' ...
                             'Using only the first %d components to compute TSQUARED.'],q);
                end
            else
                q = 0;
            end
            tsquare = (n-1) .* sum(U(:,1:q).^2,2); % == sum((score*diag(1./sigma)).^2,2)
        end
    end
    
end