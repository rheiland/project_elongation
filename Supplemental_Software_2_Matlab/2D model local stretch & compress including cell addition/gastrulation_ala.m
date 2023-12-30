% Originally coded by Wenzhe Ma
% Version 5/12/16 introduces new cells through iterations
% this function runs the simulation of gastrulation-elongation
% an input cut area can be specified, which would cause a cutting event at
% specified time
function [T,Y,T1,Y1,pressure]=gastrulation_ala(N,boundary,boundaryc,NewN,chemoN,tipN,NCN,ncp,alpha,beta,gamma,theta,Tcut,Tcut2,cut)

%% Specify additional parameters for simulation
R=1; % cell radius - fix for current project
pdn=8; % progenitor domain size - in terms of how many new cells come out at one time
pdx=1; % progenitor domain AP length;
pdy=8; % progenitor domain ML width;
pdf=NewN/(Tcut+Tcut2); % frequency of adding new cells
Nt=N+NewN; % total final number
%% Allocate cells on the field
% 05/12/16, prelocate New cells with NewN
% here only initial cells are allocated but space is made for New cells
xcurrent=zeros(4*Nt,1);
n=1;
for x=(boundaryc(1)+0.5):1:(boundaryc(2)-0.5)
    for y=(boundaryc(3)+0.5):1:(boundaryc(4)-0.5)
        xcurrent(n)=x;
        xcurrent(Nt+n)=y;
        n=n+1;
    end
end
 
%% Set up pressure recorder
range=boundaryc(1):1:boundaryc(2);
resolution=1;
recorder=zeros(floor(length(range)/resolution)-1,2);
coor=(range+resolution/2)';
recorder(:,1)=coor(1:size(coor,1)-1,:);

%% Run simulation with cellMove
tcurrent=0;
cutsn=[]; % no cut for initial period of simulation

% xcurrent stores the current pattern in the field 
% initial run before cutting
pdcounter=1; % counter for cell addition
Nc=N; % intial total number of cells
x=xcurrent; 
T=zeros(1,Tcut+1); % data storage
Y=zeros(4*Nt,Tcut+1); % data storage

T(1)=tcurrent;
Y(:,1)=xcurrent;
for i=1:Tcut
    [y,press]=cellMove2(x,Nt,Nc,R,alpha,beta,gamma,theta,boundary,chemoN,tipN,NCN,ncp,cutsn);
    x=x+y*0.1; % positions change by y produced by cellMove
    T(i+1)=T(1)+i;
    if T(i+1)/(pdn/pdf)>pdcounter
       [x,Nc]=addcells(x,Nt,Nc,tipN,pdn,pdx,pdy);
       pdcounter=pdcounter+1;
       % this creates a new x with a new Nc of cells
    end
    Y(:,i+1)=x;
    % this accumulates the pressure the upper boundary feels at this time
    recorder(:,2)=recorder(:,2)+getpressure(range,resolution,press);
end

% set up for next segment after cut
tcurrent=T(end);
xcurrent=Y(:,end);
% special insert here
% [xcurrent,boundary]=cellshift(xcurrent,N,chemoN,boundary,0.2,2);
% uncomment the above line for the global tension perturbation

% Ala's module of exponential pulling/compression - comment out to not use
% - instructions in Ala/embryo_pulling.ppt
elong_const = 80;       % the smaller the value, the stronger the elongation
for i=1:150             % first 75% of cells at the negative coordinates
    xcurrent(i,1) = xcurrent(i,1) .* exp(0.*abs(xcurrent(i,1)./elong_const));
end
for i=201:320           % any new cells added during simulation
    xcurrent(i,1) = xcurrent(i,1) .* exp(0.*abs(xcurrent(i,1)./elong_const));
end

% cut and run again
cutsn=findcell(xcurrent,Nt,cut);
% use defined cut area to find cells to remove in xcurrent
cutsn(cutsn==tipN)=[];
% protect tipN from being cut

x=xcurrent; 
T1=zeros(1,Tcut2+1); % data storage
Y1=zeros(4*Nt,Tcut2+1); % data storage

T1(1)=tcurrent;
Y1(:,1)=xcurrent;
for i=1:Tcut2
    [y,press]=cellMove2(x,Nt,Nc,R,alpha,beta,gamma,theta,boundary,chemoN,tipN,NCN,ncp,cutsn);
    x=x+y*0.1; % positions change by y produced by cellMove
    T1(i+1)=T1(1)+i;
    if T1(i+1)/(pdn/pdf)>pdcounter && pdf==NewN/(Tcut+Tcut2)
    [x,Nc]=addcells(x,Nt,Nc,tipN,pdn,pdx,pdy);
    pdcounter=pdcounter+1;
    % this creates a new x with a new Nc of cells
    end
    Y1(:,i+1)=x;
    recorder(:,2)=recorder(:,2)+getpressure(range,resolution,press);
end

%% output pressure
pressure=recorder;

