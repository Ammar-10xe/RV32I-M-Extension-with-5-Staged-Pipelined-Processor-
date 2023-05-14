
# **RV32I M-Extension with 5-Staged Pipelined Processor: Compliance Testing and Documentation**
Welcome to this repository, where we have extended our previously implemented RISC-V 32I processor with the addition of the M-extension. Before delving into the details of the M-extension, it is worth noting that the base of this project is a [5-stage RISC-V 32I pipeline processor](https://github.com/Ammarkhan561/RISCV32I-5-Stage-Pipelined-Processor-Compliance-Verification.git), which we have built and tested for compliance in a separate repository. The RISC-V 32I processor provides a solid foundation, upon which we have built and expanded with the integration of the M-extension.

This repository contains the implementation of a *RISC-V 32I* processor with the addition of the *M-extension*. This extension adds hardware integer multiplication and division instructions to the base integer instruction set. This document aims to provide a comprehensive understanding of this extension and its relevance to the RISC-V 32I architecture.

### RISC-V M-Extension

The RISC-V M-extension, also known as the *Integer Multiplication and Division* extension, is a standard extension to the base RISC-V instruction set architecture. This extension provides instructions that perform integer multiplication and division operations. The M-extension is particularly beneficial for applications that perform a lot of mathematical computations, as it greatly reduces the number of instructions required to perform these operations, leading to significant performance improvements.

The addition of the M-extension to the base RISC-V 32I instruction set enhances the computational capabilities of the processor, making it well-suited for a wide range of applications, from high-performance computing to embedded systems.

In our implementation, we've included the following instructions from the M-Extension:

-   **Multiplication Instructions**: MUL, MULH, MULHSU, MULHU
-   **Division Instructions**: DIV, DIVU, REM, REMU

These instructions allow for signed and unsigned multiplication and division, and also multiplication that produces the upper half of the product. This makes the processor more flexible and capable of handling more complex mathematical operations efficiently.


### How to Use this Repository

This repository is your one-stop destination for all resources required to understand, build, and test our RISC-V 32I processor with the M-extension.

To utilize this repository, follow the steps listed below:

1.  Clone this repository onto your local machine.
2.  Navigate to the directory named as `RV32IM/RTL`.
3.  Compile the source code using your preferred RISC-V compiler. If you are using ModelSim, you can use `vlog *.sv` to compile the source code. To run it, use `vsim -c -do "run -all" TopLevel_tb +sig=result.txt +mem_init=dut.hex`.

    -   `TopLevel_tb`: This is the name of the top-level module of the testbench.
    -   `+sig=result.txt +mem_init=demo.hex`: These are simulation arguments. 
    
----------

For more detailed information, refer to the individual files in this repository. If you have any questions or encounter any issues, please feel free to open an issue on GitHub.

Your contributions to this project are most welcome. If you wish to contribute, please fork this repository and submit a pull request

## Framework for Testing

RISCOF framework is used which is a python based framework that enables testing of a RISC-V target (hard or soft implementations) against a standard RISC-V golden reference model using a suite of RISC-V architectural assembly tests.For more information please visit [RISCOF](https://riscof.readthedocs.io/en/latest/intro.html) 
> In our case, we have compared our designed RTL  with golden reference model named sail

## Compliance Testing

Compliance testing is **to check whether the processor under development meets the open RISC-V standards or not**. There are some tests available online that tries to cover the corner cases of all the instructions type listed above. These tests are contributed by open source community and are updated from time to time. In order to call your design to be fully complianced with RISC-V International Standards, one should pass all these tests successfully. These tests are available online by the name riscv-non-isa arch test.

We have also  included a suite of tests designed to verify the correct operation of the M-extension instructions. These tests can be executed using the provided test scripts. To do so, navigate to the compliance testing folder and execute the following command:

    riscof -v debug run --config=config.ini --suite=./riscv-arch-test/riscv-test-suite/rv32i_m/I --env=./riscv-arch-test/riscv-test-suite/env

> **Note:** You would have adjust the path accordingly in the .confi.ini file. 

For more details about the Compliance Testing   please refer to the Quickstart section

## Result

Using RISCOF framework generates a report that shows how many tests are passed and how many failed. You can find the report in riscof_work/report.html. As the report is in HTML language so you need to render it for better view if you want to see the result or you can click the [View Rendered HTML](http://htmlpreview.github.io/?https://github.com/Ammarkhan561/RV32I-M-Extension-with-5-Staged-Pipelined-Processor-/blob/master/Compliance_Testing_RV32IM/riscof_work/report.html) to see the rendered report.
 
#  Quickstart RISCOF

## RISCV-GNU Toolchain

Though, we can [build](https://github.com/riscv-collab/riscv-gnu-toolchain) the toolchain from source or use the [pre-build](https://github.com/riscv-collab/riscv-gnu-toolchain/releases/tag/2022.10.11) toolchain. But don't require customize fancy features of the toolchain for application. The following command suffice. Run it to install the toolchain.

    sudo apt-get install gcc-riscv64-unknown-elf
If this did not work you can download any latest version of pre-compiled toolchain from  [RISCV-GNU Toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain/releases/tag/2022.10.11) and make sure to add the path `/path/to/install` to your  $PATH in the .bashrc/zshrc with this you should now have all the following available as command line arguments:

    riscv32-unknown-elf-addr2line      riscv32-unknown-elf-elfedit
    riscv32-unknown-elf-ar             riscv32-unknown-elf-g++
    riscv32-unknown-elf-as             riscv32-unknown-elf-gcc
    riscv32-unknown-elf-c++            riscv32-unknown-elf-gcc-8.3.0
    riscv32-unknown-elf-c++filt        riscv32-unknown-elf-gcc-ar
    riscv32-unknown-elf-cpp            riscv32-unknown-elf-gcc-nm
    riscv32-unknown-elf-gcc-ranlib     riscv32-unknown-elf-gprof
    riscv32-unknown-elf-gcov           riscv32-unknown-elf-ld
    riscv32-unknown-elf-gcov-dump      riscv32-unknown-elf-ld.bfd
    riscv32-unknown-elf-gcov-tool      riscv32-unknown-elf-nm
    riscv32-unknown-elf-gdb            riscv32-unknown-elf-objcopy
    riscv32-unknown-elf-gdb-add-index  riscv32-unknown-elf-objdump
    riscv32-unknown-elf-ranlib         riscv32-unknown-elf-readelf
    riscv32-unknown-elf-run            riscv32-unknown-elf-size
    riscv32-unknown-elf-strings        riscv32-unknown-elf-strip


## Verilog Simulator

An HDL Simulator is required that can simulate Verilog (or System Verilog designs). We have the following options.

### Icarus

:warning: It only works for Verilog designs and may not for System.

Run the following commands to install Icarus Verilog and GTK wave to view the waveform.

    sudo apt­get install iverilog
    sudo apt­get install gtkwave

### Verilator

Run the following command to install [Verilator](https://verilator.org/guide/latest/).

    sudo apt-get install verilator

### Modelsim

Modelsim Setup Lite Edition will be provided on the spot. Refer the [guide](https://profile.iiita.ac.in/bibhas.ghoshal/COA_2020/Lab/ModelSim%20Linux%20installation.html) to install the Modelsim on Linux. 

:warning: Remember that we need to have the ability to complile and simulate the design using command line interface (CLI). [User manual](https://www.microsemi.com/document-portal/doc_view/131619-modelsim-user) contains the instructions for that.

## RISCOF and Python

[RISCOF](https://riscof.readthedocs.io/en/stable/) is the standard RISC-V Compliance testing framework. Run the following commands to install RISCOF.

    sudo apt-get -y install python3-pip
    sudo apt-get install -y python3-setuptools
    pip3 install git+https://github.com/riscv/riscof.git

## Install Plugin Models

  [SAIL-riscv](https://github.com/riscv/sail-riscv) is the Golden reference model for RISC-V architecture.Run the following commands to setup the model.

    $ sudo apt-get install opam  build-essential libgmp-dev z3 pkg-config zlib1g-dev
    $ opam init -y --disable-sandboxing
    $ opam switch create ocaml-base-compiler.4.06.1
    $ opam install sail -y
    $ eval $(opam config env)
    $ git clone https://github.com/riscv/sail-riscv.git
    $ cd sail-riscv
    $ make
    $ ARCH=RV32 make
    $ ARCH=RV64 make
    $ ln -s sail-riscv/c_emulator/riscv_sim_RV64 /usr/bin/riscv_sim_RV64
    $ ln -s sail-riscv/c_emulator/riscv_sim_RV32 /usr/bin/riscv_sim_RV32
    
Please give the complete PATH to create a symbolic link for example in my case it was `sudo ln -s /home/xe-lpt-71/sail-riscv/c_emulator/sail-riscv/c_emulator/riscv_sim_RV32 /usr/bin/riscv_sim_RV32\n` After adding the symbolic link verify it using `riscv_sim_RV32`or `riscv_sim_RV64` the output of this should be

    No elf file provided.
    Usage: riscv_sim_RV32 [options] <elf_file>
    	 -d	 --enable-dirty-update
    	 -m	 --enable-misaligned
    	 -P	 --enable-pmp
    	 -N	 --enable-next
    	 -z	 --ram-size
    	 -C	 --disable-compressed
    	 -I	 --disable-writable-misa
    	 -F	 --disable-fdext
    	 -i	 --mtval-has-illegal-inst-bits
    	 -b	 --device-tree-blob
    	 -t	 --terminal-log
    	 -p	 --show-times
    	 -a	 --report-arch
    	 -T	 --test-signature
    	 -g	 --signature-granularity
    	 -h	 --help
    	 -v	 --trace
    	 -V	 --no-trace
    	 -l	 --inst-limit
    	 -x	 --enable-zfinx

Remember, creating a **symbolic link** in a directory in your PATH will allow you to run a program/command located in another directory as if it were in your PATH. It won't add the entire directory to your PATH. If you want to add an entire directory to your PATH, you need to modify your shell's configuration file (like `~/.bashrc` or `~/.bash_profile` for the bash shell, `~/.zshrc` for zsh shell).


## Command Line Interface 

I have used the ModelSim's command line interface for compiling and simulating SystemVerilog (`.sv`) files.

1.  `vlog *.sv`: The `vlog` command is used for compiling Verilog/SystemVerilog files. The `*.sv` argument tells it to compile all `.sv` files in the current directory.
    
2.  `vsim -c -do "run -all" TopLevel_tb +sig=result.txt +mem_init=dut.hex`: The `vsim` command is used to simulate compiled Verilog/SystemVerilog designs.
    
    -   `-c`: This option tells ModelSim to run in command line mode (without GUI).
    -   `-do "run -all"`: This option tells ModelSim to execute the command `run -all` immediately after loading the design. The `run -all` command starts the simulation and runs it until there are no more events to process.
    -   `TopLevel_tb`: This is the name of the top-level module of the testbench.
    -   `+sig=result.txt +mem_init=demo.hex`: These are simulation arguments. 
   3. `$value$plusargs` is a system function in Verilog and SystemVerilog that is used to read command-line arguments passed to the simulator. This function is often used to set configuration or control values at simulation runtime. It allows you to change certain variables without having to recompile your simulat 

It is always good habit to read the documentation. So make sure to check the usage of these commands.  
   [vsim](http://www.pldworld.com/_hdl/2/_ref/se_html/manual_html/c_vcmds191.html) ,  [vlog](http://www.pldworld.com/_hdl/2/_ref/se_html/manual_html/c_vcmds188.html)  and  [value$plusargs](https://www.chipverify.com/systemverilog/systemverilog-command-line-input)


## RISCV ARCH Tests

The RISC-V architecture tests are open-source and can be found on the [RISC-V Architectural Tests GitHub repository](https://github.com/riscv/riscv-arch-test). Clone the riscv arch tests using 

    git clone https://github.com/riscv-non-isa/riscv-arch-test.git

The RISC-V architecture tests are a suite of tests designed to ensure that a RISC-V CPU implementation conforms to the official RISC-V specification. These tests are important for guaranteeing the correct behavior of RISC-V implementations, and they cover a range of functionality, from basic instruction behavior to more complex features such as interrupts and exceptions. The tests are divided into different categories:

-   **RV32I**: Base Integer Instruction Set (32-bit)
-   **RV64I**: Base Integer Instruction Set (64-bit)
-   **RV32M**: Standard Extension for Integer Multiplication and Division (32-bit)
-   **RV64M**: Standard Extension for Integer Multiplication and Division (64-bit)
-   **RV32F**: Standard Extension for Single-Precision Floating-Point (32-bit)
-   **RV64F**: Standard Extension for Single-Precision Floating-Point (64-bit)
-   **RV32D**: Standard Extension for Double-Precision Floating-Point (32-bit)
-   **RV64D**: Standard Extension for Double-Precision Floating-Point (64-bit)
-   And many others

To use these tests, we would clone the repository in the working directory  to generate and run the tests against our RISC-V Core.

##  Running RISCOF

You can use the following RISCOF (RISC-V Instruction Set Compliance Framework) coomands to run compliance tests on a RISC-V Core

    riscof setup --dutname=RV32I 

This command sets up RISCOF for testing a device-under-test (DUT) named "RV32I". The DUT is the RISC-V implementation that you're testing.

    riscof run --config=config.ini --suite=/home/xe-lpt-71/Documents/5stageCompliance/riscv-arch-test/riscv-test-suite/rv32i_m/I/src --env=/home/xe-lpt-71/Documents/5stageCompliance/riscv-arch-test/riscv-test-suite/env --no-ref-run


This command runs RISCOF tests. The `--config` option specifies the configuration file, the `--suite` option specifies the path to the test suite you want to run, and the `--env` option specifies the test environment. The `–no-ref-run` option tells RISCOF not to run the tests against the reference model

    riscof -v debug run --config=config.ini --suite=./riscv-arch-test/riscv-test-suite/rv32i_m/I --env=./riscv-arch-test/riscv-test-suite/env

This command is similar to the previous one, but it includes the `-v debug` option, which sets the verbosity level to "debug". This means that RISCOF will provide more detailed output about what it's doing, which can be useful for debugging issues.


