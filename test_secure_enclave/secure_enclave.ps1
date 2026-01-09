
#Criar Chave
$cert = New-SelfSignedCertificate `
    -Subject "CN=SecureEnclaveDemo" `
    -KeyAlgorithm RSA `
    -KeyLength 2048 `
    -Provider "Microsoft Platform Crypto Provider" `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyUsage DataEncipherment, KeyEncipherment `
    -TextExtension @("2.5.29.37={text}1.3.6.1.4.1.311.80.1")

#Criar Ficheiro para cifrar
"Segredo do Secure Enclave" | Out-File message.txt -Encoding UTF8

#Cifrar Mensagem
Write-Host ""
Get-Content message.txt | Protect-CmsMessage -To $cert -OutFile message.encrypted
Write-Host "Mensagem Cifrada" -ForegroundColor Green

#Decifrar Mensagem
Write-Host ""
$texto = Unprotect-CmsMessage -Path message.encrypted
Write-Host "Mensagem decifrada: '$texto'" -ForegroundColor Green

#Simular ataque -> O resultado deve ser um erro
Write-Host ""
certutil -user -exportPFX My "SecureEnclaveDemo" roubo.pfx

#Limpar
certutil -user -delstore My "SecureEnclaveDemo" | Out-Null

Write-Host "Pressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")