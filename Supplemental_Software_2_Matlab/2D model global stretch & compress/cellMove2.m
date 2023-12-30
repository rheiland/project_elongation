% This is the core function integrating cell-cell interations and updating
% over time

function [yy,NCforce]=cellMove2(x,N,boundary,NCN,Ax,alphaPSM,alphaNC,alphaEX,alphaPN,alphaPE,alphaNE)
% this function defines the force and corresponding movements created by a
% group of cells. To start, the cells are laid out in a 2D plane with
% adjustable boundaries. 
%Cells have a random mobility associated with their location
%All cells have certain radius R below which they are sensing a repulsing force 
% Alpha*(r-R)/r, simulating collision volume. as R decreases, Alpha*(r-R)/r increases



% Specify "interaction" parameters - these will be varied for tests
R=1; % cell radius 
gamma=0.20; % random mobility of cells, NC and Ex cells dont move
NCforce=[]


% load position and speed
X=x(1:N); 
Y=x(N+1:2*N); 
Vx=x(2*N+1:3*N); 
Vy=x(3*N+1:4*N); 

% rate equation
y=zeros(4*N,1);
y(1:2*N)=[Vx;Vy];  



%% 1. interaction between cells: when they get too close they repel each other
% obtain the distances between every other cell and their type of relationships
D=squareform(pdist([X,Y])); % distance every other 
maskNC1=ones(N); maskNC2=ones(N);

for k=1:length(NCN)
    maskNC1(NCN(k),:)=0; maskNC2(:,NCN(k))=0;
end

for k=1:length(Ax)
    maskNC1(Ax(k),:)=0.25; maskNC2(:,Ax(k))=0.25;
end


intraNC=maskNC1+maskNC2<0.25; %cells that are 0 in both maskNC1 and maskNC2 are NC cell interactions
intraPSM=maskNC1+maskNC2>1.25; %cells that are 1 in both maskNC1 and maskNC2 are PSM cell interactions
inter=maskNC1+maskNC2==1; %cells that are 0/1 in both are "inter" interaction between NC and PSM

%New Masks for boundary cells
interbound=maskNC1+maskNC2==1.25;
intrabound=maskNC1+maskNC2==0.5;
interboundNC=maskNC1+maskNC2==0.25;


mask1=D<R; % Interaction radius limit, 1 warrants an interaction


for i=1:N %for each cell
    for j=i+1:N % for every other cell apart from the cell itself. this scans the top right half of the D field
        
        % PSM-PSM
        if ( mask1(i,j) && intraPSM(i,j) ) 
            r=D(i,j); 
            force=alphaPSM*(r-R)/r;       
            y(2*N+i)=y(2*N+i)+force*(X(j)-X(i))/r; 
            y(2*N+j)=y(2*N+j)-force*(X(j)-X(i))/r;
            y(3*N+i)=y(3*N+i)+force*(Y(j)-Y(i))/r;
            y(3*N+j)=y(3*N+j)-force*(Y(j)-Y(i))/r;
    
         
        % NC-NC
        elseif ( mask1(i,j) && intraNC(i,j))
            r=D(i,j);
            force=alphaNC*(r-R)/r;
            y(2*N+i)=y(2*N+i)+force*(X(j)-X(i))/r;
            y(2*N+j)=y(2*N+j)-force*(X(j)-X(i))/r;
            y(3*N+i)=y(3*N+i)+force*(Y(j)-Y(i))/r;
            y(3*N+j)=y(3*N+j)-force*(Y(j)-Y(i))/r;
            
       %PSM-NC
        elseif (mask1(i,j) && inter(i,j))
            r=D(i,j);
            force=alphaPN*(r-R)/r;
            y(2*N+i)=y(2*N+i)+force*(X(j)-X(i))/r;
            y(2*N+j)=y(2*N+j)-force*(X(j)-X(i))/r;
            y(3*N+i)=y(3*N+i)+force*(Y(j)-Y(i))/r;
            y(3*N+j)=y(3*N+j)-force*(Y(j)-Y(i))/r;

%% uncomment if the force exerted on the posterior most NC is to be recorded
%             temp = [i,j,force];
%             NCforce = [NCforce;temp];
                  
        %Ex-Ex
        elseif (mask1(i,j) && intrabound(i,j))
            r=D(i,j); 
            force=alphaEX*(r-R)/(r); 
            y(2*N+i)=y(2*N+i)+force*(X(j)-X(i))/r;
            y(2*N+j)=y(2*N+j)-force*(X(j)-X(i))/r;
            y(3*N+i)=y(3*N+i)+force*(Y(j)-Y(i))/r;
            y(3*N+j)=y(3*N+j)-force*(Y(j)-Y(i))/r;
            
            
        %Ex-PSM
        elseif (mask1(i,j) && interbound(i,j))
            r=D(i,j);
            force=alphaPE*(r-R)/r;
            y(2*N+i)=y(2*N+i)+force*(X(j)-X(i))/r;
            y(2*N+j)=y(2*N+j)-force*(X(j)-X(i))/r;
            y(3*N+i)=y(3*N+i)+force*(Y(j)-Y(i))/r;
            y(3*N+j)=y(3*N+j)-force*(Y(j)-Y(i))/r;
            
        %Ex-NC
        elseif (mask1(i,j) && interboundNC(i,j))
            r=D(i,j);
            force=alphaNE*(r-R)/r;
            y(2*N+i)=y(2*N+i)+force*(X(j)-X(i))/r;
            y(2*N+j)=y(2*N+j)-force*(X(j)-X(i))/r;
            y(3*N+i)=y(3*N+i)+force*(Y(j)-Y(i))/r;
            y(3*N+j)=y(3*N+j)-force*(Y(j)-Y(i))/r;            
            
        end
    end
end

%% 2. friction/viscosity
y(2*N+1:4*N)=y(2*N+1:4*N)-10*y(1:2*N); %%% this parameter has not been varied in the experiment

%% 3. random mobility
for i=1:N
y(2*N+i)=y(2*N+i)+gamma*25*randn(1)*~ismember(i,NCN)*~ismember(i,Ax);
y(3*N+i)=y(3*N+i)+gamma*25*randn(1)*~ismember(i,NCN)*~ismember(i,Ax);
end

% anterior boundary
alphaAP=alphaPSM;alphaML=alphaPSM; 
r=abs(X-boundary(1));
force=alphaAP*(r-R/2)./r; 
force(r>=R/2)=0; 
y(2*N+1:3*N)=y(2*N+1:3*N)-force; 

r=abs(X-boundary(2));
force=alphaAP*(r-R/2)./r;
force(r>=R/2)=0;
y(2*N+1:3*N)=y(2*N+1:3*N)+force; 

% lateral boundary
r=abs(Y-boundary(3));
force=alphaML*(r-R/2)./r;
force(r>=R/2)=0;  
y(3*N+1:4*N)=y(3*N+1:4*N)-force; 

r=abs(Y-boundary(4));
force=alphaML*(r-R/2)./r;
force(r>=R/2)=0;
y(3*N+1:4*N)=y(3*N+1:4*N)+force;

yy=y; 
