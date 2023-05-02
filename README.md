# RV32I-M-Extension-with-5-Staged-Pipelined-Processor-
This repo contains the M Extension of the RV32I 5 stage pipelined Processor 

# **DataPath followed**

 ![image](https://user-images.githubusercontent.com/104595329/235644200-67e40eca-e6f1-48f5-b0ee-ef27077dd0df.png)


### **Testing and Simulation:**

The code of factorial was used to test this since the code is calculating the factorial of 5! the output of 120 should be stored before returning back from this function in register a0(x10) 

**Factorial Code**

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
### Output Result and Waveform
The output obtained after running the factorial function  is 


 ![image](https://user-images.githubusercontent.com/104595329/235783797-2a17f9f7-e17a-4ecc-bdce-cc7275f3ff23.png)
 ![image](https://user-images.githubusercontent.com/104595329/235786860-62545096-cd48-4e5e-a742-5d60659682b5.png)

The output waveform showing the result stored in a0
