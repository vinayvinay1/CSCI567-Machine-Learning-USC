function [bu, bsigma, bindex] = hw544a( ippoints )

k = 3;
[n,d] = size(ippoints);
likelihood = {};
iterations = zeros(1,5);
bu = [];
bsigma = [];
bindex = [];
for m = 1:5
    %Initialize parameters
    u = ippoints(randperm(length(ippoints(:,1)),k),:);
    sigma2 = cat(3,eye(d),eye(d),eye(d));
    pc(1:k) = 1/k;
    wnk = zeros(n,k);
   
    itr = 0;
    passign = zeros(n,1);
    cassign = [];
    ll = [];
    llmax = -Inf;
    while(~isequal(passign,cassign))
        itr = itr+1;
        passign = cassign;
        
        %E-step
        for p = 1:k
            wnk(:,p) = pc(p)*mvnpdf(ippoints, u(p,:), sigma2(:,:,p));
        end     
        temp = sum(wnk,2);
        temp = repmat(temp,1,k);
        wnk = wnk./temp;
        
        %M-step
        u = (wnk'*ippoints)./repmat(sum(wnk)',1,d);
        for i = 1:k
            numerator = zeros(d);
            for j = 1:n
                numerator = numerator + wnk(j,i)*(ippoints(j,:)-u(i,:))'*(ippoints(j,:)-u(i,:));
            end
           sigma2(:,:,i) = numerator/sum(wnk(:,i));           
        end
        pc = sum(wnk)/n;
  
        %Log Likelihood
        [sdist, sindex] = max(wnk,[],2);
        cassign = u;
        ll(itr) = sum(log(sdist));
        sum(log(sdist))
        
        if(isequal(passign,cassign))
            iterations(m) = itr;
            likelihood{m} = ll;
            if(ll(end)>llmax)
                llmax = ll(end);         
                bu = u;              
                bsigma = sigma2;               
                bindex = sindex;
            end
        end
    end
end

subplot(3,2,1)
plot(1:iterations(1),likelihood{1})
title('1st Run')
subplot(3,2,2)
plot(1:iterations(2),likelihood{2})
title('2nd Run')
subplot(3,2,3)
plot(1:iterations(3),likelihood{3})
title('3rd Run')
subplot(3,2,4)
plot(1:iterations(4),likelihood{4})
title('4th Run')
subplot(3,2,5)
plot(1:iterations(5),likelihood{5})
title('5th Run')
end