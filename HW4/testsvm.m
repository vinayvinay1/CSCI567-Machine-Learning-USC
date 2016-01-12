function [ test_accuracy ] = testsvm( ptest_features, test_labels, w, b)

test_labels = test_labels';
[n,d] = size(ptest_features);
pred = sign(double(ptest_features)*w+b);
test_accuracy = (n - sum(abs(int64(pred)-test_labels))/2)/n;
end

