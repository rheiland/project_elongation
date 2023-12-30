function []=vecdist(Data,NCN,N,Y,T)
%script that visualizes cell movements as vectors
%define convergence movement as movement towards y = 0 
%more convergence, more green
%define extension movement as movement towards x=-35
%more extension, more red

inix=Y(1:N,1);
iniy=Y(N+1:2*N,1);
finx=Y(1:N,length(Y));
finy=Y(N+1:2*N,length(Y));
initial=[inix(NCN,1),iniy(NCN,1)];
final=[finx(NCN,1),finy(NCN,1)];
change = final - initial;
filter = [initial,change];

%% this section of code assigns RGB R values according to whether cells are travelling 
%% in the correct y direction
neg = (filter(:,2) < 0);
neg = filter(neg,:);
pneg = (neg(:,4)>0);
nneg = (pneg==0);
pval = neg(pneg,:);
nval = neg(nneg,:);

for i=1:numel(nval(:,4))
r=nval(i,4);
% Compute centile
nless = sum(nval(:,4) < r);
nequal = sum(nval(:,4) == r);
centile =(nless + 0.5*nequal) / length(nval(:,4));
nval(i,5)=0.5-(1-centile)/2;
end

for i=1:numel(pval(:,4))
 r=pval(i,4);
% Compute centile
nless = sum(pval(:,4) < r);
nequal = sum(pval(:,4) == r);
centile =(nless + 0.5*nequal) / length(pval(:,4));
pval(i,5)=0.5+centile/2;
end
neg = [pval;nval];

pos = (filter(:,2) >= 0);
pos = filter(pos,:);
ppos = (pos(:,4)>0);
npos = (ppos==0);
pval = pos(ppos,:);
nval = pos(npos,:);

for i=1:numel(pval(:,4))
 r=pval(i,4);
% Compute centile
nless = sum(pval(:,4) > r);
nequal = sum(pval(:,4) == r);
centile =(nless + 0.5*nequal) / length(pval(:,4));
pval(i,5)=0.5-(1-centile)/2;
end

for i=1:numel(nval(:,4))
 r=nval(i,4);
% Compute centile
nless = sum(nval(:,4) > r);
nequal = sum(nval(:,4) == r);
centile =(nless + 0.5*nequal) / length(nval(:,4));
nval(i,5)=0.5+centile/2;
end
pos = [pval;nval];
full= [neg;pos];

%% this section of code assigns RGB G values according to whether cells are travelling 
%% in the correct x direction (towards -ve)

xvec=full(:,3);

for i=1:numel(xvec)
r=xvec(i);
% Compute centile
nless = sum(full(:,3) > r);
nequal = sum(full(:,3) == r);
centile =(nless + 0.5*nequal) / length(full(:,3));
full(i,6)=centile;
end


%%plot graph
full(:,7)=0;
col=strings;
col=[strcat(string(full(:,5)),',',string(full(:,6)),',',string(full(:,7)))];

for i=1:numel(col)
q = quiver(full(i,1), full(i,2), full(i,3),full(i,4),...
    'Color',[col(i)]);
q.ShowArrowHead = 'on';
q.MaxHeadSize=3;
 hold on
end
xlim([-35,5]);
ylim([-5,5]);
saveas(q,'vecdist.png','png');
clf;

