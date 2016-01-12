function hw631d( eigenvecs, x_trainm, x_testm, y_train, y_test )

k = [1,5,10,20,80];

train_accuracy = zeros(1,length(k));
test_accuracy = zeros(1,length(k));
runtime = zeros(1,length(k));

for i = 1:length(k)
    t = cputime;
    %Compress Train and Test
    eigen_subset = eigenvecs(:,1:k(i));
    x_train_compressed = x_trainm*eigen_subset;
    x_train_reconstruction = x_train_compressed*eigen_subset';
    x_test_compressed = x_testm*eigen_subset;
    x_test_reconstruction = x_test_compressed*eigen_subset';

    %Classification
    tree = fitctree(x_train_reconstruction, y_train, 'SplitCriterion', 'deviance');
    train_label_inferred = predict(tree, x_train_reconstruction);
    test_label_inferred = predict(tree, x_test_reconstruction);
    
    
    train_accuracy(i) = sum(train_label_inferred==y_train)*100/length(y_train(:,1));
    test_accuracy(i) = sum(test_label_inferred==y_test)*100/length(y_test(:,1));
    runtime(i) = cputime-t;
end

output = [{'K', 'Train Accuracy', 'Test Accuracy', 'Runtime'}; num2cell([k',train_accuracy',test_accuracy',runtime'])]
end