%%script that shows final movement of cells in quiver

initial = read_MultiCellDS_xml('initial.xml');
final = read_MultiCellDS_xml('final.xml');
% make it easier to work with the cell positions; 
inipos = initial.discrete_cells.state.position;
finpos = final.discrete_cells.state.position;

%only need to call index for the initial cells as it is same as in the
%final
% find PSM cells
PSM = find( initial.discrete_cells.metadata.type == 1 ); 
% find Ecto cells
Ecto = find( initial.discrete_cells.metadata.type == 2 ); 
% find NC cells 
NC = find( initial.discrete_cells.metadata.type == 3 ); 

n=0; %change n*15 to select different z plane n -2:2


%%Plot PSM 
z = find(initial.discrete_cells.state.position(:,3)==n*15); 
com=intersect(PSM,z); 

% pull out values 
start = [inipos(com,1), inipos(com,2), inipos(com,3)];
stop = [finpos(com,1), finpos(com,2), finpos(com,3)];

change = stop - start;

 q = quiver3(inipos(com,1), inipos(com,2), inipos(com,3),change(:,1),change(:,2),change(:,3),'b');
 q.ShowArrowHead = 'on';
 q.AutoScale = 1;
 axis equal;
 xlim([-360,300]);
 ylim([-155,140]);
 zlim([-60,60]);

 hold on
 plot3( inipos(com,1), inipos(com,2), inipos(com,3), 'o','Color',[0.9412,0.9412,0.9412]);


%%Plot NC
com=intersect(NC,z);

% pull out values 
start = [inipos(com,1), inipos(com,2), inipos(com,3)];
stop = [finpos(com,1), finpos(com,2), finpos(com,3)];

change = stop - start;

 q = quiver3(inipos(com,1), inipos(com,2), inipos(com,3),change(:,1),change(:,2),change(:,3),'r');
 q.ShowArrowHead = 'on';
 q.AutoScale = 1;
 axis equal;
 xlim([-360,300]);
 ylim([-155,140]);
 zlim([-60,60]);

 hold on
 plot3( inipos(com,1), inipos(com,2), inipos(com,3), 'o','Color',[0.9412,0.9412,0.9412]);

%%Plot Ecto
com=intersect(Ecto,z);

% pull out values 
start = [inipos(com,1), inipos(com,2), inipos(com,3)];
stop = [finpos(com,1), finpos(com,2), finpos(com,3)];

change = stop - start;

 q = quiver3(inipos(com,1), inipos(com,2), inipos(com,3),change(:,1),change(:,2),change(:,3),...
     'Color',[1,0.42,0.16]);
 q.ShowArrowHead = 'on';
 q.AutoScale = 1;
 axis equal;
 xlim([-360,300]);
 ylim([-155,140]);
 zlim([-60,60]);

 hold on
 plot3( inipos(com,1), inipos(com,2), inipos(com,3), 'o','Color',[0.9412,0.9412,0.9412]);

%f=gcf;
%exportgraphics(f,'planemov.png','Resolution',500);
