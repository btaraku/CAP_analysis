function [Data, X] = CAP_open_ROI_files(dir, filename, subjlist, n_subjs)

if ischar(n_subjs)
	n_subjs = str2num(n_subjs);
end

Data = cell(1,n_subjs);
count = 1;
fid = fopen(subjlist, 'rt');
while ~feof(fid)
	s = fgetl(fid);
	disp(s)
	Data{count} = readmatrix([dir,'/',s,'/',filename]);
	count = count + 1;
end
X = cell2mat(Data)';
fclose(fid);
end
