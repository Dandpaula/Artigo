function a = bound(a, X_max, X_min)
% Garante que cada elemento do vetor 'a' esteja entre os limites X_min e X_max

a(a > X_max) = X_max(a > X_max); 
a(a < X_min) = X_min(a < X_min);

end
