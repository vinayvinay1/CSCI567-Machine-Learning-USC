
%Load Train and Test data
data = load('hw6_pca.mat');
x_train = data.X.train;
y_train = data.y.train;
x_test = data.X.test;
y_test = data.y.test;

%Mean center the X data
[n,d] = size(x_train);
meanval = nanmean(x_train);
meanmat = repmat(meanval,n,1);
x_trainm = (x_train - meanmat);
[ntest,dtest] = size(x_test);
meanmattest = repmat(meanval,ntest,1);
x_testm = (x_test - meanmattest);

%3.1(a)
eigenvecs = get_sorted_eigenvecs(x_trainm);

%3.1(b)
hw631b(eigenvecs);

%3.1(c)
hw631c(eigenvecs,x_trainm);

%3.1(d)
hw631d(eigenvecs, x_trainm, x_testm, y_train, y_test);

%Load HMM Data
load('hw6_hmm_test_normal.mat');
load('hw6_hmm_test_trojan.mat');
load('hw6_hmm_train.mat');

