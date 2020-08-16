close all;
i=-10:0.01:10;
y=sigmoid(i);
figure();
plot(zeros(size(i)), y, 'Color', 'r', 'LineWidth', 2);
hold on
plot(i, y, 'Color', 'b', 'LineWidth', 2);
z1=1.05*y;
figure();
plot(zeros(size(i)), z1, 'Color', 'r', 'LineWidth', 2);
hold on
axis([-10,10,min(z1),max(z1)]);
plot(i, z1, 'Color', 'b', 'LineWidth', 2);
z2=z1-0.05/2;
figure();
plot(zeros(size(i)), z2, 'Color', 'r', 'LineWidth', 2);
hold on
axis([-10,10,min(z2),max(z2)]);
plot(i, z2, 'Color', 'b', 'LineWidth', 2);