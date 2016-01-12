function [new_accu_1, train_accu_1, new_accu_2, train_accu_2] = decision_tree(train_data, train_label, new_data, new_label, i)

tree1 = ClassificationTree.fit(train_data, train_label, 'MinLeaf', i, 'SplitCriterion', 'gdi', 'Prune', 'off');
tree2 = ClassificationTree.fit(train_data, train_label, 'MinLeaf', i, 'SplitCriterion', 'deviance', 'Prune', 'off');

pred_tree1_train = tree1.predict(train_data);
pred_tree2_train = tree2.predict(train_data);

pred_tree1_new = tree1.predict(new_data);
pred_tree2_new = tree2.predict(new_data);

train_accu_1 = sum(pred_tree1_train == train_label)/size(train_data,1);
train_accu_2 = sum(pred_tree2_train == train_label)/size(train_data,1);

new_accu_1 = sum(pred_tree1_new == new_label)/size(new_data,1);
new_accu_2 = sum(pred_tree2_new == new_label)/size(new_data,1);