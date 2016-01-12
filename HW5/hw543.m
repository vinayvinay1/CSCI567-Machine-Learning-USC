function hw543( ippoints )

k = 2;
[n,d] = size(ippoints);
colorindex = zeros(length(k),n);

for m = 1:length(k)
    %Randomly partition points into k clusters
    rnk = zeros(n,k(m));
    for i=1:n
        if(i<=k(m))
            rnk(i,i)=1;        
        else
            rnk(i,randperm(k(m),1))=1;  
        end             
    end
    
    rnk = zeros(n,k(m));
    for i=1:n
        if(sqrt(sum(ippoints(i,:).^2))<=0.6)
            rnk(i,1)=1;
            colorindex(m,i) = 1;
        else
            rnk(i,2)=1; 
            colorindex(m,i) = 2;
       end             
    end

    %Compute Kernel Matrix
    kmat = exp(-10*(pdist2(ippoints, ippoints)).^2);
    
    itr = 0;
    passign = zeros(n,1);
    cassign = [];
    while(~isequal(passign,cassign))
        itr = itr+1;
        passign = cassign;
        
        %Calculate the Squared part of Kernalized distance
        cpart = zeros(1,k(m));
     
        for i = 1:k(m)
            temp = rnk(:,i)*rnk(:,i)';
            cpart(i) = (sum(sum((temp.*kmat))))/(sum(rnk(:,i))^2); 
        end       
        
        distances = zeros(n,k(m));
        for l = 1:n
           for p = 1:k(m)
               a = kmat(l,l);
               b = kmat(l,:)*rnk(:,p)/(sum(rnk(:,p)));
               c = cpart(p);
               distances(l,p) = a-2*b+c;  
           end
        end
        
        %Initialize rnk indicator matrix for next iteration
        rnk = zeros(n,k(m));
            
        [sdist, sindex] = min(distances,[],2);
        cassign = sindex;
        for i = 1:n
            rnk(i,sindex(i)) = 1;   
        end
        
        if(isequal(passign,cassign))
            colorindex(m,:) = sindex';
        end
    end
end

scatter(ippoints(:,1),ippoints(:,2),[],colorindex(1,:))
title('K = 2')
end