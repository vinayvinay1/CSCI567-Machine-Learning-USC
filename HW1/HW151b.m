function len = HW151b(filename);
data = importdata(filename);
trpoints = data.x_te;

x = trpoints;
xshuffled = reshape(x,[19,500]);
h = [0.5,0.25,0.20,0.125,0.1];



len = length(trpoints);
y = [1:1:len];
y1 =[];
for h = [0.5,0.25,0.20,0.125,0.1]
    const = (1/(sqrt(2*pi)*len*h));
    for k = [1:len]
    summation = 0;
    for i = [1:len]
        summation = summation + exp((-(x(k)-x(i))^2)/(2*h^2));
    end
    y(k) = const*summation;
    end
    y1(end+1,:) = y;
end
axis auto
plot(x,y1(1,:),'g',x,y1(2,:),'k',x,y1(3,:),'b',x,y1(4,:),'r',x,y1(5,:),'c'), legend('h=1','h=1.1','h=1.15','h=1.2','h=1.25')
end