function [train_data,train_label] = HW152prep(filename)
data = importdata(filename);
trpoints = data;

N = length(trpoints);
D = length(strsplit(trpoints{1}, ','));

train_data = zeros(N,(3*D-3));
train_label = zeros(N,1);

tttmap = containers.Map({'x','o','b','positive','negative'},{[1,0,0],[0,1,0],[0,0,1],1,0});

for i = [1:N]
    sample = strsplit(trpoints{i}, ',');
    train_label(i) = tttmap(sample{10});
    for j = [1:9]
        word = sample{j};
        code = tttmap(word);
        for k = [1:3]
            train_data(i,(3*(j-1)+k)) = code(k);
        end
    end    
end