% this function makes a movie given input data matrix and others
% 05/2016 - FX revises to improve speed and incorporate different cell
% types

function []=makemovie2(Data,N,chemoN,tipN,NCN,boundary,moviename)

Y=Data{1,3};
T=Data{1,2};
Y1=Data{1,5};
T1=Data{1,4};
cutsn=findcell(Y(:,end),N,Data{1,1});
cutsn(cutsn==tipN)=[];
% protect tipN from being cut

writeobj=VideoWriter(moviename);
open(writeobj);
figure(1);
drawsn=1:N;
drawsn(cutsn)=[];
stepT=5; % takes a frame every 5 iteration points
NCN1=NCN;
NCN1(ismember(NCN1,cutsn))=[];

for j=2:stepT:length(T)-1
    clf;
    hold on;
    quiver(Y(1:N,j),Y(N+1:2*N,j),Y(2*N+1:3*N,j+1)-Y(2*N+1:3*N,j),Y(3*N+1:4*N,j+1)-Y(3*N+1:4*N,j),0.3,'o','showarrowhead','on');
    plot(Y(chemoN,j),Y(N+chemoN,j),'or','MarkerFaceColor', 'r');
    for k=1:length(NCN)
        plot(Y(NCN(k),j),Y(N+NCN(k),j),'or','MarkerFaceColor', 'r');
    end
    for i=1:N
        endn=max(2,j-50*stepT);
        plot(Y(i,j:-50:endn),Y(N+i,j:-50:endn))
    end
    axis(boundary);
    %axis equal;
    hold off;
    frame=getframe;
    writeVideo(writeobj,frame);
    pause(0.1)
end
for j=2:stepT:length(T1)-1
    clf;
    hold on;
    quiver(Y1(drawsn,j),Y1(N+drawsn,j),Y1(2*N+drawsn,j+1)-Y1(2*N+drawsn,j),Y1(3*N+drawsn,j+1)-Y1(3*N+drawsn ,j),0.3,'o','showarrowhead','on');
    plot(Y1(chemoN,j),Y1(N+chemoN,j),'or','MarkerFaceColor', 'r');
    for k=1:length(NCN1)
        plot(Y1(NCN1(k),j),Y1(N+NCN1(k),j),'or','MarkerFaceColor', 'r');
    end
    for i=1:N
        if (isempty(find(i==drawsn,1)))
            continue;
        end
        endn=max(2,j-50*stepT);
        plot(Y1(i,j:-50:endn),Y1(N+i,j:-50:endn))
    end
    axis(boundary);
    %axis equal;
    hold off;
    frame=getframe;
    writeVideo(writeobj,frame);
    pause(0.1)
end

close(writeobj);