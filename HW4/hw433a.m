function [c_max] = hw433a(ptrain_features, train_labels)

c = [4^-6, 4^-5, 4^-4, 4^-3, 4^-2, 4^-1, 1, 4, 4^2];
avg_accuracy = zeros(1,length(c(1,:)));
avg_time = zeros(1,length(c(1,:)));
ksize = 3;

for i = 1:length(c(1,:))
    cvindex = 1:floor(length(ptrain_features(:,1))/ksize):length(ptrain_features(:,1));
    cvindex(end) = length(ptrain_features(:,1))+1;

    temp_accuracy = zeros(1,ksize);
    t = cputime;
     
    for j = 1:ksize
        temp_train_features = ptrain_features;  
        temp_train_labels = train_labels;
        
        temp_test_features = temp_train_features(cvindex(j):(cvindex(j+1)-1),:);
        temp_train_features(cvindex(j):(cvindex(j+1)-1),:) = [];
        
        temp_test_labels = temp_train_labels(cvindex(j):(cvindex(j+1)-1));       
        temp_train_labels(cvindex(j):(cvindex(j+1)-1)) = [];
        
        [temp_w, temp_b] = trainsvm(temp_train_features, temp_train_labels, c(i));
        temp_accuracy(j) = testsvm(temp_test_features, temp_test_labels, temp_w, temp_b);
    end

    e = cputime - t;
    avg_accuracy(i) = mean(temp_accuracy)*100;
    avg_time(i) = e/ksize; 
end

c_max = c(find(max(avg_accuracy)==avg_accuracy));

output = [{'C', 'Average Accuracy', 'Average Time'};num2cell(output)]
end

