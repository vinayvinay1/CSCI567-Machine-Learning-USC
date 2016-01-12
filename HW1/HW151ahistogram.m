function len = HW151ahistogram(filename);
data = importdata(filename);
trpoints = data.x_tr;

x = trpoints;
x= sort(x);
len = length(trpoints);
y = [1:1:len];
y1 =[];
for K = [2,4,5,8,10]
    const = (K/len);
    w = 0;
    Bk = 1/K;
    for k = [1:len]
        summation = 0;
        for i = [1:K]
            freq = sum(x >= (Bk*i -Bk) & x < (Bk*i));
            if (x(k) >= (Bk*i -Bk) & x(k) < (Bk*i))
                summation = summation + freq;
            end
        end
        y(k) = const*summation;
    end
    y1(end+1,:) = y;
end
plot(x,y1(1,:),'g',x,y1(2,:),'k',x,y1(3,:),'b',x,y1(4,:),'r',x,y1(5,:),'c'), legend('K=2','K=4','K=5','K=8','K=10')