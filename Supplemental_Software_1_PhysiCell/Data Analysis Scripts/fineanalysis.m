MCDS = read_MultiCellDS_xml('final.xml');
% make it easier to work with the cell positions; 
P = MCDS.discrete_cells.state.position;
 
% find PSM cells
PSM = find( MCDS.discrete_cells.metadata.type == 1 ); 
 
% find Ecto cells
Ecto = find( MCDS.discrete_cells.metadata.type == 2 ); 

% find NC cells
NC = find( MCDS.discrete_cells.metadata.type == 3 ); 

%% uncomment to section PSM
%Write a sectioning script for PSM
%x = [P(PSM,1), P(PSM,2), P(PSM,3)];
%x(x(:,1)>-100 & x(:,2)>-1,:)=[];
%plot3( x(:,1), x(:,2), x(:,3), 'co' )  %%script for sectioned PSM

%%now plot them
plot3( P(PSM,1), P(PSM,2), P(PSM,3), 'co' )
hold on
axis equal
plot3( P(Ecto,1), P(Ecto,2), P(Ecto,3), 'yo' )
plot3( P(NC,1), P(NC,2), P(NC,3), 'ro' )
hold off


