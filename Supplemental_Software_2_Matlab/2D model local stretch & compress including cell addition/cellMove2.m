% Originally coded by Wenzhe Ma
% this is the core function integrating cell-cell interations
% the calculation produces the forces and new positions of one iteration
% Version 2 starting 05/2016 -FX, implement two cell types and enhance
% speed

function [yy,press]=cellMove2(x,Nt,Nc,R,alpha,beta,gamma,theta,boundary,chemoN,tipN,NCN,ncp,cutsn)
% this function defines the force and corresponding movements created by a
% group of cells. To start, the cells are laid out in a 2D plane with
% adjustable boundaries. Cells have a random mobility which is associated
% with their location, this location will later be a function of the
% progenitor domain. All cells have certain radius R below which they are sensing a repulsing force 
% Alpha*(r-R)/r, simulating collision volume. All cells have "friction" Beta*V 
% proportional to and against movement, simulating viscosity.
% chemoN is built in to place a flexible landmark for mobility functions

% For N cells, there are 4N variables describing cell position and speed. 
% The boundary is set to be an rectangle for simplicity
% the cells in cutCellN will not have interaction with other cells, this is
% built in to produce cuttings for surgical perturbation simulations later

% load position and speed
X=x(1:Nc);
Y=x(Nt+1:Nt+Nc);
Vx=x(2*Nt+1:2*Nt+Nc);
Vy=x(3*Nt+1:3*Nt+Nc);

% rate equation
y=zeros(4*Nc,1);
y(1:2*Nc)=[Vx;Vy];

% 050916: try a tip cell as source of mobility
% define a tip cell that acts as the elongation frontier mark, cell
% mobility source and location mark.
% tipN=5; tipN is external to use for progenitor domain as well

% force equation
% 1. interaction between cells: when they get too close they repell each
% other

% obtain the distances between every other cell and their type
% relationships
D=squareform(pdist([X,Y])); % distance every other
maskcut=ones(Nc);
for k=1:length(cutsn)
    maskcut(cutsn(k),:)=0; maskcut(:,cutsn(k))=0;
end
maskcut=logical(maskcut); % cells cut are logical 0s, not pariticipating calculation
maskNC1=ones(Nc);maskNC2=ones(Nc);
for k=1:length(NCN)
    maskNC1(NCN(k),:)=0; maskNC2(:,NCN(k))=0;
end
intraNC=maskNC1+maskNC2<1;
intraPSM=maskNC1+maskNC2>1;
inter=maskNC1+maskNC2==1;
% maskNC=logical(abs(maskNC1+maskNC2-1)); % Intra cell pairs are 0s

mask1=D<R; % Interaction radius limit, 1 warrants an interaction
mask2=D<R;
mask3=D<R;

for i=1:Nc
    for j=i+1:Nc % this scans the top right half of the D field
        % 05/05/16 - distinguish inter (strong) vs intra (weak) interactions
        % intraPSM
        if (maskcut(i,j) && mask1(i,j) && intraPSM(i,j))
            r=D(i,j);
            force=alpha*(r-R)/r*(abs(25-abs(X(i)-X(tipN)))/28+0.1);
            % implement an adhesion gradient here, cells far from source of
            % mobility have high adhesion thus less repulsion force
            y(2*Nc+i)=y(2*Nc+i)+force*(X(j)-X(i))/r;
            y(3*Nc+i)=y(3*Nc+i)+force*(Y(j)-Y(i))/r;
            y(2*Nc+j)=y(2*Nc+j)-force*(X(j)-X(i))/r;
            y(3*Nc+j)=y(3*Nc+j)-force*(Y(j)-Y(i))/r;
        % intraNC
        elseif (maskcut(i,j) && mask2(i,j) && intraNC(i,j))
            r=D(i,j);
            force=alpha*(r-R)/r;
            % NC cell polarity can be implemented here
            y(2*Nc+i)=y(2*Nc+i)+ncp*force*(X(j)-X(i))/r;
            y(3*Nc+i)=y(3*Nc+i)+1/ncp*force*(Y(j)-Y(i))/r;
             y(2*Nc+j)=y(2*Nc+j)-ncp*force*(X(j)-X(i))/r;
            y(3*Nc+j)=y(3*Nc+j)-1/ncp*force*(Y(j)-Y(i))/r;
        % interaction between NC cell and PSM cells
       elseif (maskcut(i,j) && mask3(i,j) && inter(i,j))
            r=D(i,j);
            % this is set to be stronger to mimic different cell types
            force=alpha*(r-R)/r*3;
            y(2*Nc+i)=y(2*Nc+i)+force*(X(j)-X(i))/r;
            y(3*Nc+i)=y(3*Nc+i)+force*(Y(j)-Y(i))/r;
             y(2*Nc+j)=y(2*Nc+j)-force*(X(j)-X(i))/r;
            y(3*Nc+j)=y(3*Nc+j)-force*(Y(j)-Y(i))/r;
        end
    end
