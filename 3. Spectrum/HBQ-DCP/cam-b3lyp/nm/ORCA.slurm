#!/bin/bash
#SBATCH --job-name=cam-hbqdcp
#SBATCH --time=720:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --partition=normal

# Carregar o módulo do ORCA
module load orca/6.0.1.avx2

# Definir caminhos
INPUT="hbq-dcp-esd.inp"
OUTPUT="hbq-dcp-esd.out"
WORKDIR=$(dirname "$INPUT")
SCRDIR="/data/$SLURM_JOB_ID"

# Criar diretório de scratch
mkdir -p "$SCRDIR"

# Copiar input para o scratch e navegar até lá
cp "$INPUT" "$SCRDIR"
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

