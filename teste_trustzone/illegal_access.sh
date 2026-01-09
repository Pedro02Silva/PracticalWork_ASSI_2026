echo "[*] Tentativa de leitura direta do dispositivo TEE..."
cat /dev/tee0 2>/dev/null || echo "Erro: acesso direto bloqueado"

echo
echo "[*] Tentativa de escrita direta no dispositivo TEE..."
echo "ataque" > /dev/tee0 2>/dev/null || echo "Erro: escrita direta bloqueada"

echo
echo "[*] Tentativa de criar dump com dd..."
dd if=/dev/tee0 of=/tmp/tee_dump bs=1 count=64 2>/dev/null || echo "Erro: acesso bloqueado"

echo
echo "[*] Conclusão:"
echo "O Secure World não é acessível diretamente. Todas as tentativas são negadas."