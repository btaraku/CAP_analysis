function [F, TM, TMn, MDT, NT] = icatb_dfnc_statevector_stats(a, k)

Ntps = length(a);

%% Fraction of time spent in each state
F = zeros(1,k);
for jj = 1:k
    F(jj) = (sum(a == jj))/Ntps;
end

%% Number of Transitions
NT = sum(abs(diff(a)) > 0);

%% Mean dwell time in each state
MDT = zeros(1,k);
for jj = 1:k
    start_t = find(diff(a==jj) == 1);
    end_t = find(diff(a==jj) == -1);
    if a(1)==jj
        start_t = [0; start_t];
    end
    if a(end) == jj
        end_t = [end_t; Ntps];
    end
    MDT(jj) = mean(end_t-start_t);
    if isempty(end_t) & isempty(start_t)
        MDT(jj) = 0;
    end
end

% Number of transitions from state A
knt = zeros(1,k);
for i = 1:k
    for j = 1:Ntps-1
        if a(j) == i && a(j+1) ~= i;
            knt(i) = knt(i) + 1;
        end
    end
end

%% Transition Matrix (frequencies of trasitions from state A to state B)
TM = zeros(k,k);
for t = 2:Ntps
    TM(a(t-1),a(t)) =  TM(a(t-1),a(t)) + 1;
end

%% Normalized Transition Matrix (frequency of trasitions from state A to state B over total transitions from state A)
TMn = zeros(k,k);
for i=1:k
    TMn(i,:) = TM(i,:) ./ knt(i);
    TMn(i,i) = 0;
end
