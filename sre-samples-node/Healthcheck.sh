#!/bin/bash

# Função para esperar 5 segundos com um círculo de pontos
wait_with_dots() {
  for i in {1..5}; do
    echo -n "."
    sleep 1
  done
  echo -e "\n"
}

# Endpoint base
BASE_URL="http://localhost:8080"

# Liveness Check
echo "Executando Liveness Check..."
curl -s "$BASE_URL/health/liveness"
echo -e "\n"

# Espera de 5 segundos
echo "Aguardando 5 segundos para o próximo comando"
wait_with_dots

# Readiness Check (antes de ficar pronto)
echo "Executando Readiness Check antes da aplicação estar pronta..."
curl -s "$BASE_URL/health/readiness"
echo -e "\n"

# Espera de 5 segundos
echo "Aguardando 5 segundos para o próximo comando"
wait_with_dots

# Simulação de aplicação pronta
echo "Simulando que a aplicação está pronta (make-ready)..."
curl -s "$BASE_URL/make-ready"
echo -e "\n"

# Espera de 5 segundos
echo "Aguardando 5 segundos para o próximo comando"
wait_with_dots

# Readiness Check (depois de ficar pronta)
echo "Executando Readiness Check depois da aplicação estar pronta..."
curl -s "$BASE_URL/health/readiness"
echo -e "\n"

# Conclusão
echo "Testes de Health Check concluídos."