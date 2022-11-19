# Egg Timer FPGA Design 🥚⏲️

# 1 – Introduction

Timing is key to boil eggs just how you like them. This designed implemented on a FPGA can set a timer to alert you when your eggs are ready. The design has pre-set timers for soft, medium, or hard-boiled eggs. Any time can be set with the push buttons for other timed tasks. Simple logic implementation using FPGA.

# 2- Diagrams

## 3.1 Block Diagram

<p align="center">
  <img src="https://user-images.githubusercontent.com/86809275/124993326-3b11fd80-e012-11eb-9b4f-4a441597fa2b.jpeg" alt="A close up of a diagram on a white background"/>
</p>

## 3.2 Schematic

<p align="center">
  <img src="https://user-images.githubusercontent.com/86809275/124993360-4402cf00-e012-11eb-8d07-3523a71c8a1a.png" alt="A model"/>
</p>


Vivado 2016.3 did not allow the Nexys4 DDR board installation, as a result a fully wired and correct Box Diagram was not produced. Instead, the schematic of the design using a similar part is provided instead and a hand drawn Box Diagram.

# 3 – Design

## 3.1 Design Choices

The design’s base function is to act as a timer that will reduce a pre-set or chosen time to zero all displayed on the seven-segment anode. The Button\_Time (debouncer) and the Current\_timer (counter, timer, display, 7segment) modules and their submodules work together and achieve this. Innovations beyond the base function include a switch enabled stopwatch, time pre-sets, and a visual led display that indicates zero.  The on-board clock (100MHz) will provide the high frequency clock. The Clock wizard IP is then used to divide the clock frequency from 100MHz to 5MHz, then another divider module (5MHz\_1Hz) will divide the frequency to 1 Hz. The entire design maintains synchronicity and is completely synchronous throughout.

**Egg\_Timer**

The top module for the entire system was designed with a top-down philosophy in mind. All outputs determined are fed back into this module for segment display. This module divides the clock in two ways. First the system calls on the Clocking Wizard IP which divides the system clock to 5MHz. The rest of the division is manufactured by another divider module (5MHz\_1Hz), which will take the clock (wire clk\_5) and divide it again to 1 Hz. The registers and wires required for the initialize the submodules are created. These submodules are called to produce the valid debounced changes, the current time displayed, the visual signaling zero, and the correct stopwatch time. After calling all submodules, a positive triggered clock loop checks if the timer is zero, if the timer is enabled, or if the stopwatch is enabled. If the timer is zero, the led visual is triggered and displayed. Depending on which one is enabled, either the egg timer or the stopwatch is displayed, and the corresponding led lit. If both are enabled, the egg timer persists over the stopwatch.

**Button\_Time**

Mechanical properties can cause button switches to contact more than once and produce an invalid signal. In a high frequency system, these button inputs can look like pulses instead of a single action. To prevent this phenomenon from occurring in this design, a debounce module was created to filter unwanted false positives. The module starts by dividing the 5MHz clock to ten milliseconds. This new clock is used as a positive edge trigger in a loop that facilitates the comparison of stored values (flip-flops) using a shift register to output valid presses. 

**Current\_Timer**

In this module, the 5Mhz clock, the valid debounced signals, the enable, reset, and pre-set switches are inputted. This module’s primary function is to calculate the remaining timer, determine the 7-segment display outputs, and adjust the timer. The registers and wires required for the five submodules to operate are initialized. These submodules are then called to calculate and display the correct timer. The top module Current\_timer loops and will refresh and update the correct time as determined by the submodule (clock\_timing) and send the 7-segment display values back to the top module.

  **Clock\_timing**

  This submodule includes a counter, timer adjustment with valid debounced inputs, and a reset to zero or any of the pre-set times. The timer can be adjusted to a max of 59:59 seconds, if the minutes or the seconds are incremented past that the values will reset to zero. If reset is enabled and all other pre-set switches are off, then the timer goes to zero. If a single pre-set switch is enabled, then reset will reset timer to pre-set. The timer will be decremented only if it is not zero or the value to the left is not zero. Each second is subtracted is determined by a using the 1 Hz clock signal. The calculated and correct time is back to the top-module and straight into the 7-segment output submodules to be outputted to the anode display.

**AlarmOn**

This module is called on by the top module when the timer hits zero. It accepts a 5MHz clock, a visual toggle and outputs a fourteen-bit register named LED. This register will initializes the unused LEDs on the FPGA and will produce a distinct and unique visual. Each LED is lit individually from three to sixteen over a short time interval. This visual performance is the indicates that timer has finished. This module was created as a part of the innovation of this base design.

**Stop\_Watch**

If called upon by the top module (if timerenable is 1), the 7-segment display will now a millisecond stopwatch controlled by the timerreset and timerenable inputs. This module has no defined limit and is a part of the innovation of the base design.

# 5 - Verilog/Software Code

Here is a link to the code on my github [here](https://github.com/1brahimsaid/eggtimer).

# 6 – Verification
The design was tested and simulated using a manufactured test bench. Doing so proved that the design would work without using an FPGA.

## 6.1 Test Benches 

Here is a link to the test bench code on my github [here](https://github.com/1brahimsaid/eggtimer).

## 6.2 Simulations

<p align="center">
  <img src="https://user-images.githubusercontent.com/86809275/124993430-5b41bc80-e012-11eb-99b2-66139db6e16c.png"/>
</p>

Figure 1: tb\_egg Behaviour Simulation

## 6.3 Resource Usage

Table 1: Post-Synthesis Resource Utilization

<p align="center">
  <img src="https://user-images.githubusercontent.com/86809275/124993437-5da41680-e012-11eb-8239-27d74b2d7447.png"/>
</p>

Table 2: Post-Implementation Resource Utilization

<p align="center">
  <img src="https://user-images.githubusercontent.com/86809275/124993449-60067080-e012-11eb-9724-3547b28bbbee.png"/>
</p>

# 7 – Conclusions (Lessons Learned)

The Clocking Wizard IP can only produce a clock 5Mhz and nothing lower. In this design case, it would be easier to call on the same clock divider module twice to produce a 1 Hz clock. Initializing and preparing long `if else` chains are easier to code, but significantly more wasteful (on system resources) than behavioural code. 

...return to [`projects.ibrahimsaid.ca`](https://projects.ibrahimsaid.ca/) or [`ibrahimsaid.ca`](https://www.ibrahimsaid.ca/).
