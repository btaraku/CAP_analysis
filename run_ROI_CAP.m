addpath('/nafs/narr/btaraku/rfMRI_analysis/scripts/CAP_analysis/Jnomi_code/elbow');

% Parameters

% n iterations
n_iter = 5000;
% n_replicates
n_rep = 100;
% Distance method
dmethod = 'correlation';
% Range of k values for kmeans clustering
k_range = 2:50;

% Data directory for prerpocessed and parcellated fMRI files
datadir = '';
% Name of prerpocessed and parcellated fMRI file
filename = '';
% Text file list of all subjects to run
subjlist = '';
% Number of subjects in list
n_subjs = ;

[Data, X] = CAP_open_ROI_files(datadir, filename, subjlist, n_subjs);

size(X)

[IDX_list, SSE, R] = CAP_kmeans_clustering_parfor(X, n_iter, n_rep, k_range, dmethod, 24);

% Save output from k-means clustering in .mat file, in order to find elbow point (next step)
save('.mat', 'IDX_list', 'SSE', 'R');

