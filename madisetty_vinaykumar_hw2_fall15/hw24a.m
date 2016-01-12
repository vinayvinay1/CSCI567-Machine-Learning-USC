function [training_labels, training_features, test_labels, test_features, headers] = hw24a
[n,t,r] = xlsread('titanic3.xls');

rows = length(r)-1;
columns = length(r(1,:))-1;
headers = r(1,:);headers(2) = [];
missingvaluecount = zeros(1,columns);
databody = r(2:(rows+1),:);

%Calculate missing values for each column
for i = 1:(columns+1)
    count = 0;
    tempcolumn = databody(:,i);
    for j = 1:rows
        if(isnan(tempcolumn{j}))
            count = count +1;
        end
    end
    missingvaluecount(i) = count;
end

%randomize body rows
databody = databody(randperm(rows),:);

%divide into training and test parts
setsize = int32(rows/2);
training_set = databody(1:setsize,:);
training_labels = training_set(:,2);
training_set(:,2) = [];
training_features = training_set(:,1:columns);

test_set = databody((setsize+1):rows,:);
test_labels = test_set(:,2);
test_set(:,2) = [];
test_features = test_set(:,1:columns);

missingvaluecount(2) = [];
output = [cellfun(@num2str, headers, 'UniformOutput', false); arrayfun(@num2str, missingvaluecount, 'UniformOutput', false)];
output
end