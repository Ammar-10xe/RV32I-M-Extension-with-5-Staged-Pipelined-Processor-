# RV32I-M-Extension-with-5-Staged-Pipelined-Processor-
This repo contains the M Extension of the RV32I 5 stage pipelined Processor 

# **DataPath followed**

 ![image](https://user-images.githubusercontent.com/104595329/235644200-67e40eca-e6f1-48f5-b0ee-ef27077dd0df.png)


### **Testing and Simulation:**
In Order to test the correct working of M extension I have added some test case which will check all the 8 different Instructions of M extension  that are

- MUL (Multiply): Computes the product of two 32-bit signed integers.
- MULH (Multiply High): Computes the upper 32 bits of the 64-bit signed product of two 32-bit signed integers.
- MULHSU (Multiply High Signed/Unsigned): Computes the upper 32 bits of the 64-bit signed product of a 32-bit signed integer and a 32-bit unsigned integer.
- MULHU (Multiply High Unsigned): Computes the upper 32 bits of the 64-bit unsigned product of two 32-bit unsigned integers.
- DIV (Divide): Divides two 32-bit signed integers and returns the quotient.
- DIVU (Divide Unsigned): Divides two 32-bit unsigned integers and returns the quotient.
- REM (Remainder): Divides two 32-bit signed integers and returns the remainder.
- REMU (Remainder Unsigned): Divides two 32-bit unsigned integers and returns the remainder.

The test case written is as follows:
```

# Load two unsigned 32-bit integers into registers x1 and x2
li x1, 100
li x2, 200

# Multiply the two integers and store the result in a 64-bit register x3
mul x3, x1, x2

# Load two signed 32-bit integers into registers x4 and x5
li x4, -50
li x5, 20

# Multiply the two integers and store the high 32 bits of the result in a register x6
mulh x6, x4, x5

# Load two signed 32-bit integers into registers x7 and x8
li x7, -100
li x8, 25

# Divide the first integer by the second integer and store the quotient in a register x9
div x9, x7, x8

# Load two unsigned 32-bit integers into registers x10 and x11
li x10, 500
li x11, 37

# Divide the first integer by the second integer and store the remainder in a register x12
remu x12, x10, x11

# Load two unsigned 32-bit integers into registers x13 and x14
li x13, 1000
li x14, 50

# Divide the first integer by the second integer and store the quotient in a register x15
divu x15, x13, x14

# Load two signed 32-bit integers into registers x16 and x17
li x16, -200
li x17, 40

# Multiply the two integers and store the low 32 bits of the result in a register x18
mul x18, x16, x17

# Load two signed 32-bit integers into registers x19 and x20
li x19, -300
li x20, 60

# Multiply the two integers and store the unsigned high 32 bits of the result in a register x21
mulhu x21, x19, x20

# Load two unsigned 32-bit integers into registers x22 and x23
li x22, 400
li x23, 80

# Multiply the two integers and store the unsigned low 32 bits of the result in a register x24
mul x24, x22, x23
```

After running the above code the contents of the register should be 

```
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00007d00 00000050 00000190 0000003b 0000003c fffffed4 ffffe0c0 00000028
ffffff38 00000014 00000032 000003e8 00000013 00000025 000001f4 fffffffc 00000019 ffffff9c ffffffff 00000014 ffffffce 00004e20 000000c8
00000064 00000000
```

After running the above code on MODELSIM we can verify the contents of the register are same as shown:

 ![image](https://user-images.githubusercontent.com/104595329/235796124-542aba51-6dad-4729-b975-0e605564a68e.png)

You can verify the contents by copying the code code and running it on the the https://venus.cs61c.org

## Factorial Code Testing:

The code of factorial was used to test this since the code is calculating the factorial of 5! the output of 120 should be stored before returning back from this function in register a0(x10) 


## **Factorial Code**

```
factorial:

    # Save registers
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)

    # Initialize variables
    addi s0, x0, 1 # s0 = 1 (accumulator)
    addi t0, x0, 1 # t0 = 1 (loop counter)
    li a0, 5       # Load argument n into a0

    # Loop
    factorial_loop:
        beq t0, a0, factorial_end # If t0 == n, exit loop
        addi t0, t0, 1           # Increment loop counter
        mul s0, s0, t0           # Multiply accumulator by loop counter
        j factorial_loop

    # End of function
    factorial_end:
        
        #move the result to a0
        mv a0, s0 

        # Restore registers
        lw ra, 4(sp)
        lw s0, 0(sp)
        addi sp, sp, 8
        
        # Return result
        jr ra

```
The following code is using the mul instruction which is not an Interger type instruction and it will be supported by M extension

The hex generated for this code is 

```
ff810113
00112223
00812023
00100413
00100293
00500513
00a28863
00128293
02540433
ff5ff06f
00040513
00412083
00012403
00810113
00008067
```
## Output Result and Waveform
The output obtained after running the factorial function  is 


 ![image](https://user-images.githubusercontent.com/104595329/235783797-2a17f9f7-e17a-4ecc-bdce-cc7275f3ff23.png)
 
 The output waveform showing the result stored in a0
 
 ![image](https://user-images.githubusercontent.com/104595329/235786860-62545096-cd48-4e5e-a742-5d60659682b5.png)


