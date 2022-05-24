%% Script for SIR model
%% Part 1
% x_t+1 = Ax_t used as base equation for SIRD model

population = 100;                                 % determine population size
x_initial = population*[1; 0; 0; 0];               % determine initial x-vector
% initially everyone is susceptible 

% create matrix A, which is matrix given in Section 9.3 of the book:
A = [0.95,0.04,0,0;0.05,0.85,0,0;0,0.1,1,0;0,0.01,0,1];

% we will simulate the system over 50 days, with increments of 1 day
t = 0:1:50;

% create system named "system"
system = ss(A,[],[],[],[]);                 % create system
[~,~,x] = lsim(system ,[], t , x_initial);  % simulate
x = x';                                     % flip x so we can plot it
                                            % properly

figure();
hold on;
plot(t,x);
title('SIRD Model Simulation')
xlabel('Time (days)');
ylabel('Percentage of Population');
legend('S','I','R','D','location', 'northeast');

%% Part 2
% Matrices B, C, and D are for the other populations' models
B = [0.95,0,0,0;0.05,0.75,0,0;0,0.24,1,0;0,0.01,0,1];
C = [0.70,0,0,0;0.30,0.75,0,0;0,0.10,1,0;0,0.15,0,1];
D = [0.50,0,0,0;0.50,0.15,0,0;0,0.05,1,0;0,0.80,0,1];


%population numbers for different countries
population = 100;
population2 = 400;
population3 = 50;

% determine initial x-vector for each population
x_initial = population*[1; 0; 0; 0];       
x_initial2 = population2*[1; 0; 0; 0];
x_initial3 = population3*[1; 0; 0; 0];
x_initial3Pop = cat(1, x_initial, x_initial2, x_initial3);

% create matrices for each population. 
Pop1 = cat(1,B,zeros(4),zeros(4));
Pop2 = cat(1,zeros(4),C,zeros(4));
Pop3 = cat(1,zeros(4),zeros(4),D);


% which is the SIRD model for 3 different populations
threePopulations = cat(2,Pop1,Pop2,Pop3);

% we will simulate the system over 50 days, with increments of 1 day
t = 0:1:50;

% create system named "system2"
system2 = ss(threePopulations,[],[],[],[]);       % create system
[~,~,x2] = lsim(system2 ,[], t , x_initial3Pop);  % simulate
x2 = x2';                                     
% flip x so we can plot it properly

figure();
subplot(3,1,1);
plot(t,x2(1:4,:));
title('SIRD Model Population 1 (Canada)')
xlabel('Time (days)');
ylabel('% of Population');
legend('S','I','R','D','location', 'northeast');

subplot(3,1,2);
plot(t,x2(5:8,:));
title('SIRD Model Population 2 (Bangladesh)')
xlabel('Time (days)');
ylabel('% of Population');
legend('S','I','R','D','location', 'northeast');

subplot(3,1,3);
plot(t,x2(9:12,:));
title('SIRD Model Population 3 (Malawi)')
xlabel('Time (days)');
ylabel('% of Population');
legend('S','I','R','D','location', 'northeast');

% People are moving across populations, except the recovered and deceased
% people. 
% When infected people recover they become immune to the disease, so people
% can't go from infected to susceptible. 
% Susceptible people stay susceptible when they move across populations,
% and infected people stay infected when they move across populations. So
% people dont't change state when they move to another population. 

acrossPop = threePopulations;
acrossPop(1,1) = 0.85;
acrossPop(2,1) = 0.04;
acrossPop(5,1) = 0.04;
acrossPop(9,1) = 0.07;

acrossPop(2,2) = 0.50;
acrossPop(3,2) = 0.42;
acrossPop(4,2) = 0.04;
acrossPop(6,2) = 0.03;
acrossPop(10,2) = 0.01;

acrossPop(1,5) = 0.33;
acrossPop(5,5) = 0.46;
acrossPop(6,5) = 0.15;
acrossPop(9,5) = 0.06;

acrossPop(2,6) = 0.23;
acrossPop(6,6) = 0.56;
acrossPop(7,6) = 0.10;
acrossPop(8,6) = 0.08;
acrossPop(10,6) = 0.03;

acrossPop(1,9) = 0.20;
acrossPop(5,9) = 0.05;
acrossPop(9,9) = 0.50;
acrossPop(10,9) = 0.25;

acrossPop(2,10) = 0.13;
acrossPop(6,10) = 0.02;
acrossPop(10,10) = 0.10;
acrossPop(11,10) = 0.05;
acrossPop(12,10) = 0.70;

system3 = ss(acrossPop,[],[],[],[]);              % create system
[~,~,x3] = lsim(system3 ,[], t , x_initial3Pop);  % simulate
x3 = x3';                                     

figure();
subplot(3,1,1);
plot(t,x3(1:4,:));
title('Canada After Across Population Movement')
xlabel('Time (days)');
ylabel('% of Population');
legend('S','I','R','D','location', 'northeast');

subplot(3,1,2);
plot(t,x3(5:8,:));
title('Bangladesh After Across Population Movement')
xlabel('Time (days)');
ylabel('% of Population');
legend('S','I','R','D','location', 'northeast');

subplot(3,1,3);
plot(t,x3(9:12,:));
title('Malawi After Across Population Movement')
xlabel('Time (days)');
ylabel('% of Population');
legend('S','I','R','D','location', 'northeast');


%% Part 3
%create immunity matrix for the population.
% immunization is given only to the infected people. So people who go from
% infected to susceptible don't get the cure. Susceptible people also don't
% get the cure. In addition, there is limited amount of the vaccine, so not
% everyone who is infected can get the vaccine.
immunization = [0,0,0,0;0,-0.3,0,0;0,0.3,0,0;0,0,0,0];
newA = A + immunization;
population = 100;                                
x_initial = population*[1; 0; 0; 0]; 

% we will simulate the system over 50 days, with increments of 1 day
t = 0:1:50;

% create system with immunization.
systemI = ss(newA,[],[],[],[]);
[~,~,x4] = lsim(systemI ,[], t , x_initial);  
x4 = x4';                                     

figure();
hold on;
plot(t,x4);
title('SIRD Model Simulation with Immunization')
xlabel('Time (days)');
ylabel('Percentage of Population');
legend('S','I','R','D','location', 'northeast');

