// States
`define Detect_Quiet 5'b00000
`define Detect_Active 5'b00001
`define Polling_Active 5'b00010
`define Polling_configuration 5'b00011
`define Config_Linkwidth_start 5'b00100
`define Config_Linkwidth_Accept 5'b00101
`define Config_Lanenum_wait 5'b00110
`define Config_Lanenum_Accept 5'b00111
`define Config_complete 5'b01000
`define Config_idle 5'b01001
`define L0 5'b01010

    
    function automatic void reference_function(ref PIPE_sequence_item pipe_ref);
        case (pipe_ref.i_LTSSMState)
		`Detect_Quiet: begin
			pipe_ref.o_LTSSM_LaneDetected = 0;
			pipe_ref.o_TxDetectRx_Loopback = 0;
			pipe_ref.o_TxElecIdle = 1;
			pipe_ref.o_TxCompliance = 0;
			pipe_ref.o_RxPolarity = 0;
			pipe_ref.o_PowerDown = 2'b10;
			pipe_ref.o_Rate = 0;
			pipe_ref.o_LTSSM_UpLink = 0;
		end
		`Detect_Active: begin
			if(pipe_ref.i_PhyStatus) begin
				if(pipe_ref.i_RXstatus==3'b000) pipe_ref.o_LTSSM_LaneDetected = 0;
				else if(pipe_ref.i_RXstatus==3'b011) pipe_ref.o_LTSSM_LaneDetected = 1;
			end
			else pipe_ref.o_LTSSM_LaneDetected = 0;
			pipe_ref.o_TxDetectRx_Loopback = 1;
			pipe_ref.o_TxElecIdle = 1;
			pipe_ref.o_TxCompliance = 0;
			pipe_ref.o_RxPolarity = 0;
			pipe_ref.o_PowerDown = 2'b10;
			pipe_ref.o_Rate = 0;
			pipe_ref.o_LTSSM_UpLink = 0;
		end
		default: begin
			pipe_ref.o_LTSSM_LaneDetected = 1;
			pipe_ref.o_TxDetectRx_Loopback = 0;
			pipe_ref.o_TxElecIdle = 0;
			pipe_ref.o_TxCompliance = 0;
			pipe_ref.o_RxPolarity = 0;
			pipe_ref.o_PowerDown = 2'b00;
			pipe_ref.o_Rate = 0;
			pipe_ref.o_LTSSM_UpLink = 0;
		end
        endcase

        pipe_ref.o_LTSSM_RxElecIdle = pipe_ref.i_RxElecIdle;

    endfunction: reference_function