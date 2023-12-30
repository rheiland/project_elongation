% this function makes a movie given input data matrix and others
% 05/2016 - FX revises to improve speed and incorporate different cell types

function []=makemovie2(Data,N,NCN,boundary,moviename,Ax)

Y=Data{1,2};
T=Data{1,1};

% protect tipN from being cut

writeobj=VideoWriter(moviename);
open(writeobj);
figure(1);
drawsn=1:N;
stepT=200; % takes a frame every 5 iteration points
 

for j=2:stepT:length(T)-1
    clf; %clear current figure
    hold on; 
    
    %quiver plot, velocity vectors as arrows 
    quiver(Y(1:N,j),Y(N+1:2*N,j),Y(2*N+1:3*N,j+1)-Y(2*N+1:3*N,j),Y(3*N+1:4*N,j+1)-Y(3*N+1:4*N,j),0.3,'o','showarrowhead','on');
   
    for k=1:length(NCN)
        plot(Y(NCN(k),j),Y(N+NCN(k),j),'or','MarkerFaceColor', 'r');
    end
    
     for k=1:length(Ax)
        plot(Y(Ax(k),j),Y(N+Ax(k),j),'oy','MarkerFaceColor', 'w');
     end

    axis(boundary);
    hold off;
    frame=getframe;
    writeVideo(writeobj,frame);
    pause(0.1)
end

close(writeobj);