/*  ====================================================================
   FASE 02: MODELAGEM DE KPIS - MANIFESTO DE PRODUTO
   KPI 4: Qual é o tempo que o cliente americano leva entre ver a marca no evento e finalmente tomar a decisão de se cadastrar?

   Objetivo: Analisar quanto tempo os usuários americanos levaram para
  realizar o cadastro após serem impactados pelo GP de Miami.

  A análise considera uma janela de 72 horas após a largada, permitindo identificar se a conversão 
  acontece por impulso ou após um período de consideração da marca.
==================================================================== */

WITH cadastros_corrida AS(
  /* Cálculo da diferença, em horas, entre a largada do GP e o momento em que o usuário realizou seu cadastro */
  SELECT
    id_usuario,
    TIMESTAMP_DIFF(data_hora_cadastro,TIMESTAMP('2026-05-03 19:00:00'), HOUR) AS horas_pos_largada
  FROM `nubank_data.cadastros_clientes`
  WHERE codigo_do_pais = 'US'
    AND data_hora_cadastro BETWEEN TIMESTAMP('2026-05-03 19:00:00')
      AND TIMESTAMP_ADD(TIMESTAMP('2026-05-03 19:00:00'),INTERVAL 72 HOUR)
)

/* Classificação dos cadastros entre conversão imediata e conversão após período de consideração */
SELECT
  horas_pos_largada, 
  CASE
    WHEN horas_pos_largada BETWEEN 0 AND 2 THEN '1.Durante o Evento (Impulso)'
    ELSE '2.Pós-Evento (Incubação/Namoro)'
  END AS momento_cadastro,
  COUNT(DISTINCT id_usuario) AS qtd_cadastros
FROM cadastros_corrida
GROUP BY horas_pos_largada, momento_cadastro
ORDER BY horas_pos_largada