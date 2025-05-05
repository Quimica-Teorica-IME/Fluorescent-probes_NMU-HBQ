#!/bin/bash
#SBATCH --job-name=hbq-dcp-esd      # Nome do job (substituir por algo informativo)
#SBATCH --time=720:00:00         # Tempo máximo de execução 
#SBATCH --nodes=1                # Número de nós 
#SBATCH --ntasks-per-node=32      # Número de tarefas (cores) por nó
#SBATCH --partition=normal       # Partição do SLURM (ajustar conforme o cluster)

# Carregar o módulo do ORCA (ajuste a versão conforme a disponível em cada partição - normal e ryzen7--> 6.0.1.avx2 e intel7--> 6.0.1)
module load orca/6.0.1.avx2

# Definir caminhos
INPUT="/home/mmaximo/brunogabriel/ESD/B3LYP/HBQ-DCP/hbq-dcp-esd.inp"      # Caminho completo para o arquivo .inp - ajustar conforme necessário
OUTPUT="/home/mmaximo/brunogabriel/ESD/B3LYP/HBQ-DCP/hbq-dcp-esd.out"    # Caminho completo para o arquivo .out - ajustar conforme necessário
WORKDIR=$(dirname "$INPUT")
SCRDIR="/data/$SLURM_JOB_ID"

# Criar diretório de scratch
mkdir -p "$SCRDIR"

# Garantir que o scratch seja limpo ao final ou se o job for cancelado
trap 'echo "Job cancelado ou terminado – limpando o scratch..."; rm -rf "$SCRDIR"' EXIT

# Copiar input para o scratch e navegar até lá
cp -r "$WORKDIR"/* "$SCRDIR"
cd "$SCRDIR"

# Executar ORCA no scratch
orca "$(basename $INPUT)" > "$OUTPUT"

# Verificar se ORCA terminou corretamente
if grep -q "ORCA TERMINATED NORMALLY" "$(basename $OUTPUT)"; then
    echo "Cálculo finalizado com sucesso!"
else
    echo "Erro no cálculo. Verifique o arquivo de saída."
fi

# Copiar os arquivos úteis de volta ao diretório original
cp *.inp "$WORKDIR" 2>/dev/null || true
cp *.gbw "$WORKDIR" 2>/dev/null || true
cp *.engrad "$WORKDIR" 2>/dev/null || true
cp *.xyz "$WORKDIR" 2>/dev/null || true
cp *.hess "$WORKDIR" 2>/dev/null || true
cp *.out "$WORKDIR" 2>/dev/null || true
cp *.spectrum "$WORKDIR" 2>/dev/null || true
cp *.cpcm "$WORKDIR" 2>/dev/null || true
cp *.prop "$WORKDIR" 2>/dev/null || true
cp "$(basename $OUTPUT)" "$WORKDIR"  # Saída principal

# Limpar o scratch
cd /tmp
rm -rf "$SCRDIR"

