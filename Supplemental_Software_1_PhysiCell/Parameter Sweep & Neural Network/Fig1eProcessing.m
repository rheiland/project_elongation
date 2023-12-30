
rec = [];
output = [];

for i = 1:numel(data(:,1))
pos =data(i,:).';
vars = var(i,:);

N=300;
NCN=[105:10:295,106:10:296,104:10:184,107:10:187]; % NC cells 

xval= pos(NCN,:);
yval= pos(N+NCN,:);

%deletes NC cells that have escaped
NC = [xval,yval];

NC(NC(:,2)>= 5, :)= [];
NC(NC(:,2)<= -5, :)= [];
NC(NC(:,1)>= 5, :)= [];
NC(NC(:,1)<= -25, :)= [];

xval= NC(:,1);
yval= NC(:,2);

%fitting to linear regression
f = fittype('a*x+b'); 
fit1 = fit(xval,yval,f,'StartPoint',[0,0]);

%identifying outliers
fdata = feval(fit1,xval); 
I = abs(fdata - yval) > 1.5*std(yval);
outliers = excludedata(xval,yval,'indices',I);

incarray = outliers == 0;
inliers = NC(incarray,:);
inliers = [inliers(:,1).' ; inliers(:,2).'];


hold on
c = minBoundingBox(inliers);

% % plot
% plot(fit1,'r-',xval,yval,'k.',outliers,'m*') 
% hold on
% plot(c(1,[1:end 1]),c(2,[1:end 1]),'k');
% xlim([-35 5]);
% ylim([-5 5]);

%have to correct for minBoundingBox limitations
%find the two points with the most negative x values
[temp, order] = sort(c(1,:));
ans = c(:,order);
thickness = pdist([ans(:,1).';ans(:,2).'],'euclidean');

%find the two points with the most negative y values to find length
[temp, order] = sort(c(2,:));
ans = c(:,order);
length = pdist([ans(:,1).';ans(:,2).'],'euclidean');

%calculate angle
slope = (c(2,2) - c(2,1)) ./ abs((c(1,2) - c(1,1)));
angle = atand(slope);

%correct for lines that slope downwards
if angle > 70
   angle = 90 - angle;
end

ratio = length/thickness;

output = [output;[thickness,length,ratio,angle]];

%deletes instances where length has not been properly calculated

rec=[rec;vars];

end

rec(output(:,2)<= 10, :)= [];
output(output(:,2)<= 10, :)= [];





