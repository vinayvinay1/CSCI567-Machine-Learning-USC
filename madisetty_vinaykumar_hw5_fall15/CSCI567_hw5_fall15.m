
%Load Blob and Circle points
blob = load('hw5_blob.mat');
bpoints = blob.points;
circle = load('hw5_circle.mat');
cpoints = circle.points;

%4.2
hw542(bpoints);
hw542(cpoints);

%4.3
hw543(cpoints);

%4.4
[bu, bsigma, bindex] = hw544a(bpoints);
hw544b(bpoints, bindex);
bu
bsigma
