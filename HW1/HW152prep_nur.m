function [train_data,train_label] = HW152prep_nur(filename)
data = importdata(filename);
trpoints = data;

N = length(trpoints);
D = length(strsplit(trpoints{1}, ','));

train_data = zeros(N,27);
train_label = zeros(N,5);

nurmap1 = containers.Map({'usual','pretentious','great_pret'},{[1,0,0],[0,1,0],[0,0,1]});
nurmap2 = containers.Map({'proper','less_proper','improper','critical','very_crit'},{[1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,0,0,1]});
nurmap3 = containers.Map({'complete','completed','incomplete','foster'},{[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]});
nurmap4 = containers.Map({'1','2','3','more'},{[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]});
nurmap5 = containers.Map({'convenient','less_conv','critical'},{[1,0,0],[0,1,0],[0,0,1]});
nurmap6 = containers.Map({'convenient','inconv'},{[1,0],[0,1]});
nurmap7 = containers.Map({'nonprob','slightly_prob','problematic'},{[1,0,0],[0,1,0],[0,0,1]});
nurmap8 = containers.Map({'recommended','priority','not_recom'},{[1,0,0],[0,1,0],[0,0,1]});
nurmap9 = containers.Map({'spec_prior','priority','not_recom','recommend','very_recom'},{[1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,0,0,1]});

nurmap = {nurmap1,nurmap2,nurmap3,nurmap4,nurmap5,nurmap6,nurmap7,nurmap8,nurmap9};

for i = [1:N]
    sample = strsplit(trpoints{i}, ',');
    labelcode = nurmap9(sample{9});
    labelcodelen = length(labelcode);
    for l = [1:labelcodelen]
        train_label(i,l) = labelcode(l);
    end
    
    
    for j = [1:8]      
        word = sample{j};         
        code = nurmap{j}(word);        
        codelen = length(code);
        for k = [1:codelen]             
            train_data(i,(3*(j-1)+k)) = code(k);         
        end        
     end  
end