function hw631c( eigenvecs, x_trainm )

samples = [5500, 6500, 7500, 8000, 8500];
k = [1,5,10,20,80];

for i = 1:length(samples)
    subplot(length(k)+1,length(samples),i)
    imshow(double(reshape(x_trainm(samples(i),:),16,16)),[])
    title(['raw image #',num2str(samples(i))])
    
    ptr = length(samples)+i;
    for j = 1:length(k)
        eigen_subset = eigenvecs(:,1:k(j));
        x_compressed = x_trainm*eigen_subset;
        x_reconstruction = x_compressed*eigen_subset';
        subplot(length(k)+1,length(samples),ptr)   
        imshow(double(reshape(x_reconstruction(samples(i),:),16,16)),[])
        title(['s#',num2str(samples(i)),', #pc=',num2str(k(j))])
        ptr = ptr+length(samples);
    end  
end
end