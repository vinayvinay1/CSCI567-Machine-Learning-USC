[train_data,train_label] = HW152prep('hw1ttt_train.data');
[new_data,new_label] = HW152prep('hw1ttt_test.data');
[newt_data,newt_label] = HW152prep('hw1ttt_valid.data');

[new_accu, train_accu] = naive_bayes(train_data, train_label, new_data, new_label)

[newt_accu, train_accu] = naive_bayes(train_data, train_label, newt_data, newt_label)
