

% this function receives pounding data "press" from CellMove2 and
% calculate the pressure on the boundaries

function p=getpressure(range,resolution,press)

p=zeros(floor(length(range)/resolution)-1,1);

for i=1:size(p)
    ind=press(:,1)>=range(i) & press(:,1)<range(i+1);
    p(i)=abs(sum(press(ind,2)));
end

end