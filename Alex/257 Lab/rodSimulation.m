%Number of steps
Nx = 4; %Number of steps in length
Nt = 100000; %Number of steps in time
t0 = 0; %Start time (s)
tf = 1000; %End time (s)
x0 = 0; %Start length (m)
xf = 0.3; %End length (m)

%Constants
kc = 10; %Convection coefficient of horizontal Al rod (W/(m^2K))
k = 205; %Constant of conductivity of Al (W/(mK))
a = 0.01; %Radius of the rod (m)
Tl = 0; %Temperature of left side of rod (K)
Tr = 0; %Temperature of right side of rod (K)
e = 0.95; %Emmisivity of rod
SBc = 5.67e-8; %Stefan-Boltzmann constant (W/(m^2K^4))
Tamb = 298; %Ambient temperature (K)
Cp = 910; %Specific heat capacity of Al (J/(K kg))
rho = 2.7e3; %Density of Al (kg/m^3)

%Calculated numbers
dx = (xf - x0)/(Nx);
dt = (tf - t0)/(Nt);
Ploss_convec = @(Tx) kc*2*pi*a*dx*(Tx-Tamb); %Power lost due to convection (W)
Ploss_rad = @(Tx) e*SBc*2*pi*a*dx*(Tx.^4-Tamb^4); %Power lost due to radiation (W)
dT = @(P) (P * dt)/(Cp * pi*a^2*dx*rho); %Temperature change in chunk (K)

%==============
%= Simulation =
%==============

%Constants
Pinl = 10; %Power into the left side of the rod (W)

%Storage
T = zeros(Nx, Nt); %Array of temp over time, indices are (x,t)

%initial
T(:,1) = ones(Nx,1)*Tamb;

for time = 1:Nt-1
    T(1,time+1)=T(1,time)+dT(Pinl);
    T(2:Nx-1,time+1)=T(2:Nx-1,time)+(k/(Cp*rho))*((T(3:Nx,time)-2*T(2:Nx-1,time)+T(1:Nx-2,time))./dx^2)*dt;
    T(2:Nx-1, time+1) = T(2:Nx-1, time+1) - dT(Ploss_convec(T(2:Nx-1, time+1))) - dT(Ploss_rad(T(2:Nx-1, time+1)));
    T(Nx,time+1)=Tamb;
end
Temp_pos1 = T(1,:);
dT(Ploss_convec([300 300 300 300 300]))
contour(T);
time = linspace(0,tf,Nt)/60;
plot(time, Temp_pos1);
