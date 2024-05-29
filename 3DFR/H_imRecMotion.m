function [optmSt, quatrecFrame] = H_imRecMotion(data,knnFrame,PosIm,counter,optmSt,projMtx,energy,missingPositions,randMark,varargin)
%% This function is used for the purpose of motion reconstruction
%
if(isfield(data,'samdb'))
    nrOfFrames = data.samdb.nrOfFrames;
else
    nrOfFrames = data.nrOfFrames;
end
numOfFrames  = 1;
quatrecFrame = zeros(93,numOfFrames);
optmSt.estimatedPositions = PosIm;
optmSt.limbLengths_query = H_getLimbLengths(optmSt.estimatedPositions,missingPositions,randMark);

%%
lb = []; ub = [];
% counter = ithFrame - otherOP.startFrame + 1;
% fprintf('\b\b\b%5i (%5i  /%5i)',ithFrame,counter,otherOP.endFrame - otherOP.startFrame + 1);

localModelPosePrior        = cast(knnFrame','double'); % quat data
[optmSt.coeffs,score]      = princomp2(localModelPosePrior);
optmSt.meanVec             = mean(localModelPosePrior)';
optmSt.meanVecPosePrior    = optmSt.meanVec;
covMatPosePrior            = computeCovMat(localModelPosePrior(:,:),optmSt.nrOfSVPosePriorP);
%covMatPosePrior           = computeCovMat(localModelPosePrior,otherOP.nrOfSVPosePrior);
optmSt.invCovMatPosePrior  = inv(covMatPosePrior);
%__________________________________________________________________________
%
% localModelPosePrior_Pos             = cast(data.pos(:,nnidxPos)','double');
% [optimStruct.coeffs_Pos,score_Pos]  = princomp2(localModelPosePrior_Pos);
% optimStruct.meanVec_Pos             = mean(localModelPosePrior_Pos)';
% optimStruct.meanVecPosePrior_Pos 	  = optimStruct.meanVec_Pos(optimStruct.controlIDX.pos);
% covMatPosePrior_Pos                 = computeCovMat(localModelPosePrior_Pos(:,optimStruct.controlIDX.pos),otherOP.nrOfSVPosePrior_Pos);
% optimStruct.invCovMatPosePrior_Pos  = inv(covMatPosePrior_Pos);

% % % localModelPosePrior_Pos        = cast(data.pos(:,nnidxPos)','double'); % positional data
% % % [optmSt.coeffs_Pos,score_Pos]  = princomp2(localModelPosePrior_Pos);
% % % optmSt.meanVec_Pos             = mean(localModelPosePrior_Pos)';
% % % covMatPosePrior_Pos            = computeCovMat(localModelPosePrior_Pos,otherOP.nrOfSVPosePriorP);
% % % optmSt.invCovMatPosePrior_Pos  = inv(covMatPosePrior_Pos);
% % % %__________________________________________________________________________

if counter > 1
    startValue      = (optmSt.coeffs(:,1:optmSt.nrOfPrinComps) \ (optmSt.recFramePrev(:,numOfFrames) - optmSt.meanVec))';
else
    startValue       = score(1,1:optmSt.nrOfPrinComps);
    %%%% startValue       = mean(localModelPosePrior ,2);
end
%%
% optimization -------------------------------------
X = lsqnonlin(@(x) objfunLocal(x,optmSt,energy,missingPositions,randMark),startValue,lb,ub,optmSt.optLSQ);
quatrecFrame(:,numOfFrames) = optmSt.coeffs(:,1:optmSt.nrOfPrinComps) * X' + optmSt.meanVec;
%%%%%%mrec = buildMotFromRotData(quatrecFrame(:,numOfFrames),optmSt.skel,optmSt.dofs);

% rtData.rootPosDelta      = data.deltaRootPos(:,nnidxPos);
% rtData.rootOriDelta      = data.deltaRootOri(:,nnidxPos);
end

function f = objfunLocal(x,optmSt,energy,missingPositions,randMark)
%function f = objfunLocal(x,optimStruct,angleAZ,angleEL,noiseMM)
%% local Objective functions
pos_curr   = optmSt.coeffs(:,1:optmSt.nrOfPrinComps) * x' + optmSt.meanVec;
if(strcmp(energy, 'all'))
    %% pose adjustment term
    diffVec_Pos = pos_curr - optmSt.meanVec;
    e_pose = diffVec_Pos' * optmSt.invCovMatPosePrior * diffVec_Pos;
    e_pose = e_pose / (2*31);
    %e_pose = e_pose / sqrt(numel(diffVec_Pos));
    
    %% control term -----------------------------------------------------------
    pos_curr_red = pos_curr;
    pos_curr_red(missingPositions,:) = [];
    e_control   = sqrt((optmSt.estimatedPositions - pos_curr_red).^2);
    %e_control   = optmSt.estimatedPositions - pos_curr_red;
    %%%e_control   = e_control / sqrt(numel(e_control));
    
    %% smoothness term --------------------------------------------------------
    if (~isempty(optmSt.posLastLast) || ~isempty(optmSt.thirdLast))
        e_smoothness    = pos_curr + optmSt.summand;
    else
        e_smoothness    = zeros(size(pos_curr));
    end
    %e_smoothness = e_smoothness / sqrt(numel(e_smoothness));
    e_smoothness = e_smoothness / (2*31);
    
    %% Limb Lengths for anthropometric energy
    %e_limbLengths = S_getLimbLengths(pos_curr_red);
    % limbLengths_curr = S_getLimbLengths(pos_curr_red,missingPositions,randMark);
    % limbLengths_query = S_getLimbLengths(optmSt.estimatedPositions,missingPositions,randMark);
    
    limbLengths_curr = H_getLimbLengths(pos_curr_red,missingPositions,randMark);
    %limbLengths_query = H_getLimbLengths(optmSt.estimatedPositions,missingPositions,randMark);
    
    e_limbLengths = optmSt.limbLengths_query - limbLengths_curr;
    %e_limbLengths   = e_limbLengths / sqrt(numel(e_limbLengths));
    e_limbLengths   = e_limbLengths / (2*8);
    %% prior term -------------------------------------------------------------
    % % % diffVec = quat_curr(optmSt.priorIDX.quats) - optmSt.meanVecPosePrior;
    % % % e_prior = diffVec' * optmSt.invCovMatPosePrior * diffVec;
    % % % e_prior = (e_prior / numel(diffVec))^2;
    
    %% Function return vales --------------------------------------------------
end
if(strcmp(energy, 'smoothness'))
    f = [optmSt.w_smoothness   * e_smoothness];
elseif(strcmp(energy, 'smoothness&pose'))
    f = [optmSt.w_smoothness   * e_smoothness;...
        optmSt.w_pose         * e_pose];
elseif(strcmp(energy, 'all'))
    f = [optmSt.w_smoothness   * e_smoothness;...
        optmSt.w_limbs         * e_limbLengths;...
        optmSt.w_pose         * e_pose;...
        optmSt.w_control      * e_control];
elseif(strcmp(energy, 'PCA'))
    f = pos_curr;
end

%  figure(11)
%  clf
%  S_plot3DSkeleton(pos_curr);hold on
%  S_plot3DSkeleton(optmSt.estimatedPositions);
%  drawnow();
%  hold on
end

function covMat = computeCovMat(localModel,nrOfSVPosePrior)
%% Compute Covariance Matrix
[U,S,V]     = svd(localModel,'econ');
singVal     = diag(S);
totalNrOfSV = numel(singVal);
sigma       = sum(singVal(nrOfSVPosePrior+1:end).^2)/(totalNrOfSV-nrOfSVPosePrior);
S2          = diag([singVal(1:nrOfSVPosePrior)' sqrt(sigma)*ones(1,(totalNrOfSV-nrOfSVPosePrior))]);
covMat      = V*S2*V'/(totalNrOfSV-1);
end
