%Task 1

radius = 1000;
users  = 100;

c      = 3e8; %Speed of light
fc     = 5e9; %center frequency
carriers = 52;

Bw     = 20e6;
PtGtGr = 10;
lambda = c./((fc-Bw/2)+Bw/carriers/2:Bw/carriers:(fc+Bw/2)-Bw/carriers/2);
L      = 1;

K      = 1.38e-23; %Boltzman constant
T      = 290;      %Temp in Kelvin
N      = K*T*Bw;   %Noise

%get user coordinates
points = generate_users(users, radius);

%plot circle
circle(0,0,radius);
hold on;

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
disp Distance: 
disp(sqrt(d2));

%Calcuate power received
%Pr = PtGtGr * lambda.^2 ./ ((4*pi)^2 * L) ./ d2;
Pr = zeros(length(d2),carriers);
for d = 1:length(d2)
    for l = 1:carriers
        Pr(d,l) = PtGtGr * lambda(l)^2 / ((4*pi)^2 * L) / d2(d);
    end
end
disp Pr:
disp(Pr);

%Add fading (what is this product called?)
Pr2 = Pr .* random('Rayleigh', 0.75, users, carriers);
disp 'Pr * Rayleigh:'
disp(Pr2);

%Calculate SNR
SNR = Pr2 ./ N;
disp SNR:
disp(SNR);

%shannon capacity
C = Bw/52 * log2(1 + SNR);
disp c:
disp(C)

%Sum per user
throughput = points;
for i = 1:users
    throughput(i,3) = sum(C(i,:));
end
disp Throughput:
disp(throughput);

avg = mean(throughput);
disp Avg:
disp(avg);

throughput = sortrows(throughput, 3);

disp Sorted:
disp(throughput);

%Plot five worst and legend
plot(throughput(1, 1), throughput(1, 2), '.', 'color',[0 0.9 0]);
plot(throughput(2, 1), throughput(2, 2), '.', 'color',[0 0.8 0.8]);
plot(throughput(3, 1), throughput(3, 2), '.', 'color',[0 0 0.8]);
plot(throughput(4, 1), throughput(4, 2), '.', 'color',[0.8 0.8 0]);
plot(throughput(5, 1), throughput(5, 2), '.', 'color',[1 0 0]);

legend('Radius','Users','Fifth', 'Fourth', 'Third', 'Second', 'Worst')
legend('Location', 'EastOutside')
hold off;
