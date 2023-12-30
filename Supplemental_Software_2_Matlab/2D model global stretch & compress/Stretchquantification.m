output = [];
rec=[];

for i = 1:n

Y = Data{1,1+i};

ini = Y(:,1);
fin = Y(:,8001);


inix_val= ini(NCN,:);
iniy_val= ini(N+NCN,:);

finx_val= fin(NCN,:);
finy_val= fin(N+NCN,:);


%deletes NC cells that have escaped from the final
NC = [finx_val,finy_val];

NC(NC(:,2)>= 5, :)= [];
NC(NC(:,2)<= -5, :)= [];
NC(NC(:,1)>= 5, :)= [];
NC(NC(:,1)<= -25, :)= [];

NC(isnan(NC))=0;

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

 
% % plot to check the min bounding box

% plot(fit1,'r-',xval,yval,'k.',outliers,'m*') 
% hold on
% plot(c(1,[1:end 1]),c(2,[1:end 1]),'k');
% xlim([-35 5]);
% ylim([-5 5]);



%Calculate initial distance
%find the two points with the most negative x values
[temp, order] = sort(c(1,:));
ans = c(:,order);
thickness = pdist([ans(:,1).';ans(:,2).'],'euclidean');

%find the two points with the most negative y values to find length
[temp, order] = sort(c(2,:));
ans = c(:,order);
length = pdist([ans(:,1).';ans(:,2).'],'euclidean');


% % calculate angle of notochord

% slope = (c(2,2) - c(2,1)) ./ abs((c(1,2) - c(1,1)));
% angle = atand(slope);
% %correct for lines that slope downwards
% if angle > 70
%    angle = 90 - angle;
% end

%Extension-Convergence ratio
ExCratio = length/thickness;

%Extension ratio
%original length is just the biggest absolute value of inix_val


Exratio = length/(abs(min(inix_val))+ max(inix_val));

%deletes instances where length has not been properly calculated

rec=[rec;fin];
output = [output; [ExCratio,Exratio]];

end

csvwrite('output3.csv',output);
csvwrite('recorder3.csv',rec);

