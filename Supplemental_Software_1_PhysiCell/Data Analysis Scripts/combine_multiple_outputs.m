rec=[]

for i = 1:10
%%Set this as the working directory for your files
%cd(['C:\Users\chris\Desktop\Part III project\PhysiCell_V.1.7.1\Final\No Lat\No Lat ',sprintf('%0d', i ),'\output'])

initial = read_MultiCellDS_xml('initial.xml');
final = read_MultiCellDS_xml('final.xml');
% make it easier to work with the cell positions; 
inipos = initial.discrete_cells.state.position;
finpos = final.discrete_cells.state.position;

% find PSM cells
NC = find( initial.discrete_cells.metadata.type == 3 ); 
n=0; %change n*15 to select different z plane n -2:2

%%Plot PSM 
z = find(initial.discrete_cells.state.position(:,3)==n*15); 
com=intersect(NC,z); 

%% pull out values 
stop = [finpos(com,1), finpos(com,2), finpos(com,3)];
sorted = sort(stop(:,1),'descend');
average = mean(sorted(1:5,:));
rec=[rec;average];
end