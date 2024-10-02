#!/bin/bash

# URL da API
API_URL="localhost:8080/api/bulkhead"

# Função para fazer a requisição e exibir o resultado
function make_request {
    RESPONSE=$(curl -s -w "%{http_code}" -o /dev/null $API_URL)

    # Verificando o código de resposta HTTP
    if [[ "$RESPONSE" -eq 200 ]]; then
        echo "Requisição com sucesso. Status: $RESPONSE"
    elif [[ "$RESPONSE" -eq 500 ]]; then
        echo "Limite excedido. Status: $RESPONSE"
    else
        echo "Requisição falhou. Status: $RESPONSE"
    fi
}

# Rodada 1: Enviando 2 requisições simultâneas (limite do bulkhead)
echo "Rodada 1: Enviando 2 requisições"
for i in {1..2}; do
    make_request &
done
wait

# Rodada 2: Tentando exceder o limite com 3 requisições simultâneas
echo "Rodada 2: Executando o limite (3 requisições)"
for i in {1..3}; do
    make_request &
done
wait

# Rodada 3: Tentando exceder o limite com 10 requisições simultâneas
echo "Rodada 3: Executando o limite (10 requisições)"
for i in {1..10}; do
    make_request &
done
wait

