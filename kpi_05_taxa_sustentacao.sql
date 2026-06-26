/*  ====================================================================
   FASE 02: MODELAGEM DE KPIS - MANIFESTO DE PRODUTO
   KPI 5: Quanto do volume inicial de aquisição de clientes foi mantido ao longo das 72 horas após o GP?

   Objetivo: Avaliar a capacidade do GP de Miami de manter a aquisição
  de clientes americanos nos dias subsequentes ao evento.

  A análise compara o volume de cadastros dos três primeiros dias após a largada utilizando
  o Dia 1 como referência.
==================================================================== */

WITH volume_diario AS(
  /* Consolidação do volume diário de cadastros durante as 72 horas posteriores ao GP */
  SELECT
    CASE
      WHEN DATE_DIFF(DATE(data_hora_cadastro), DATE('2026-05-03'), DAY) = 0 THEN 'Dia 1'
      WHEN DATE_DIFF(DATE(data_hora_cadastro), DATE('2026-05-03'), DAY) = 1 THEN 'Dia 2'
      ELSE'Dia 3'
    END AS dia_cadastro,
    COUNT(DISTINCT id_usuario) AS qtd_cadastros  
  FROM `nubank_data.cadastros_clientes`

  WHERE codigo_do_pais = 'US'
    AND data_hora_cadastro BETWEEN TIMESTAMP('2026-05-03 19:00:00')
      AND TIMESTAMP_ADD(TIMESTAMP('2026-05-03 19:00:00'), INTERVAL 72 HOUR)

  GROUP BY dia_cadastro
  ORDER BY dia_cadastro
),

/* Utilização do primeiro dia como referência para medir a manutenção do interesse ao longo do tempo */
calculo_sustentacao AS(
  SELECT
    dia_cadastro,
    qtd_cadastros,
    FIRST_VALUE(qtd_cadastros) OVER(ORDER BY dia_cadastro) AS volume_dia_1
  FROM volume_diario
)

/* Cálculo da taxa de sustentação do evento */
SELECT
  dia_cadastro,
  qtd_cadastros,
  ROUND((qtd_cadastros/volume_dia_1) * 100, 2) AS taxa_sustentacao
FROM calculo_sustentacao

ORDER BY dia_cadastro 

