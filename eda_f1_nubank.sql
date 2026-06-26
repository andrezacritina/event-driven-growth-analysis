/* Visualizando as 5 primeiras linhas para entender os dados da tabela de cadastros_brutos */

select 
  * 
from `nubank_data.cadastros_clientes`
limit 5;


/* Comparação do volume de cadastros entre Brasil e Estados Unidos durante o período analisado  */

SELECT
  codigo_do_pais,
  count(distinct id_usuario) as qtd_usuarios
FROM `nubank_data.cadastros_clientes`
WHERE data_hora_cadastro >= '2026-05-01 00:00:00' 
  AND data_hora_cadastro <= '2026-05-31 23:59:59'

GROUP BY codigo_do_pais
ORDER BY qtd_usuarios DESC;


/*Evolução diária dos cadastros americanos para identificação de padrões e possíveis picos de aquisição*/

SELECT
  CAST(data_hora_cadastro AS DATE) as dia_de_cadastro,
  COUNT(DISTINCT id_usuario) as qtd_cadastros
FROM `nubank_data.cadastros_clientes`
WHERE codigo_do_pais = 'US'
GROUP BY dia_de_cadastro
ORDER BY dia_de_cadastro;



/*Identificação das faixas horárias com maior concentração de cadastros no dia do GP de Miami*/

SELECT
  EXTRACT(HOUR FROM data_hora_cadastro) AS hora_cadastro, 
  COUNT(DISTINCT id_usuario) AS qtd_cadastros_eventos, 
FROM `nubank_data.cadastros_clientes`
WHERE codigo_do_pais = 'US' 
  AND CAST(data_hora_cadastro AS DATE) = '2026-05-03'
GROUP BY EXTRACT(HOUR FROM data_hora_cadastro)
ORDER BY hora_cadastro ASC;
