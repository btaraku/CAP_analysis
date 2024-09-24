% Parameters and paths

% Optimal k used in analysis
k = ;
% Numbwr of subjects in analysis
n_subjs = ;
% Load .mat file with cluster indices for all subject timepoints
load('.mat');
ntps = size(IDX,1)/n_subjs;

F_all = zeros(k, n_subjs);
TM_all = zeros(k, k, n_subjs);
TMn_all = zeros(k, k, n_subjs);
MDT_all = zeros(k, n_subjs);
NT_all = zeros(n_subjs,1);

for i = 1:n_subjs
	first = ntps*(i-1) + 1;
	last = ntps*i;
%	[first, last]
	subj_states = IDX(first:last);
	[F, TM, TMn, MDT, NT] = icatb_dfnc_statevector_stats(subj_states, k);

	F_all(:,i) = F;
	TM_all(:,:,i) = TM;
        TMn_all(:,:,i) = TMn;
	MDT_all(:,i) = MDT;
	NT_all(i) = NT;
end
