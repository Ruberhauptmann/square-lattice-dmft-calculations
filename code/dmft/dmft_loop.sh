export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

echo "NSLOTS on $HOSTNAME is $NSLOTS"

EXE_DIR=/fastscratch/tsievers/square-lattice-dmft/bin

$EXE_DIR/init_$NSLOTS

date > log.txt
mpirun -np "$NSLOTS" $EXE_DIR/self  >> log.txt

date >> log.txt
for n in 1 2 3 4 5 6 7 8
do
  i=$n
  mpirun -np "$NSLOTS" $EXE_DIR/ctqmc  >> log.txt
  cp dmft.input dmft_$i.input
  cp g0_tau.dat g0_tau_$i.dat
  cp hyb_tau.dat hyb_tau_$i.dat
  cp ctqmc.result ctqmc_$i.result
  cp C_NN.txt C_NN_$i.txt
  cp C_SzSz.txt C_SzSz_$i.txt
  cp density_matrix.dat density_matrix_$i.dat

  mpirun -np "$NSLOTS" $EXE_DIR/self  >> log.txt
  cp dmft.result dmft_$i.result
  cp sigma.txt sigma_$i.txt
  date >> log.txt
done

sed -i -e 's/0.0001/0.00000000000/g' dmft.input

for n in 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
do
  i=$n
  mpirun -np "$NSLOTS" $EXE_DIR/ctqmc  >> log.txt
  cp dmft.input dmft_$i.input
  cp g0_tau.dat g0_tau_$i.dat
  cp hyb_tau.dat hyb_tau_$i.dat
  cp ctqmc.result ctqmc_$i.result
  cp C_NN.txt C_NN_$i.txt
  cp C_SzSz.txt C_SzSz_$i.txt
  cp density_matrix.dat density_matrix_$i.dat

  mpirun -np "$NSLOTS" $EXE_DIR/self  >> log.txt
  cp dmft.result dmft_$i.result
  cp sigma.txt sigma_$i.txt
  date >> log.txt
done
