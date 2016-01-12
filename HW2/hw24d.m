function hw24d( training_labels, training_features, test_labels, test_features, headers )
trainx = training_features(:,[1 8 6 5 4 3 10]);
testx = test_features(:,[1 8 6 5 4 3 10]);
headersx = headers([1 8 6 5 4 3 10]);

sexmap = containers.Map({'female', 'male'},[1,2]);
embarkedmap = containers.Map({'C', 'Q', 'S'},[1,2,3]);

%Fill missing Embarked
for i = 1:length(testx)
    if(isnan(testx{i,7}))
        testx{i,7} = 'S';
    end
end
for i = 1:length(trainx)
    if(isnan(trainx{i,7}))
        trainx{i,7} = 'S';
    end
end

%Fill missing Fare
for i = 1:length(testx)
    if(isnan(testx{i,2}))
        testx{i,2} = 33.2955;
    end
end
for i = 1:length(trainx)
    if(isnan(trainx{i,2}))
        trainx{i,2} = 33.2955;
    end
end

%Encode in dummy variables
for j = 1:length(trainx)
    trainx{j,6} = sexmap(trainx{j,6});
    trainx{j,7} = embarkedmap(trainx{j,7});
end
for j = 1:length(testx)
    testx{j,6} = sexmap(testx{j,6});
    testx{j,7} = embarkedmap(testx{j,7});
end
tsexdummy = dummyvar(cell2mat(trainx(:,6)));
tembarkeddummy = dummyvar(cell2mat(trainx(:,7)));
trainx = [trainx, num2cell(tsexdummy), num2cell(tembarkeddummy)];
trainx(:,[6 7]) = [];
testsexdummy = dummyvar(cell2mat(testx(:,6)));
testembarkeddummy = dummyvar(cell2mat(testx(:,7)));
testx = [testx, num2cell(testsexdummy),num2cell(testembarkeddummy)];
testx(:,[6 7]) = [];

%Normalize
ntrainx = trainx;
ntestx = testx;
meanval = zeros(1, 5);
stdval = zeros(1, 5);
for i = 1:5
    meanval(i) = nanmean(cell2mat(ntrainx(:,i)));
    stdval(i) = nanstd(cell2mat(ntrainx(:,i)));
    for j = 1:length(ntrainx)
       if(~isnan(ntrainx{j,i}))
           ntrainx{j,i} = (ntrainx{j,i} - meanval(i))/stdval(i); 
       end
    end
end

for i = 1:5
    for j = 1:length(ntestx)
       if(~isnan(ntestx{j,i}))
           ntestx{j,i} = (ntestx{j,i} - meanval(i))/stdval(i); 
       end
    end
end

%Multiple Models
bage = glmfit(cell2mat(ntrainx), cell2mat(training_labels), 'binomial', 'link', 'logit');
trainxnage = ntrainx; trainxnage(:,5) = [];
bnage = glmfit(cell2mat(trainxnage), cell2mat(training_labels), 'binomial', 'link', 'logit');

tmop = zeros(length(trainx),1);
temop = zeros(length(testx),1);

for i = 1:length(ntrainx)
    if(isnan(ntrainx{i,5}))
        trnx = ntrainx(i,:); trnx(5) = [];
        tmop(i,1) = glmval(bnage, cell2mat(trnx),'logit');
    else
        tmop(i,1) = glmval(bage, cell2mat(ntrainx(i,:)),'logit');
    end
end

for i = 1:length(ntestx)
    if(isnan(ntestx{i,5}))
        tstx = ntestx(i,:); tstx(5) = [];
        temop(i,1) = glmval(bnage, cell2mat(tstx),'logit');
    else
        temop(i,1) = glmval(bage, cell2mat(ntestx(i,:)),'logit');
    end
end

fprintf('Multiple Models\n');
fprintf('Training Accuracy: %f \n', calcaccuracy(training_labels, tmop));
fprintf('Testing Accuracy: %f \n', calcaccuracy(test_labels, temop));


%Substituting Values
trainxnew = trainx;
for i = 1:length(trainxnew)
    if(isnan(trainxnew{i,5}))
       trainxnew{i,5} = meanval(5); 
    end
end

for i = 1:length(trainxnew)
    trainxnew{i,5} = (trainxnew{i,5} - meanval(5))/stdval(5);
end

for i = [1 2 3 4]
    trainxnew(:,i) = ntrainx(:,i);
end

testxnew = testx;
for i = 1:length(testxnew)
    if(isnan(testxnew{i,5}))
       testxnew{i,5} = meanval(5); 
    end
end

for i = 1:length(testxnew)
    testxnew{i,5} = (testxnew{i,5} - meanval(5))/stdval(5);
end

for i = [1 2 3 4]
    testxnew(:,i) = ntestx(:,i);
end

bsubst = glmfit(cell2mat(trainxnew), cell2mat(training_labels), 'binomial', 'link', 'logit');

tsop = glmval(bsubst, cell2mat(trainxnew),'logit');
tesop = glmval(bsubst, cell2mat(testxnew),'logit');

fprintf('Substituted Values\n');
fprintf('Training Accuracy: %f \n', calcaccuracy(training_labels, tsop));
fprintf('Testing Accuracy: %f \n', calcaccuracy(test_labels, tesop));
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