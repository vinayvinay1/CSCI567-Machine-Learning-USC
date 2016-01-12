function len = HW151aepa(filename);
data = importdata(filename);
trpoints = data.x_tr;

x = trpoints;
x= sort(x);
len = length(trpoints);
y = [1:1:len];
y1 =[];
for h = [0.5,0.25,0.20,0.125,0.1]
    const = (3/(4*len*h^3));
    for k = [1:len]
        summation = 0;
        for i = [1:len]
            if (abs((x(k)-x(i))/h) <= 1)
                summation = summation + (h^2-(x(k)-x(i))^2);
            end
        end
        y(k) = const*summation;
    end
    y1(end+1,:) = y;
end
plot(x,y1(1,:),'g',x,y1(2,:),'k',x,y1(3,:),'b',x,y1(4,:),'r',x,y1(5,:),'c'), legend('h=10000','h=10000.0002','h=10000.0004','h=10000.0006','h=10000.0008')
end