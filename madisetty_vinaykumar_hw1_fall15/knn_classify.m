function [new_accu, train_accu] = knn_classify(train_data, train_label, new_data, new_label, k)
% k-nearest neighbor classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%  K: number of nearest neighbors
%
% Output:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data (using leave-one-out
%  strategy)
%
% CSCI 567: Machine Learning, Fall 2015, Homework 1
distance = pdist(train_data);
distanceMatrix = squareform(distance);
distanceMatrix(distanceMatrix==0)=inf;
sortedDistance = sort(distanceMatrix, 2);

for i=1:size(train_data,1)
tempIndex = find(distanceMatrix(i,:)<=sortedDistance(i,k));
finalIndex(i,1:k)= tempIndex(1:k);
end
finalIndex=finalIndex(:,1:k);

estimatedClass=mode(train_label(finalIndex),2);
train_accu = size(train_data(estimatedClass==train_label),1)/size(train_data,1);

% testing
total_data = [train_data; new_data];
distance = pdist(total_data);
distanceMatrix = squareform(distance);
distanceMatrix = distanceMatrix((size(train_data,1)+1):size(total_data,1), 1:size(train_data,1));
sortedDistance = sort(distanceMatrix, 2);

for i=1:size(new_data,1)
tempIndex = find(distanceMatrix(i,:)<=sortedDistance(i,k));
finalIndexTest(i,1:k)= tempIndex(1:k);
end
finalIndexTest=finalIndexTest(:,1:k);

estimatedClass=mode(train_label(finalIndexTest),2);
new_accu = size(new_data(estimatedClass==new_label),1)/size(new_data,1);