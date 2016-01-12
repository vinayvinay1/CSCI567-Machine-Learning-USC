function [ accuracy ] = own_linear( ptrain_features, train_labels, ptest_features, test_labels, c_max)

[w,b] = trainsvm(ptrain_features, train_labels, c_max);
accuracy = testsvm(ptest_features, test_labels, w, b);
end

