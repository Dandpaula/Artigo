function PSO_Hidro()

clc; clear;
global PSO_curve

% -------------------------
% Parâmetros do problema
n = 4;
Qmin = 50 * ones(1,n);
Qmax = 150 * ones(1,n);
Qtotal = 400;

% -------------------------
% Parâmetros do PSO
num_particles = 30;
max_iter = 100;
w = 0.7;        % Inércia
c1 = 1.5;       % Peso cognitivo
c2 = 1.5;       % Peso social

% Inicializar partículas
X = zeros(num_particles, n);
V = zeros(num_particles, n);
pbest = zeros(num_particles, n);
pbest_val = inf(num_particles, 1);
gbest = zeros(1,n);
gbest_val = inf;

for i = 1:num_particles
    X(i,:) = rand(1,n) .* (Qmax - Qmin) + Qmin;
    X(i,:) = ajustarVazaoTotal(X(i,:), Qtotal, Qmin, Qmax);
end

% Avaliar população inicial
for i = 1:num_particles
    fit = objective_function(X(i,:));
    pbest(i,:) = X(i,:);
    pbest_val(i) = fit;

    if fit < gbest_val
        gbest = X(i,:);
        gbest_val = fit;
    end
end

Convergence_curve = zeros(1, max_iter);

% -------------------------
% Loop principal
for iter = 1:max_iter
    for i = 1:num_particles
        % Atualizar velocidade
        r1 = rand(1,n);
        r2 = rand(1,n);
        V(i,:) = w * V(i,:) ...
               + c1 * r1 .* (pbest(i,:) - X(i,:)) ...
               + c2 * r2 .* (gbest - X(i,:));

        % Atualizar posição
        X(i,:) = X(i,:) + V(i,:);
        X(i,:) = bound(X(i,:), Qmax, Qmin);
        X(i,:) = ajustarVazaoTotal(X(i,:), Qtotal, Qmin, Qmax);

        % Avaliar
        fit = objective_function(X(i,:));
        if fit < pbest_val(i)
            pbest(i,:) = X(i,:);
            pbest_val(i) = fit;
        end
        if fit < gbest_val
            gbest = X(i,:);
            gbest_val = fit;
        end
    end

    Convergence_curve(iter) = gbest_val;
    fprintf('Iteração %d: Melhor Valor = %.4f\n', iter, -gbest_val);
end

% -------------------------
% Resultados finais
disp('Melhor distribuição de vazão (PSO):');
disp(gbest);
disp('Valor máximo da função objetivo (PSO):');
disp(-gbest_val);

% Salvar curva
PSO_curve = Convergence_curve;

% Gráfico
figure;
plot(-Convergence_curve, 'g', 'LineWidth', 2);
xlabel('Iterações'); ylabel('Função Objetivo');
title('Convergência do PSO');
grid on;

end

% -------------------------
function Q = ajustarVazaoTotal(Q, Qtotal, Qmin, Qmax)
    Q = max(min(Q, Qmax), Qmin);
    soma = sum(Q);
    if soma == 0
        Q = Qmin;
        soma = sum(Q);
    end
    Q = Q / soma * Qtotal;
    Q = max(min(Q, Qmax), Qmin);
end
