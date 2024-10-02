#!/bin/bash

# Definindo o número de requisições por rodada
NUM_REQUESTS=10
SUCCESS_COUNT=0
FAILURE_COUNT=0
FALLBACK_COUNT=0

# Função para realizar requisições
perform_requests() {
    for ((i=1; i<=NUM_REQUESTS; i++)); do
        # Fazendo a requisição para o endpoint e capturando a resposta
        RESPONSE=$(curl -s -w "%{http_code}" -o response.txt http://localhost:8080/api/circuitbreaker)
        RESPONSE_BODY=$(cat response.txt)

        # Verificando o código de status e a resposta
        if [ $RESPONSE -eq 200 ]; then
            echo "Requisição $i: Sucesso (200)"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        elif [ $RESPONSE -eq 500 ]; then
            echo "Requisição $i: Falha (500) - Erro retornado pelo Circuit Breaker"
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        elif [ $RESPONSE -eq 503 ]; then
            echo "Requisição $i: Fallback ativado (503)"
            FALLBACK_COUNT=$((FALLBACK_COUNT + 1))
        else
            echo "Requisição $i: Outro status: $RESPONSE"
        fi
    done
}

# Função para calcular e exibir o percentual de sucesso, falha e fallback
calculate_percentage() {
    TOTAL=$((SUCCESS_COUNT + FAILURE_COUNT + FALLBACK_COUNT))

    if [ $TOTAL -gt 0 ]; then
        SUCCESS_PERCENTAGE=$((SUCCESS_COUNT * 100 / TOTAL))
        FAILURE_PERCENTAGE=$((FAILURE_COUNT * 100 / TOTAL))
        FALLBACK_PERCENTAGE=$((FALLBACK_COUNT * 100 / TOTAL))

        echo ""
        echo "Resumo da rodada:"
        echo "Requisições com sucesso (200): $SUCCESS_COUNT"
        echo "Requisições com falha (500): $FAILURE_COUNT"
        echo "Requisições com fallback (503): $FALLBACK_COUNT"
        echo "Percentual de sucesso: $SUCCESS_PERCENTAGE%"
        echo "Percentual de falha: $FAILURE_PERCENTAGE%"
        echo "Percentual de fallback: $FALLBACK_PERCENTAGE%"
    else
        echo "Nenhuma requisição foi feita."
    fi
}

# Reseta os contadores
reset_counts() {
    SUCCESS_COUNT=0
    FAILURE_COUNT=0
    FALLBACK_COUNT=0
}

# Realiza as requisições
reset_counts
perform_requests
calculate_percentage