% call dpm detector
    % ACF model trained on caltech dataset
    % load('models/AcfCaltech+Detector.mat','detector');
    % ACF model trained on Inria dataset
    % load('models/AcfInriaDetector.mat','detector');
    
    % LDCF model trained on caltech dataset
    % load('models/LdcfCaltechDetector.mat','detector');
    % LDCF model trained on Inria dataset
    % load('models/LdcfInriaDetector.mat','detector');
    
% % load detection model prior to function call
% load('models/LdcfInriaDetector.mat','detector');
% 
% % use LDCF - necessary modifications
% opts.filters=[5 4]; opts.pJitter=struct('flip',1,'nTrn',3,'mTrn',1);
% opts.pBoost.pTree.maxDepth=3; opts.pBoost.discrete=0; opts.seed=2;
% opts.pPyramid.pChns.shrink=2; opts.name='models/LdcfInria';

load('models/AcfInriaDetector.mat','detector');

nms = struct('type', 'ms', 'overlap', 0.5);
pModify=struct('pNms', [nms], 'cascThr', 0);
detector=acfModify(detector,pModify);
inpath = '/Users/ire/Desktop/Code/VOCdevkit/VOC2007/JPEGImages/smallSet/';
apath='/Users/ire/Desktop/Code/ACF/annotations/2007/smallSet/inria/thresh0/';
outpath='/Users/ire/Desktop/Code/ACF/processed/2007/smallSet/inria/thresh_2/';
acf_detect_and_store(inpath, apath, outpath, detector);
clear;


