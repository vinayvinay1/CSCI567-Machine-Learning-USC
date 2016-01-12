function [ gftrainx, gftestx ] = hw24f( trainx, training_labels, testx, test_labels )

newtrainx = trainx;
newtestx = testx;
%newtrainx(:,1:8) = [];
%newtestx(:,1:8) = [];
gftrainx = [];
gftestx = [];
optimalcolumn = zeros(1,10);
taccuracies = zeros(1,10);
teaccuracies = zeros(1,10);

for i = 1:10
    accuracies = zeros(1,length(newtrainx(1,:)));
    
    for j = 1:length(newtrainx(1,:))
        gftrainx(:,i) = cell2mat(newtrainx(:,j)); 
        b = glmfit(gftrainx, cell2mat(training_labels), 'binomial', 'link', 'logit');
        predict = glmval(b, gftrainx,'logit');
        accuracies(j) = calcaccuracy(training_labels, predict);
    end
    optimalcolumn(i) = min(find(accuracies == max(accuracies)));
    gftrainx(:,i) = cell2mat(newtrainx(:,optimalcolumn(i)));
    gftestx(:,i) = cell2mat(newtestx(:,optimalcolumn(i)));
   
    tpredict = glmval(b, gftrainx,'logit');
    tepredict = glmval(b, gftestx,'logit');
    
    taccuracies(i) = calcaccuracy(training_labels, tpredict);
    teaccuracies(i) = calcaccuracy(test_labels, tepredict);
end
x = 1:10;
plot(x,taccuracies, x, teaccuracies);
xlabel('No of Features'), ylabel('Accuracy'), legend('Training', 'Test');
axis([1 10 0 1]);
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