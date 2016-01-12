function [trainx, testx] =  hw24e( training_labels, training_features, test_labels, test_features, headers )
trainx = training_features(:,[1 8 6 5 4 3 10]);
testx = test_features(:,[1 8 6 5 4 3 10]);
headersx = headers([1 8 6 5 4 3 10]);
cutpoints = [];

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

%Discretize Sex and Embarked
for j = 1:length(trainx)
    trainx{j,6} = sexmap(trainx{j,6});
    trainx{j,7} = embarkedmap(trainx{j,7});
end
for j = 1:length(testx)
    testx{j,6} = sexmap(testx{j,6});
    testx{j,7} = embarkedmap(testx{j,7});
end

%Append square-root columns at 6-10
sqrtcolumns = zeros(length(trainx),5);
for i = 1:length(trainx)
    for j = 1:5
        sqrtcolumns(i,j) = sqrt(trainx{i,j});
    end
end
trainx = [trainx, num2cell(sqrtcolumns)];
sqrtcolumns = zeros(length(testx),5);
for i = 1:length(testx)
    for j = 1:5
        sqrtcolumns(i,j) = sqrt(testx{i,j});
    end
end
testx = [testx, num2cell(sqrtcolumns)];

%Move Sex and Embarked from 6,7 to 11,12
trainxse = trainx(:,[6 7]);
testxse = testx(:,[6 7]);
trainx(:,[6 7]) = [];testx(:,[6 7]) = [];
trainx = [trainx, trainxse];
testx = [testx, testxse];

%Discretize five numeric variables
for m = 1:5
    [cutpoints{end+1}, trainx] = discretize(trainx, m);
end
for i = 1:length(cutpoints)
    cpi = cutpoints{i};
    if(length(cpi) >10)
        discolumn = zeros(length(testx),1);
        for j = 1:10
            if(j == 10)
                idx = find(cell2mat(testx(:,i)) >= cpi(j) & cell2mat(testx(:,i)) <= cpi(j+1));         
            else
                idx = find(cell2mat(testx(:,i)) >= cpi(j) & cell2mat(testx(:,i)) < cpi(j+1));   
            end
            idx = idx';
            for k = idx
                discolumn(k) = j;
            end
        end
        testx = [testx, num2cell(discolumn)];
    else
        testx = [testx, testx(:,i)];
    end 
end

%Restore NaN for Discretized Age column #17
for i = 1:length(trainx)
    if(trainx{i,17} == 0)
        trainx{i,17} = NaN;
    end
end
for i = 1:length(testx)
    if(testx{i,17} == 0)
        testx{i,17} = NaN;
    end
end

% Encode Sex, Embarked and 5 Numeric columns #11-17
for m = 11:17
    tcodedcolumn = dummycoding(trainx(:,m));
    trainx = [trainx, num2cell(tcodedcolumn)];  
    tecodedcolumn = dummycoding(testx(:,m));
    testx = [testx, num2cell(tecodedcolumn)];
    testx(:,[(length(trainx(1,:))+1):length(testx(1,:))]) = [];
end
trainx(:, 11:17) = [];
testx(:, 11:17) = [];

%Append Interaction Variables
len = length(trainx(1,:));
newcol = len*(len-1)/2;
intcolumns = zeros(length(trainx), newcol);
count = 1;
for i = 1:len-1
    for j = (i+1):len
        intcolumns(:,count) = cell2mat(trainx(:,i)).*cell2mat(trainx(:,j));
        count=count+1;
    end 
end
trainx = [trainx, num2cell(intcolumns)];

len = length(testx(1,:));
newcol = len*(len-1)/2;
intcolumns = zeros(length(testx), newcol);
count = 1;
for i = 1:len-1
    for j = (i+1):len
        intcolumns(:,count) = cell2mat(testx(:,i)).*cell2mat(testx(:,j));
        count=count+1;
    end 
end
testx = [testx, num2cell(intcolumns)];

% Delete columns with 1 or 0 distinct non-NaN values
x = length(trainx);
for i = x:-1:1
    uniq = unique(cell2mat(trainx(:,i)));
    y = length(uniq);
    for j = y:-1:1
        if(isnan(uniq(j)))
            uniq(j) = [];
        end   
    end
    if(length(uniq)<2)
       trainx(:,i) = []; 
       testx(:,i) = [];
    end
end

%Normalize Train and Test data
ntrainx = trainx;
ntestx = testx;
meanval = zeros(1, length(ntrainx(1,:)));
stdval = zeros(1, length(ntrainx(1,:)));
for i = 1:length(trainx(1,:))
    meanval(i) = nanmean(cell2mat(ntrainx(:,i)));
    stdval(i) = nanstd(cell2mat(ntrainx(:,i)));
    for j = 1:length(ntrainx(:,1))
       if(~isnan(ntrainx{j,i}))
           ntrainx{j,i} = (ntrainx{j,i} - meanval(i))/stdval(i); 
       end
    end
end

for i = 1:length(trainx(1,:))
    for j = 1:length(ntestx(:,1))
       if(~isnan(ntestx{j,i}))
           ntestx{j,i} = (ntestx{j,i} - meanval(i))/stdval(i); 
       end
    end
end
length(trainx(1,:))
end

function [cutpoint, trainx] = discretize(trainx, head)
indpvariable = unique(cell2mat(trainx(:,head)));
cutpoint = [];
x = length(indpvariable);
for i = x:-1:1
    if(isnan(indpvariable(i)))
        indpvariable(i) = [];
    end
end

if(length(indpvariable) > 10)
    sortedm = sort(cell2mat(trainx(:,head)));
    y = length(sortedm);       
    for i = y:-1:1     
        if(isnan(sortedm(i)))                  
            sortedm(i) = [];           
        end       
    end
    range = ceil(length(sortedm)/10);
    cutpoint = zeros(1,11);
    cutpoint(11) = sortedm(end);
    sidx = 1;
    for i = 1:10       
        cutpoint(i) = sortedm(sidx); 
        sidx = sidx + range;        
    end
    
    discolumn = zeros(length(trainx),1);
    for i = 1:10
        if(i == 10)
            idx = find(cell2mat(trainx(:,head)) >= cutpoint(i) & cell2mat(trainx(:,head)) <= cutpoint(i+1));         
        else
            idx = find(cell2mat(trainx(:,head)) >= cutpoint(i) & cell2mat(trainx(:,head)) < cutpoint(i+1));   
        end
        idx = idx';
        for j = idx
            discolumn(j) = i;
        end
    end
    trainx = [trainx, num2cell(discolumn)];

else
    cutpoint = indpvariable';
    trainx = [trainx, trainx(:,head)];
end
end

function [codedcolumn] = dummycoding(column)
uniqpoints = unique(cell2mat(column));
x = length(uniqpoints);
for i = x:-1:1
    if(isnan(uniqpoints(i)))
        uniqpoints(i) = [];
    end   
end

codedcolumn = zeros(length(column), length(uniqpoints)-1);
for i = 1:(length(uniqpoints)-1)
    idx = find(cell2mat(column) == uniqpoints(i));
    idx = idx';
    for j = idx
        codedcolumn(j,i) = 1;
    end
end

%Encode NaN where ever found as NaN
for i = 1:length(column)
    if(isnan(column{i}))
        for j = 1:(length(uniqpoints)-1)
            codedcolumn(i,j) = NaN;
        end
    end
end
end

