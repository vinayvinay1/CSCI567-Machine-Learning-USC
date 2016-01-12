function hw35d

rand_x = zeros(100,100);
rand_y = zeros(100,100);
lambda = [0.01;0.1;1;10];
bias2 = zeros(1,4);
variance = zeros(1,4);


for i = 1:100
    rand_x(i,:) = 2.*rand(1,100) -1;
   for j = 1:100
       rand_y(i,j) = 2*(rand_x(i,j)^2) + normrnd(0,sqrt(0.1));
   end  
end

fy1 = zeros(100,100);
fy2 = zeros(100,100);
fy3 = zeros(100,100);
fy4 = zeros(100,100);

%Calculate MSE for all 6 g(x)
for i = 1:100
    xval = rand_x(i,:)';
    xval2 = rand_x(i,:)'.^2;
    
    %Perform Ridge Regression
    x = [xval,xval2];
    b = ridge(rand_y(i,:)',x,lambda,0);
    yval = ridgeval(b,x,lambda);
    fy1(i,:) = yval(1,:);
    fy2(i,:) = yval(2,:);
    fy3(i,:) = yval(3,:);
    fy4(i,:) = yval(4,:);

end

 %Bias
 true_y = (rand_x.^2)*2;
 bias2 = [mean(mean((true_y-fy1).^2)), mean(mean((true_y-fy2).^2)), mean(mean((true_y-fy3).^2)), mean(mean((true_y-fy4).^2))];
 
 %Variance
 variance = [mean(mean((mean(fy1(:))-fy1).^2)), mean(mean((mean(fy2(:))-fy2).^2)), mean(mean((mean(fy3(:))-fy3).^2)), mean(mean((mean(fy4(:))-fy4).^2))];
 
 output = [{'Bias2', 'Variance'}; [arrayfun(@num2str,bias2,'UniformOutput',false)',arrayfun(@num2str,variance,'UniformOutput',false)']];
 output
end

function yval = ridgeval(b,x,lambda)
lambda = lambda';
yval = zeros(length(lambda(1,:)),length(x(:,1)));
for i = 1:length(lambda(1,:))
    bval = b(:,i)';
    for j = 1:length(x(:,1))
        yval(i,j) = sum(x(j,:).*bval(2:end))+bval(1);
    end
end
end