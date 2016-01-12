function hw434(ptrain_features, train_labels)

c = [4^-6, 4^-5, 4^-4, 4^-3, 4^-2, 4^-1, 1, 4, 4^2];
avg_accuracy = zeros(1,length(c(1,:)));
avg_time = zeros(1,length(c(1,:)));
ksize = 3;

for i = 1:length(c(1,:))
    t = cputime;
    
    lib_param = ['-t 0 -q -c ',num2str(c(i)), ' -v ',num2str(ksize)];
    avg_accuracy(i) = svmtrain(double(train_labels'), double(ptrain_features), lib_param);
    
    e = cputime - t;
    avg_time(i) = e/ksize; 
end

output = [{'C', 'Average Accuracy', 'Average Time'};num2cell(output)]
end

