using System;
using System.Text;
using Tpm2Lib;

namespace Tpm_test
{
    class Program
    {
        static void Main(string[] args)
        {
            // 1. Ligação ao TPM

            var tpmDevice = new TbsDevice();
            tpmDevice.Connect();
            var tpm = new Tpm2(tpmDevice);

            Console.WriteLine("--- Início do laboratório TPM ---");

            uint pcrIndex = 23;
            var algId = TpmAlgId.Sha256; 


            // PASSO 1: Leitura Inicial do PCR

            PcrSelection[] selectionIn =
            {
                new PcrSelection(algId, new uint[] { pcrIndex })
            };

            PcrSelection[] selectionOut;
            Tpm2bDigest[] pcrValues;

            tpm.PcrRead(selectionIn, out selectionOut, out pcrValues);

            if (pcrValues == null || pcrValues.Length == 0)
            {
                Console.WriteLine($"Erro: Não foi possível ler o PCR {pcrIndex} com o algoritmo {algId}.");
                tpm.Dispose();
                return;
            }

            byte[] originalPcr = pcrValues[0].buffer;
            Console.WriteLine($"\nPCR {pcrIndex} original:");
            Console.WriteLine(BitConverter.ToString(originalPcr).Replace("-", ""));

            // PASSO 2: APENAS CONCEITO de associação do estado atual do PCR ao segredo

            string segredo = "PROJETO_ASSI_123";
            Console.WriteLine($"\nO dado '{segredo}' foi logicamente selado ao estado atual do PCR.");


            // PASSO 3: Extender DO PCR -> Simular um ataque ou uma alteração no sistema
  
            byte[] badHash = new byte[32]; 
            new Random().NextBytes(badHash);

            Console.WriteLine("\nA atualizar o PCR (a alterar o estado do sistema)...");

            tpm.PcrExtend(
                TpmHandle.Pcr(pcrIndex),
                new TpmHash[] { new TpmHash(algId, badHash) }
            );

            // PASSO 4: Verificar Alteração PCR

            tpm.PcrRead(selectionIn, out selectionOut, out pcrValues);
            byte[] newPcr = pcrValues[0].buffer;

            Console.WriteLine($"PCR {pcrIndex} após modificação:");
            Console.WriteLine(BitConverter.ToString(newPcr).Replace("-", ""));

            if (BitConverter.ToString(originalPcr) != BitConverter.ToString(newPcr))
            {
                Console.WriteLine("\nO PCR foi alterado!");
                Console.WriteLine("O segredo já não pode ser desbloqueado (unseal falha).");
            }

            // Libertar recursos

            tpm.Dispose();

            Console.WriteLine("\nPrima qualquer tecla para sair...");
            Console.ReadKey();
        }
    }
}
