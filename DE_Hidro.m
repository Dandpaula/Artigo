function DE_Hidro()

clc; clear;
global DE_curve

% -------------------------
n = 4;
Qmin = 50 * ones(1,n);
Qmax = 150 * ones(1,n);
Qtotal = 400;

PopSize = 30;
Max_iter = 100;
F = 0.5;
CR = 0.9;

Pop = zeros(PopSize, n);
for i = 1:PopSize
    Pop(i,:) = rand(1,n) .* (Qmax - Qmin) + Qmin;
    Pop(i,:) = ajustarVazaoTotal(Pop(i,:), Qtotal, Qmin, Qmax);
end

Fitness = zeros(PopSize, 1);
for i = 1:PopSize
    Fitness(i) = objective_function(Pop(i,:));
end

[bestFitness, bestIdx] = min(Fitness);
BestSol = Pop(bestIdx,:);
Convergence_curve = zeros(1, Max_iter);

for iter = 1:Max_iter
    for i = 1:PopSize
        idx = randperm(PopSize, 3);
        while any(idx == i)
            idx = randperm(PopSize, 3);
        end
        x1 = Pop(idx(1),:); x2 = Pop(idx(2),:); x3 = Pop(idx(3),:);
        mutant = x1 + F * (x2 - x3);

        trial = Pop(i,:);
        jrand = randi(n);
        for j = 1:n
            if rand <= CR || j == jrand
                trial(j) = mutant(j);
            end
        end

        trial = bound(trial, Qmax, Qmin);
        trial = ajustarVazaoTotal(trial, Qtotal, Qmin, Qmax);
        trial_fitness = objective_function(trial);

        if trial_fitness < Fitness(i)
            Pop(i,:) = trial;
            Fitness(i) = trial_fitness;
        end
    end

    [bestFitness, bestIdx] = min(Fitness);
    BestSol = Pop(bestIdx,:);
    Convergence_curve(iter) = bestFitness;

    fprintf('Iteração %d: Melhor Valor = %.4f\n', iter, -bestFitness);
end

disp('Melhor distribuição de vazão (DE):');
disp(BestSol);
disp('Valor máximo da função objetivo (DE):');
disp(-bestFitness);

DE_curve = Convergence_curve;

% Gráfico
figure;
plot(-Convergence_curve, 'r', 'LineWidth', 2);
xlabel('Iterações'); ylabel('Função Objetivo');
title('Convergência da Evolução Diferencial');
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
