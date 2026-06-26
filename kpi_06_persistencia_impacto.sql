/*  ====================================================================
   FASE 02: MODELAGEM DE KPIS - MANIFESTO DE PRODUTO
   KPI 6:Depois de quanto tempo tudo voltou ao normal?
==================================================================== */

WITH aquisicao_dia_normal AS (
  /* Construção da base de comportamento normal de aquisição de clientes americanos partindo da data de 
  15 dias anteriores ao GP de Miami como referência */
  SELECT
    DATE(data_hora_cadastro) AS dia,
    COUNT(DISTINCT id_usuario) AS qtd_clientes
  FROM `nubank_data.cadastros_clientes`
  WHERE codigo_do_pais = 'US'
    AND DATE(data_hora_cadastro)
      BETWEEN DATE_SUB(DATE('2026-05-03'), INTERVAL 15 DAY)
      AND DATE_SUB(DATE('2026-05-03'), INTERVAL 1 DAY)
  GROUP BY dia
),

/* Cálculo da média histórica diária de aquisição que servirá como linha de base para comparação */
media_historica AS (
  SELECT
    AVG(qtd_clientes) AS media_normal
  FROM aquisicao_dia_normal
),

/* Volume diário de cadastros americanos após o GP de Miami */
cadastros_pos_evento AS (
  SELECT
    DATE(data_hora_cadastro) AS dia,
    COUNT(DISTINCT id_usuario) AS qtd_cadastros
  FROM `nubank_data.cadastros_clientes`
  WHERE codigo_do_pais = 'US'
    AND DATE(data_hora_cadastro) >= DATE('2026-05-03')
  GROUP BY dia
)

/* Comparação entre o volume observado após o evento e a média histórica de aquisição */
SELECT
  p.dia,
  p.qtd_cadastros,
  ROUND(m.media_normal,1) AS media_normal
FROM cadastros_pos_evento p
CROSS JOIN media_historica m
ORDER BY p.dia