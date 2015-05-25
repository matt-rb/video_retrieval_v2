function [ normalized_fv, mean_data  ] = normalize_features( feature_vectors, mean_data )
%% Normalize feature vectors
%   Input:
%       feature_vectors : NxD matrix where N is the number of features and
%                         D is dimantion of features.
%       mean_data : mean of data if exist
%
%   Output:
%       normalized_fv: Normalized feature vectors.
%       mean_data : mean of input data.

%% calculate mean
if (nargin<2) || isempty(mean_data)
  mean_data = mean(feature_vectors);
end

%% normalization
feature_vectors=bsxfun(@minus,feature_vectors,mean_data);
normalized_fv=bsxfun(@rdivide,feature_vectors,sqrt(sum(feature_vectors.^2,2)));

end

