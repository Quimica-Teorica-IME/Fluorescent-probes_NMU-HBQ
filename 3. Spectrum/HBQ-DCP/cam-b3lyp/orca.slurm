#!/bin/bash
#SBATCH --job-name=cams2
#SBATCH --time=720:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=250
#SBATCH --partition=normal


# Definir o caminho para o ORCA
export ORCA_PATH=~/orca_6_0_1_avx2            # Caminho para a pasta do ORCA
export PATH=$ORCA_PATH:$PATH                 # Adicionar ORCA ao PATH

# Definir variÃ¡veis importantes
export ORCA_INPUT="hbq-dcp-esd.inp"          # Nome do arquivo de entrada
export ORCA_OUTPUT="hbq-dcp-esd.out"         # Nome do arquivo de saÃ­da
export ORCA_SCRDIR=$SLURM_JOB_ID             # DiretÃ³rio temporÃ¡rio para arquivos de scratch

# Criar diretÃ³rio de scratch
mkdir -p $ORCA_SCRDIR

# Executar o ORCA
$ORCA_PATH/orca $ORCA_INPUT > $ORCA_OUTPUT

# Mover arquivos de scratch de volta para o diretÃ³rio de trabalho
mv $ORCA_SCRDIR/* .

# Limpar diretÃ³rio de scratch
rm -rf $ORCA_SCRDIR
