function automatic void reference_function( FSM_sequence_item reference_item_h);

    static reg     [4:0] Detect_Quiet=5'b00000;
    static reg     [4:0] Detect_Active=5'b00001;
    static reg     [4:0] Polling_Active=5'b00010;
    static reg     [4:0] Polling_configuration=5'b00011;
    static reg     [4:0]  Config_Linkwidth_start=5'b00100;
    static reg     [4:0] Config_Linkwidth_Accept=5'b00101;
    static reg     [4:0] Config_Lanenum_wait=5'b00110;
    static reg     [4:0]  Config_Lanenum_Accept=5'b00111;
    static reg     [4:0]  Config_complete=5'b01000;
    static reg     [4:0]  Config_idle=5'b01001;
    static reg     [4:0] L0=5'b01010;

    static reg   [7:0] COM=8'hBC;
    static reg   [7:0] PAD=8'hF7;
    static reg   [7:0] FTS=8'hFF;
    static reg   [7:0] SKP=8'h1C;

    static reg    [7:0] state;
    static reg    [7:0] nstate;






    if(!reference_item_h.i_resetn)
        begin
        state=Detect_Quiet;
        reference_item_h.o_LTSSM_state = state;
    end
            
     case(state)
        Detect_Quiet:
        begin

            nstate=state;
            reference_item_h.o_timer_timeoutValue = 12; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =0;
            reference_item_h.o_OScreator_types = 3;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 0;
            reference_item_h.o_OScreator_Symbol0=0;
            reference_item_h.o_OScreator_Symbol1=0;
            reference_item_h.o_OScreator_Symbol2=0;
            reference_item_h.o_OScreator_Symbol3=0;
            reference_item_h.o_OScreator_Symbol4=0;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=0;
            reference_item_h.o_OScreator_Symbol7=0;
            reference_item_h.o_OScreator_Symbol8=0;
            reference_item_h.o_OScreator_Symbol9=0;
            reference_item_h.o_OScreator_Symbol10=0;
            reference_item_h.o_OScreator_Symbol11=0;
            reference_item_h.o_OScreator_Symbol12=0;
            reference_item_h.o_OScreator_Symbol13=0;
            reference_item_h.o_OScreator_Symbol14=0;
            reference_item_h.o_OScreator_Symbol15=0;  
            if (reference_item_h.i_PHY_RxElecIdle ==0 || reference_item_h.i_timer_timeout == 1)
            begin 
                reference_item_h.o_timer_start =0;
                reference_item_h.o_LTSSM_stateChange =1;
                nstate = Detect_Active;
            end
        end

        Detect_Active:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 12; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =0;
            reference_item_h.o_OScreator_types = 3;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 0;
            reference_item_h.o_OScreator_Symbol0=0;
            reference_item_h.o_OScreator_Symbol1=0;
            reference_item_h.o_OScreator_Symbol2=0;
            reference_item_h.o_OScreator_Symbol3=0;
            reference_item_h.o_OScreator_Symbol4=0;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=0;
            reference_item_h.o_OScreator_Symbol7=0;
            reference_item_h.o_OScreator_Symbol8=0;
            reference_item_h.o_OScreator_Symbol9=0;
            reference_item_h.o_OScreator_Symbol10=0;
            reference_item_h.o_OScreator_Symbol11=0;
            reference_item_h.o_OScreator_Symbol12=0;
            reference_item_h.o_OScreator_Symbol13=0;
            reference_item_h.o_OScreator_Symbol14=0;
            reference_item_h.o_OScreator_Symbol15=0;  
            if (reference_item_h.i_PHY_laneDetected ==1)
            begin 
                reference_item_h.o_timer_start =0;
                reference_item_h.o_LTSSM_stateChange =1;
                nstate = Polling_Active;
            end
            if (reference_item_h.i_timer_timeout == 1)
            begin
                reference_item_h.o_timer_start =0;
                reference_item_h.o_LTSSM_stateChange =1;
                nstate = Detect_Quiet;
            end
        end
        

        Polling_Active:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 260; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =24;
            reference_item_h.o_OScreator_types = 1;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 1;
            reference_item_h.o_OScreator_Symbol0=COM;
            reference_item_h.o_OScreator_Symbol1=PAD;
            reference_item_h.o_OScreator_Symbol2=PAD;
            reference_item_h.o_OScreator_Symbol3=FTS;
            reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=8'h4A;
            reference_item_h.o_OScreator_Symbol7=8'h4A;
            reference_item_h.o_OScreator_Symbol8=8'h4A;
            reference_item_h.o_OScreator_Symbol9=8'h4A;
            reference_item_h.o_OScreator_Symbol10=8'h4A;
            reference_item_h.o_OScreator_Symbol11=8'h4A;
            reference_item_h.o_OScreator_Symbol12=8'h4A;
            reference_item_h.o_OScreator_Symbol13=8'h4A;
            reference_item_h.o_OScreator_Symbol14=8'h4A;
            reference_item_h.o_OScreator_Symbol15=8'h4A;   
            if(reference_item_h.i_OSdecoder_Ack==2'b01 && reference_item_h.i_OScreator_Ack == 1)
            begin
            nstate=Polling_configuration;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Polling_configuration:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 160; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =16;
            reference_item_h.o_OScreator_types = 1;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 1;
            reference_item_h.o_OScreator_Symbol0=COM;
            reference_item_h.o_OScreator_Symbol1=PAD;
            reference_item_h.o_OScreator_Symbol2=PAD;
            reference_item_h.o_OScreator_Symbol3=FTS;
            reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
            reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h45;
              reference_item_h.o_OScreator_Symbol7=8'h45;
              reference_item_h.o_OScreator_Symbol8=8'h45;
              reference_item_h.o_OScreator_Symbol9=8'h45;
              reference_item_h.o_OScreator_Symbol10=8'h45;
              reference_item_h.o_OScreator_Symbol11=8'h45;
              reference_item_h.o_OScreator_Symbol12=8'h45;
              reference_item_h.o_OScreator_Symbol13=8'h45;
              reference_item_h.o_OScreator_Symbol14=8'h45;
              reference_item_h.o_OScreator_Symbol15=8'h45;   
            if(reference_item_h.i_OScreator_Ack==1 && reference_item_h.i_OSdecoder_Ack==2'b01)
            begin
            nstate=Config_Linkwidth_start;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_Linkwidth_start:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 64; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =11'h7ff; 
            reference_item_h.o_OScreator_types = 1;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 1;
            reference_item_h.o_OScreator_Symbol0=COM;
            if(reference_item_h.i_LTSSM_UpDown==0)
				reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
			 else
             begin
            reference_item_h.o_OScreator_Symbol1=8'h00;
             end
            reference_item_h.o_OScreator_Symbol2=PAD;
            reference_item_h.o_OScreator_Symbol3=FTS;
            reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=8'h4A;
            reference_item_h.o_OScreator_Symbol7=8'h4A;
            reference_item_h.o_OScreator_Symbol8=8'h4A;
            reference_item_h.o_OScreator_Symbol9=8'h4A;
            reference_item_h.o_OScreator_Symbol10=8'h4A;
            reference_item_h.o_OScreator_Symbol11=8'h4A;
            reference_item_h.o_OScreator_Symbol12=8'h4A;
            reference_item_h.o_OScreator_Symbol13=8'h4A;
            reference_item_h.o_OScreator_Symbol14=8'h4A;
            reference_item_h.o_OScreator_Symbol15=8'h4A;   
            if(reference_item_h.i_OSdecoder_Ack==2'b01)
            begin
            nstate=Config_Linkwidth_Accept;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_Linkwidth_Accept:
        begin
              nstate=state;
              reference_item_h.o_timer_start=1;
              reference_item_h.o_timer_timeoutValue = 64;  
              reference_item_h.o_LTSSM_stateChange=0;
              reference_item_h.o_OScreator_enable=1;
              reference_item_h.o_OScreator_types=1;
              reference_item_h.o_LTSSM_L0_up=0;
                            
              reference_item_h.o_OScreator_Symbol0=COM;
             if(reference_item_h.i_LTSSM_UpDown==0)
             begin
				reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
             end
			 else
             begin
			  reference_item_h.o_OScreator_Symbol1=8'h00;
              end
              reference_item_h.o_OScreator_Symbol2=PAD;
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h4A;
              reference_item_h.o_OScreator_Symbol7=8'h4A;
              reference_item_h.o_OScreator_Symbol8=8'h4A;
              reference_item_h.o_OScreator_Symbol9=8'h4A;
              reference_item_h.o_OScreator_Symbol10=8'h4A;
              reference_item_h.o_OScreator_Symbol11=8'h4A;
              reference_item_h.o_OScreator_Symbol12=8'h4A;
              reference_item_h.o_OScreator_Symbol13=8'h4A;
              reference_item_h.o_OScreator_Symbol14=8'h4A;
              reference_item_h.o_OScreator_Symbol15=8'h4A;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
            if(reference_item_h.i_OSdecoder_Ack==2'b01)
            begin 
            nstate=Config_Lanenum_wait;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_Lanenum_wait:
        begin

             nstate=state;
             reference_item_h.o_timer_start=1;
             reference_item_h.o_timer_timeoutValue = 30;
             reference_item_h.o_LTSSM_stateChange=0;  
             reference_item_h.o_OScreator_enable=1;
             reference_item_h.o_OScreator_types=1;
             reference_item_h.o_LTSSM_L0_up=0;
                           
             reference_item_h.o_OScreator_Symbol0=COM;
               if(reference_item_h.i_LTSSM_UpDown==0)
			  begin
			  reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
			  reference_item_h.o_OScreator_Symbol2=reference_item_h.i_OSdecoder_Lane;
			  end
			  else
			  begin
			  reference_item_h.o_OScreator_Symbol1=8'h00;
			  reference_item_h.o_OScreator_Symbol2=8'h00;
			  end
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h4A;
              reference_item_h.o_OScreator_Symbol7=8'h4A;
              reference_item_h.o_OScreator_Symbol8=8'h4A;
              reference_item_h.o_OScreator_Symbol9=8'h4A;
              reference_item_h.o_OScreator_Symbol10=8'h4A;
              reference_item_h.o_OScreator_Symbol11=8'h4A;
              reference_item_h.o_OScreator_Symbol12=8'h4A;
              reference_item_h.o_OScreator_Symbol13=8'h4A;
              reference_item_h.o_OScreator_Symbol14=8'h4A;
              reference_item_h.o_OScreator_Symbol15=8'h4A;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
                                   
            if(reference_item_h.i_OSdecoder_Ack==2'b01)
            begin
            nstate=Config_Lanenum_Accept;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
        end

        Config_Lanenum_Accept:
        begin
            nstate=state;
            reference_item_h.o_timer_start=1;
            reference_item_h.o_LTSSM_stateChange=0;
            reference_item_h.o_timer_timeoutValue = 30; 
            
            reference_item_h.o_OScreator_enable=1;
             reference_item_h.o_OScreator_types=1;
            reference_item_h.o_LTSSM_L0_up=0;
                           
             reference_item_h.o_OScreator_Symbol0=COM;
               if(reference_item_h.i_LTSSM_UpDown==0)
              begin
              reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
              reference_item_h.o_OScreator_Symbol2=reference_item_h.i_OSdecoder_Lane;
              end
              else
              begin
              reference_item_h.o_OScreator_Symbol1=8'h00;
              reference_item_h.o_OScreator_Symbol2=8'h00;
              end
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h4A;
              reference_item_h.o_OScreator_Symbol7=8'h4A;
              reference_item_h.o_OScreator_Symbol8=8'h4A;
              reference_item_h.o_OScreator_Symbol9=8'h4A;
              reference_item_h.o_OScreator_Symbol10=8'h4A;
              reference_item_h.o_OScreator_Symbol11=8'h4A;
              reference_item_h.o_OScreator_Symbol12=8'h4A;
              reference_item_h.o_OScreator_Symbol13=8'h4A;
              reference_item_h.o_OScreator_Symbol14=8'h4A;
              reference_item_h.o_OScreator_Symbol15=8'h4A;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
                                   
            
            if(reference_item_h.i_OSdecoder_Ack==2'b01) 
            begin
            nstate=Config_complete;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_complete:
        begin
        nstate=state;
            reference_item_h.o_timer_start=1;
            reference_item_h.o_LTSSM_stateChange=0;
            reference_item_h.o_timer_timeoutValue = 160;
              reference_item_h.o_OScreator_enable=1;
              reference_item_h.o_OScreator_types=1;
                reference_item_h.o_LTSSM_L0_up=0;
                            
              reference_item_h.o_OScreator_Symbol0=COM;
               if(reference_item_h.i_LTSSM_UpDown==0)
			  begin
			  reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
			  reference_item_h.o_OScreator_Symbol2=reference_item_h.i_OSdecoder_Lane;
			  end
			  else
			  begin
			  reference_item_h.o_OScreator_Symbol1=8'h00;
			  reference_item_h.o_OScreator_Symbol2=8'h00;
			  end
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h45;
              reference_item_h.o_OScreator_Symbol7=8'h45;
              reference_item_h.o_OScreator_Symbol8=8'h45;
              reference_item_h.o_OScreator_Symbol9=8'h45;
              reference_item_h.o_OScreator_Symbol10=8'h45;
              reference_item_h.o_OScreator_Symbol11=8'h45;
              reference_item_h.o_OScreator_Symbol12=8'h45;
              reference_item_h.o_OScreator_Symbol13=8'h45;
              reference_item_h.o_OScreator_Symbol14=8'h45;
              reference_item_h.o_OScreator_Symbol15=8'h45;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
                                   
            if(reference_item_h.i_OSdecoder_Ack==2'b10&&reference_item_h.i_OScreator_Ack==1)
            begin
            reference_item_h.o_OScreator_resetTScounter=0;
            reference_item_h.o_OScreator_reqNum=16;
            nstate=Config_idle;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if(reference_item_h.i_OSdecoder_Ack==2'b01 || reference_item_h.i_OSdecoder_Ack==2'b10)
                begin
                reference_item_h.o_OScreator_resetTScounter=1;
                reference_item_h.o_OScreator_reqNum=16;
                end        
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end   
        end

        Config_idle:
        begin
            nstate=state;
            reference_item_h.o_OScreator_enable=1;
            reference_item_h.o_OScreator_types=2;
            reference_item_h.o_timer_start=1;
            reference_item_h.o_LTSSM_stateChange=0;
            reference_item_h.o_timer_timeoutValue = 20;           
            reference_item_h.o_LTSSM_L0_up=0;
                          
            reference_item_h.o_OScreator_Symbol0=0;
            reference_item_h.o_OScreator_Symbol1=0;
            reference_item_h.o_OScreator_Symbol2=0;
            reference_item_h.o_OScreator_Symbol3=0;
            reference_item_h.o_OScreator_Symbol4=0;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=0;
            reference_item_h.o_OScreator_Symbol7=0;
            reference_item_h.o_OScreator_Symbol8=0;
            reference_item_h.o_OScreator_Symbol9=0;
            reference_item_h.o_OScreator_Symbol10=0;
            reference_item_h.o_OScreator_Symbol11=0;
            reference_item_h.o_OScreator_Symbol12=0;
            reference_item_h.o_OScreator_Symbol13=0;
            reference_item_h.o_OScreator_Symbol14=0;
            reference_item_h.o_OScreator_Symbol15=0;  
            reference_item_h.o_OScreator_reqNum=11'h7ff; 
            reference_item_h.o_OScreator_resetTScounter=0;
                      
            
            if(reference_item_h.i_OSdecoder_Ack==2'b10&&reference_item_h.i_OScreator_Ack==1)
            begin
            reference_item_h.o_OScreator_resetTScounter=0;
            reference_item_h.o_OScreator_reqNum=16 ;
            nstate=L0;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
            else if(reference_item_h.i_OSdecoder_Ack==2'b01 || reference_item_h.i_OSdecoder_Ack==2'b10) 
                begin
                reference_item_h.o_OScreator_resetTScounter=1;
                reference_item_h.o_OScreator_reqNum=16 ;
                end    
        end

        L0:
        begin
        nstate=state;
        reference_item_h.o_OScreator_enable=0;
        reference_item_h.o_OScreator_types=3;
        reference_item_h.o_timer_start=1;
        reference_item_h.o_LTSSM_stateChange=0;
        reference_item_h.o_timer_timeoutValue=23'd100;  
        reference_item_h.o_LTSSM_L0_up=1;
                
        reference_item_h.o_OScreator_Symbol0=0;
        reference_item_h.o_OScreator_Symbol1=0;
        reference_item_h.o_OScreator_Symbol2=0;
        reference_item_h.o_OScreator_Symbol3=0;
        reference_item_h.o_OScreator_Symbol4=0;
        reference_item_h.o_OScreator_Symbol5=0;
        reference_item_h.o_OScreator_Symbol6=0;
        reference_item_h.o_OScreator_Symbol7=0;
        reference_item_h.o_OScreator_Symbol8=0;
        reference_item_h.o_OScreator_Symbol9=0;
        reference_item_h.o_OScreator_Symbol10=0;
        reference_item_h.o_OScreator_Symbol11=0;
        reference_item_h.o_OScreator_Symbol12=0;
        reference_item_h.o_OScreator_Symbol13=0;
        reference_item_h.o_OScreator_Symbol14=0;
        reference_item_h.o_OScreator_Symbol15=0;  
        reference_item_h.o_OScreator_reqNum=0; 
        reference_item_h.o_OScreator_resetTScounter=0;
        
        if(reference_item_h.i_timer_timeout==1)
        begin
        reference_item_h.o_OScreator_enable=1;
        reference_item_h.o_OScreator_types=0;
        reference_item_h.o_OScreator_Symbol0=COM;
        reference_item_h.o_OScreator_Symbol1=SKP;
        reference_item_h.o_OScreator_Symbol2=SKP;
        reference_item_h.o_OScreator_Symbol3=SKP;
        reference_item_h.o_OScreator_reqNum=1;
        reference_item_h.o_timer_start=0;
        end  
        end
 default: begin
        nstate=Detect_Quiet;
        reference_item_h.o_OScreator_enable=0;
        reference_item_h.o_OScreator_types=0;
        reference_item_h.o_timer_start=0;
        reference_item_h.o_LTSSM_stateChange=0;
        reference_item_h.o_timer_timeoutValue=0; 
        reference_item_h.o_LTSSM_L0_up=0;
                 
         
         reference_item_h.o_OScreator_Symbol0=0;
         reference_item_h.o_OScreator_Symbol1=0;
         reference_item_h.o_OScreator_Symbol2=0;
         reference_item_h.o_OScreator_Symbol3=0;
         reference_item_h.o_OScreator_Symbol4=0;
         reference_item_h.o_OScreator_Symbol5=0;
         reference_item_h.o_OScreator_Symbol6=0;
         reference_item_h.o_OScreator_Symbol7=0;
         reference_item_h.o_OScreator_Symbol8=0;
         reference_item_h.o_OScreator_Symbol9=0;
         reference_item_h.o_OScreator_Symbol10=0;
         reference_item_h.o_OScreator_Symbol11=0;
         reference_item_h.o_OScreator_Symbol12=0;
         reference_item_h.o_OScreator_Symbol13=0;
         reference_item_h.o_OScreator_Symbol14=0;
         reference_item_h.o_OScreator_Symbol15=0;  
         reference_item_h.o_OScreator_reqNum=0;
         reference_item_h.o_OScreator_resetTScounter=0;
                     
        end 


        endcase







    if(reference_item_h.i_resetn)
        begin
    state = nstate;
    reference_item_h.o_LTSSM_state = state;
    end
            
     
    case(state)
        Detect_Quiet:
        begin

            nstate=state;
            reference_item_h.o_timer_timeoutValue = 12; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =0;
            reference_item_h.o_OScreator_types = 3;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 0;
            reference_item_h.o_OScreator_Symbol0=0;
            reference_item_h.o_OScreator_Symbol1=0;
            reference_item_h.o_OScreator_Symbol2=0;
            reference_item_h.o_OScreator_Symbol3=0;
            reference_item_h.o_OScreator_Symbol4=0;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=0;
            reference_item_h.o_OScreator_Symbol7=0;
            reference_item_h.o_OScreator_Symbol8=0;
            reference_item_h.o_OScreator_Symbol9=0;
            reference_item_h.o_OScreator_Symbol10=0;
            reference_item_h.o_OScreator_Symbol11=0;
            reference_item_h.o_OScreator_Symbol12=0;
            reference_item_h.o_OScreator_Symbol13=0;
            reference_item_h.o_OScreator_Symbol14=0;
            reference_item_h.o_OScreator_Symbol15=0;  
            if (reference_item_h.i_PHY_RxElecIdle ==0 || reference_item_h.i_timer_timeout == 1)
            begin 
                reference_item_h.o_timer_start =0;
                reference_item_h.o_LTSSM_stateChange =1;
                nstate = Detect_Active;
            end
        end

        Detect_Active:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 12; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =0;
            reference_item_h.o_OScreator_types = 3;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 0;
            reference_item_h.o_OScreator_Symbol0=0;
            reference_item_h.o_OScreator_Symbol1=0;
            reference_item_h.o_OScreator_Symbol2=0;
            reference_item_h.o_OScreator_Symbol3=0;
            reference_item_h.o_OScreator_Symbol4=0;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=0;
            reference_item_h.o_OScreator_Symbol7=0;
            reference_item_h.o_OScreator_Symbol8=0;
            reference_item_h.o_OScreator_Symbol9=0;
            reference_item_h.o_OScreator_Symbol10=0;
            reference_item_h.o_OScreator_Symbol11=0;
            reference_item_h.o_OScreator_Symbol12=0;
            reference_item_h.o_OScreator_Symbol13=0;
            reference_item_h.o_OScreator_Symbol14=0;
            reference_item_h.o_OScreator_Symbol15=0;  
            if (reference_item_h.i_PHY_laneDetected ==1)
            begin 
                reference_item_h.o_timer_start =0;
                reference_item_h.o_LTSSM_stateChange =1;
                nstate = Polling_Active;
            end
            if (reference_item_h.i_timer_timeout == 1)
            begin
                reference_item_h.o_timer_start =0;
                reference_item_h.o_LTSSM_stateChange =1;
                nstate = Detect_Quiet;
            end
        end
        

        Polling_Active:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 260; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =24;
            reference_item_h.o_OScreator_types = 1;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 1;
            reference_item_h.o_OScreator_Symbol0=COM;
            reference_item_h.o_OScreator_Symbol1=PAD;
            reference_item_h.o_OScreator_Symbol2=PAD;
            reference_item_h.o_OScreator_Symbol3=FTS;
            reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=8'h4A;
            reference_item_h.o_OScreator_Symbol7=8'h4A;
            reference_item_h.o_OScreator_Symbol8=8'h4A;
            reference_item_h.o_OScreator_Symbol9=8'h4A;
            reference_item_h.o_OScreator_Symbol10=8'h4A;
            reference_item_h.o_OScreator_Symbol11=8'h4A;
            reference_item_h.o_OScreator_Symbol12=8'h4A;
            reference_item_h.o_OScreator_Symbol13=8'h4A;
            reference_item_h.o_OScreator_Symbol14=8'h4A;
            reference_item_h.o_OScreator_Symbol15=8'h4A;   
            if(reference_item_h.i_OSdecoder_Ack==2'b01 && reference_item_h.i_OScreator_Ack == 1)
            begin
            nstate=Polling_configuration;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Polling_configuration:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 160; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =16;
            reference_item_h.o_OScreator_types = 1;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 1;
            reference_item_h.o_OScreator_Symbol0=COM;
            reference_item_h.o_OScreator_Symbol1=PAD;
            reference_item_h.o_OScreator_Symbol2=PAD;
            reference_item_h.o_OScreator_Symbol3=FTS;
            reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
            reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h45;
              reference_item_h.o_OScreator_Symbol7=8'h45;
              reference_item_h.o_OScreator_Symbol8=8'h45;
              reference_item_h.o_OScreator_Symbol9=8'h45;
              reference_item_h.o_OScreator_Symbol10=8'h45;
              reference_item_h.o_OScreator_Symbol11=8'h45;
              reference_item_h.o_OScreator_Symbol12=8'h45;
              reference_item_h.o_OScreator_Symbol13=8'h45;
              reference_item_h.o_OScreator_Symbol14=8'h45;
              reference_item_h.o_OScreator_Symbol15=8'h45;   
            if(reference_item_h.i_OScreator_Ack==1 && reference_item_h.i_OSdecoder_Ack==2'b01)
            begin
            nstate=Config_Linkwidth_start;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_Linkwidth_start:
        begin
            nstate=state;
            reference_item_h.o_timer_timeoutValue = 64; 
            reference_item_h.o_timer_start = 1;
            reference_item_h.o_LTSSM_L0_up =0;
            reference_item_h.o_OScreator_reqNum =11'h7ff; 
            reference_item_h.o_OScreator_types = 1;
            reference_item_h.o_OScreator_resetTScounter = 0;
            reference_item_h.o_LTSSM_stateChange = 0;
            reference_item_h.o_OScreator_enable = 1;
            reference_item_h.o_OScreator_Symbol0=COM;
            if(reference_item_h.i_LTSSM_UpDown==0)
				reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
			 else
             begin
            reference_item_h.o_OScreator_Symbol1=8'h00;
             end
            reference_item_h.o_OScreator_Symbol2=PAD;
            reference_item_h.o_OScreator_Symbol3=FTS;
            reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=8'h4A;
            reference_item_h.o_OScreator_Symbol7=8'h4A;
            reference_item_h.o_OScreator_Symbol8=8'h4A;
            reference_item_h.o_OScreator_Symbol9=8'h4A;
            reference_item_h.o_OScreator_Symbol10=8'h4A;
            reference_item_h.o_OScreator_Symbol11=8'h4A;
            reference_item_h.o_OScreator_Symbol12=8'h4A;
            reference_item_h.o_OScreator_Symbol13=8'h4A;
            reference_item_h.o_OScreator_Symbol14=8'h4A;
            reference_item_h.o_OScreator_Symbol15=8'h4A;   
            if(reference_item_h.i_OSdecoder_Ack==2'b01)
            begin
            nstate=Config_Linkwidth_Accept;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_Linkwidth_Accept:
        begin
              nstate=state;
              reference_item_h.o_timer_start=1;
              reference_item_h.o_timer_timeoutValue = 64;  
              reference_item_h.o_LTSSM_stateChange=0;
              reference_item_h.o_OScreator_enable=1;
              reference_item_h.o_OScreator_types=1;
              reference_item_h.o_LTSSM_L0_up=0;
                            
              reference_item_h.o_OScreator_Symbol0=COM;
             if(reference_item_h.i_LTSSM_UpDown==0)
             begin
				reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
             end
			 else
             begin
			  reference_item_h.o_OScreator_Symbol1=8'h00;
              end
              reference_item_h.o_OScreator_Symbol2=PAD;
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h4A;
              reference_item_h.o_OScreator_Symbol7=8'h4A;
              reference_item_h.o_OScreator_Symbol8=8'h4A;
              reference_item_h.o_OScreator_Symbol9=8'h4A;
              reference_item_h.o_OScreator_Symbol10=8'h4A;
              reference_item_h.o_OScreator_Symbol11=8'h4A;
              reference_item_h.o_OScreator_Symbol12=8'h4A;
              reference_item_h.o_OScreator_Symbol13=8'h4A;
              reference_item_h.o_OScreator_Symbol14=8'h4A;
              reference_item_h.o_OScreator_Symbol15=8'h4A;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
            if(reference_item_h.i_OSdecoder_Ack==2'b01)
            begin 
            nstate=Config_Lanenum_wait;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_Lanenum_wait:
        begin

             nstate=state;
             reference_item_h.o_timer_start=1;
             reference_item_h.o_timer_timeoutValue = 30;
             reference_item_h.o_LTSSM_stateChange=0;  
             reference_item_h.o_OScreator_enable=1;
             reference_item_h.o_OScreator_types=1;
             reference_item_h.o_LTSSM_L0_up=0;
                           
             reference_item_h.o_OScreator_Symbol0=COM;
               if(reference_item_h.i_LTSSM_UpDown==0)
			  begin
			  reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
			  reference_item_h.o_OScreator_Symbol2=reference_item_h.i_OSdecoder_Lane;
			  end
			  else
			  begin
			  reference_item_h.o_OScreator_Symbol1=8'h00;
			  reference_item_h.o_OScreator_Symbol2=8'h00;
			  end
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h4A;
              reference_item_h.o_OScreator_Symbol7=8'h4A;
              reference_item_h.o_OScreator_Symbol8=8'h4A;
              reference_item_h.o_OScreator_Symbol9=8'h4A;
              reference_item_h.o_OScreator_Symbol10=8'h4A;
              reference_item_h.o_OScreator_Symbol11=8'h4A;
              reference_item_h.o_OScreator_Symbol12=8'h4A;
              reference_item_h.o_OScreator_Symbol13=8'h4A;
              reference_item_h.o_OScreator_Symbol14=8'h4A;
              reference_item_h.o_OScreator_Symbol15=8'h4A;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
                                   
            if(reference_item_h.i_OSdecoder_Ack==2'b01)
            begin
            nstate=Config_Lanenum_Accept;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
        end

        Config_Lanenum_Accept:
        begin
            nstate=state;
            reference_item_h.o_timer_start=1;
            reference_item_h.o_LTSSM_stateChange=0;
            reference_item_h.o_timer_timeoutValue = 30; 
            
            reference_item_h.o_OScreator_enable=1;
             reference_item_h.o_OScreator_types=1;
            reference_item_h.o_LTSSM_L0_up=0;
                           
             reference_item_h.o_OScreator_Symbol0=COM;
               if(reference_item_h.i_LTSSM_UpDown==0)
              begin
              reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
              reference_item_h.o_OScreator_Symbol2=reference_item_h.i_OSdecoder_Lane;
              end
              else
              begin
              reference_item_h.o_OScreator_Symbol1=8'h00;
              reference_item_h.o_OScreator_Symbol2=8'h00;
              end
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h4A;
              reference_item_h.o_OScreator_Symbol7=8'h4A;
              reference_item_h.o_OScreator_Symbol8=8'h4A;
              reference_item_h.o_OScreator_Symbol9=8'h4A;
              reference_item_h.o_OScreator_Symbol10=8'h4A;
              reference_item_h.o_OScreator_Symbol11=8'h4A;
              reference_item_h.o_OScreator_Symbol12=8'h4A;
              reference_item_h.o_OScreator_Symbol13=8'h4A;
              reference_item_h.o_OScreator_Symbol14=8'h4A;
              reference_item_h.o_OScreator_Symbol15=8'h4A;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
                                   
            
            if(reference_item_h.i_OSdecoder_Ack==2'b01) 
            begin
            nstate=Config_complete;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
        end

        Config_complete:
        begin
        nstate=state;
            reference_item_h.o_timer_start=1;
            reference_item_h.o_LTSSM_stateChange=0;
            reference_item_h.o_timer_timeoutValue = 160;
              reference_item_h.o_OScreator_enable=1;
              reference_item_h.o_OScreator_types=1;
                reference_item_h.o_LTSSM_L0_up=0;
                            
              reference_item_h.o_OScreator_Symbol0=COM;
               if(reference_item_h.i_LTSSM_UpDown==0)
			  begin
			  reference_item_h.o_OScreator_Symbol1=reference_item_h.i_OSdecoder_Link;
			  reference_item_h.o_OScreator_Symbol2=reference_item_h.i_OSdecoder_Lane;
			  end
			  else
			  begin
			  reference_item_h.o_OScreator_Symbol1=8'h00;
			  reference_item_h.o_OScreator_Symbol2=8'h00;
			  end
              reference_item_h.o_OScreator_Symbol3=FTS;
              reference_item_h.o_OScreator_Symbol4=8'b0000_0010;
              reference_item_h.o_OScreator_Symbol5=0;
              reference_item_h.o_OScreator_Symbol6=8'h45;
              reference_item_h.o_OScreator_Symbol7=8'h45;
              reference_item_h.o_OScreator_Symbol8=8'h45;
              reference_item_h.o_OScreator_Symbol9=8'h45;
              reference_item_h.o_OScreator_Symbol10=8'h45;
              reference_item_h.o_OScreator_Symbol11=8'h45;
              reference_item_h.o_OScreator_Symbol12=8'h45;
              reference_item_h.o_OScreator_Symbol13=8'h45;
              reference_item_h.o_OScreator_Symbol14=8'h45;
              reference_item_h.o_OScreator_Symbol15=8'h45;
             reference_item_h.o_OScreator_reqNum=11'h7ff; 
             reference_item_h.o_OScreator_resetTScounter=0;
                                   
            if(reference_item_h.i_OSdecoder_Ack==2'b10&&reference_item_h.i_OScreator_Ack==1)
            begin
            reference_item_h.o_OScreator_resetTScounter=0;
            reference_item_h.o_OScreator_reqNum=16;
            nstate=Config_idle;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if(reference_item_h.i_OSdecoder_Ack==2'b01 || reference_item_h.i_OSdecoder_Ack==2'b10)
                begin
                reference_item_h.o_OScreator_resetTScounter=1;
                reference_item_h.o_OScreator_reqNum=16;
                end        
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end   
        end

        Config_idle:
        begin
            nstate=state;
            reference_item_h.o_OScreator_enable=1;
            reference_item_h.o_OScreator_types=2;
            reference_item_h.o_timer_start=1;
            reference_item_h.o_LTSSM_stateChange=0;
            reference_item_h.o_timer_timeoutValue = 20;           
            reference_item_h.o_LTSSM_L0_up=0;
                          
            reference_item_h.o_OScreator_Symbol0=0;
            reference_item_h.o_OScreator_Symbol1=0;
            reference_item_h.o_OScreator_Symbol2=0;
            reference_item_h.o_OScreator_Symbol3=0;
            reference_item_h.o_OScreator_Symbol4=0;
            reference_item_h.o_OScreator_Symbol5=0;
            reference_item_h.o_OScreator_Symbol6=0;
            reference_item_h.o_OScreator_Symbol7=0;
            reference_item_h.o_OScreator_Symbol8=0;
            reference_item_h.o_OScreator_Symbol9=0;
            reference_item_h.o_OScreator_Symbol10=0;
            reference_item_h.o_OScreator_Symbol11=0;
            reference_item_h.o_OScreator_Symbol12=0;
            reference_item_h.o_OScreator_Symbol13=0;
            reference_item_h.o_OScreator_Symbol14=0;
            reference_item_h.o_OScreator_Symbol15=0;  
            reference_item_h.o_OScreator_reqNum=11'h7ff; 
            reference_item_h.o_OScreator_resetTScounter=0;
                      
            
            if(reference_item_h.i_OSdecoder_Ack==2'b10&&reference_item_h.i_OScreator_Ack==1)
            begin
            reference_item_h.o_OScreator_resetTScounter=0;
            reference_item_h.o_OScreator_reqNum=16 ;
            nstate=L0;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            end
            else if (reference_item_h.i_timer_timeout==1)
            begin
            nstate=Detect_Quiet;
            reference_item_h.o_LTSSM_stateChange=1;
            reference_item_h.o_timer_start=0;
            reference_item_h.o_OScreator_enable=0;
            end
            else if(reference_item_h.i_OSdecoder_Ack==2'b01 || reference_item_h.i_OSdecoder_Ack==2'b10) 
                begin
                reference_item_h.o_OScreator_resetTScounter=1;
                reference_item_h.o_OScreator_reqNum=16 ;
                end    
        end

        L0:
        begin
        nstate=state;
        reference_item_h.o_OScreator_enable=0;
        reference_item_h.o_OScreator_types=3;
        reference_item_h.o_timer_start=1;
        reference_item_h.o_LTSSM_stateChange=0;
        reference_item_h.o_timer_timeoutValue=23'd100;  
        reference_item_h.o_LTSSM_L0_up=1;
                
        reference_item_h.o_OScreator_Symbol0=0;
        reference_item_h.o_OScreator_Symbol1=0;
        reference_item_h.o_OScreator_Symbol2=0;
        reference_item_h.o_OScreator_Symbol3=0;
        reference_item_h.o_OScreator_Symbol4=0;
        reference_item_h.o_OScreator_Symbol5=0;
        reference_item_h.o_OScreator_Symbol6=0;
        reference_item_h.o_OScreator_Symbol7=0;
        reference_item_h.o_OScreator_Symbol8=0;
        reference_item_h.o_OScreator_Symbol9=0;
        reference_item_h.o_OScreator_Symbol10=0;
        reference_item_h.o_OScreator_Symbol11=0;
        reference_item_h.o_OScreator_Symbol12=0;
        reference_item_h.o_OScreator_Symbol13=0;
        reference_item_h.o_OScreator_Symbol14=0;
        reference_item_h.o_OScreator_Symbol15=0;  
        reference_item_h.o_OScreator_reqNum=0; 
        reference_item_h.o_OScreator_resetTScounter=0;
        
        if(reference_item_h.i_timer_timeout==1)
        begin
        reference_item_h.o_OScreator_enable=1;
        reference_item_h.o_OScreator_types=0;
        reference_item_h.o_OScreator_Symbol0=COM;
        reference_item_h.o_OScreator_Symbol1=SKP;
        reference_item_h.o_OScreator_Symbol2=SKP;
        reference_item_h.o_OScreator_Symbol3=SKP;
        reference_item_h.o_OScreator_reqNum=1;
        reference_item_h.o_timer_start=0;
        end  
        end
 default: begin
        nstate=Detect_Quiet;
        reference_item_h.o_OScreator_enable=0;
        reference_item_h.o_OScreator_types=0;
        reference_item_h.o_timer_start=0;
        reference_item_h.o_LTSSM_stateChange=0;
        reference_item_h.o_timer_timeoutValue=0; 
        reference_item_h.o_LTSSM_L0_up=0;
                 
         
         reference_item_h.o_OScreator_Symbol0=0;
         reference_item_h.o_OScreator_Symbol1=0;
         reference_item_h.o_OScreator_Symbol2=0;
         reference_item_h.o_OScreator_Symbol3=0;
         reference_item_h.o_OScreator_Symbol4=0;
         reference_item_h.o_OScreator_Symbol5=0;
         reference_item_h.o_OScreator_Symbol6=0;
         reference_item_h.o_OScreator_Symbol7=0;
         reference_item_h.o_OScreator_Symbol8=0;
         reference_item_h.o_OScreator_Symbol9=0;
         reference_item_h.o_OScreator_Symbol10=0;
         reference_item_h.o_OScreator_Symbol11=0;
         reference_item_h.o_OScreator_Symbol12=0;
         reference_item_h.o_OScreator_Symbol13=0;
         reference_item_h.o_OScreator_Symbol14=0;
         reference_item_h.o_OScreator_Symbol15=0;  
         reference_item_h.o_OScreator_reqNum=0;
         reference_item_h.o_OScreator_resetTScounter=0;
                     
        end 


        endcase
endfunction