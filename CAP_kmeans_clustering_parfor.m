function [IDX_list, SSE, R] = CAP_kmeans_clustering(X, n_iter, n_rep, k_range, dmethod, nworkers)

	IDX_list = zeros(size(X,1), length(k_range));
	SSE = zeros(1,length(k_range));
	R = zeros(1,length(k_range));

	parpool(nworkers);
	parfor (i=1:length(k_range),nworkers)
		k = k_range(i);
		fprintf('---------------- k = %d ------------------\n', k)
		[IDX, C, SUMD, D] = kmeans(X, k, 'distance', dmethod, 'Replicates', n_rep, 'Display', 'final', 'MaxIter', n_iter, 'empty', 'drop');
		IDX_list(:,i) = IDX;
		[SSE(i), R(i)] = cluster_goodness(D, IDX);
	end
end
