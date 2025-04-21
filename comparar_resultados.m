function comparar_resultados()

% Declarar as variáveis globais
global GWO_curve DE_curve PSO_curve

% Verificar se estão preenchidas
if isempty(GWO_curve) || isempty(DE_curve) || isempty(PSO_curve)
    error('Rode GWO_Hidro, DE_Hidro e PSO_Hidro antes de comparar.');
end

% Padronizar tamanhos
min_len = min([length(GWO_curve), length(DE_curve), length(PSO_curve)]);
gwo = -GWO_curve(1:min_len);
de = -DE_curve(1:min_len);
pso = -PSO_curve(1:min_len);

% Plotar
figure;
hold on;
g1 = plot(1:min_len, gwo, 'b', 'LineWidth', 2);
g2 = plot(1:min_len, de, 'r', 'LineWidth', 2);
g3 = plot(1:min_len, pso, 'g', 'LineWidth', 2);
legend([g1 g2 g3], {'GWO', 'DE', 'PSO'}, 'Location', 'best');

xlabel('Iterações');
ylabel('Função Objetivo');
title('Comparação da Convergência: GWO x DE x PSO');
grid on;

end
