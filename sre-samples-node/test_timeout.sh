#!/bin/bash

# URL da API
API_URL="http://localhost:8080/api/timeout"

# Definindo o número de requisições
NUM_REQUESTS=10

# Função para realizar requisições
perform_requests() {
    for ((i=1; i<=NUM_REQUESTS; i++)); do
        # Fazendo a requisição para o endpoint e capturando a resposta
        RESPONSE=$(curl -s -w "%{http_code}" -o response.txt $API_URL)
        RESPONSE_BODY=$(cat response.txt)

        # Verificando o código de status e a resposta
        if [ $RESPONSE -eq 200 ]; then
            echo "Requisição $i: Sucesso (200) - Resposta: $RESPONSE_BODY"
        elif [ $RESPONSE -eq 500 ]; then
            echo "Requisição $i: Falha (500) - Erro retornado: $RESPONSE_BODY"
        else
            echo "Requisição $i: Outro status: $RESPONSE"
        fi
    done
}

# Realizando as requisições
perform_requests
