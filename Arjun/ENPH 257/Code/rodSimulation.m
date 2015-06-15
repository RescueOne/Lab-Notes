%Number of steps
Nx = 100; %Number of steps in length
Nt = 100000; %Number of steps in time
t0 = 0; %Start time (s)
tf = 2800; %End time (s)
x0 = 0; %Start length (m)
xf = 0.3; %End length (m)

%Constants
kc = 13.5; %Convection coefficient of horizontal Al rod (W/(m^2K))
k = 160; %Constant of conductivity of Al (W/(mK))
a = 0.011; %Radius of the rod (m)
e = .21; %Emmisivity of sandblasted Al rod
SBc = 5.67e-8; %Stefan-Boltzmann constant (W/(m^2K^4))
Tamb = 298+7; %Ambient temperature (K)
Cp = 850; %Specific heat capacity of Al (J/(K kg))
rho = 2.7e3; %Density of Al (kg/m^3)

%Calculated numbers
dx = (xf - x0)/(Nx);
dt = (tf - t0)/(Nt);
dT_convec = @(Tx) (kc*2*(Tx-Tamb)*dt)/(Cp*rho*a); %Temperature change due to convection (K)
dT_rad = @(Tx) (e*SBc*2*(Tx.^4-Tamb^4)*dt)/(Cp*rho*a); %Temperature change due to radiation (K)
dT_convec_end = @(Tx) (kc*(Tx-Tamb)*dt)/(Cp*rho*dx);
dT_rad_end = @(Tx) (e*SBc*(Tx.^4-Tamb^4)*dt)/(Cp*rho*dx);
dT = @(P) (P * dt)/(Cp * pi*a^2*dx*rho); %Temperature change in chunk (K)

%==============
%= Simulation =
%==============

%Constants
Pinl = 6.5; %Power into the left side of the rod (W)

%Storage
T = zeros(Nx, Nt); %Array o temp over time, indices are (x,t)

%initial
T(:,1) = ones(Nx,1)*(273+28); %Set all temperatures to Tamb

for time = 1:Nt-1
    %power in to rod
    T(1,time+1)=T(1,time)+dT(Pinl);
    
    %temperature changes due to conduction
    %along rod
    T(2:Nx-1,time+1)=T(2:Nx-1,time)+(k/(Cp*rho))*((T(3:Nx,time)-2*T(2:Nx-1,time)+T(1:Nx-2,time))./dx^2)*dt;
    T(1,time+1) = T(1,time+1)+((k/(Cp*rho))*(T(2,time)-T(1,time+1))./dx^2)*dt;
    T(Nx,time+1) = T(Nx,time)-((k/(Cp*rho))*(T(Nx,time)-T(Nx-1,time))./dx^2)*dt;
    
    %temperature changes due to loss in convection and radiation
    %along rod
    T(1:Nx,time+1)=T(1:Nx,time+1) - dT_convec(T(1:Nx,time+1)) - dT_rad(T(1:Nx,time+1));
    
    %at cold and hot end of rod
    T(Nx,time+1)=T(Nx,time+1) - dT_convec_end(T(Nx,time+1)) - dT_rad_end(T(Nx,time+1));
end

timeSim = linspace(0,tf,Nt);

% for position = 1:Nx
%     plot(timeSim,(T(position,:)-273));
%     hold on;
% end

plot(timeSim,(T(1,:)-273));
hold on
plot(timeSim,(T(Nx,:)-273));
plot(timeSim,(T(floor(Nx/3),:)-273));
plot(timeSim,(T(floor(Nx*2/3),:)-273));

xlabel('Time (Seconds)');
ylabel('Temp (C)');

timeDATA = timeDATA(1:size(T1, 2));
plot(timeDATA, T1, 'c', timeDATA, T2, 'y', timeDATA, T3, 'g', timeDATA, T4, 'r', timeDATA, T5, 'm')

hold off;