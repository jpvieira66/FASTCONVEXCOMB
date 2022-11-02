%% Ilustrative example of the use of the fast method for obtaining convex combination coefficients
%  presented in the paper 
% J. P. Vieira, R. K. H. Galvão and R. J. M. Afonso. "A fast method for obtaining convex combination coefficients," In Automatica, December 16--18, 2023.

n = 3;
% Setting the polytope limits
x_min = [-1 -1 -1];
x_max = [ 1 1 1];

% Constraint sets represented by polpyhedrons
P = Polyhedron('lb',x_min,'ub',x_max);
plot(P,'color',[0.6 0.6 0.6],'alpha',0.2);

% Point to determine the convex combination
x = [0.2 -0.3 0.5];

[listV, lambda] = findConvexCombination(P.A,P.b,P.V',x');

xhat = 0;
nV = length(listV);
for i = 1:nV
    xhat = xhat + lambda(i)*P.V(listV(i),:);
end

% Showing the algorithm results
fprintf('---------------------------Output Results-------------------------------\n')

fprintf('Original Point                         x = [%s] \n', num2str(reshape(x, 1, []))) ;
fprintf('Point from the convex Combination hat{x} = [%s]\n\n',num2str(reshape(xhat, 1, [])));

fprintf('Lambda                                   = [%s]\n',num2str(reshape(lambda, 1, [])));
fprintf('Sum of Lambda coefficientes              =  %2.2f \n',sum(lambda));

for idx_vert = 1:nV
fprintf('Selected vertice V%d  =  [%s]\n',idx_vert, num2str(reshape(P.V(listV(i),:), 1, [])));  
end