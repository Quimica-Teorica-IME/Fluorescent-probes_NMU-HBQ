#!/bin/bash
#SBATCH --job-name=cam-es-hbqdcp
#SBATCH --time=720:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --partition=normal

module load orca/6.0.1.avx2

# Definir variÃ¡veis importantes
export ORCA_INPUT="hbq-dcp-es.inp"          # Nome do arquivo de entrada
export ORCA_OUTPUT="hbq-dcp-es.out"         # Nome do arquivo de saÃ­da
export ORCA_SCRDIR=$SLURM_JOB_ID             # DiretÃ³rio temporÃ¡rio para arquivos de scratch

# Criar diretÃ³rio de scratch
mkdir -p $ORCA_SCRDIR

# Executar o ORCA
orca $ORCA_INPUT > $ORCA_OUTPUT

# Mover arquivos de scratch de volta para o diretÃ³rio de trabalho
mv $ORCA_SCRDIR/* .

# Limpar diretÃ³rio de scratch
rm -rf $ORCA_SCRDIR
