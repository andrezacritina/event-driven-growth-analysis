/*  ====================================================================
   FASE 02: MODELAGEM DE KPIS - MANIFESTO DE PRODUTO
   KPI 3: No dia do evento, o quanto os EUA ganharam relevância dentro do Nubank global?

   Objetivo:
  Mensurar a relevância do mercado americano dentro da estratégia global de 
  aquisição do Nubank durante o dia do GP de Miami.

  A análise compara o volume de clientes americanos com o total de clientes adquiridos globalmente,
  permitindo avaliar a participação dos EUA na aquisição total da companhia.
==================================================================== */

SELECT
/* Cálculo da participação dos EUA sobre o total de cadastros realizados no dia do evento */
  COUNT(DISTINCT id_usuario) AS cadastros_mundial,
  COUNT(DISTINCT CASE 
    WHEN codigo_do_pais = 'US' 
    THEN id_usuario END)
  AS casdastros_us,
  ROUND(
    (COUNT(DISTINCT CASE 
      WHEN codigo_do_pais = 'US' 
    THEN id_usuario END )) / (COUNT(DISTINCT id_usuario)) *100, 2) AS  share_percentual
FROM `nubank_data.cadastros_clientes`
WHERE DATE(data_hora_cadastro) = '2026-05-03'