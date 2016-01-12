function hw35a

rand_x = zeros(100,10);
rand_y = zeros(100,10);
bias2 = zeros(1,6);
variance = zeros(1,6);


for i = 1:100
    rand_x(i,:) = 2.*rand(1,10) -1;
   for j = 1:10
       rand_y(i,j) = 2*(rand_x(i,j)^2) + normrnd(0,sqrt(0.1));
   end  
end

fy1 = ones(100,10);
fy2 = zeros(100,10);
fy3 = zeros(100,10);
fy4 = zeros(100,10);
fy5 = zeros(100,10);
fy6 = zeros(100,10);

mse1 = zeros(1,100);
mse2 = zeros(1,100);
mse3 = zeros(1,100);
mse4 = zeros(1,100);
mse5 = zeros(1,100);
mse6 = zeros(1,100);

%Calculate MSE for all 6 g(x)
for i = 1:100
    xval = rand_x(i,:)';
    xval2 = rand_x(i,:)'.^2;
    xval3 = rand_x(i,:)'.^3;
    xval4 = rand_x(i,:)'.^4;
    
    
    %For g1(x)
    mse1(i) = mean((rand_y(i,:) - fy1(i,:)).^2);

    %For g2(x)
    x2 = zeros(10,0);
    b2 = glmfit(x2 ,rand_y(i,:),'normal','link','identity');
    fy2(i,:) = glmval(b2,x2,'identity');
    mse2(i) = mean((rand_y(i,:) - fy2(i,:)).^2);

    %For g3(x)
    x3 = xval;
    b3 = glmfit(x3 ,rand_y(i,:),'normal','link','identity');
    fy3(i,:) = glmval(b3,x3,'identity');
    mse3(i) = mean((rand_y(i,:) - fy3(i,:)).^2);
    
    %For g4(x)
    x4 = [xval,xval2];
    b4 = glmfit(x4 ,rand_y(i,:),'normal','link','identity');
    fy4(i,:) = glmval(b4,x4,'identity');
    mse4(i) = mean((rand_y(i,:) - fy4(i,:)).^2);
    
    %For g5(x)
    x5 = [xval,xval2,xval3];    
    b5 = glmfit(x5 ,rand_y(i,:),'normal','link','identity');
    fy5(i,:) = glmval(b5,x5,'identity');
    mse5(i) = mean((rand_y(i,:) - fy5(i,:)).^2);
    
    %For g6(x)
    x6 = [xval,xval2,xval3,xval4];    
    b6 = glmfit(x6 ,rand_y(i,:),'normal','link','identity');
    fy6(i,:) = glmval(b6,x6,'identity');
    mse6(i) = mean((rand_y(i,:) - fy6(i,:)).^2);
end

%plot graphs
subplot(3,2,1)
histogram(mse1,10)
title('g1(x) = 1'),ylabel('Frequency'),xlabel('Mean Squared Error')
subplot(3,2,2)
histogram(mse2,10)
title('g2(x) = w0'),ylabel('Frequency'),xlabel('Mean Squared Error')
subplot(3,2,3)
histogram(mse3,10)
title('g3(x) = w0 + w1*x'),ylabel('Frequency'),xlabel('BiMean Squared Errorns')
subplot(3,2,4)
histogram(mse4,10)
title('g4(x) = w0 + w1*x + w2*x^2'),ylabel('Frequency'),xlabel('Mean Squared Error')
subplot(3,2,5)
histogram(mse5,10)
title('g5(x) = w0 + w1*x + w2*x^2 + x3*x^3'),ylabel('Frequency'),xlabel('Mean Squared Error')
subplot(3,2,6)
histogram(mse6,10)
title('g6(x) = w0 + w1*x + w2*x^2 + x3*x^3 + w4*x^4'),ylabel('Frequency'),xlabel('Mean Squared Error')

%Bias
true_y = (rand_x.^2)*2;
bias2 = [mean(mean((true_y-fy1).^2)), mean(mean((true_y-fy2).^2)), mean(mean((true_y-fy3).^2)), mean(mean((true_y-fy4).^2)), mean(mean((true_y-fy5).^2)), mean(mean((true_y-fy6).^2))];

%Variance
variance = [mean(mean((mean(fy1(:))-fy1).^2)), mean(mean((mean(fy2(:))-fy2).^2)), mean(mean((mean(fy3(:))-fy3).^2)), mean(mean((mean(fy4(:))-fy4).^2)), mean(mean((mean(fy5(:))-fy5).^2)), mean(mean((mean(fy6(:))-fy6).^2))];

output = [{'Bias2', 'Variance'}; [arrayfun(@num2str,bias2,'UniformOutput',false)',arrayfun(@num2str,variance,'UniformOutput',false)']];
output
end