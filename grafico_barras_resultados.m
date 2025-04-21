function grafico_barras_resultados()

% Valores dos algoritmos
valorGWO = 2321.4;
valorDE  = 2433.1;
valorPSO = 2433.1;

algoritmos = {'GWO', 'DE', 'PSO'};
valores = [valorGWO, valorDE, valorPSO];

% Gráfico de barras
figure;
bar(valores, 0.5);
set(gca, 'xticklabel', algoritmos);
ylabel('Valor Máximo da Função Objetivo');
title('Comparação de Desempenho: GWO x DE x PSO');
grid on;

% Adicionar valores no topo
text(1:length(valores), valores + 20, num2str(valores','%.1f'), ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold');

end
