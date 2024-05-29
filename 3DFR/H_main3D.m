function res = H_main3D(tanInput, missingMarkers,dataset,hdm)
%% Add Path
addpath(genpath(fullfile('E:\0_MyWork\02-Journal-Articles\03-3D-Markers-Recovery\01-Code')));
%% input options
pathDB               = 'E:\0_MyWork\02-Journal-Articles\03-3D-Markers-Recovery\01-Code\Dataset\';
pathRes              = 'E:\0_MyWork\02-Journal-Articles\03-3D-Markers-Recovery\01-Code\Results\';
opts.dataset         = dataset;                                            % 'HDM05' or 'CMU'
opts.tanInput        = tanInput;                                           % 'boxing' or 'jumpTwist' or 'fig8' or 'jumping' or 'martialArts' or 'kicking' or 'salsa' or 'acrobatics'
opts.stepSize        = 3;
opts.energy          = 'all';                                              % 'all' or 'PCA'
opts.missingMarkers  = missingMarkers;                                     % 3 for 10% missing markers out of total 31 (6 for 20%), (9 for 30%)
opts.markerSelection = 'random';                                              % 'random', 'fix'
opts.tempInfo        = 'no';
HDM05                = hdm;
%% optmSt Options
optmSt.tempoKNN         = 1024;
optmSt.k                = 128; % 256
optmSt.nrOfSVPosePriorP = 65; % 65
optmSt.nrOfPrinComps    = 65; % 65
optmSt.temp             = 0;
optmSt.w_control        = 1.3;                             % 1.2   (1) 0.5, 1/512, 1.50
optmSt.w_smoothness     = 0.05;                            % 1/64 (1/512) 1/1024, 0.5, 1, 1/256
optmSt.w_pose           = 0.1;                             % 1/512   (1) 1.25, 0.5, 1/1024
optmSt.w_limbs          = 0.05;
optmSt.posLast          = [];
optmSt.posLastLast      = [];
optmSt.thirdLast        = [];
optmSt.optLSQ           = optimset( 'Display','none',...
    'MaxFunEvals',10000,...
    'MaxIter',50000,...
    'TolFun',0.0001,...
    'TolX',0.0001,...
    'LargeScale','off',...
    'Algorithm','levenberg-marquardt');
%% Load Database
if(strcmp(opts.dataset, 'HDM05'))
    dbFile = strcat(pathDB,'HDM05.mat');
    timeArray = 1;
elseif(strcmp(opts.dataset, 'CMU'))
    dbFile = strcat(pathDB,'CMU.mat');
    timeArray = 1;
elseif(strcmp(opts.dataset, 'CMU30'))
    dbFile = strcat(pathDB,'CMU_Comp_30.mat');
    %timeFile = strcat(pathDB,'dbTimeCMU30.mat');
    timeArray = 1;
%    load(timeFile);
elseif(strcmp(opts.dataset, 'CMU15'))
    dbFile = strcat(pathDB,'CMU_Comp_15.mat');
    timeArray = 1;
elseif(strcmp(opts.dataset, 'CMU60'))
    dbFile = strcat(pathDB,'CMU_Comp_60.mat');
    timeArray = 1;
elseif(strcmp(opts.dataset, 'CMU90'))
    dbFile = strcat(pathDB,'CMU_Comp_90.mat');
    timeArray = 1;
elseif(strcmp(opts.dataset, 'CMU120'))
    dbFile = strcat(pathDB,'CMU_Comp_120.mat');
    timeArray = 1;
end
disp('Loading database file !!');
load(dbFile);
if (dbFile)
end
disp('Database has been successfuly loaded. ');
db.pos          = double(db.pos);
db.quat         = [];
db.invRootRot   = [];
db.deltaRootOri = [];
db.deltaRootPos = [];
db.origRootOri  = [];
db.origRootPos  = [];
db.skels        = [];
%% Query Relevant
[opts.startQuery, opts.endQuery] = H_getinputQuery(db,opts.tanInput);
qSize     = opts.endQuery - opts.startQuery + 1;
query     = double(db.pos(:,opts.startQuery:opts.endQuery));
db.pos(:,opts.startQuery:opts.endQuery) = [];
db.nrOfFrames = db.nrOfFrames - qSize;
%% HDM05
if(strcmp(HDM05, 'yes'))
    clear db
    dbFile = strcat(pathDB,'db.mat');
    load(dbFile);
    db.pos          = double(db.pos);
    db.quat         = [];
    db.invRootRot   = [];
    db.deltaRootOri = [];
    db.deltaRootPos = [];
    db.origRootOri  = [];
    db.origRootPos  = [];
    db.skels        = [];
end
%% Parameters Information
% % %     startQuery = 1;                                              %(30495 (31325 cmu30)for basketball motion)(196282 (333996 cmu30)for boxing motion)
% % %     endQuery  = 2000;                                           %(30532 (31362 cmu30)for basketball motion)(197681 (335395 cmu30)for boxing motion)
numberOfJoints = 9;                                         %Set to 'false' when working for all possible combinations and to draw results of AED
errorRecosResults = 'True';
timeReconsResults = 'False';
missingPart = 'Legs';                                   % 'Legs' 'Arms' 'Right part' or 'Left part'
% janBauman(lArm rArm bothArms lLeg rLeg bothLegs)
% 6(80%SR),9(70%SR),12(60%SR),15(50%SR),18(40%SR)
missingType = 'RANDOM';                                      % 'FIXED' or 'RANDOM'

%% Reconstruct frames
opts.iterations = 1;
res.randMark = cell(opts.iterations,1);
res.recFrame = cell(opts.iterations,1);
res.errPrFr  = cell(opts.iterations,1);
res.RMSE     = zeros(opts.iterations,1);

% res_CMU30_6_enLimb.wControl=[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.4, 1.6 1.8 2.0]';
% res_CMU30_6_enLimb.wPose =[0.02, 0.04, 0.06, 0.08, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2, 0.24, 0.28, 0.32, 0.36 0.4]';
% res_CMU30_6_enLimb.wSmooth =[0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]';
% res_CMU30_6_enLimb.wLimb =[0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1]';
for i=1:opts.iterations
    %optmSt.w_limbs        = res_CMU30_6.wLimb(i,1); 
    tic
    fprintf('Running Iteration No: %d \n',i);
    [resTemp, opts, optmSt]       = H_tanRecMissing(db,query, optmSt, timeArray, opts);
    res.randMark{i,1} = opts.randMark;
    res.recFrame{i,1} = resTemp.recFrame;
    res.knnFrame{i,1} = resTemp.knnTemp;
    res.errPrFr{i,1}  = resTemp.errPrFr;
    res.RMSE(i,1)     = resTemp.RMSE;
    res.stdev(i,1)    = resTemp.stdev;
    t(i) = toc;
end
res.opts    = opts;
res.timeKn  = t;
res.avgRMSE = mean(res.RMSE(:,1));
res.avgstdev = mean(res.stdev(:,1));
res.optmSt  = optmSt;
res.query   = query;
%% Saving options
% % svName        = 'res_CMU30_3.mat';
% % save(fullfile(pathRes,svName),'res_CMU30_3','-v7.3');
end



