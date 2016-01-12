%Add LIBSVM path
addpath('libsvm-3.20/matlab');

%Load Train and Test data
train = load('phishing-train.mat');
test = load('phishing-test.mat');
train_features = train.features;
train_labels = train.label;
test_features = test.features;
test_labels = test.label;

%3.1
[ptrain_features, ptest_features] = hw431(train_features, test_features);

%3.2
[ w,b ] = trainsvm( ptrain_features, train_labels, c);
[ test_accuracy ] = testsvm( ptest_features, test_labels, w, b);

%3.3
%3.3a
[c_max] = hw433a(ptrain_features, train_labels);
%3.3b
[ accuracy ] = own_linear( ptrain_features, train_labels, ptest_features, test_labels, c_max);

%3.4
hw434(ptrain_features, train_labels);

%3.5
%3.5a
hw435a(ptrain_features, train_labels);
%3.5b
hw435b(ptrain_features, train_labels);
libsvm(ptrain_features, train_labels, ptest_features, test_labels);

