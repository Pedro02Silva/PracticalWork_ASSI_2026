echo "[*] Tentativa de localizar ficheiros relacionados com Secure World..."
find / -name "*secure*" 2>/dev/null

echo
echo "[*] Verificar se existem objetos de secure storage visíveis..."
ls /data 2>/dev/null

echo
echo "[*] Tentar ler dados do Secure World diretamente (falhará)..."
for f in /data/*; do
  echo "---- $f ----"
  cat "$f" 2>/dev/null
done

echo
echo "[*] Tentar extrair strings legíveis de possíveis binários do TEE..."
for f in /usr/bin/*secure*; do
  echo "---- $f ----"
  strings "$f" 2>/dev/null
done

echo
echo "[*] Conclusão:"
echo "Não é possível aceder aos dados sensíveis do Secure World a partir do Normal World."