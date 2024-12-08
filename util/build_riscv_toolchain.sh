git clone --branch 2022.01.17 --recursive https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
./configure --prefix=/home/$USER/tools/riscv --with-abi=ilp32 --with-arch=rv32imc --with-cmodel=medlow
make