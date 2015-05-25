function [ H ] = lsh( Dim, n_bit, data )
%% LSH Hashing function
% Input:
%   Dim : Dimensions of original data
%   n_bit : Number of binary bits (reduced dimension)
%   data : Original data (feature vectors)

fprintf(1,'Claculate LSH started...');
    H= randn(Dim,n_bit);
    temp = data - ones(size(data))*diag(mean(data));
    norm_temp = temp/norm(temp);
    projected_data=  norm_temp * H;
    H = sign(projected_data);
reverseStr = repmat(sprintf('\b'), 1, length('started...'));
fprintf(1,strcat(reverseStr,'Done!\n'));
end

