radius = 1000;
users  = 100;

c      = 3e8; %Speed of light
fc     = 5e9; %center frequency
carrs  = 52;  %number of carriers

Bw     = 20e6;
PtGtGr = 10;
lambda = c./((fc-Bw/2)+Bw/carrs/2:Bw/carrs:(fc+Bw/2)-Bw/carrs/2);
L      = 1;

K      = 1.38e-23; %Boltzman constant
T      = 290;      %Temp in Kelvin
N      = K*T*Bw;   %Noise

%make user coordinates
points = generate_users(users, radius);

%********** Task 1 ***********
%Simulate single BS

task1 = figure;
hold on;

%plot circle at x, y, radius
circle(0,0,radius);

%plot users
plot(points(:,1), points(:,2),'k+');
axis equal;
xlim([-radius-10 radius+10]);
ylim([-radius-10 radius+10]);
title('OFDMA Simulation')
xlabel('Position [m]');
ylabel('Position [m]');

%Calculate distance
d2 = points(:,1).^2 + points(:,2).^2;

%Calcuate power received
Pr = zeros(length(d2),carrs);
for d = 1:length(d2)
    for l = 1:carrs
        Pr(d,l) = PtGtGr * lambda(l)^2 / ((4*pi)^2 * L) / d2(d);
    end
end

%Add fading
Prf = Pr .* random('Rayleigh', 0.75, users, carrs);

%Calculate SNR
SNR = Prf ./ N;

%shannon capacity per channel per user
C = Bw/52 * log2(1 + SNR);

%Sum per user per channel
throughput = points;
for i = 1:users
    throughput(i, 3) = sum(C(i, :));
end

disp( 'Average throughput task 1 [bps]:' );
disp( mean(throughput(:,3)) );

%Sort the throughputs so we can find the lowest
throughput = sortrows(throughput, 3);

%Plot five worst and legend
plot(throughput(1, 1), throughput(1, 2), '.', 'MarkerSize', 20, 'color',[0.8 0.8 0.8]);
plot(throughput(2, 1), throughput(2, 2), '.', 'MarkerSize', 20, 'color',[0.6 0.6 0.6]);
plot(throughput(3, 1), throughput(3, 2), '.', 'MarkerSize', 20, 'color',[0.4 0.4 0.4]);
plot(throughput(4, 1), throughput(4, 2), '.', 'MarkerSize', 20, 'color',[0.2 0.2 0.2]);
plot(throughput(5, 1), throughput(5, 2), '.', 'MarkerSize', 20, 'color',[0 0 0]);

legend('Radius','Users','Fifth', 'Fourth', 'Third', 'Second', 'Worst')
legend('Location', 'EastOutside')
hold off;

%********** Task 2 **********
%Add neighbouring BS to previous

task2 = figure;
hold on;

%plot circles
circle(0,0,radius);
circle(2*radius,0,radius);

%plot users
plot(points(:,1), points(:,2),'k+');
axis equal;
xlim([-radius-10 3*radius+10]);
ylim([-radius-10 radius+10]);
title('OFDMA Simulation')
xlabel('Position [m]');
ylabel('Position [m]');

%Power received from second base station
d22 = (points(:,1)-2*radius).^2 + points(:,2).^2;
Pr2 = zeros(length(d2),carrs);
for d = 1:length(d22)
    for l = 1:carrs
        Pr2(d,l) = PtGtGr * lambda(l)^2 / ((4*pi)^2 * L) / d22(d);
    end
end

%Calculate SINR
SINR = Prf ./ (Pr2 + N);

%shannon capacity
C = Bw/52 * log2(1 + SINR);

%Sum per user
throughput = points;
for i = 1:users
    throughput(i,3) = sum(C(i,:));
end

disp( 'Average throughput task 2 [bps]:' );
disp( mean(throughput(:,3)) );

%Sort the throughputs again
throughput = sortrows(throughput, 3);

%Plot five worst and legend
plot(throughput(1, 1), throughput(1, 2), '.', 'MarkerSize', 20, 'color',[0.8 0.8 0.8]);
plot(throughput(2, 1), throughput(2, 2), '.', 'MarkerSize', 20, 'color',[0.6 0.6 0.6]);
plot(throughput(3, 1), throughput(3, 2), '.', 'MarkerSize', 20, 'color',[0.4 0.4 0.4]);
plot(throughput(4, 1), throughput(4, 2), '.', 'MarkerSize', 20, 'color',[0.2 0.2 0.2]);
plot(throughput(5, 1), throughput(5, 2), '.', 'MarkerSize', 20, 'color',[0 0 0]);

legend('Radius', 'Radius II', 'Users','Fifth', 'Fourth', 'Third', 'Second', 'Worst')
legend('Location', 'East')
hold off;
