`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2020 09:34:22 AM
// Design Name: 
// Module Name: tb_egg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// TOP MODULE //
module tb_egg(
    );    
   // INPUTS //       
    reg CLK100MHZ;         // 100MHz input clock; used to generate each real-time second
    reg reset;             // resets the egg timer and sets the programmed cook time to 00:00
    reg enable;            // enables/disables egg timer
    reg ButtonModify;      // used to modify timer length
    reg ButtonStart;       // starts egg timer
    reg ButtonMin;         // increments mins when ButtonModify = 1 
    reg ButtonSec;         // increments seconds when ButtonModify = 1
    reg softboiled;        // if enabled; and reset is enabled; instead of resetting to 00:00; resets at 6:00 (softboiled)
    reg mediumboiled;      // if enabled; and reset is enabled; instead of resetting to 00:00; resets at 9:30 (mediumboiled) 
    reg hardboiled;        // if enabled; and reset is enabled; instead of resetting to 00:00; resets at 14:00 (hardboiled)
    reg timerenabled;      // enables milisecond/second timer 
    reg timerreset;        // resets milisecond/second timer  
   
   // OUTPUTS //      
    wire led0;             // LED0 on when egg timer is enabled
    wire led;
    wire LED;              // LED1 blinks at a 1s interval when the timer is counting down            
    wire seg;              // 
    wire an;               // used for the 7 segment display
    
    Egg_Timer egg1(
    
                   .CLK100MHZ(CLK100MHZ),          // 100MHz input clock; used to generate each real-time second
                   .reset(reset),                  // resets the egg timer and sets the programmed cook time to 00:00
                   .enable(enable),                // enables/disables egg timer
                   .ButtonModify(ButtonModify),    // used to modify timer length
                   .ButtonStart(ButtonStart),      // starts egg timer
                   .ButtonMin(ButtonMin),          // increments mins when ButtonModify = 1 
                   .ButtonSec(ButtonSec),          // increments seconds when ButtonModify = 1
                   .softboiled(softboiled),        // if enabled; and reset is enabled; instead of resetting to 00:00; resets at 6:00 (softboiled)
                   .mediumboiled(mediumboiled),    // if enabled; and reset is enabled; instead of resetting to 00:00; resets at 9:30 (mediumboiled) 
                   .hardboiled(hardboiled),        // if enabled; and reset is enabled; instead of resetting to 00:00; resets at 14:00 (hardboiled)
                   .timerenabled(timerenabled),    // enables milisecond/second timer 
                   .timerreset(timerreset),         // resets milisecond/second timer  
                   .led0(led0),                    // LED0 on when egg timer is enabled
                   .led(led),
                   .LED(LED),                      // LED1 blinks at a 1s interval when the timer is counting down            
                   .seg(seg),         
                   .an(an)         
                   );

   // CLOCK //
    initial 
    begin
          CLK100MHZ = 0;
    end         
    always #5 CLK100MHZ = ~CLK100MHZ;
 
 // INITIAL BLOCK //
              initial
              begin
                #0   ButtonStart = 0;
                #20  ButtonStart = 1;
                #200 ButtonStart = 0;
              end                                         
              initial
              begin
                #0   ButtonModify = 1;
                #10  ButtonModify = 0;
              end            
              initial
              begin
                #0   ButtonMin = 1;
                #5   ButtonMin = 0;
              end
             initial
              begin
                #0   ButtonSec = 1;
                #5   ButtonSec = 0;
                #10  ButtonSec = 1;
                #15  ButtonSec = 0;
              end 
            initial
            begin
               #0   softboiled = 0;
               #100 softboiled = 1;
               #105 softboiled = 0;
            end
            initial
            begin
               #0   reset = 0;
               #100 reset = 1;
               #105 reset = 0;
            end
            initial
            begin
               #0   mediumboiled = 0;
            end
            initial
            begin
               #0   hardboiled = 0;
            end               
            initial
            begin
               #0   enable = 1;
               #200 enable = 0;
            end
            initial
            begin
               #0   timerenabled = 0;
               #205 timerenabled = 1;
               #300 timerenabled = 0;
            end
            initial
            begin
               #0   timerreset = 0;
               #250 timerreset = 1;
               #255 timerreset = 0;
            end
