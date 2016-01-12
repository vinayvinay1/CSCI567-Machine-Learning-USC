function [ptrain_features, ptest_features] = hw431(train_features, test_features)

mod_columns = [2,7,8,14,15,16,26,29];

ptrain_features = train_features;
ptest_features = test_features;

%Change -1 to 2 and 0 to 3 and apply dummyvar
for i = mod_columns
    ptrain_features(ptrain_features(:,i)==-1,i) = 2;
    ptrain_features(ptrain_features(:,i)==0,i) = 3; 
    ptrain_features = [ptrain_features, int64(dummyvar(double(ptrain_features(:,i))))];
    
    ptest_features(ptest_features(:,i)==-1,i) = 2;
    ptest_features(ptest_features(:,i)==0,i) = 3;
    ptest_features = [ptest_features, int64(dummyvar(double(ptest_features(:,i))))];
end

%Remove original columns that were encoded
ptrain_features(:,mod_columns) = [];
ptest_features(:,mod_columns) = [];
end

