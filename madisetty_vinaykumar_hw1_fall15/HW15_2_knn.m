[train_data,train_label] = HW152prep('hw1ttt_train.data');
[new_data,new_label] = HW152prep('hw1ttt_test.data');
[newt_data,newt_label] = HW152prep('hw1ttt_valid.data');

for k = [1:2:15]
    [new_accu, train_accu] = knn_classify(train_data, train_label, new_data, new_label, k)
    [new_accu, train_accu] = knn_classify(train_data, train_label, newt_data, newt_label, k)
end
