#!/bin/bash
#SBATCH --job-name=nmu1_es
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --partition=extra

module load orca/5.0.4

# Definir variáveis importantes
export ORCA_INPUT="NMU-1_ES.inp"         # Nome do arquivo de entrada
export ORCA_OUTPUT="NMU-1_ES.out"       # Nome do arquivo de saída
export ORCA_SCRDIR=$SLURM_JOB_ID      # Diretório temporário para arquivos de scratch

# Criação do diretório de scratch
mkdir -p $ORCA_SCRDIR

# Executar o ORCA
orca $ORCA_INPUT > $ORCA_OUTPUT

# Mover arquivos de scratch de volta para o diretório de trabalho
mv $ORCA_SCRDIR/* .

# Limpar diretório de scratch
rm -rf $ORCA_SCRDIR
