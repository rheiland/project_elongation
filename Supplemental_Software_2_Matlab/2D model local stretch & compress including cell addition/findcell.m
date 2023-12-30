% this function finds cellIDs in a given area, within a given set of
% coordinates

% input: V, one column vector with row numbers as cellIDs; cut, coordinate
% boundaries; N, Number of cells
% output: a vector of row numbers (cellIDs)

function out=findcell(V,N,cut)
out=find(V(1:N)<cut(1) & V(1:N)>cut(2) & abs(V(N+1:2*N))>cut(3) & abs(V(N+1:2*N))<cut(4));

% take out absolute values for single side cut
%out=find(V(1:N)<cut(1) & V(1:N)>cut(2) & V(N+1:2*N)>cut(3) & V(N+1:2*N)<cut(4));

end
