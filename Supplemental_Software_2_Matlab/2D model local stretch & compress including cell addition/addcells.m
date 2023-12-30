
% 05/12/16, this new function takes in an x configuration of cells, uses
% available slots in x to add new cells, according to inputs

function [x,Nc]=addcells(x,Nt,Nc,tipN,pdn,pdx,pdy)

for i=1:pdx % number of colums
    for j=1:pdy % number of rows
    x(Nc+i+j-1)=x(tipN)-1-i; % these numnbers can be adjusted, this put new cells to the
    % posterior of the tipN
    x(Nt+Nc+i+j-1)=x(tipN+Nt)-4+j; % this put the first cell lower to tipN
    end
end

Nc=Nc+pdn;

end