function hw24g( gftrainx, training_labels )

%Compute glmfit accuracies for train
bglm = glmfit(gftrainx, cell2mat(training_labels), 'binomial', 'link', 'logit');
tpred = glmval(bglm, gftrainx,'logit');
taccuracy = calcaccuracy(training_labels, tpred);

%Append One column to trainx
newtrainx = ones(length(gftrainx(:,1)),1);
newtrainx = [newtrainx, gftrainx];
  
accuracies = gdfit(newtrainx, cell2mat(training_labels),0.1);
x = 1:length(accuracies);
subplot(2,2,1);
plot(x,accuracies);
title('Subplot-1: Stepsize = 0.1'),xlabel('No of Iterations'), ylabel('Accuracy');

accuracies = gdfit(newtrainx, cell2mat(training_labels),0.3);
x = 1:length(accuracies);
subplot(2,2,2);
plot(x,accuracies);
title('Subplot-2: pclStepsize = 0.3'),xlabel('No of Iterations'), ylabel('Accuracy');

accuracies = gdfit(newtrainx, cell2mat(training_labels),0.8);
x = 1:length(accuracies);
subplot(2,2,3);
plot(x,accuracies);
title('Subplot-3: Stepsize = 0.8'),xlabel('No of Iterations'), ylabel('Accuracy');

accuracies = gdfit(newtrainx, cell2mat(training_labels),1.5);
x = 1:length(accuracies);
subplot(2,2,4);
plot(x,accuracies);
title('Subplot-4: Stepsize = 1.5'),xlabel('No of Iterations'), ylabel('Accuracy');
end


function accuracies = gdfit(x,y,stepsize)
b = zeros(length(x(1,:)),1);
accuracies = zeros(1,100);

for i = 1:100
    for j = 1:length(x(:,1))
        sigmoid = (1./(1+exp(-x(j,:)*b)));
        b = b -  stepsize*((sigmoid-y(j))*x(j,:)');
    end
    predict = gdval(b,x);
    accuracies(i) = calcaccuracy(num2cell(y),predict);
end
end


function predict = gdval(b,x)   
predict = 1./(1+exp(-1*x*b));
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