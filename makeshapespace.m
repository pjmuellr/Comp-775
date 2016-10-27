function  [eigenvectors, eigenvalues,estd, total_variance] = makeshapespace(tuples)
%[eigenvectors, principalvariance,estd, totalvariance]
%get size
S = size(tuples,2);
%get mean
u = mean(tuples,2);
%get variance
tuplesvar=(tuples-repmat(u,1,S));
%total variance
total_variance = trace((1/(S-1))*(tuplesvar*tuplesvar'));
%eigen calculation
[eigenvectors,eigenvalues] = eigs((tuplesvar*tuplesvar'), S-1);
eigenvalues = sum(eigenvalues)/24;
%standard devation
estd = sqrt(eigenvalues);


