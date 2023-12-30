clear; 
n = 1

%Field Parameters
N=300; % number of cells (to start simulation)
boundary=[-35,5,-5,5]; % field size
boundaryc=[-25,5,-5,5]; % intial cell domain size
Time=8000; %8000


%Allocate cells
 NCN=[105:10:295,106:10:296,104:10:184,107:10:187]; % NC cells 
 Ax=[1:10:131,10:10:140,2:10:102,9:10:109,3:10:73,8:10:78,4:10:54,7:10:57,5:10:45,6:10:46];%External cells
% 


%Determine repulsion parameters
alphaPSM= 10; 
alphaNC= 4;
alphaEX= 0.6;
alphaPN= 60; 
alphaPE= 35;
alphaNE= 15;

Data=cell(1,n+1);

for i = 1:n
%Simulation code
[T,Y,recorder]=allocate(N,Ax,boundary,boundaryc,NCN,Time,alphaPSM,alphaNC,alphaEX,alphaPN,alphaPE,alphaNE);
Data{1,1}=T;
Data{1,1+i}=Y;
end


 
% %Make movie
%  moviename='moviename';
%  makemovie2(Data,N,NCN,boundary,moviename,Ax);
% % %End of Make Movie


% % The following code plots distance over time
% 
% t=Data{1,1};
% rec=[]
% meanrec=[]
%      
%     for i = 1:n
%     y=Data{1,1+i};
%     NC=y(NCN,:);
%     NC=sort(NC,'ascend');
%     dist=abs(NC(1,:));
%     rec=[rec;dist];
%     end
%     
% meanrec=mean(rec,1);        
% stdrec=std(rec);
% 
% hold on
% sub=1:200:8001;
% h=errorbar(t(:,sub),meanrec(:,sub),stdrec(:,sub));
% 
% 
% 
% meanrec=mean(rec,1);
% h=plot(t,meanrec);
% 
% saveas(h,'quantdist.png','png');
% 
% % end of distance over time script

% 
% %%This code is for finding the ratio of the final length to the initial
% %%length
% 
% 
% output = [];
% rec=[];
% 
% for i = 1:n
% 
% Y = Data{1,1+i};
% 
% ini = Y(:,1);
% fin = Y(:,8001);
% 
% 
% inix_val= ini(NCN,:);
% iniy_val= ini(N+NCN,:);
% 
% finx_val= fin(NCN,:);
% finy_val= fin(N+NCN,:);
% 
% 
% %deletes NC cells that have escaped from the final
% NC = [finx_val,finy_val];
% 
% NC(NC(:,2)>= 5, :)= [];
% NC(NC(:,2)<= -5, :)= [];
% NC(NC(:,1)>= 5, :)= [];
% NC(NC(:,1)<= -25, :)= [];
% 
% xval= NC(:,1);
% yval= NC(:,2);
% 
% %fitting to linear regression
% f = fittype('a*x+b'); 
% fit1 = fit(xval,yval,f,'StartPoint',[0,0]);
% 
% %identifying outliers
% fdata = feval(fit1,xval); 
% I = abs(fdata - yval) > 1.5*std(yval);
% outliers = excludedata(xval,yval,'indices',I);
% 
% incarray = outliers == 0;
% inliers = NC(incarray,:);
% inliers = [inliers(:,1).' ; inliers(:,2).'];
% 
% 
% hold on
% c = minBoundingBox(inliers);
% 
%  
% % % plot to check the min bounding box
% 
% % plot(fit1,'r-',xval,yval,'k.',outliers,'m*') 
% % hold on
% % plot(c(1,[1:end 1]),c(2,[1:end 1]),'k');
% % xlim([-35 5]);
% % ylim([-5 5]);
% 
% 
% 
% %Calculate initial distance
% %find the two points with the most negative x values
% [temp, order] = sort(c(1,:));
% ans = c(:,order);
% thickness = pdist([ans(:,1).';ans(:,2).'],'euclidean');
% 
% %find the two points with the most negative y values to find length
% [temp, order] = sort(c(2,:));
% ans = c(:,order);
% length = pdist([ans(:,1).';ans(:,2).'],'euclidean');
% 
% 
% % % calculate angle of notochord
% 
% % slope = (c(2,2) - c(2,1)) ./ abs((c(1,2) - c(1,1)));
% % angle = atand(slope);
% % %correct for lines that slope downwards
% % if angle > 70
% %    angle = 90 - angle;
% % end
% 
% %Extension-Convergence ratio
% ExCratio = length/thickness;
% 
% %Extension ratio
% %original length is just the biggest absolute value of inix_val
% 
% 
% Exratio = length/(abs(min(inix_val))+ max(inix_val));
% 
% %deletes instances where length has not been properly calculated
% 
% rec=[rec;fin];
% output = [output; [ExCratio,Exratio]];
% 
% end
