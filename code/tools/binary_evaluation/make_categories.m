
load('features/caltech256_feats.mat');

test_train_index = cell(size(fs_index),3);

temp_idx=1;
counter = 1;


fprintf('Build up Test-train data started...\n');
for i=1:size(fs_index)
    
cat = str2num(fs_index{i}(length(fs_index{i})-11:length(fs_index{i})-9));
test_train_index{i,1} = fs_index(i);
test_train_index{i,2} = cat;

if temp_idx<cat
    temp_idx=cat;
    counter=1;
end

if counter<31
    test_train_index{i,3}=1;
else
    test_train_index{i,3} = 0;
end
counter = counter+1;
end


fprintf('Make train set...\n');
train_set_index = find(cellfun(@(x) x==1, test_train_index(:,3)));
train_set= [train_set_index(:,1), cell2mat(test_train_index(train_set_index(:,1),2))];

fprintf('train SVM...\n');
%SVMStruct = svmtrain(feats(:,train_set(:,1)),train_set(:,2));
numInst = size(train_set,1);
numLabels = max(train_set(:,2));

%# Train one-against-all models
model = cell(numLabels,1);

for k=1:numLabels
    model{k} = train(double(train_set(:,2)==k), sparse(double(feats(:,train_set(:,1))')), '-s 1');
    %reverseStr = repmat(sprintf('\b'), 1, length(num2str(k)));
    fprintf(strcat(num2str(k),'\n'));
end

%model = train(double(train_set(:,2)), double(feats(:,train_set(:,1))') ,'-s 4 -v 257');

fprintf('Make test set...\n');
test_set_index = find(cellfun(@(x) x==0, test_train_index(:,3)));
test_set= [test_set_index(:,1), cell2mat(test_train_index(test_set_index(:,1),2))];

fprintf('test SVM...\n');
numTest = size(test_set,1);
%# Get probability estimates of test instances using each model
prob                    = zeros(numTest,numLabels);
for k=1:numLabels
    [~,~,p]                 = predict(double(test_set(:,2)==k), double(feats(:,test_set(:,1))'), model{k});
    prob(:,k)               = p(:,model{k}.Label==1);    % Probability of class==k
end

% Predict the class with the highest probability
[~,pred]                = max(prob,[],2);
acc                     = sum(pred == test_set(:,2)) ./ numel(test_set(:,2));    % Accuracy
C                       = confusionmat(test_set(:,2), pred);  
