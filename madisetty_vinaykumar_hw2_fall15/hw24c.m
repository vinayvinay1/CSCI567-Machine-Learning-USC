function hw24c( training_labels, training_features, headers )

numeric = [1,4,5,6,8];
mi = zeros(1,length(headers));

for i = 1:length(headers)
    d = sum(numeric == i);
    mi(i) = calculatemi(training_labels, training_features, i, d); 
end
output = [cellfun(@num2str, headers, 'UniformOutput', false); arrayfun(@num2str, mi, 'UniformOutput', false)];
output
end

function A = calculatemi(training_labels, training_features, head, d)
hy = 0;
hyonx = 0;

%form custom matrix of just X and Y and remove missing value rows
xymatrix = [training_labels, training_features(:, head)];
for i = length(training_features):-1:1
    if(isnan(xymatrix{i, 2}))
        xymatrix(i,:) = [];
    end
end

%Calculate H(Y)
survivors = sum(cell2mat(xymatrix(:,1)) == 1);
dead = sum(cell2mat(xymatrix(:,1)) == 0);
total = survivors+dead;
if(survivors == 0 || dead == 0)
    hy = 0;
else
    hy = -((survivors/total)*log(survivors/total) + (dead/total)*log(dead/total));
end

%Calculate H(Y|X)
if(d == 0) % Non numeric variables
    %Convert all cells to strings first to avoid errors
    xymatrix(:,2) = cellfun(@num2str, xymatrix(:,2), 'UniformOutput', false);
    [C, ia, ic] = unique(xymatrix(:,2));
    
    for i = 1:length(C)
        numofx = sum(ic == i);
        pyonx = 0;
        pnyonx = 0;
        idx = find(ic == i);idx = idx';
        for j = idx
            if(xymatrix{j,1} == 1)
                pyonx = pyonx +1;
            else
                pnyonx = pnyonx + 1;
            end        
        end
        temp = (numofx/total)*((pyonx/numofx)*log(pyonx/numofx) + (pnyonx/numofx)*log(pnyonx/numofx));
        if(isnan(temp))
            temp = 0;
        end
        hyonx = hyonx + temp;
    end  
else  %numeric variables
    [C, ia, ic] = unique(cell2mat(xymatrix(:,2)));
    if(length(C) <=10) % Dont discretize
        for i = 1:length(C)
        
            numofx = sum(ic == i);        
            pyonx = 0;        
            pnyonx = 0;        
            idx = find(ic == i);idx = idx';      
            for j = idx            
                if(xymatrix{j,1} == 1)                
                    pyonx = pyonx +1;           
                else                   
                    pnyonx = pnyonx + 1;
                end        
            end
            temp = (numofx/total)*((pyonx/numofx)*log(pyonx/numofx) + (pnyonx/numofx)*log(pnyonx/numofx));
            if(isnan(temp))
                temp = 0;
            end
            hyonx = hyonx + temp;
        end        
    else % Discretize to 10 equal density bins
        %Find cutpoints
        sortedm = sort(cell2mat(xymatrix(:,2)));
        range = ceil(length(sortedm)/10);
        cutpoints = zeros(1,11);
        cutpoints(11) = sortedm(end);
        sidx = 1;
        for i = 1:10
            cutpoints(i) = sortedm(sidx);
            sidx = sidx + range;
        end
           
        for i = 1:(length(cutpoints) - 1)           
            numofx = sum(cell2mat(xymatrix(:,2))>= cutpoints(i) & cell2mat(xymatrix(:,2))< cutpoints(i+1));        
            pyonx = 0;        
            pnyonx = 0;        
            idx = find(cell2mat(xymatrix(:,2))>= cutpoints(i) & cell2mat(xymatrix(:,2))< cutpoints(i+1));
            idx = idx';      
            for j = idx            
                if(xymatrix{j,1} == 1)                
                    pyonx = pyonx +1;           
                else                   
                    pnyonx = pnyonx + 1;
                end        
            end
            temp = (numofx/total)*((pyonx/numofx)*log(pyonx/numofx) + (pnyonx/numofx)*log(pnyonx/numofx));
            if(isnan(temp))
                temp = 0;
            end
            hyonx = hyonx + temp;           
        end     
    end
end
A = hy + hyonx;
end