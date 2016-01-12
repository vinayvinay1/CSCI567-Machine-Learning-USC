[train_data,train_label] = HW152prep('hw1ttt_train.data');
[new_data,new_label] = HW152prep('hw1ttt_test.data');
[newt_data,newt_label] = HW152prep('hw1ttt_valid.data');

for i = [1:10]
    [new_accu_1, train_accu_1, new_accu_2, train_accu_2] = decision_tree(train_data, train_label, new_data, new_label, i)
   
end
