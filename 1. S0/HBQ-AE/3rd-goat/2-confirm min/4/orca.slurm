#!/bin/bash
#SBATCH --job-name=svr4
#SBATCH --time=720:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --nodelist=n01
#SBATCH --partition=normal


# Definir o caminho para o ORCA
export ORCA_PATH=~/orca_6_0_1_avx2            # Caminho para a pasta do ORCA
export PATH=$ORCA_PATH:$PATH                 # Adicionar ORCA ao PATH

# Definir variáveis importantes
export ORCA_INPUT="4.inp"          # Nome do arquivo de entrada
export ORCA_OUTPUT="4.out"         # Nome do arquivo de saída
export ORCA_SCRDIR=$SLURM_JOB_ID             # Diretório temporário para arquivos de scratch

# Criar diretório de scratch
mkdir -p $ORCA_SCRDIR

# Executar o ORCA
$ORCA_PATH/orca $ORCA_INPUT > $ORCA_OUTPUT

# Mover arquivos de scratch de volta para o diretório de trabalho
mv $ORCA_SCRDIR/* .

# Limpar diretório de scratch
rm -rf $ORCA_SCRDIR
