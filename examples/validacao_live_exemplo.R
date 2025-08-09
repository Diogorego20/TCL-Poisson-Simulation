# ==============================================================================
# EXEMPLO PRÁTICO: VALIDAÇÃO ESTATÍSTICA DE LIVE NO INSTAGRAM
# ==============================================================================
#
# Autor: Diogo Da Silva Rego
# Curso: Estatística - UFPB
# Contexto: Inferência Estatística para Detecção de Manipulação
#
# Este script demonstra como usar inferência estatística para validar
# se os números de engajamento de uma live são autênticos ou manipulados.
#
# ==============================================================================

# CONFIGURAÇÃO INICIAL ========================================================

# Limpeza do ambiente
rm(list = ls())

# Definir semente para reprodutibilidade
set.seed(123)

# Parâmetros do modelo teórico
LAMBDA_TEORICO <- 6  # Engajamento esperado: 6 interações por minuto

cat("=================================================================\n")
cat("SISTEMA DE VALIDAÇÃO ESTATÍSTICA DE LIVES NO INSTAGRAM\n")
cat("=================================================================\n\n")

# FUNÇÃO DE VALIDAÇÃO ==========================================================

#' Valida estatisticamente o engajamento de uma live
#' 
#' @param dados_engajamento Vetor com número de interações por minuto
#' @param lambda_esperado Parâmetro lambda da distribuição de Poisson esperada
#' @param nivel_confianca Nível de confiança para o teste (padrão: 0.95)
#' @return Lista com resultado da validação
validar_live <- function(dados_engajamento, lambda_esperado = 6, nivel_confianca = 0.95) {
  
  # Calcular estatísticas observadas
  n <- length(dados_engajamento)
  media_obs <- mean(dados_engajamento)
  variancia_obs <- var(dados_engajamento)
  
  # Calcular valores teóricos
  media_teorica <- lambda_esperado
  variancia_teorica <- lambda_esperado / n
  desvio_teorico <- sqrt(variancia_teorica)
  
  # Calcular intervalo de confiança
  z_critico <- qnorm((1 + nivel_confianca) / 2)
  ic_inferior <- media_teorica - z_critico * desvio_teorico
  ic_superior <- media_teorica + z_critico * desvio_teorico
  
  # Teste de hipóteses
  dentro_ic <- (media_obs >= ic_inferior) && (media_obs <= ic_superior)
  
  # Calcular p-valor
  z_stat <- (media_obs - media_teorica) / desvio_teorico
  p_valor <- 2 * (1 - pnorm(abs(z_stat)))
  
  # Determinar status
  if (dentro_ic) {
    status <- "✅ VÁLIDO"
    interpretacao <- "Engajamento dentro do esperado estatisticamente"
  } else {
    status <- "🚨 SUSPEITO"
    interpretacao <- "Engajamento fora do padrão normal - investigar manipulação"
  }
  
  # Calcular poder de detecção
  poder_deteccao <- round((1 - 2 * pnorm(-z_critico)) * 100, 1)
  
  # Retornar resultados
  return(list(
    status = status,
    interpretacao = interpretacao,
    media_observada = round(media_obs, 3),
    media_teorica = media_teorica,
    intervalo_confianca = c(round(ic_inferior, 3), round(ic_superior, 3)),
    p_valor = round(p_valor, 4),
    poder_deteccao = poder_deteccao,
    duracao_minutos = n,
    nivel_confianca = nivel_confianca * 100
  ))
}

# CASOS DE TESTE ==============================================================

cat("CASOS DE TESTE - VALIDAÇÃO DE LIVES\n")
cat("====================================\n\n")

# CASO 1: Live Autêntica (Engajamento Normal) ================================

cat("CASO 1: LIVE AUTÊNTICA\n")
cat("----------------------\n")

# Simular dados de uma live orgânica de 50 minutos
live_autentica <- rpois(50, lambda = LAMBDA_TEORICO)

cat("Dados observados (primeiros 10 minutos):", paste(live_autentica[1:10], collapse = ", "), "\n")
cat("Duração total:", length(live_autentica), "minutos\n\n")

# Validar
resultado_autentica <- validar_live(live_autentica)

# Exibir resultados
cat("RESULTADO DA VALIDAÇÃO:\n")
cat("Status:", resultado_autentica$status, "\n")
cat("Interpretação:", resultado_autentica$interpretacao, "\n")
cat("Média observada:", resultado_autentica$media_observada, "\n")
cat("Intervalo de confiança 95%: [", resultado_autentica$intervalo_confianca[1], 
    ", ", resultado_autentica$intervalo_confianca[2], "]\n")
cat("P-valor:", resultado_autentica$p_valor, "\n")
cat("Poder de detecção:", resultado_autentica$poder_deteccao, "%\n\n")

# CASO 2: Live Suspeita (Engajamento Inflado) ================================

cat("CASO 2: LIVE SUSPEITA (ENGAJAMENTO INFLADO)\n")
cat("--------------------------------------------\n")

# Simular dados de uma live com engajamento artificialmente inflado
live_suspeita <- rpois(50, lambda = 12)  # Lambda muito alto!

cat("Dados observados (primeiros 10 minutos):", paste(live_suspeita[1:10], collapse = ", "), "\n")
cat("Duração total:", length(live_suspeita), "minutos\n\n")

