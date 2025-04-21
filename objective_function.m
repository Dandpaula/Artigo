function f = objective_function(Q)

% Parâmetros da função Griewank: Eficiência(Q) = 1 + (Q^2 / 4000) - cos(Q)
% Função objetivo: Eficiência(Qi) * Qi para cada turbina

eff = 1 + (Q.^2 / 4000) - cos(Q); % Eficiência de cada turbina
f_total = sum(eff .* Q);         % Soma total da eficiência ponderada por vazão

f = -f_total; % Inverter sinal para transformar em problema de minimização

end
