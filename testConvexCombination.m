profile on
clear, clc, close all

% randn('state',2)

nP = 20; % Number of random points employd in the creation of the polytope
n = 4; % Dimension

Vmpt = randn(nP,n); % Vertex matrix in MPT format (row-wise)

P = Polyhedron(Vmpt);
P.minVRep();

V = (P.V)'; % Vertices in column-wise form

P.computeHRep;
P.minHRep();
aux = P.H;
H = aux(:,1:n);
b = aux(:,end);

% Takes a point inside the polytope
flag = 0;
while flag == 0
    x = 0.8*randn(n,1);
    if max(H*x - b) < 0, flag = 1; end
end

disp('Start proposed algorithm.')

% max(H*x - b)

tic
[listV, lambda] = findConvexCombination(H,b,V,x);
elapsed_time = toc

solV = V(:,listV);
nSolV = length(solV);

xhat = zeros(n,1);
for i = 1:nSolV
    xhat = xhat + lambda(i)*solV(:,i);
end

[x xhat]

lambda
sum(lambda)