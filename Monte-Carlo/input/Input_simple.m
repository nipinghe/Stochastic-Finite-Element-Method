%% General setup
PROBLEM.General.MeshName   = 'simple_1x05_64e.mat';
% Name of output file
PROBLEM.General.SaveName   = NameSequence('results_simple','output',[],'.mat',1);
% SaveMode
PROBLEM.General.SaveMode   = 1;
% keep statistics about solver etc 
PROBLEM.General.Stats    = 1;

%% Solver setup
% Accuracy of iterative solver (stop iterating if err is below accuracy)
PROBLEM.Solver.Accuracy = 1e-6;
% Maximum iteration steps of solver (stop iteration if iter exeeds NoI)
PROBLEM.Solver.NoI      = 10;
% Regularisation coefficient
PROBLEM.Solver.lambda   = 1e-12;

%% Loading type
% number of electrodes
PROBLEM.Electrode.N_e  = 30;
% Temperature on electrode
PROBLEM.Electrode.Temp = 0.0;
% Electrode impedance
PROBLEM.Electrode.Im = 100.5;

%% Load definition
% definition of boundary conditions
% [N x 4] cell array of N boundary conditions
% BC{i,1} - [x1 y1;x2 y2] coordinates "from-to" where the BC apply
% BC{i,2} - BC type 'transfer'/'dirichlet'/'neumann'/'robin'
% BC{i,3} - prescribed value of BC. For each type:
%         - 'transfer' - defines a T0 in eq.: q=alpha*(T-T0)
%         - 'dirichlet' - sets the value of potential
%         - 'neumann' - sets the value of fluxes in [flux/m] - is then multiplied by length of element edge
% BC{i,4} - sets the additional information for each BC. For dirichlet/neumann leave the entry empty, i.e. [], 
%           for 'transfer' it defines the transfer coefficient alpha
% The hierarchy is following: 'dirichlet' - 'neumann' - 'transfer', i.e. dirichlet overrides neumann etc.
PROBLEM.LoadDef.BC = {[0.0 0.0;0.0 1.0],'transfer',30,0.1;... left boundary
                      [1.0 1.0;1.0 0.0],'transfer',-5,0.1};% right boundary

%% Material settings
% definition of known material properties
% anisotropy true/false
MATERIAL.Settings.anisotropy=true;

%% Material parameter setup
% obtain gpc coefficients with 'MonteCarlo','Collocation' or 'lhs'
MATERIAL.Settings.RF.Method='lhs';

% Covariance parameters for field 1
MATERIAL.Settings.RF.P{1}.nu=4;
MATERIAL.Settings.RF.P{1}.rho=0.4;
% Covariance parameters for field 2
MATERIAL.Settings.RF.P{2}.nu=4;
MATERIAL.Settings.RF.P{2}.rho=0.4;
% Covariance parameters for field 3
MATERIAL.Settings.RF.P{3}.nu=4;
MATERIAL.Settings.RF.P{3}.rho=0.4;

% correlation between fields
MATERIAL.Settings.RF.C=[1  0.6 0.2;
             0.6  1  0.2;
             0.2 0.2  1];
MATERIAL.Settings.RF.VAR=[(0.2*3)^2 (0.2*5)^2 (0.3*30)^2];
MATERIAL.Settings.RF.MEAN=[3 5 90];

% field point-wise distribution: 'normal'/'lognormal'
% PROBLEM.RF.sampling={'normal','normal','normal','normal'};
MATERIAL.Settings.RF.sampling={'lognormal','lognormal','lognormal'};
% choose covariance function for each field:
% - 'matern' parameters: rho - correlation length
%                        nu - differentiability
% - 'exponential' parameters: rho - correlation length
% - 'gauss' parameters: rho - correlation length
% - 'periodic' parameters: rho - correlation length
% - 'constant' parameters: rho - correlation
MATERIAL.Settings.RF.covariance={'matern','matern','matern'};
% get the number of random fields
MATERIAL.Settings.RF.N_rf=length(MATERIAL.Settings.RF.P);
% % get the number of eigenmodes for each randomfield = number of Random Variables (for each field)
% PROBLEM.RF.N_rv=30;
% set number of random variables: either choose the number of variables or percent of
% variance is reahced
MATERIAL.Settings.RF.N_rv=10;
MATERIAL.Settings.RF.N_rv_prec=0.9; % choose number on scale <0,1> (1 is the most precise)
% get the number of samples to generate the randomfields
MATERIAL.Settings.RF.N_s=10e1;

%% Load Mesh
MESH = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');