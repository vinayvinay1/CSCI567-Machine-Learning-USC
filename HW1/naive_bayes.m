function [new_accu, train_accu] = naive_bayes(train_data, train_label, new_data, new_label)
% naive bayes classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%
% Outstrput:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data 
%
% CSCI 567: Machine Learning, Fall 2015, Homework 1
xparameters = [sum(train_data(train_label==1,:))/size(train_label(train_label==1),1); sum(train_data(train_label==2,:))/size(train_label(train_label==2),1); sum(train_data(train_label==3,:))/size(train_label(train_label==3),1); sum(train_data(train_label==4,:))/size(train_label(train_label==4),1)];
xparameters(xparameters==0)=0.1;
yparameters = [size(train_label(train_label==1),1)/size(train_label,1), size(train_label(train_label==2),1)/size(train_label,1), size(train_label(train_label==3),1)/size(train_label,1), size(train_label(train_label==4),1)/size(train_label,1)];
logXparameters = log(xparameters);
logYparameters = log(yparameters);


logEstimated = (train_data * transpose(logXparameters)+ repmat(logYparameters,size(train_label,1),1));
estimated = exp(logEstimated);
[estimatedMaxVal estimatedMaxInd] = max(estimated,[],2);
train_accu = size(train_data(estimatedMaxInd==train_label),1)/size(train_data,1);


logEstimated = (new_data * transpose(logXparameters)+ repmat(logYparameters,size(new_label,1),1));
estimated = exp(logEstimated);
[estimatedMaxVal estimatedMaxInd] = max(estimated,[],2);
new_accu = size(new_data(estimatedMaxInd==new_label),1)/size(new_data,1);