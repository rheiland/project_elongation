%Load and process Data
rec=[]
for i = 1:10
cd(['C:\Users\chris\Desktop\Part III project\PhysiCell_V.1.7.1\Final\2D model\Pos\No Pos '...
    ,sprintf('%0d', i ),'\output']);

initial = read_MultiCellDS_xml('initial.xml');
final = read_MultiCellDS_xml('final.xml');
% make it easier to work with the cell positions; 
inipos = initial.discrete_cells.state.position;
finpos = final.discrete_cells.state.position;

% find PSM cells
NC = find( initial.discrete_cells.metadata.type == 3 ); 

% % find Ecto cells
% Ecto = find( initial.discrete_cells.metadata.type == 2 ); 
% % find NC cells 
% NC = find( initial.discrete_cells.metadata.type == 3 ); 
% 
n=0; %change n*15 to select different z plane n -2:2
%%Plot PSM 
z = find(initial.discrete_cells.state.position(:,3)==n*15); 
com=intersect(NC,z); 

%% pull out values 
start = [inipos(com,1), inipos(com,2), inipos(com,3)];
stop = [finpos(com,1), finpos(com,2), finpos(com,3)];
change = stop - start;
filter = [start,change];

%% this section of code assigns RGB R values according to whether cells are travelling 
%% in the correct y direction

neg = (filter(:,2) < 0);
neg = filter(neg,:);
pneg = (neg(:,5)>0);
nneg = (pneg==0);
pval = neg(pneg,:);
nval = neg(nneg,:);

for i=1:numel(nval(:,5))
 r=nval(i,5);
% Compute centile
nless = sum(nval(:,5) < r);
nequal = sum(nval(:,5) == r);
centile =(nless + 0.5*nequal) / length(nval(:,5));
nval(i,7)=0.5-(1-centile)/2;
end

for i=1:numel(pval(:,5))
 r=pval(i,5);
% Compute centile
nless = sum(pval(:,5) < r);
nequal = sum(pval(:,5) == r);
centile =(nless + 0.5*nequal) / length(pval(:,5));
pval(i,7)=0.5+centile/2;
end
neg = [pval;nval];


pos = (filter(:,2) >= 0);
pos = filter(pos,:);
ppos = (pos(:,5)>0);
npos = (ppos==0);
pval = pos(ppos,:);
nval = pos(npos,:);

for i=1:numel(pval(:,5))
 r=pval(i,5);
% Compute centile
nless = sum(pval(:,5) > r);
nequal = sum(pval(:,5) == r);
centile =(nless + 0.5*nequal) / length(pval(:,5));
pval(i,7)=0.5-(1-centile)/2;
end

for i=1:numel(nval(:,5))
 r=nval(i,5);
% Compute centile
nless = sum(nval(:,5) > r);
nequal = sum(nval(:,5) == r);
centile =(nless + 0.5*nequal) / length(nval(:,5));
nval(i,7)=0.5+centile/2;
end
pos = [pval;nval];
full= [neg;pos];

%% this section of code assigns RGB G values according to whether cells are travelling 
%% in the correct x direction (towards +ve)

xvec=full(:,4);

for i=1:numel(xvec)
r=xvec(i);
% Compute centile
nless = sum(full(:,4) < r);
nequal = sum(full(:,4) == r);
centile =(nless + 0.5*nequal) / length(full(:,4));
full(i,8)=centile;
end

%%this section of code assigns thickness according to change in Z +ve, bold
thic=full(:,6);
for i=1:numel(thic)
r=thic(i);
% Compute centile
nless = sum(full(:,6) < r);
nequal = sum(full(:,6) == r);
centile =(nless + 0.5*nequal) / length(full(:,4));
full(i,10)=centile*1.5+0.01; 
end

%%plot graph
full(:,9)=0;
rec=[rec;full];
end

%%Plot Histogram
Border = 0.1;
Sigma = 0.05;
stepSize = 0.01;

%%Points
Px=rec(:,7);  
Py=rec(:,8);
pD = [Px Py];
pN = length(Px);

pXrange = [min(Px)-Border max(Px)+Border];
pYrange = [min(Py)-Border max(Py)+Border];

%Setup coordinate grid
[pXX pYY] = meshgrid(pXrange(1):stepSize:pXrange(2), pYrange(1):stepSize:pYrange(2));
pYY = flipud(pYY);

%Parzen parameters and function handle
pf1 = @(C1,C2) (1/pN)*(1/((2*pi)*Sigma^2)).*...
         exp(-( (C1(1)-C2(1))^2+ (C1(2)-C2(2))^2)/(2*Sigma^2));
pPPDF1 = zeros(size(pXX));    

%Populate coordinate surface
[R C] = size(pPPDF1);
NN = length(pD);
for c=1:C
   for r=1:R 
       for d=1:pN 
            pPPDF1(r,c) = pPPDF1(r,c) + ...
                pf1([pXX(1,c) pYY(r,1)],[pD(d,1) pD(d,2)]); 
       end
   end
end

%Normalize data
m1 = max(pPPDF1(:));
pPPDF1 = pPPDF1 / m1;


%Visualize points
rec(:,9)=0;
col=strings;
col=[strcat(string(rec(:,7)),',',string(rec(:,8)),',',string(rec(:,9)))];

for i=1:NN
stem3(pD(i,1),pD(i,2),0,...
     'o','Color',[col(i)],'MarkerSize',6,'MarkerFaceColor',[col(i)]);
hold on;
end

%Add PDF estimates to figure
fig=figure(1)
s1 = surfc(pXX,pYY,pPPDF1);shading interp;alpha(s1,'color');
sub1=gca;
view(2);
colormap(fig,parula);
colorbar

hold on;
% 
% saveas(fig,'histogram.fig','fig');

