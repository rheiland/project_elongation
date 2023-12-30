%%write a script that tracks movement of n random cells over time

%%first plot NC cells
MCDS = read_MultiCellDS_xml('final.xml');

% make it easier to work with the cell positions; 
P = MCDS.discrete_cells.state.position;
 
% find NC cells
NC = find( MCDS.discrete_cells.metadata.type == 3 ); 
plot3( P(NC,1), P(NC,2), P(NC,3), 'o','Color',[0.9412,0.9412,0.9412]);
hold on
axis equal


%counts number of output files in current directory (pwd) 
source_dir = pwd; 
d = dir([source_dir, '\output*.xml']);
n=length(d);

%pad numbers
padded=string('output00000000.xml');
for i=1:n-1
padded =[padded, strcat('output',sprintf( '%08d', i ),'.xml')];
end

average=zeros(n,2);


% select a subset of NC cells
NC = find( MCDS.discrete_cells.metadata.type == 3 ); 
subset = datasample(NC,10,'Replace',false); %change number to change number of cells selected
y=[];

%remove cells that do not move for visualization purposes



plot3( P(subset,1), P(subset,2), P(subset,3), 'ro','MarkerFaceColor','r' ); %color the subset black

%call files to build recorder 
for i=1:n
MCDS =read_MultiCellDS_xml(padded(:,i));
% make it easier to work with the cell positions; 
P = MCDS.discrete_cells.state.position;
x = [P(subset,1), P(subset,2), P(subset,3)];
y = [y,x]; %y is a recorder
end 

%reconfigure y
z=[];

for j = 1:numel(subset)  
    for i=1:n
    z = [z;y(j,(i*3-2):(i*3))];
    end
end
%plot 


cell=z(1:n,:);
plot3(cell(:,1),cell(:,2),cell(:,3),'r');



for i=1:numel(subset)-1
        cell=z((i*n+1):(i+1)*n,:);
        plot3(cell(:,1),cell(:,2),cell(:,3),'r')
end

xlim([-360,300]);
ylim([-155,140]);
zlim([-60,60]);

hold off

% f=gcf;
% exportgraphics(f,'cellmov.png','Resolution',300);






