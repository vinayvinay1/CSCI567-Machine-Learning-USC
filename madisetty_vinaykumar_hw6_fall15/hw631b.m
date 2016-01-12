function hw631b( eigenvecs )
display_count = 8;
for i = 1:display_count
    subplot(2,4,i)
    imshow(double(reshape(eigenvecs(:,i),16,16)),[])
    title(i)
end
end