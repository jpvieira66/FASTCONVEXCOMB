function [gamma, Ib, z] = findBoundaryPointPolytope(H,b,v,p)

% Finds a boundary point xb in a polytope (i.e. a bounded polyhedron) described by H*x <= b. 
%
% The boundary point is obtained by shooting a ray from point v
% along a direction given by the column vector (p - v).
% It is assumed that v, p belong to the polytope and that p is in the
% interior of the polytope.
% Ib is the index set of the inequalities corresponding 
% to the boundary hyperplanes hit by the ray, i.e. H(Ib,:)*z = b(Ib)

c = p - v;
Z = H*c;
W = b - H*v;

iPlus = find(Z > 0);

aux = W(iPlus)./Z(iPlus);
gamma = min(aux);
index_gamma = find(abs(aux-gamma) < 1e-12);

z = v + gamma*c; % Boundary point
Ib = iPlus(index_gamma);