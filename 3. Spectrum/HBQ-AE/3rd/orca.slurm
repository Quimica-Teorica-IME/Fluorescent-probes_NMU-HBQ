#!/bin/bash
#SBATCH --job-name=hbq-ESD
#SBATCH --time=720:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --partition=normal

module load orca/6.0.1.avx2

# Definir variáveis importantes
export ORCA_INPUT="HBQ_ESD.inp"          # Nome do arquivo de entrada
export ORCA_OUTPUT="HBQ_ESD.out"         # Nome do arquivo de saída
export ORCA_SCRDIR=$SLURM_JOB_ID             # Diretório temporário para arquivos de scratch

# Criar diretório de scratch
mkdir -p $ORCA_SCRDIR

# Executar o ORCA
orca $ORCA_INPUT > $ORCA_OUTPUT

# Mover arquivos de scratch de volta para o diretório de trabalho
mv $ORCA_SCRDIR/* .

# Limpar diretório de scratch
rm -rf $ORCA_SCRDIR
