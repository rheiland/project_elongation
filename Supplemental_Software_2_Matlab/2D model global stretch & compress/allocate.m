%This function sets the boundaries and allocates cells 

function [T,Y,recorder]=allocate(N,Ax,boundary,boundaryc,NCN,Time,alphaPSM,alphaNC,alphaEX,alphaPN,alphaPE,alphaNE)

%% Allocate cells on the field
xcurrent=zeros(4*N,1);
n=1;
recorder=[];

for x=(boundaryc(1)+0.5):1:(boundaryc(2)-0.5) %change middle value to stretch along the x axis
    for y=(boundaryc(3)+0.5):1:(boundaryc(4)-0.5)
        xcurrent(n)=x;  %0-200 is the x coordinates of preallocated cells, 201-280 remain as space to be added
        xcurrent(N+n)=y; %281-480 is the y coordinates of preallocated cells, 481-680 remain as space to be added
        %681-1120 remain empty    
        n=n+1;
    end
end

 
%% Run simulation with cellMove
tcurrent=0;
x=xcurrent; 
T=zeros(1,Time+1); 
Y=zeros(4*N,Time+1); 

T(1)=tcurrent;
Y(:,1)=xcurrent; 

for i=1:Time
    [y,NCforce]=cellMove2(x,N,boundary,NCN,Ax,alphaPSM,alphaNC,alphaEX,alphaPN,alphaPE,alphaNE);
    x=x+y*0.1; % y is output yy by cellmove2
    T(i+1)=T(1)+i; %Time counter update
    Y(:,i+1)=x;  % store new x positions
    
%% uncomment if the force exerted on the posterior most NC is to be recorded
%     timerec=[0,0,i];
%     recorder=[recorder;timerec;NCforce];
end



