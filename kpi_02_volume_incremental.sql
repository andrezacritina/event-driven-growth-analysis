/* ====================================================================
   FASE 02: MODELAGEM DE KPIS - MANIFESTO DE PRODUTO
   KPI 2: Quantos clientes realizaram o cadastro e entraram para a lista de leads do banco?

   Objetivo:
  Estimar quantos clientes adicionais foram adquiridos no dia do GP de Miami em comparação com 
  o comportamento histórico de aquisição dos usuários americanos.

  Nota metodológica:
  Os dias normais são calculados com base na média diária de cadastros nos dias sem influência 
  direta do evento (excluindo o dia do GP e os dois dias subsequentes para evitar contaminação do efeito).
==================================================================== */

WITH cadastros_evento AS(
  /* Volume de cadastros de clientes americanos no dia do GP */
  SELECT
    COUNT(DISTINCT id_usuario) AS qtd_cadastros
FROM `nubank_data.cadastros_clientes`
WHERE codigo_do_pais = 'US'
AND DATE(data_hora_cadastro) = '2026-05-03'
),

 /* Construção do comportamento histórico de aquisição
  (dias considerados “normais” sem influência do evento) */
dia_normal AS(
  SELECT
    DATE(data_hora_cadastro) AS dia,
    COUNT(DISTINCT id_usuario) AS qtd_normal
  FROM `nubank_data.cadastros_clientes`
  WHERE codigo_do_pais = 'US'
  AND DATE(data_hora_cadastro) NOT IN ('2026-05-03', '2026-05-04', '2026-05-05')
  GROUP BY dia
)

/* Comparação entre evento e a base de cadastros em dias normais 
para estimar o volume incremental de aquisição */
SELECT
  e.qtd_cadastros AS cadastros_evento,
  ROUND(AVG(n.qtd_normal),1) AS media_cadastros,
  /* Diferença entre observado e esperado */
  e.qtd_cadastros - ROUND(AVG(n.qtd_normal), 2) AS vol_incremental
FROM cadastros_evento e
CROSS JOIN dia_normal n 

GROUP BY e.qtd_cadastros;