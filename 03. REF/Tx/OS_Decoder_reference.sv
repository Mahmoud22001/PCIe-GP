function OS_decoder_out OS_decoder_ref(
        input logic resetn,
        input logic [15:0] Rx_Data,
        input logic [1:0] Rx_DataK,
        input logic [1:0] Rx_Valid,
        input logic [1:0] Rx_COM_Indicator,
        input logic [4:0] LTSSM_state,
        input logic LTSSM_StateChange,
        input logic LTSSM_UpDown
        );
        
        static OS_decoder_out decoder_ref;

        static TS_type polling_active_type;	
        static bit [8:0] matching;              // each bit corresponding to a clk cycle
        static bit [3:0] TS_Counter;            // To count the received matching TS in any state
        static bit [3:0] idle_Counter;          // To count the received Logical IDLE's needed in Config_idle state
        static bit [3:0] cycles_counter;        // To count the number of cycles during which a TS is being processed
        static logic [1:0] TS_in_process;       // To indicate whenever the ref model is processing a TS
        static bit First_cond_achieved;         // To indicate the first condition has been achieved in states requiring two conditions (e.g. Config_complete)
        static logic [7:0] saved_link = `PAD;
        static logic [7:0] saved_lane = `PAD;
        static logic [7:0] saved_lane_Down = `PAD;
        static bit [1:0] saved_Ack; 
        static bit double_ack;
        static int dummy_count = 0;

        if (double_ack && LTSSM_state inside {`Config_complete, `Config_idle}) begin
            decoder_ref.Ack = saved_Ack;
            double_ack = 0;
        end

        if ((dummy_count == 1)) begin
            if (saved_link != `PAD ) begin
                // $display("At [%0t]: The saved link is %0h, ref_link = %0h", $realtime, saved_link, decoder_ref.Link);
                decoder_ref.Link = saved_link;
                // $display("after, At [%0t]: The saved link is %0h, ref_link = %0h", $realtime, saved_link, decoder_ref.Link);
            end
            
            if (saved_lane != `PAD && LTSSM_UpDown == 1'b0) begin
                decoder_ref.Lane = saved_lane; // Upstream device
                // $display("saved_lane UPSTREAM = %0h", saved_lane);
            end

            else if (saved_lane_Down != `PAD && LTSSM_UpDown == 1'b1) begin
                // $display("saved_lane_Down = %0h", saved_lane_Down);
                decoder_ref.Lane = saved_lane_Down; // Downstream device
                // $display("saved_lane_Down = %0h", saved_lane_Down);
            end
            // $display($realtime, " :dummy count alla = %0d", dummy_count);
            
            dummy_count = 0;

        end


        if (!resetn) begin
            // $display("saved_lane = %0h, saved_lane_Down = %0h", saved_lane, saved_lane_Down);
            decoder_ref.Ack = 2'b00;
            decoder_ref.Lane = (LTSSM_UpDown==1)? saved_lane_Down : saved_lane;
            decoder_ref.Link = saved_link;
            TS_Counter = 0;
            idle_Counter = 0;
            cycles_counter = 0;
            // saved_link = `PAD;
            // saved_lane = `PAD;
            // saved_lane_Down = `PAD;
            // decoder_ref.Lane = `PAD;
            // decoder_ref.Link = `PAD;
            // saved_link = 1;
            // saved_lane = 1;
            // saved_lane_Down = 1;
            saved_Ack = 2'b00;
            TS_in_process = 0;
            First_cond_achieved = 0;
            return decoder_ref;
        end

        else if (LTSSM_StateChange==1) begin       // FSM has entered a new state
            decoder_ref.Ack = 2'b00;
            TS_Counter = 0;
            idle_Counter = 0;
            cycles_counter = 0;
            saved_Ack = 2'b00;
            TS_in_process = 0;
            First_cond_achieved = 0;

            return decoder_ref;
        end

        else if (Rx_COM_Indicator == 2'b01 && Rx_Valid == 2'b11 && Rx_DataK[0] == 1'b1 && Rx_Data[7:0] == `COM) begin // The starting of a TS
            TS_in_process = 2'b01; // to be processed in 8 cycles
            $display("At [%0t]: The start of a Training Sequence is detected. This sequence will be processed in 8 cycles", $realtime);
        end

        else if (Rx_COM_Indicator == 2'b10 && Rx_Valid[1] == 1'b1 && Rx_DataK[1] == 1'b1 && Rx_Data[15:8] == `COM) begin // The starting of a TS
            TS_in_process = 2'b10; // to be processed in 9 cycles
            $display("At [%0t]: The start of a Training Sequence is detected. This sequence will be processed in 9 cycles", $realtime);
        end

        else if (Rx_COM_Indicator == 2'b00 && Rx_DataK == 2'b00 && TS_in_process == 2'b00 && LTSSM_state == `Config_idle) begin // Received Logical IDLE while no TS is being processed
            
            if (Rx_Valid == 2'b11 && Rx_Data == 16'b0) begin
                idle_Counter += 'd2;
                $display("The Two bytes of Rx_Data are Logical IDLE");
                // $display($realtime, ", idle_Counter aloooo = %0d", idle_Counter);
            end

            else if (Rx_Valid==2'b10 && Rx_Data[15:8] == 'b0) begin
                idle_Counter++;
                $display("The Most Significant Byte of Rx_Data is Logical IDLE");
            end

            else if (Rx_Valid==2'b01 && Rx_Data[7:0] == 'b0) begin
                idle_Counter++;
                $display("The Least Significant Byte of Rx_Data is Logical IDLE");
            end
            if (saved_Ack == 2'b10) begin
                decoder_ref.Ack = saved_Ack;   
                idle_Counter = 0;       
            end 

        end
        else begin
            decoder_ref.Ack = saved_Ack;
            // if((LTSSM_state == `Config_complete) && (double_ack == 0))
                // $display($time, "Ack is haaaaa = %0b ", saved_Ack);
        end




        if (TS_in_process inside {2'b10, 2'b01} || LTSSM_state == `Config_idle) begin	// The processing of TS and Logical IDLE's


            if (LTSSM_state != `Config_idle) begin

                if (process_TS(polling_active_type, matching, TS_in_process, Rx_Data, Rx_DataK, Rx_Valid, LTSSM_state, LTSSM_UpDown, cycles_counter, TS_Counter, saved_link, saved_lane, saved_lane_Down)) begin
                    $display("A Trainging Sequence has been processed successfully. Number of processed TS = %0d", TS_Counter);

                    if ((saved_link != `PAD ) || (saved_lane != `PAD && LTSSM_UpDown == 1'b0) || (saved_lane_Down != `PAD && LTSSM_UpDown == 1'b1)) begin
                        dummy_count = 1;
                    end
                  
                    // if (saved_lane != `PAD && LTSSM_UpDown == 1'b0) begin
                    //     decoder_ref.Lane = saved_lane; // Upstream device
                    // end

                    // else if (saved_lane_Down != `PAD && LTSSM_UpDown == 1'b1) begin
                    //     decoder_ref.Lane = saved_lane_Down; // Downstream device
                    //     $display("saved_lane_Down = %0h", saved_lane_Down);
                    // end

                    case(LTSSM_state) // Checking the required number of TS and Logical IDLE in each state 

                        `Polling_Active , `Polling_configuration: begin
                            if (TS_Counter >= 8) begin
                                saved_Ack = 2'b01;
                            end
                        end

                        `Config_Linkwidth_start , `Config_linkwidth_accept , `Config_Lanenum_wait , `Config_Lanenum_Accept: begin
                            if (TS_Counter >= 2) begin
                                saved_Ack = 2'b01;
                            end

                        end

                        `Config_complete: begin

                            if (TS_Counter == 1 && !First_cond_achieved) begin
                                saved_Ack = 2'b01; // First condition (receiveing one TS2) is achieved
                                TS_Counter = 0; // Resetting the counter to start counting for the second condition
                                First_cond_achieved = 1;
                                double_ack = 1;
                            end

                            else if (TS_Counter >= 8 && First_cond_achieved) begin
                                saved_Ack = 2'b10; // Second condition is achieved
                                First_cond_achieved = 0; // For the next state
                            end
                        end

                    endcase

                end
                // // $monitor("counter = %0d", TS_Counter);
                // if (TS_Counter == 0 && LTSSM_UpDown !=1 ) begin
                //     $display("The received lane is %0h", saved_lane);
                //     // decoder_ref.Lane = saved_lane;
                // end
                        


            end

            else begin // Current state is Config_idle

                if (idle_Counter >= 1 && !First_cond_achieved) begin
                    saved_Ack = 2'b01; // First condition is achieved
                    First_cond_achieved = 1;
                    double_ack = 1;
                end

                else if(idle_Counter >= 9 && First_cond_achieved) begin
                    saved_Ack = 2'b10; // Second condition is achieved
                    First_cond_achieved = 0;
                end


            end
        end
        

        return decoder_ref;
        
    endfunction

    function automatic bit process_TS(
        ref TS_type polling_active_type,
        ref bit [8:0] matching,
        ref logic [1:0] TS_in_process,
        input logic [15:0] Rx_Data,
        input logic [1:0] Rx_DataK,
        input logic [1:0] Rx_Valid,
        input logic [4:0] LTSSM_state,
        input logic LTSSM_UpDown,
        ref bit [3:0] cycles_counter,
        ref bit [3:0] TS_Counter,
        ref logic [7:0] saved_link,
        ref logic [7:0] saved_lane,
        ref logic [7:0] saved_lane_Down
        );

        if(TS_in_process == 2'b01) begin	// 8 cycles of processing

            case (LTSSM_state)

                `Polling_Active: begin	// Requires receiving 8 TSx/PAD/PAD (can be TS1 or TS2)

                    if (cycles_counter == 0 && Rx_Data[15:8] == `PAD && Rx_DataK[1] == 1) begin     // (Link#, COM)
                        matching[0] = 1;
                        
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b01) begin   // (N_FTS, Lane#)
                        matching[1] = 1;
                        saved_lane = `PAD;
                    end

                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin  // (Training Ctrl, Rate ID)
                        matching[2] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && polling_active_type == not_set) begin     // (TS ID, TS ID)
                        
                        if (Rx_Data == {`TS1, `TS1}) begin
                            polling_active_type = TS1_type;
                        end

                        else if (Rx_Data == {`TS2, `TS2}) begin
                            polling_active_type = TS2_type;
                        end

                        matching[3] = 1;

                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && ((polling_active_type == TS2_type && Rx_Data == {`TS2, `TS2}) || (polling_active_type == TS1_type && Rx_Data == {`TS1, `TS1}))) begin    // (TS ID, TS ID)
                        matching[cycles_counter] = 1;
                    end

                end

                `Polling_configuration: begin // Requires receiving 8 TS2/PAD/PAD 

                    if (cycles_counter == 0 && Rx_Data[15:8] == `PAD && Rx_DataK[1] == 1) begin
                        matching[0] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b01) begin
                        matching[1] = 1;
                        saved_lane = `PAD;
                    end

                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2}) begin
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_Linkwidth_start: begin // Requires receiving 2 TS1/Link#/PAD 

                    if (cycles_counter == 0 && Rx_Data[15:8] != `PAD && saved_link == `PAD && Rx_DataK[1] == 0) begin
                        if(TS_Counter==0) saved_link = Rx_Data[15:8];
                        matching[0] = 1;
                    end

                    else if (cycles_counter == 0 && Rx_Data[15:8] == saved_link && Rx_DataK[1] == 0) begin
                        matching[0] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b01) begin
                        matching[1] = 1;
                        saved_lane = `PAD;
                    end

                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1}) begin
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_linkwidth_accept: begin // Requires receiving 2 TS1/Link#/PAD for Downstream, 2 TS1/Link#/Lane# for Upstream

                    if (cycles_counter == 0 && Rx_Data[15:8] == saved_link && Rx_DataK[1] == 0) begin
                        matching[0] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b01 && LTSSM_UpDown==1'b1) begin     // Downstream device
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] != `PAD && saved_lane == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && LTSSM_UpDown == 1'b0) begin  // Upstream device
                        if(TS_Counter==0) saved_lane = Rx_Data[7:0];
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && LTSSM_UpDown == 1'b0) begin   // Upstream device
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1}) begin
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_Lanenum_wait: begin // Requires receiving 2 TS1/Link#/Non-PAD for Downstream, 2 TS2/Link#/Lane# for Upstream
                    
                    if (cycles_counter == 0 && Rx_Data[15:8] == saved_link && Rx_DataK[1] == 0) begin
                        // $display("3laaaaaaaaaaaaaaaaaaaa, in config_lanenum_wait, saved_link = %0h", saved_link);
                        matching[0] = 1;
                    end
                    // if(cycles_counter==1) $display("At time [%0t]: Rx_Data[7:0] (saved_lane) = %0h, LTSSM_UpDown = %0b", $realtime, Rx_Data[7:0], LTSSM_UpDown);
                    else if (cycles_counter == 1 && Rx_Data[7:0] != `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && LTSSM_UpDown == 1'b1) begin       // Downstream device
                        if(TS_Counter==0) saved_lane_Down = Rx_Data[7:0];
                        // $display("The received lane is %0h", saved_lane_Down);
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == saved_lane && Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && LTSSM_UpDown == 1'b0) begin     	// Upstream device
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1} && LTSSM_UpDown == 1'b1) begin       // Downstream device
                        matching[cycles_counter] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2} && LTSSM_UpDown == 1'b0) begin       // Upstream device
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_Lanenum_Accept: begin // Requires receiving 2 TS1/Link#/Lane# for Downstream, 2 TS2/Link#/Lane# for Upstream

                    if (cycles_counter == 0 && Rx_Data[15:8] == saved_link && Rx_DataK[1] == 0) begin
                        matching[0] = 1;
                    end

                    else if (cycles_counter == 1 && ((Rx_Data[7:0] == saved_lane_Down)||(Rx_Data[7:0] == saved_lane)) && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[1] = 1;
                    end
                    
                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1} && LTSSM_UpDown == 1'b1) begin       // Downstream device
                        matching[cycles_counter] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2} && LTSSM_UpDown == 1'b0) begin       // Upstream device
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_complete: begin

                    if (cycles_counter == 0 && Rx_Data[15:8] == saved_link && Rx_DataK[1] == 0) begin
                        matching[0] = 1;
                    end

                    else if (cycles_counter == 1 && ((Rx_Data[7:0] == saved_lane_Down)||(Rx_Data[7:0] == saved_lane)) && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[7:0] == 8'd2 && Rx_Data[15:8] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2}) begin
                        matching[cycles_counter] = 1;
                    end

                end

            endcase

        end

        else if (TS_in_process == 2'b10) begin	// 9 cycles of processing

            if (cycles_counter == 0) begin      // (COM, xxxxx)
                matching[0] = 1;
            end

            else begin

                case (LTSSM_state)

                `Polling_Active: begin	// Requires receiving 8 TSx/PAD/PAD (can be TS1 or TS2)

                    if (cycles_counter == 1 && Rx_Data == {`PAD, `PAD} && Rx_Valid == 2'b11 && Rx_DataK == 2'b11) begin     // (Lane#, Link#)
                        matching[1] = 1;
                    end
                    
                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin      // (Rate ID, N_FTS)
                        matching[2] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && polling_active_type == not_set) begin    // (TS ID, Training Ctrl)
                        
                        if (Rx_Data[15:8] == `TS1) begin
                            polling_active_type = TS1_type;
                        end
                        
                        else if (Rx_Data[15:8] == `TS2) begin
                            polling_active_type = TS2_type;
                        end

                        matching[3] = 1;

                    end

                    else if (cycles_counter == 3 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && ((polling_active_type == TS1_type && Rx_Data[15:8] == `TS1) || (polling_active_type == TS2_type && Rx_Data[15:8] == `TS2))) begin
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && ((polling_active_type == TS1_type && Rx_Data[7:0] == `TS1) || (polling_active_type == TS2_type && Rx_Data[7:0] == `TS2)) && Rx_Valid[0] == 1 && Rx_DataK[0] == 0) begin     // (xxxxx, TS ID) --> last cycle
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && ((polling_active_type == TS2_type && Rx_Data == {`TS2, `TS2}) || (polling_active_type == TS1_type && Rx_Data == {`TS1, `TS1}))) begin        // (TS ID, TS ID)
                        matching[cycles_counter] = 1;
                    end

                end

                `Polling_configuration: begin // Requires receiving 8 TS2/PAD/PAD 

                    if (cycles_counter == 1 && Rx_Data == {`PAD, `PAD} && Rx_Valid == 2'b11 && Rx_DataK == 2'b11) begin
                        matching[1] = 1;	
                    end

                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1; 
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS2 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS2 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0) begin
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2}) begin
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_Linkwidth_start: begin // Requires receiving 2 TS1/Link#/PAD 
                    
                    if (cycles_counter == 1 && Rx_Data[7:0]!=`PAD && Rx_Data[15:8] == `PAD && saved_link == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b10) begin
                        if(TS_Counter==0) saved_link = Rx_Data[7:0];
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_Data[15:8] == `PAD && Rx_Valid == 2'b11 && Rx_DataK == 2'b10) begin
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1; 
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS1 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS1 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0) begin
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1}) begin
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_linkwidth_accept: begin // Requires receiving 2 TS1/Link#/PAD for Downstream, 2 TS1/Link#/Lane# for Upstream
                    
                    if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b10 && Rx_Valid == 2'b11 && LTSSM_UpDown == 1'b1 && Rx_Data[15:8] == `PAD) begin     // Downstream device
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b00 && Rx_Valid == 2'b11 && LTSSM_UpDown == 1'b0 && Rx_Data[15:8]!=`PAD && saved_lane == `PAD) begin // Upstream device
                        if(TS_Counter==0) saved_lane = Rx_Data[15:8];
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b00 && Rx_Valid == 2'b11 && LTSSM_UpDown == 1'b0 && Rx_Data[15:8] == saved_lane) begin      // Upstream device
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS1 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS1 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0) begin
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1}) begin
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_Lanenum_wait: begin // Requires receiving 2 TS1/Link#/Non-PAD for Downstream, 2 TS2/Link#/Lane# for Upstream
                    
                    if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b00 && Rx_Valid == 2'b11 && LTSSM_UpDown == 1'b1 && Rx_Data[15:8]!=`PAD) begin   // Downstream device 
                        if(TS_Counter==0) saved_lane_Down = Rx_Data[15:8];
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b00 && Rx_Valid == 2'b11 && LTSSM_UpDown == 1'b0 && Rx_Data[15:8] == saved_lane) begin      // Upstream device
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS1 && LTSSM_UpDown == 1'b1 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin      // Downstream device
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS2 && LTSSM_UpDown == 1'b0 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin      // Upstream device
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS1 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0 && LTSSM_UpDown == 1'b1) begin     // Downstream device
                        matching[8] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS2 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0 && LTSSM_UpDown == 1'b0) begin     // Upstream device
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1} && LTSSM_UpDown == 1'b1) begin       // Downstream device
                        matching[cycles_counter] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2} && LTSSM_UpDown == 1'b0) begin       // Upstream device
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_Lanenum_Accept: begin // Requires receiving 2 TS1/Link#/Lane# for Downstream, 2 TS2/Link#/Lane# for Upstream
                    
                    if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b00 && Rx_Valid == 2'b11 && (Rx_Data[15:8] == saved_lane || Rx_Data[15:8] == saved_lane_Down)) begin
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS1 && LTSSM_UpDown == 1'b1 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin      // Downstream device
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS2 && LTSSM_UpDown == 1'b0 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin      // Upstream device
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS1 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0 && LTSSM_UpDown == 1'b1) begin     // Downstream device
                        matching[8] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS2 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0 && LTSSM_UpDown == 1'b0) begin     // Upstream device
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS1, `TS1} && LTSSM_UpDown == 1'b1) begin       // Downstream device
                        matching[cycles_counter] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2} && LTSSM_UpDown == 1'b0) begin       // Upstream device
                        matching[cycles_counter] = 1;
                    end

                end

                `Config_complete: begin

                    if (cycles_counter == 1 && Rx_Data[7:0] == saved_link && Rx_DataK == 2'b00 && Rx_Valid == 2'b11 && (Rx_Data[15:8] == saved_lane || Rx_Data[15:8] == saved_lane_Down)) begin
                        matching[1] = 1;
                    end

                    else if (cycles_counter == 2 && Rx_Data[15:8] == 8'd2 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[2] = 1;
                    end

                    else if (cycles_counter == 3 && Rx_Data[15:8] == `TS2 && Rx_Data[7:0] == 8'd0 && Rx_Valid == 2'b11 && Rx_DataK == 2'b00) begin
                        matching[3] = 1;
                    end

                    else if (cycles_counter == 8 && Rx_Data[7:0] == `TS2 && Rx_Valid[0] == 1 && Rx_DataK[0] == 0) begin
                        matching[8] = 1;
                    end

                    else if (Rx_Valid == 2'b11 && Rx_DataK == 2'b00 && Rx_Data == {`TS2, `TS2}) begin
                        matching[cycles_counter] = 1;
                    end

                end

            endcase

            end
            
        end

        if ((TS_in_process == 2'b01 && cycles_counter == 7) || (TS_in_process == 2'b10 && cycles_counter == 8)) begin  // TS has been fully processed
            
            // if (LTSSM_state == `Config_complete) begin
            //     $display("Matching = %b", matching);
            //     $display("TS_in_process = %0b", TS_in_process);
            //     $display("saved_link = %0h", saved_link);   
            //     $display("saved_lane_Down = %0h", saved_lane_Down);
            //     $display("saved_lane = %0h", saved_lane);
            // end     
            
            if ((TS_in_process == 2'b01 && matching == 9'b0111_11111) || (TS_in_process == 2'b10 && matching == 9'b1111_11111)) begin       // TS is matching with the required format
                TS_Counter++;
                
            end


            TS_in_process = 0;
            matching = 0;
            cycles_counter = 0;
            return 1;
            
        end

        else begin
            cycles_counter++;
            return 0;
        end

    endfunction