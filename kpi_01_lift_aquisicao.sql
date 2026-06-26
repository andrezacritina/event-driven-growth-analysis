/* =========================================================
   FASE 02: MODELAGEM DE KPIS - MANIFESTO DE PRODUTO
   KPI 1: Lift de Aquisição (O Termômetro de Atração)
   Objetivo: Mensurar o impacto do GP de Miami na aquisição de clientes
      americanos, comparando o volume de cadastros do dia do evento
      com o comportamento histórico em dias sem influência
      direta da corrida.
   ========================================================= */


/* volume dos cadastros americanos no dia do evento */
WITH table_cadastro_eventos AS(
  SELECT
    COUNT(DISTINCT id_usuario) AS qtd_evento
  FROM `nubank_data.cadastros_clientes`
  WHERE codigo_do_pais = 'US'
    AND DATE(data_hora_cadastro) = '2026-05-03'
),

/* volume de cadastros americanos em dias em que não há eventos. 
Para isso foi feita a exclusão dos dias dos eventos */
table_cadastro_dia_normal AS(
  SELECT
    DATE(data_hora_cadastro) AS dia,
    COUNT(DISTINCT id_usuario) AS qtd_dia_normal
  FROM `nubank_data.cadastros_clientes`
  WHERE codigo_do_pais = 'US'
 
  AND DATE(data_hora_cadastro) NOT IN ('2026-05-03', '2026-05-04', '2026-05-05')

  GROUP BY dia
)

/* proporção do volume de cadastros americanos em dias dos eventos comparados a dias 
que não houve eventos para a construção do Lift de Aquisição % */
SELECT
  e.qtd_evento AS volume_evento,
  ROUND(AVG(n.qtd_dia_normal), 1) AS media_dia_normal,
  ROUND(
    ((e.qtd_evento - AVG(n.qtd_dia_normal)) / AVG(n.qtd_dia_normal)) *100, 2) AS lift_percentual

FROM table_cadastro_eventos e
CROSS JOIN
table_cadastro_dia_normal n 

GROUP BY e.qtd_evento;