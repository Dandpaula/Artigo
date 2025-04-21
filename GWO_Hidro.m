function GWO_Hidro()

clc; clear;
global GWO_curve

% -------------------------
% Parâmetros do problema
n = 4;
Qmin = 50 * ones(1,n);
Qmax = 150 * ones(1,n);
Qtotal = 400;

% -------------------------
% Parâmetros do algoritmo
SearchAgents_no = 30;
Max_iter = 100;

% Inicializar posições
Positions = zeros(SearchAgents_no, n);
for i = 1:SearchAgents_no
    Positions(i,:) = rand(1,n) .* (Qmax - Qmin) + Qmin;
    Positions(i,:) = ajustarVazaoTotal(Positions(i,:), Qtotal, Qmin, Qmax);
end

Alpha_pos = zeros(1,n);
Alpha_score = inf;
Beta_pos = zeros(1,n); Beta_score = inf;
Delta_pos = zeros(1,n); Delta_score = inf;

Convergence_curve = zeros(1, Max_iter);

for t = 1:Max_iter
    for i = 1:SearchAgents_no
        Positions(i,:) = bound(Positions(i,:), Qmax, Qmin);
        Positions(i,:) = ajustarVazaoTotal(Positions(i,:), Qtotal, Qmin, Qmax);
        fitness = objective_function(Positions(i,:));

        if fitness < Alpha_score
            Alpha_score = fitness;
            Alpha_pos = Positions(i,:);
        elseif fitness < Beta_score
            Beta_score = fitness;
            Beta_pos = Positions(i,:);
        elseif fitness < Delta_score
            Delta_score = fitness;
            Delta_pos = Positions(i,:);
        end
    end

    a = 2 - t * (2 / Max_iter);

    for i = 1:SearchAgents_no
        for j = 1:n
            r1 = rand(); r2 = rand();
            A1 = 2*a*r1 - a; C1 = 2*r2;
            D_alpha = abs(C1*Alpha_pos(j) - Positions(i,j));
            X1 = Alpha_pos(j) - A1*D_alpha;

            r1 = rand(); r2 = rand();
            A2 = 2*a*r1 - a; C2 = 2*r2;
            D_beta = abs(C2*Beta_pos(j) - Positions(i,j));
            X2 = Beta_pos(j) - A2*D_beta;

            r1 = rand(); r2 = rand();
            A3 = 2*a*r1 - a; C3 = 2*r2;
            D_delta = abs(C3*Delta_pos(j) - Positions(i,j));
            X3 = Delta_pos(j) - A3*D_delta;

            Positions(i,j) = (X1 + X2 + X3) / 3;
        end
    end

    Convergence_curve(t) = Alpha_score;
    fprintf('Iteração %d: Melhor Valor = %.4f\n', t, -Alpha_score);
end

disp('Melhor distribuição de vazão (GWO):');
disp(Alpha_pos);
disp('Valor máximo da função objetivo (GWO):');
disp(-Alpha_score);

% Salvar curva global
GWO_curve = Convergence_curve;

% Gráfico
figure;
plot(-Convergence_curve, 'b', 'LineWidth', 2);
xlabel('Iterações'); ylabel('Função Objetivo');
title('Convergência do GWO');
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
