


n = 3
t=Data{1,1};
rec=[]
meanrec=[]

     
    for i = 1:n
    y=Data{1,1+i};
    NC=y(NCN,:);
    NC=sort(NC,'ascend');
    dist=abs(NC(1,:));
    rec=[rec;dist];
    end
    
meanrec=mean(rec,1);        
stdrec=std(rec);

hold on
sub=1:200:8001;
h=errorbar(t(:,sub),meanrec(:,sub),stdrec(:,sub));



meanrec=mean(rec,1);
h=plot(t,meanrec);

saveas(h,'quantdist.png','png');
clf;






