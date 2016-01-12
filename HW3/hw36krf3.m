function hw36krf3
[n,t,r] = xlsread('hw3.xls');

format long g;
r = cell2mat(r);

rows = length(r);
databody = r;
lambda = [0, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000];
sigma2 = [0.125,0.25,0.5,1,2,4,8];
ksize = 5;
bestlambda = zeros(1,3);
bestsigma = zeros(1,3);
avgtesterror = 0;


for m = 1:3
    %Randomize
    databody = databody(randperm(rows),:);

    %Split into Train and Test
    setsize = int32(rows*0.5);
    training_set = databody(1:setsize,:);
    test_set = databody((setsize+1):rows,:);
    
    %Normalize
    meanval = zeros(1, length(training_set(1,:)));
    stdval = zeros(1, length(training_set(1,:)));
    for i = 2:length(training_set(1,:))
        meanval(i) = nanmean(training_set(:,i));
        stdval(i) = nanstd(training_set(:,i));
        for j = 1:length(training_set(:,1))
            if(~isnan(training_set(j,i)))
                training_set(j,i) = (training_set(j,i) - meanval(i))/stdval(i); 
            end
        end
    end
    
    for i = 2:length(test_set(1,:))
        for j = 1:length(test_set(:,1))
            if(~isnan(test_set(j,i)))
                test_set(j,i) = (test_set(j,i) - meanval(i))/stdval(i); 
            end
        end
    end

    %Perform Linear Ridge Regression on each dataset
    %Split Training data virtually by creating index cutpoints
    cvindex = 1:floor(length(training_set(:,1))/ksize):length(training_set(:,1));
    cvindex(end) = length(training_set(:,1))+1;
    
    minval = inf;
     
    for sval = 1:length(sigma2)            
        for i = 1:length(lambda(1,:))               
            cverror = 0;                
            for j = 1:ksize                    
                trainval = training_set;
                testval = trainval(cvindex(j):(cvindex(j+1)-1),:);
                trainval(cvindex(j):(cvindex(j+1)-1),:) = [];
                       
                Kval = exp((-1*pdist2(x2fx(trainval(:,2:end)),x2fx(trainval(:,2:end))))/sigma2(sval));
                kxval = exp((-1*pdist2(x2fx(trainval(:,2:end)),x2fx(testval(:,2:end))))/sigma2(sval));
                ival = (Kval + lambda(i)*eye(length(trainval(:,1))))\eye(length(trainval(:,2:end)));
                pred_y = (trainval(:,1)')*ival*kxval;   

                      
                cverror = cverror + mean((pred_y' - testval(:,1)).^2);                
            end            
            cverror = cverror/ksize;
            if(cverror < minval)                    
                minval = cverror;
                bestlambda(m) = lambda(i);
                bestsigma(m) = sigma2(sval);                  
            end
        end            
    end      
   
                    
    %Train Model using the best Lambda obtained
    K = exp((-1*pdist2(x2fx(training_set(:,2:end)),x2fx(training_set(:,2:end))))/bestsigma(m));
    kx = exp((-1*pdist2(x2fx(training_set(:,2:end)),x2fx(test_set(:,2:end))))/bestsigma(m));
    ix = (K + bestlambda(m)*eye(length(training_set(:,1))))\eye(length(training_set(:,2:end)));
    y = (training_set(:,1)')*ix*kx;
    
    avgtesterror = avgtesterror + mean((y' - test_set(:,1)).^2);
end
avgtesterror = avgtesterror/3;
bestlambda
bestsigma
avgtesterror
end