function hw24b( training_labels, training_features, headers )

%Discretize numeric independent variables
pclass = unique(cell2mat(training_features(:,1))); 
pclass = removenan(pclass);pclass = pclass';
age = unique(cell2mat(training_features(:,4))); 
age = removenan(age);age = age';
sibsp = unique(cell2mat(training_features(:,5))); 
sibsp = removenan(sibsp); sibsp = sibsp';
parch = unique(cell2mat(training_features(:,6)));
parch = removenan(parch); parch = parch';
fare = unique(cell2mat(training_features(:,8)));
fare = removenan(fare); fare = fare';

%plot graphs
subplot(3,2,1)
plotgraphs(training_labels, training_features, pclass, 1)
title('Subplot-1: pclass'),ylabel('Survival Probability'),xlabel('pclass')
subplot(3,2,2)
plotgraphs(training_labels, training_features, age, 4)
title('Subplot-2: age'),ylabel('Survival Probability'),xlabel('age')
subplot(3,2,3)
plotgraphs(training_labels, training_features, sibsp, 5)
title('Subplot-3: sibsp'),ylabel('Survival Probability'),xlabel('sibsp')
subplot(3,2,4)
plotgraphs(training_labels, training_features, parch, 6)
title('Subplot-4: parch'),ylabel('Survival Probability'),xlabel('parch')
subplot(3,2,5)
plotgraphs(training_labels, training_features, fare, 8)
title('Subplot-5: fare'),ylabel('Survival Probability'),xlabel('fare')
end

function A = removenan(A)
x = length(A);
for i = x:-1:1
    if(isnan(A(i)))
        A(i) = [];
    end   
end
end

function plotgraphs(training_labels, training_features, uniquepoints, head)

if(length(uniquepoints) > 10)
    minimum = min(uniquepoints);
    maximum = max(uniquepoints);
    range = (maximum - minimum)/10;
    xline = 1:10;
    yline = zeros(1,10);
    
    w = minimum;
    for i = xline
        survivorcount = 0;
        totalcount = 0;
        for j = 1:length(training_features)
            if (training_features{j,head} >= w && training_features{j,head}<(w+range))
                totalcount = totalcount+1;
                if(training_labels{j} == 1)
                    survivorcount = survivorcount+1;
                end
            end  
        end
        w = w + range;
        yline(i) = survivorcount/totalcount;
    end
    bar(xline, yline);
else
    xline = 1:length(uniquepoints);
    yline = zeros(1, length(uniquepoints));
    
    for i = 1:length(uniquepoints)
        survivorcount = 0;
        totalcount = 0;
        for j = 1:length(training_features)
            if (training_features{j,head} == uniquepoints(i))
                totalcount = totalcount+1;
                if(training_labels{j} == 1)
                    survivorcount = survivorcount+1;
                end
            end  
        end
        yline(i) = survivorcount/totalcount;
    end 
    bar(xline, yline);
end
end