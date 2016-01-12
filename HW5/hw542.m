function hw542( ippoints )

k = [2,3,5];
[n,d] = size(ippoints);
colorindex = zeros(length(k),n);

for m = 1:length(k)
    %Initialize uk for k clusters
    uk = rand(k(m),d);
    
    itr = 0;
    passign = zeros(n,1);
    cassign = [];
    while(~isequal(passign,cassign))
        itr = itr+1;
        %Initialize rnk indicator matrix
        rnk = zeros(n,k(m));
        
        passign = cassign;
        distances = pdist2(ippoints, uk);
        [sdist, sindex] = min(distances,[],2);
        cassign = sindex;
        for i = 1:n
            rnk(i,sindex(i)) = 1;   
        end
        
        for j = 1:k(m)
            uk(j,:) =  (rnk(:,j)'*ippoints)/sum(rnk(:,j));
        end
        uk(isnan(uk)) = rand(1,1);
        
        if(isequal(passign,cassign))
            colorindex(m,:) = sindex';
        end       
    end
end

subplot(2,2,1)
scatter(ippoints(:,1),ippoints(:,2),[],colorindex(1,:))
title('K = 2')
subplot(2,2,2)
scatter(ippoints(:,1),ippoints(:,2),[],colorindex(2,:))
title('K = 3')
subplot(2,2,3)
scatter(ippoints(:,1),ippoints(:,2),[],colorindex(3,:))
title('K = 5')
end