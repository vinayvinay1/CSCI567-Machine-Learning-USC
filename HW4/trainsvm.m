function [ w,b ] = trainsvm( ptrain_features, train_labels, c)

train_labels = train_labels';
[n, d] = size(ptrain_features);
H = diag([ones(d,1); zeros(n+1,1)]);

A = -[repmat(train_labels, 1, d+1) .* [ptrain_features, ones(n,1)], eye(n)];
lb = -[inf(d+1,1); zeros(n,1)];
B = -ones(n,1);
f = [zeros(d+1,1); c*ones(n,1)];
                    
[x,fval,exitflag,output,lambda] = quadprog(H, f, double(A), B, [], [], lb);

b = x(d+1);
w = x(1:d);
end

