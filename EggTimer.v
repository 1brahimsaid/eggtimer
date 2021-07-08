`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Ibrahim Said
// 
// Create Date: 03/25/2020 08:50:44 AM
// Module Name: Egg_Timer
// Project Name: Egg Timer
// Target Devices: Nexys
// 
//  
//////////////////////////////////////////////////////////////////////////////////
// TOP MODULE //
module Egg_Timer( 
// CORE //  
    input CLK100MHZ,        // 100MHz input clock, used to generate each real-time second
    input reset,            // resets the egg timer and sets the programmed cook time to 00:00
    input enable,           // enables/disables egg timer
    input ButtonModify,     // used to modify timer length
    input ButtonStart,      // starts egg timer
    input ButtonMin,        // increments mins when ButtonModify = 1 
    input ButtonSec,        // increments seconds when ButtonModify = 1
    
    output led0,            // LED0 on when egg timer is enabled
    output led,             // LED1 blinks at a 1s interval when the timer is counting down  
    output reg [6:0] seg,   // 
    output reg [7:0]  an,   // used for the 7 segment display    
// INNOVATIONS //
   // PRESETS  
    input softboiled,       // if enabled, and reset is enabled, instead of resetting to 00:00, resets at 6:00 (softboiled)
    input mediumboiled,     // if enabled, and reset is enabled, instead of resetting to 00:00, resets at 9:30 (mediumboiled) 
    input hardboiled,       // if enabled, and reset is enabled, instead of resetting to 00:00, resets at 14:00 (hardboiled)     
   // VISUAL  
    output [13:0]LED,       // LED visual when Egg Timer hits zero   
   // TIMER  
    input timerenabled,      // enables milisecond/second timer 
    input timerreset        // resets milisecond/second timer    
    );
// CLOCK //     
    wire clk_5;
    clk_wiz_0 instace(
    .clk_out1(clk_5),
    .clk_in1(CLK100MHZ));   // 100MHz clock divided to control signal
// REGISTERS/WIRES //   
    reg ledin = 0;
    reg led0 = 0;
                            // integer counter = 0;
                            // wire [13:0] led1;
         
    wire [7:0] an1; wire [7:0] an2; wire [7:0]an3;
    wire [6:0]seg1; wire [6:0]seg2; wire [6:0]seg3;    
    wire [3:0] smallmin1; wire [3:0] smallsec1; wire [2:0] bigsec1; wire [2:0] bigmin1;
    wire [3:0] smallmin2; wire [3:0] smallsec2; wire [2:0] bigsec2; wire [2:0] bigmin2;

// SUBMODULES // 
    Button_Time change (clk_5, ButtonModify, ButtonMin, ButtonSec, secout, minout);   
   // debounce module ( D-flip-flop w/ clk enable signal)
                                                                                       
    Current_timer currTime (clk_5, enable, reset, secout, minout, ButtonStart, softboiled, mediumboiled, hardboiled, smallmin1, bigmin1, smallsec1, bigsec1, an1, seg1, led);
    // 7 segment display, timer calculations, clock manipulation, led0 and led presets and resets   
                                                                                                                                   
    AlarmOn on(clk_5, ledin, LED); 
 // LED Visual when timer completes
                                                                                      
    Stop_Watch milli(clk_5, timerenabled ,timerreset ,seg3 ,an3);                    
 // Millisecond/Second Timer

// MODE CHECK // 
    always @ (posedge clk_5) begin
        ledin = 1;
        if (bigmin1 == 0 & smallmin1 == 0 & smallsec1 == 0 & bigsec1 == 0) begin
            ledin = 1;
        end else
            ledin = 0;     
        if (enable) begin
            led0 = 1;
            an = an1;                                   
            seg = seg1;
        end       
        if(enable == 0) begin
            led0 = 0;
        end                              
        if (timerenabled) begin
            seg = seg3;
            an = an3;
        end
    end

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Ibrahim Said
// 
// Create Date: 03/25/2020 08:50:44 AM
// Module Name: Egg_Timer
// Project Name: Egg Timer
// Target Devices: Nexys
// 
//  
//////////////////////////////////////////////////////////////////////////////////
// TOP MODULE //
module Button_Time(
    input clk,
    input buttonModify,
    input buttonMin,
    input buttonSec,

    output reg secout,
    output reg minout
    );
// DEBOUNCE/INCREMENT //   
    always @ (posedge clk) begin
        if (buttonModify) begin 
            if (buttonSec)
                secout <= 1;
            else 
                secout <= 0;
                
            if (buttonMin)
                minout <= 1;
            else 
                minout <= 0;                    
        end
end 
      reg df1, df2 = 0;

      always @(posedge CLK100HZ or posedge reset) begin
             shift forward
          if (reset) begin
              df1 <= 0;
              df2 <= 0;
          end else begin
              df2 <= dff1;
              df1 <= press;
          end
               compare; if shifted forward
      end
   endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Ibrahim Said
// 
// Create Date: 03/25/2020 08:50:44 AM
// Module Name: Current_timer
// Project Name: Egg Timer
// Target Devices: Nexys
// 
//  
//////////////////////////////////////////////////////////////////////////////////
// TOP MODULE //
module Current_timer(
    input CLK,
    input enable,
    input reset,
    input secin,
    input minin,
    input ButtonStart,
    input softboiled,
    input mediumboiled,
    input hardboiled,
    
    output [3:0] smallmin,
    output [2:0] bigmin,
    output [3:0] smallsec,
    output [2:0] bigsec,
    output reg [7:0]an,
    output reg [6:0]seg,
    output reg led    
    ); 

// REGISTERS/WIRES/INTEGERS //   
    reg [32:0] oneSec = 0;
    integer seconds = 0;
    
    integer refreshcounter;
    integer refresh = 0;
    
    wire [7:0] an1; wire [7:0] an2; wire [7:0] an3; wire [7:0] an4;
    wire [6:0]seg1; wire [6:0]seg2; wire [6:0]seg3; wire [6:0]seg4;
    wire [3:0] smallminT; wire [2:0] bigminT; wire [4:0] hourT;
    
// SUBMODULES //
    Clock_timing clktime (CLK, enable, reset, secin, minin, ButtonStart, softboiled, mediumboiled, hardboiled, smallsec, smallmin, bigmin, bigsec);
    sec_right a(smallsec, an1, seg1);
    sec_left b(bigsec, an2, seg2);
    min_right c(smallmin, an3, seg3);
    min_left d(bigmin, an4, seg4);
      
// REFRESH CURRENT TIME //    
    always @ (posedge CLK) begin
    
         if (refreshcounter >= 12500)begin
            if (refresh == 0)begin
                an = an1;
                seg = seg1;
                refresh = refresh + 1;
            end else if (refresh == 1) begin
                an = an2;
                seg = seg2;
                refresh = refresh + 1;
            end else if (refresh == 2) begin
                an = an3;
                seg = seg3;
                refresh = refresh + 1;
            end else if (refresh == 3) begin
                an = an4;
                seg = seg4;
                refresh = 0;
            end            
            refreshcounter = 0;
        end
        refreshcounter = refreshcounter + 1;
    end
    
// FLASHING LED1 AT 1 HZ
    always @(posedge CLK) begin  // must change to 2500000 
        if (oneSec == 250000)begin
            led =~ led;
            oneSec = 0;
        end
oneSec <= oneSec + 1; 
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Ibrahim Said
// 
// Create Date: 03/25/2020 08:50:44 AM
// Module Name: Clock_timing
// Project Name: Egg Timer
// Target Devices: Nexys
// 
//  
//////////////////////////////////////////////////////////////////////////////////

// TOP MODULE //
module Clock_timing(
    input clk,
    input enable,
    input reset,
    input secin,
    input minin,
    input ButtonStart,
    input softboiled,                 // if enabled, reset sets the programmed cook time to soft boiled 
    input mediumboiled,               // if enabled, reset sets the programmed cook time to medium boiled 
    input hardboiled,                 // if enabled, reset sets the programmed cook time to hard boiled
    
    output reg [3:0] smallsec,
    output reg [3:0] smallmin,
    output reg [2:0] bigmin,
    output reg [2:0] bigsec   
    );

// INTEGERS/INITIAL CONDITIONS //   
    integer toggle = 0;    
    integer countSec = 0;
    integer counter = 0;
    
    initial bigmin = 0;                                              // Do I need to initialize the values?
    initial bigsec = 0;
    initial smallmin = 0;
    initial smallsec = 0;
    
// MANUALLY INCREMENTING EGG TIME //    
    always @(posedge clk) begin
        if (secin) begin                                            // increments mins when ButtonModify = 1 and ButtonSec = 1 
            counter = counter + 1;
            if (counter == 500000) begin 
                smallsec = smallsec + 1;
                counter = 0;
                if (smallsec == 10) begin
                    bigsec = bigsec + 1;                             
                    smallsec = 0;
                    if (bigsec == 6) begin                           // resets after 59 seconds
                        smallsec = 0;
                        bigsec = 0;
                        
                    end
                end
            end    
        end

        if (minin) begin                                            // increments mins when ButtonModify = 1 and ButtonMin = 1 
            counter = counter + 1;
            if (counter == 500000) begin
                smallmin = smallmin + 1;       
                counter = 0;
                if (smallmin == 10) begin
                    bigmin = bigmin + 1;                            
                    smallmin = 0;
                    if (bigmin == 6) begin                          // resets after 59 minutes
                        smallmin = 0;
                        bigmin = 0;
                    end
                end
            end
        end
        
// RESETS/PRESETS //       
        if (reset) begin
            if (softboiled) begin                
                smallmin = 6;
                bigmin = 0;
                smallsec = 0;
                bigsec = 0;
                
            end else if (mediumboiled) begin            
               smallmin = 9;
               bigmin = 0;
               smallsec = 0;
               bigsec = 3; 
               
            end else if (hardboiled) begin          
               smallmin = 4;
               bigmin = 1;
               smallsec = 0;
               bigsec = 0;
               
            end else          
               smallmin = 6;
               bigmin = 0;
               smallsec = 0;
               bigsec = 0;      
               
        end 
        
// EGG TIMER COUNTDOWN //        
        if (countSec == 500000) begin 
            if (enable) begin
                toggle = 0;       
                if (secin == 0 & minin == 0 & ButtonStart) begin 
                    if (smallsec != 0  & toggle == 0) begin
                        smallsec = smallsec - 1;
                        toggle = 1;
                    end else if (smallsec == 0 & bigsec != 0 & toggle == 0) begin
                        smallsec = 9;
                        bigsec = bigsec - 1;
                        toggle = 1;
                    end else if (smallsec == 0 & bigsec == 0 & smallmin != 0 & toggle == 0) begin
                        smallsec = 9;
                        bigsec = 5;
                        smallmin = smallmin - 1;
                        toggle = 1;
                    end else if (smallsec == 0 & bigsec == 0 & smallmin == 0 & bigmin != 0 & toggle == 0) begin
                        smallsec = 9;
                        bigsec = 5;
                        smallmin = 9;
                        bigmin = bigmin -1;
                        toggle = 1;
                    end else if (enable & ButtonStart) begin                        
                        countSec = 0; 
                        countSec = countSec + 1;                                       
                    end
                end    
            end           
        end
    countSec = countSec + 1;    
    end
endmodule 

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Ibrahim Said
// 
// Create Date: 03/25/2020 08:50:44 AM
// Module Name: AlarmOn
// Project Name: Egg Timer
// Target Devices: Nexys
// 
//  
//////////////////////////////////////////////////////////////////////////////////

// TOP MODULE //
module AlarmOn(
    input Clk,
    input ledon,
    
    output reg [13:0] led    
    );    
    
// REGISTERS/INTEGERS //
    integer counter = 0;
    reg [3:0] counterled = 0;
    initial led = 0;                // do I need to? V?
      
    always @(posedge Clk) begin
        counter = counter + 1;
        if (counter == 50000) begin
            counter = 0; 
            counterled = counterled + 1;
        if (counterled == 14)
            counterled = 0;
        end
        if (ledon) begin
            case (counterled)
                4'b0011 : led = 16'b0000000000001000;
                4'b0100 : led = 16'b0000000000010000;
                4'b0101 : led = 16'b0000000000100000;
                4'b0110 : led = 16'b0000000001000000;
                4'b0111 : led = 16'b0000000010000000;
                4'b1000 : led = 16'b0000000100000000;
                4'b1001 : led = 16'b0000001000000000;
                4'b1010 : led = 16'b0000010000000000;
                4'b1011 : led = 16'b0000100000000000;
                4'b1100 : led = 16'b0001000000000000;
                4'b1101 : led = 16'b0010000000000000;
                4'b1110 : led = 16'b0100000000000000;
                4'b1111 : led = 16'b1000000000000000;
                4'b0000 : led = 16'b0000000000000001;
                default : led = 16'b0000000000000000;
            endcase                        
        end
        else begin        
            counterled = 0;
            led = 0;
            counter = 0;   
        end      
    end

endmodule
  