end

% 2. friction/viscosity
y(2*Nc+1:4*Nc)=y(2*Nc+1:4*Nc)-beta*y(1:2*Nc);

% 3. chemofield 
for i=1:Nc
    if (chemoN==i)
        continue;
    end
    vchem=chemoField([X(chemoN);Y(chemoN)],[X(i);Y(i)]);
    y(2*Nc+i)=y(2*Nc+i)+theta*vchem(1);
    y(3*Nc+i)=y(3*Nc+i)+theta*vchem(2);
    
end

% 4. random mobility
% y(2*N+1:4*N)=y(2*N+1:4*N)+gamma*randn(2*N,1);
% The above provides just simple, uniform random mobility

% introduce a mobility gradient here, linear, gamma controls the magnitude

for i=1:Nc
y(2*Nc+i)=y(2*Nc+i)+gamma*abs(25-abs(X(i)-X(tipN)))*randn(1)*~ismember(i,NCN);
y(3*Nc+i)=y(3*Nc+i)+gamma*abs(25-abs(X(i)-X(tipN)))*randn(1)*~ismember(i,NCN);
% when a cell is labeled as NC, no random mobi
%y(2*Nc+i)=y(2*Nc+i)+gamma*20*randn(1)*~ismember(i,NCN);
%y(3*Nc+i)=y(3*Nc+i)+gamma*20*randn(1)*~ismember(i,NCN);
% test no mobility gradient, high or low mobi throughout
end

% 5. force from boundary condition - non-essential given the distance from
% where main actions take place

alphaAP=alpha;alphaML=alpha;
% anterior-posterior boundary
r=abs(X-boundary(1));
force=alphaAP*(r-R/2)./r;
force(r>=R/2)=0;
y(2*Nc+1:3*Nc)=y(2*Nc+1:3*Nc)-force;
r=abs(X-boundary(2));
% modify force at Anterior boundary, boundary 2 *(abs(15-abs(boundary(2)-X(tipN)))/17+0.1)
force=alphaAP*(r-R/2)./r;
force(r>=R/2)=0;
y(2*Nc+1:3*Nc)=y(2*Nc+1:3*Nc)+force;

% lateral boundary
r=abs(Y-boundary(3));
force=alphaML*(r-R/2)./r;
force(r>=R/2)=0;
y(3*Nc+1:4*Nc)=y(3*Nc+1:4*Nc)-force;
r=abs(Y-boundary(4));
force=alphaML*(r-R/2)./r;
force(r>=R/2)=0;
y(3*Nc+1:4*Nc)=y(3*Nc+1:4*Nc)+force;

% record the boundary force here for pressure
press=[X,force];
%% the tip cell does not move vertically
y(Nc+tipN)=0;
% this assumption keeps the frontier along the
% A-P axis, this is important given the small number of cells used in the
% simulation and the frontier cell is sensitive to ML force fluctuations.
% In reality, many cells could help straight elongation. Revision of the
% model from this point will help modeling symmetry control.

%% this part re-pad y to yy to restore the zeros
yy=zeros(4*Nt,1);
yy(1:Nc)=y(1:Nc);
yy(Nt+1:Nt+Nc)=y(Nc+1:2*Nc);
yy(2*Nt+1:2*Nt+Nc)=y(2*Nc+1:3*Nc);
yy(3*Nt+1:3*Nt+Nc)=y(3*Nc+1:4*Nc);
