#!/bin/bash

# URL da rota para teste de rate limit
URL="http://localhost:8080/api/ratelimit"

# Função para fazer uma chamada e exibir o status da resposta
make_request() {
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    echo "Status HTTP: $RESPONSE"
}

# Contador de chamadas realizadas
counter=0

# Faz chamadas em um intervalo mais curto para tentar superar 100 chamadas em 60 segundos
echo "Fazendo chamadas para tentar superar 100 chamadas em 60 segundos..."
start_time=$(date +%s)
while true; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    counter=$((counter + 1))
    
    if [ "$RESPONSE" -eq 429 ]; then
        echo "Você excedeu o limite de requisições, por gentileza tente mais tarde!"
        break
    else
        echo "Status HTTP: $RESPONSE"
        echo "Chamadas realizadas: $counter"
    fi
    
    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))
    if [ $elapsed_time -ge 60 ]; then
        break
    fi
    sleep 0.3  # Intervalo reduzido para tentar aumentar o número de chamadas
done

echo "Simulação completa. Total de chamadas realizadas: $counter."
