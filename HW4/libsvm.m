function libsvm(ptrain_features, train_labels, ptest_features, test_labels)

lib_param = ['-t 1 -q -c 16 -d 3'];
model = svmtrain(double(train_labels'), double(ptrain_features), lib_param);
[pred,test_accuracy,dv]=svmpredict(double(test_labels'), double(ptest_features), model);
test_accuracy
end