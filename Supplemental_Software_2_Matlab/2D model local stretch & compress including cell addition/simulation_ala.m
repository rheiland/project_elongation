
% Specify "Field" parameters - these will be fixed for this project
N=200; % number of cells (to start simulation)
boundary=[-35,5,-5,5]; % field size
boundaryc=[-15,5,-5,5]; % intial cell domain size
chemoN=175; % cell marking the elongation frontier, when the model is used for chemotaxis
tipN=5; % cell marking the elongation frontier, when the model is used for random mobility
NCN=[5:10:195,6:10:196,4:10:84,7:10:87]; % define NC cells
NewN=120; % number of new cells to be added during simulation

% Specify "interaction" parameters - these will be varied for tests
alpha=5; % cell repulsion oefficient among each other - simulating collision volume
beta=10; % friction coefficient cells encounter - viscosity
gamma=0.15; % random mobility of cells
theta=0; % chemotaxis coefficient, strength of repulsion and attraction
ncp=3; % notochord cell polarity, 1 is no polarity, 3 is standard, 10 or 0.1 are highly polarized

% Specify "iteration" parameters - these will be fixed for this project
Tcut=1000; % time to run before cut
Tcut2=5000; % time to run after cut

% Perturbations
cutmatrix=[-15,-15,0,0;1,-5,1,3;1,-5,3,5;5,2,1,3;-5,-7,0,2;...
    5,2,0,2;2,-1,0,2;-5,-18,2,4;-6,-15,0,1.5;-17,-21,0,3;-5,-18,2.5,3.5;];
% sc=ones(1,9)*1;% select what to cut, see below
sc=8;
% 1=nothing; 2=pPSM; 3=lateral plate; 4=aPSM; 5=axial progenitors; 6=aNC;
% 7=pNC
% version2: 8=pPSM; 9=pNC; 10=AxialPD; 11=partial pPSM / density reduction
% note, when using 10, also reduce NewN by half and change gastrulation.m
% for frequency
cutinput=cutmatrix(sc,:); 

Data=cell(size(cutinput,1),5);
for i=1:size(cutinput,1)
    [T,Y,T1,Y1,pressure]=gastrulation_ala(N,boundary,boundaryc,NewN,chemoN,tipN,NCN,ncp,alpha,beta,gamma,theta,Tcut,Tcut2,cutinput(i,:));
    Data{i,1}=cutinput(i,:);
    Data{i,2}=T;
    Data{i,3}=Y;
    Data{i,4}=T1;
    Data{i,5}=Y1;
    disp([num2str(i),'/',num2str(size(cutinput,1))])
end

%moviename='test1';
%makemovie2(Data,N+NewN,chemoN,tipN,NCN,boundary,moviename);
