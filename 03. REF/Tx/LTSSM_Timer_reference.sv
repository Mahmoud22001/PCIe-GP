function void timer_ref(input logic resetn,
                             input logic start,
                             input logic [22:0] input_time,
                             ref logic ref_out);
        if(!resetn || !start) begin
            counter = 0;
            ref_out = 0;
        end
        else if(start) begin
            // ++counter;
            if((counter++)==input_time) ref_out = 1;
        end
    endfunction 

// module tb (
// );
//     logic clk = 0;
//     logic start, resetn, time_out;
//     logic [22:0] in_val;

//     always #5 clk = ~clk;

//     timer_ref m1(.*);

//     initial begin
//         resetn = 0; #10; resetn = 1;
//         in_val = 6;
//         #6;
//         start = 1;
//     end

//     always @(posedge clk) begin
//         $display("At time %0t: Reset = %0b, Start = %0b, Counter = %0d, Out = %0b", $realtime(), resetn, start, m1.counter, time_out);
//     end
// endmodule