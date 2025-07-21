# Sierpinski Triangle in MIPS Assembly

This project is a MIPS assembly language implementation for generating the Sierpinski Triangle fractal, a classic example of recursive programming. The program renders the output graphically by directly manipulating the framebuffer of the **Bitmap Display** tool within the **MARS (MIPS Assembler and Runtime Simulator)**.

## Key Features

*   **Recursive Fractal Generation**: The core of the program is the `sub_triangle` function, which calls itself to generate the fractal's repeating, self-similar patterns.
*   **Direct Framebuffer Manipulation**: The program draws the triangle pixel-by-pixel directly into the Bitmap Display's memory-mapped framebuffer, demonstrating a fundamental technique of graphics programming.
*   **Efficient Stack Management**: Utilizes the stack to save and restore register states (`$ra`, arguments, temporary values) across deep recursive calls, ensuring the integrity of each function instance. Custom macros (`save_recursion_registers`, `load_recursion_registers`) are used to streamline this process.
*   **Bresenham's Line Algorithm**: The `draw_line` function implements a MIPS version of Bresenham's algorithm to efficiently draw lines between two points using only integer arithmetic.
*   **Configurable Recursion Depth**: The depth of the recursion, which controls the detail of the fractal, can be easily adjusted by changing a single value in the `main` function.

## Technologies Used

*   **MIPS32 Assembly Language**
*   **MARS (MIPS Assembler and Runtime Simulator)**
    *   Specifically utilizes the **Bitmap Display** tool for graphical output.

## How to Install and Execute

### Prerequisites

*   **Java Runtime Environment (JRE)**: MARS is a Java application and requires a JRE to run.
*   **MARS Simulator**: You must have the MARS simulator. You can download it from its [official university page](https://dpetersanderson.github.io/).

### Step-by-Step Instructions

1.  **Launch MARS** and open the `fractals.asm` file via **File -> Open...**.

2.  **Open and Configure the Bitmap Display**:
    *   In the menu bar, navigate to **Tools -> Bitmap Display**.
    *   A new window will appear. Configure it with the following settings, which are required for the program to work correctly:
        *   **Unit Width in Pixels**: `1`
        *   **Unit Height in Pixels**: `1`
        *   **Display Width in Pixels**: `512`
        *   **Display Height in Pixels**: `512`
        *   **Base address for display**: `0x10010000 (static data)`

3.  **Connect the Display**: In the Bitmap Display window, click the **"Connect to MIPS"** button.

4.  **Assemble and Run**:
    *   Assemble the program by clicking the **Assemble** icon (screwdriver and wrench) or by pressing `F3`.
    *   Run the program by clicking the **Run** icon (green play button) or by pressing `F5`.

5.  **Observe the Output**: A white Sierpinski Triangle will be progressively drawn on the black background of the Bitmap Display window.
