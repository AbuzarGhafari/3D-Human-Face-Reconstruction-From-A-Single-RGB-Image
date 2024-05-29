function f = objfunLocal(x,optim,rootP2D)
%function f = objfunLocal(x,optimStruct,angleAZ,angleEL,noiseMM)
%% local Objective functions
pos_curr    = optim.coeffs_Pos(:,1:optim.nrOfPrinComps) * x' + optim.meanVec_Pos;

%% Prior pose term
e_pose      = computePrior_local(optim.localModelPosePrior_Pos',pos_curr,optim.wtPoserep,optim.jointWeights,3,optim.expMPrior);
e_pose      = e_pose/sqrt(numel(e_pose));
%% control term
est3d       = pos_curr;
est3d       = reshape(est3d,3,[]);

R           = rotmatrix(optim.camMtx(1),'y');
sc          = [optim.camMtx(2) 0 0;0 optim.camMtx(2) 0;0 0 optim.camMtx(2)];
est3d       = sc*R*est3d;

est2d       = est3d(1:2,:);
est2d       = est2d + repmat(rootP2D,1,size(est2d,2));
est2d       = reshape(est2d,[],1);
e_control   = optim.estP2D(optim.cJidx2) - est2d(optim.cJidx2);
e_control   = reshape(e_control,2,numel(e_control)/2);
e_control   = sqrt(sum(e_control.^2));
e_control   = reshape(e_control,[],1);
e_control   = e_control /sqrt( numel(e_control)); %

%% Limb Length term
for k = 1:length(optim.limlenIdx)
    %limlen(k,1) = abs(sum(pos_curr(optim.limlenIdx(k,1:3)) - pos_curr(optim.limlenIdx(k,4:6))));
    %limlen(k,1) = sum(abs(pos_curr(optim.limlenIdx(k,1:3)) - pos_curr(optim.limlenIdx(k,4:6))));
    limlen(k,1) = sqrt(sum((pos_curr(optim.limlenIdx(k,1:3)) - pos_curr(optim.limlenIdx(k,4:6))).^2));
end
e_limb     = optim.limlen - limlen(:,ones(1,numel(optim.wtPose)));
e_limb     = reshape(e_limb,[],1);
e_limb     = sqrt(e_limb.^2);
e_limb     = e_limb/sqrt(numel(e_limb));

%% Function return vales --------------------------------------------------
f = [optim.w_pose        * e_pose;...
    optim.w_control      * e_control;...
    %optim.w_pose2D       * e_pose2D;...
    optim.w_limb         * e_limb...
    ];
end