# Validar
resultado_suspeita <- validar_live(live_suspeita)

# Exibir resultados
cat("RESULTADO DA VALIDAÇÃO:\n")
cat("Status:", resultado_suspeita$status, "\n")
cat("Interpretação:", resultado_suspeita$interpretacao, "\n")
cat("Média observada:", resultado_suspeita$media_observada, "\n")
cat("Intervalo de confiança 95%: [", resultado_suspeita$intervalo_confianca[1], 
    ", ", resultado_suspeita$intervalo_confianca[2], "]\n")
cat("P-valor:", resultado_suspeita$p_valor, "\n")
cat("Poder de detecção:", resultado_suspeita$poder_deteccao, "%\n\n")

# CASO 3: Live com Dados Reais (Exemplo Hipotético) =========================

cat("CASO 3: DADOS REAIS DE UMA LIVE ESPECÍFICA\n")
cat("-------------------------------------------\n")

# Exemplo de dados coletados de uma live real (hipotética)
dados_live_real <- c(7, 5, 8, 6, 4, 9, 5, 7, 6, 8, 
                     5, 6, 7, 4, 8, 6, 5, 9, 7, 6,
                     8, 5, 6, 7, 4, 6, 8, 5, 7, 6)

cat("Dados observados:", paste(dados_live_real[1:10], collapse = ", "), "...\n")
cat("Duração total:", length(dados_live_real), "minutos\n\n")

# Validar
resultado_real <- validar_live(dados_live_real)

# Exibir resultados
cat("RESULTADO DA VALIDAÇÃO:\n")
cat("Status:", resultado_real$status, "\n")
cat("Interpretação:", resultado_real$interpretacao, "\n")
cat("Média observada:", resultado_real$media_observada, "\n")
cat("Intervalo de confiança 95%: [", resultado_real$intervalo_confianca[1], 
    ", ", resultado_real$intervalo_confianca[2], "]\n")
cat("P-valor:", resultado_real$p_valor, "\n")
cat("Poder de detecção:", resultado_real$poder_deteccao, "%\n\n")

# ANÁLISE COMPARATIVA =========================================================

cat("ANÁLISE COMPARATIVA DOS CASOS\n")
cat("==============================\n\n")

# Criar tabela comparativa
casos <- data.frame(
  Caso = c("Live Autêntica", "Live Suspeita", "Live Real"),
  Media_Obs = c(resultado_autentica$media_observada, 
                resultado_suspeita$media_observada,
                resultado_real$media_observada),
  P_valor = c(resultado_autentica$p_valor,
              resultado_suspeita$p_valor, 
              resultado_real$p_valor),
  Status = c("VÁLIDO", "SUSPEITO", 
             ifelse(resultado_real$p_valor < 0.05, "SUSPEITO", "VÁLIDO"))
)

print(casos)

# VISUALIZAÇÃO SIMPLES ========================================================

cat("\nVISUALIZAÇÃO DOS RESULTADOS\n")
cat("===========================\n")

# Gráfico comparativo simples
par(mfrow = c(1, 3), mar = c(4, 4, 3, 1))

# Live autêntica
hist(live_autentica, 
     main = "Live Autêntica", 
     xlab = "Interações/min",
     ylab = "Frequência",
     col = "lightgreen",
     breaks = 10)
abline(v = mean(live_autentica), col = "red", lwd = 2)

# Live suspeita
hist(live_suspeita, 
     main = "Live Suspeita", 
     xlab = "Interações/min",
     ylab = "Frequência",
     col = "lightcoral",
     breaks = 10)
abline(v = mean(live_suspeita), col = "red", lwd = 2)

# Live real
hist(dados_live_real, 
     main = "Live Real", 
     xlab = "Interações/min",
     ylab = "Frequência",
     col = "lightblue",
     breaks = 10)
abline(v = mean(dados_live_real), col = "red", lwd = 2)

par(mfrow = c(1, 1))

# RECOMENDAÇÕES PRÁTICAS ======================================================

cat("\nRECOMENDAÇÕES PARA USO PRÁTICO\n")
cat("==============================\n\n")

cat("1. COLETA DE DADOS:\n")
cat("   - Colete dados minuto a minuto durante toda a live\n")
cat("   - Mínimo 30 minutos para análise confiável\n")
cat("   - Registre horários para detectar padrões suspeitos\n\n")

cat("2. CRITÉRIOS DE VALIDAÇÃO:\n")
cat("   - P-valor < 0.05: Suspeito de manipulação\n")
cat("   - Média fora do IC 95%: Investigar mais profundamente\n")
cat("   - Variância muito baixa: Possível automação\n\n")

cat("3. AÇÕES RECOMENDADAS:\n")
cat("   - VÁLIDO: Prosseguir com confiança\n")
cat("   - SUSPEITO: Solicitar auditoria independente\n")
cat("   - Documentar todos os resultados para relatórios\n\n")

cat("=================================================================\n")
cat("ANÁLISE CONCLUÍDA - SISTEMA DE VALIDAÇÃO ESTATÍSTICA\n")
cat("=================================================================\n")

# ==============================================================================
# FIM DO EXEMPLO
# ==============================================================================

