% Leitura dos dados
data = readtable("Beach_Water_Quality_-_Automated_Sensors_20240808 (1).csv");

% Seleção das colunas relevantes (Temperatura, Turbidez, Altura das Ondas)
temp = data.WaterTemperature;
turb = data.Turbidity;
hight = data.WaveHeight;

% Limpeza dos dados: removendo valores NaN e filtrando valores negativos
temp = rmmissing(temp(temp >= 0));
turb = rmmissing(turb(turb >= 0));
hight = rmmissing(hight(hight >= 0));

% Cálculo das médias
m_temp = mean(temp);
m_turb = mean(turb);
m_hight = mean(hight);

% Cálculo das incertezas (desvio padrão)
i_temp = std(temp);
i_turb = std(turb);
i_hight = std(hight);

% Exibição das médias e incertezas
fprintf('=== Média e Incerteza ====\n');
fprintf('Temperatura: Média = %.2f, Incerteza = %.2f\n', m_temp, i_temp);
fprintf('Turbidez: Média = %.2f, Incerteza = %.2f\n', m_turb, i_turb);
fprintf('Altura das Ondas: Média = %.2f, Incerteza = %.2f\n', m_hight, i_hight);

% Definição das faixas para normalização
temp_min = 15; temp_max = 30;
turb_min = 0; turb_max = 5;
hight_min = 0; hight_max = 5;

% Normalização das variáveis para valores entre 0 e 1
temp_norm = min(max((m_temp - temp_min) / (temp_max - temp_min), 0), 1);
turb_norm = min(max((m_turb - turb_min) / (turb_max - turb_min), 0), 1);
hight_norm = min(max((m_hight - hight_min) / (hight_max - hight_min), 0), 1);

% Combinação dos riscos (média aritmética simples)
risco_final = (temp_norm + turb_norm + hight_norm) / 3;

% Propagação de incerteza combinada (raiz quadrada da soma dos quadrados das incertezas)
incerteza_combinada = sqrt(i_temp^2 + i_turb^2 + i_hight^2);

% Propagação de incerteza expandida (multiplicada pelo fator de cobertura k = 2)
k = 2;
incerteza_expandida = k * incerteza_combinada;

% Exibição do risco final e das incertezas combinada e expandida
fprintf('Risco Final: %.2f\n', risco_final);
fprintf('Incerteza Combinada: %.2f\n', incerteza_combinada);
fprintf('Incerteza Expandida: %.2f\n', incerteza_expandida);
