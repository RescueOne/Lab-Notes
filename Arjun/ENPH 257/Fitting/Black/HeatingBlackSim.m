%Constants for fit
kc = 9.7098; %Convection coefficient of horizontal Al rod (W/(m^2K))
k = 188.1926; %Constant of conductivity of Al (W/(mK))
e = 0.9772; %Emmisivity of sandblasted Al rod
Cp = 908.0408; %Specific heat capacity of Al (J/(K kg))
loss = 0.2121; %Fractional loss of power to environment

%Power
V = 15.1; %V, voltage into power resistor
I = 0.68; %A, current into power resistor
Ppower = V*I %W
Pinl = Ppower*(1-loss) %Power into the left side of the rod (W)

%Number of steps
Nx = 140; %Number of steps in length
Nt = 100000; %Number of steps in time
t0 = 0; %Start time (s)
tf = 1900; %End time (s)
x0 = 0; %Start length (m)
xf = 0.3; %End length (m)

%Constants
a = 0.011; %Radius of the rod (m)
SBc = 5.67e-8; %Stefan-Boltzmann constant (W/(m^2K^4))
Tamb = 273+31; %Ambient temperature (K)
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

%Storage
T = zeros(Nx, Nt); %Array o temp over time, indices are (x,t)

%initial
T(:,1) = ones(Nx,1)*(273+31); %Set all temperatures to Tamb

for time = 1:Nt-1
    %power in to and conduction out of first slice
    T(1,time+1)=T(1,time)+dT(Pinl)+((k/(Cp*rho))*(T(2,time)-T(1,time))./dx^2)*dt;
    
    %temperature changes due to conduction along rod
    T(2:Nx-1,time+1)=T(2:Nx-1,time)+(k/(Cp*rho))*((T(3:Nx,time)-2*T(2:Nx-1,time)+T(1:Nx-2,time))./dx^2)*dt;
    T(Nx,time+1) = T(Nx,time)-((k/(Cp*rho))*(T(Nx,time)-T(Nx-1,time))./dx^2)*dt;
    
    %temperature changes due to loss in convection and radiation
    T(1:Nx,time+1)=T(1:Nx,time+1) - dT_convec(T(1:Nx,time+1)) - dT_rad(T(1:Nx,time+1));
    
    %convection and radiation at cold and hot end of rod
    T(Nx,time+1)=T(Nx,time+1) - dT_convec_end(T(Nx,time+1)) - dT_rad_end(T(Nx,time+1));
end


% Point trim for data (to allow for time it takes to heat power resistor)
notTrimmed = false; 
if notTrimmed
    l = length(T1);
    numTrim = 4;
    T1 = T1(numTrim:l);
    T2 = T2(numTrim:l);
    T3 = T3(numTrim:l);
    T4 = T4(numTrim:l);
    T5 = T5(numTrim:l);
    timeDATA = timeDATA(1:length(T1));
end

timeSim = linspace(0,tf,Nt);

% Plot of all points of rod simulation
% for position = 1:Nx
%     plot(timeSim,(T(position,:)-273));
%     hold on;
% end

plot(timeSim,(T(1,:)-273));
hold on;
plot(timeSim,(T(Nx,:)-273));
plot(timeSim,(T(floor(Nx/3),:)-273));
plot(timeSim,(T(floor(Nx*2/3),:)-273));

xlabel('Time (Seconds)');
ylabel('Temp (C)');

plot(timeDATA, T1, 'c', timeDATA, T2, 'y', timeDATA, T3, 'g', timeDATA, T4, 'r', timeDATA, T5, 'm')

% Calculate chai squared values
X1 = zeros(1,length(timeDATA));
X2 = zeros(1,length(timeDATA));
X3 = zeros(1,length(timeDATA));
X4 = zeros(1,length(timeDATA));
T = T-273;
for tindex = 1:length(timeDATA)
   % Getting correct indices
   tcur = timeDATA(tindex);
   tmp = abs(timeSim-tcur);
   [idx idx] = min(tmp); %index of closest value
   TData1 = T1(tindex);
   TSim1 = T(Nx,idx);
   X1(tindex) = (TData1-TSim1)^2;
   
   TData2 = T2(tindex);
   TSim2 = T(floor(Nx*2/3),idx);
   X2(tindex) = (TData2-TSim2)^2;
   
   TData3 = T3(tindex);
   TSim3 = T(floor(Nx/3),idx);
   X3(tindex) = (TData3-TSim3)^2;
   
   TData4 = T4(tindex);
   TSim4 = T(1,idx);
   X4(tindex) = (TData4-TSim4)^2;
end

Xsquare1 = sum(X1)/length(X1)
Xsquare2 = sum(X2)/length(X2)
Xsquare3 = sum(X3)/length(X3)
Xsquare4 = sum(X4)/length(X4)

(Xsquare1+Xsquare2+Xsquare3+Xsquare4)/4

hold off;