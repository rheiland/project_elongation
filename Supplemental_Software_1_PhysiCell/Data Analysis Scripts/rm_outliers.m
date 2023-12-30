thic=[]
long=[]
ang=[]
for i = 9
cd(['C:\Users\chris\Desktop\Part III project\PhysiCell_V.1.7.1\Final\No Lat\No Lat '...
    ,sprintf('%0d', i ),'\output'])

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
xval = finpos(com,1);
yval = finpos(com,2);
% sorted = sort(stop(:,1),'descend');
% average = mean(sorted(1:5,:));
% rec=[rec;average];
% end

%fitting to linear regression
f = fittype('a*x+b'); 
fit1 = fit(xval,yval,f,'StartPoint',[0,0]);

%identifying outliers
fdata = feval(fit1,xval); 
I = abs(fdata - yval) > 1.5*std(yval);
outliers = excludedata(xval,yval,'indices',I);

incarray = outliers == 0;
inliers = stop(incarray,:);
inliers = [inliers(:,1).' ; inliers(:,2).'];


hold on
c = minBoundingBox(inliers);

% plot
plot(fit1,'r-',xval,yval,'k.',outliers,'m*') 
hold on
plot(c(1,[1:end 1]),c(2,[1:end 1]),'k');
xlim([-360,300]);
ylim([-155,140]);
%  
% %have to correct for minBoundingBox limitations
% %find the two points with the most negative x values
% [temp, order] = sort(c(1,:));
% ans = c(:,order);
% thickness = pdist([ans(:,1).';ans(:,2).'],'euclidean');
% 
% %find the two points with the most negative y values to find length
% [temp, order] = sort(c(2,:));
% ans = c(:,order);
% length = pdist([ans(:,1).';ans(:,2).'],'euclidean')
% 
% %calculate angle
% slope = (c(2,2) - c(2,1)) ./ abs((c(1,2) - c(1,1)));
% angle = atand(slope);
% 
% %correct for lines that slope downwards
% if angle > 70
%    angle = 90 - angle;
% end
% % 
% % ratio = length/thickness;
% % 
% % output = [output;[thickness,length,ratio,angle]];
% % 
% % %deletes instances where length has not been properly calculated
% % 
% % rec=[rec;vars];
% % 
% % end
% % rec(output(:,2)<= 10, :)= [];
% % output(output(:,2)<= 10, :)= [];
% thic=[thic;thickness];
% long=[long;length];
% ang=[ang;angle];
end

