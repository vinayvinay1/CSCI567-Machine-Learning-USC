function hw435a(ptrain_features, train_labels)

c = [4^-3, 4^-2, 4^-1, 1, 4, 4^2, 4^3, 4^4, 4^5, 4^6, 4^7];
deg = [1,2,3];
avg_accuracy = zeros(length(c(1,:)), length(deg(1,:)));
avg_time = zeros(length(c(1,:)), length(deg(1,:)));
ksize = 3;

for i = 1:length(c(1,:))
    t = cputime;
    
    for j = 1:length(deg(1,:))
        lib_param = ['-t 1 -q -c ',num2str(c(i)), ' -v ',num2str(ksize), '-d', num2str(deg(j))];
        avg_accuracy(i,j) = svmtrain(double(train_labels'), double(ptrain_features), lib_param);
    
        e = cputime - t;
        avg_time(i,j) = e/ksize;   
    end   
end

output_acc = [[{'Avg.accuracy'}, num2cell(deg)];num2cell([c',avg_accuracy])]
output_time = [[{'Avg.time'}, num2cell(deg)];num2cell([c',avg_time])]
end