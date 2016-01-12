function hw24h( gftrainx, training_labels )

%Compute glmfit accuracies for train
bglm = glmfit(gftrainx, cell2mat(training_labels), 'binomial', 'link', 'logit');
tpred = glmval(bglm, gftrainx,'logit');
taccuracy = calcaccuracy(training_labels, tpred);

%Append One column to trainx
newtrainx = ones(length(gftrainx(:,1)),1);
newtrainx = [newtrainx, gftrainx];

accuracies = nwfit(newtrainx, cell2mat(training_labels));
x = 1:length(accuracies);
plot(x,accuracies);
title('Newton Method'),xlabel('No of Iterations'), ylabel('Accuracy');
end


function accuracies = nwfit(x,y)
b = ones(length(x(1,:)),1);
accuracies = zeros(1,100);
hess = zeros(length(x(1,:)), length(x(1,:)));
grad = zeros(length(x(1,:)),1);

for i = 1:100
    for j = 1:length(x(:,1))
        sigmoid = (1./(1+exp(-x(j,:)*b)));
        hess = hess + (sigmoid*(1-sigmoid)*x(j,:)'*x(j,:));
        grad = grad + (sigmoid-y(j))*x(j,:)';
    end
    b = b - 0.1*(hess\grad);
    predict = nwval(b,x);
    accuracies(i) = calcaccuracy(num2cell(y),predict);
end
end


function predict = nwval(b,x)
predict = 1./(1+exp(-x*b));
end

function accu = calcaccuracy(correct, predict)
total = length(correct);
cpred = 0;
for i = 1:length(correct)
    if(correct{i} == round(predict(i)))
        cpred = cpred + 1;
    end
end
accu = cpred/total;
end