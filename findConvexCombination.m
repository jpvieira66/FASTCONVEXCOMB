function [listV,lambda] = findConvexCombination(H,b,V,x)

% Finds a list of vertices whose convex hull comprises a point x (in column vector representation)
% in a polytope with H-rep H*x < = b and vertices stored in V (column-wise).
%
% lambda is the vector of convex combination coefficientes associated to
% the vertices indexed in listV

nV = size(V,2); % Number of vertices
indexV = 1:nV;

% (Dimensionality reduction): Checks if x lies on a facet
aux = abs(H*x - b);
ib = find(aux < 1e-6);
if ~isempty(ib)
    % Removes vertices outside the facet
    hHit = H(ib,:); bHit = b(ib);
    % If any equality is not satisfied, the vertex is removed
    aux = abs(hHit*V - bHit);
    iOut =  find(sum(aux,1) > 1e-6); % Sum along each column of aux
    V(:,iOut) = [];
    indexV(iOut) = [];
    nV = nV - length(iOut);
    % Removes equality constraints associated to the facet
    H(ib,:) = [];  b(ib) = [];
end

% Initialization: Finds vertex closest to x
z = x;
Dif = V - repmat(z,1,nV);
Dist2 = sum(Dif.^2);
[d2Min,iMin] = min(Dist2);
listV = indexV(iMin);

i = 1; % Vertex counter
while d2Min > 1e-12

    % Shoots a ray
    v = V(:,iMin);
    p = z;
    [gamma(i), Ib, z] = findBoundaryPointPolytope(H,b,v,p);
   
    % Removes vertex already used
    V(:,iMin) = [];
    indexV(iMin) = [];
    nV = nV - 1;
  
    % Removes vertices outside the intersection of the hyperplanes hit by the ray
    hHit = H(Ib,:); bHit = b(Ib);
    % If any equality is not satisfied, the vertex is removed
    aux = abs(hHit*V - bHit);
    iOut =  find(sum(aux,1) > 1e-6); % Sum along each column of aux
    V(:,iOut) = [];
    indexV(iOut) = [];
    nV = nV - length(iOut);
   
    % Removes equality constraints associated to the hyperplanes hit by the ray
    H(Ib,:) = [];
    b(Ib) = [];
    
    % Vertex check
    Dif = V - repmat(z,1,nV);
    Dist2 = sum(Dif.^2);
    [d2Min,iMin] = min(Dist2);
    listV = [listV indexV(iMin)];

    i = i + 1;

end

nListV = length(listV);
% Finds the convex combination coefficients
for j = 1:(nListV-1)
   aux = 1 - gamma(j);
   for k = (j+1):(nListV-1)
       aux = aux*gamma(k);
   end
   coef(j) = -aux;
end
coef(nListV) = 1;

lambda = coef/prod(gamma);