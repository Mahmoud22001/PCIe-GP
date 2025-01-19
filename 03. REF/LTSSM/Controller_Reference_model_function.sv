function automatic reference_function( ref controller_sequence_item reference_item_h);

static     reg  old_TxBuffer_Empty;
static     reg  old_OS_Empty;
static     reg  old_Pi_Buffer;
static     reg [1:0] old_Mux_Sel;
static     reg [1:0] old_SE_Sel;
static     reg flag, old_flag;


case (reference_item_h.i_reset_n)

 0: begin
if (reference_item_h.L0 == 0 && reference_item_h.OS_Empty == 1 && reference_item_h.TxBuffer_Empty == 1 && reference_item_h.Pi_Buffer == 2'b00)
begin
    	reference_item_h.TxBuffer_rd_en=1'b0;
		reference_item_h.BiBuffer_rd_en=1'b0;			
        reference_item_h.Mux_Sel=2'b10; 
    	reference_item_h.SE_Sel=2'b00;
		reference_item_h.OS_rd_en=1'b0;

        old_TxBuffer_Empty = 1;
        old_Mux_Sel= 0;
        old_SE_Sel=0;
        old_OS_Empty = 1;
        old_flag = 0;
        old_Pi_Buffer = 00;
end
else
begin
    	reference_item_h.TxBuffer_rd_en=1'bx;
		reference_item_h.BiBuffer_rd_en=1'bx;			
        reference_item_h.Mux_Sel=2'bxx; 
    	reference_item_h.SE_Sel=2'bxx;
		reference_item_h.OS_rd_en=1'bx;

        old_TxBuffer_Empty = 1;
        old_Mux_Sel= 0;
        old_SE_Sel=0;
        old_OS_Empty = 1;
        old_flag = 0;
        old_Pi_Buffer = 00;
end

end
1: begin
            
        old_TxBuffer_Empty <= reference_item_h.TxBuffer_Empty;
        old_Mux_Sel<=reference_item_h.Mux_Sel;
        old_SE_Sel<=reference_item_h.SE_Sel;
        old_OS_Empty <= reference_item_h.OS_Empty;
        old_flag <= flag;
        old_Pi_Buffer <= reference_item_h.Pi_Buffer;
        case (reference_item_h.L0)
            0:
                begin
                    case (reference_item_h.OS_Empty)
                        0: 
                            begin 
                                if (reference_item_h.TxBuffer_Empty==1'b0)
                                    begin
                                        if (reference_item_h.Pi_Buffer ==2'b11 )
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b1;
											reference_item_h.BiBuffer_rd_en=1'b1;
											reference_item_h.Mux_Sel=2'b00; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b0;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                    end
                            
                               else if (reference_item_h.TxBuffer_Empty==1'b1)
                                    begin
                                        if (old_TxBuffer_Empty == 1'b0 && reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b01; 
											reference_item_h.SE_Sel=2'b10;
											reference_item_h.OS_rd_en=1'b0;
                                            end
                                        else if (old_TxBuffer_Empty == 1'b1 && reference_item_h.Pi_Buffer ==2'b11) 
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b11; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b1;   
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                    end
                                else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                            end 
                            
                        1:
                            begin 
                                if (reference_item_h.Pi_Buffer==1'b11)
                                    begin
                                
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b00; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b0;
                                    end
                               else  // won't happen
                                     begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                      end
                                    
                            end 
                    endcase 
                end
            1:
                begin
                    case (reference_item_h.OS_Empty)
                        0: 
                            begin 
                                if (reference_item_h.TxBuffer_Empty==1'b0 && old_TxBuffer_Empty ==1'b0 && old_OS_Empty ==1'b1)
                                    begin
                                        if (reference_item_h.Pi_Buffer ==2'b11 )
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b1;
											reference_item_h.BiBuffer_rd_en=1'b1;
											reference_item_h.Mux_Sel=2'b00; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b0;
                                            flag = 1;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            flag = 0;
                                            end
                                    end
                            
                               else if (reference_item_h.TxBuffer_Empty==1'b0 && flag ==1'b1)
                                    begin
                                        if ( reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b1;
											reference_item_h.BiBuffer_rd_en=1'b1;
											reference_item_h.Mux_Sel=2'b00; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b0;
                                            flag = 1;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                    end

                               else if (reference_item_h.TxBuffer_Empty==1'b1 && flag ==1'b1)
                                    begin
                                        if ( reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b01; 
											reference_item_h.SE_Sel=2'b10;
											reference_item_h.OS_rd_en=1'b0;
                                            flag = 0;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                    end
                                else if ( reference_item_h.OS_Empty ==1'b0)
                                    begin
                                        if ( reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b11; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b1;
                                            flag = 0;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                    end


                                else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                            end 
                            
                        1:
                            begin 
                                if (reference_item_h.TxBuffer_Empty==1'b0)
                                    begin
                                        if ((reference_item_h.Pi_Buffer ==2'b01 ||  reference_item_h.Pi_Buffer ==2'b10 )&& old_Pi_Buffer==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b01; 
											reference_item_h.SE_Sel=2'b10;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                        else if (reference_item_h.Pi_Buffer ==2'b01 ||  reference_item_h.Pi_Buffer ==2'b10 )
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b1;
											reference_item_h.BiBuffer_rd_en=1'b1;
											reference_item_h.Mux_Sel=2'b01; 
											reference_item_h.SE_Sel=2'b01;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                        
                                        else if (reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b1;
											reference_item_h.BiBuffer_rd_en=1'b1;
											reference_item_h.Mux_Sel=2'b00; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                    end
                               else if (reference_item_h.TxBuffer_Empty==1'b1 && old_TxBuffer_Empty == 1'b0)
                                    begin
                                        if (reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b01; 
											reference_item_h.SE_Sel=2'b10;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                            

                                    end
                               else if (reference_item_h.TxBuffer_Empty==1'b1)
                                    begin


                                         if (reference_item_h.Pi_Buffer ==2'b11)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b10; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                                         else if (reference_item_h.Pi_Buffer ==2'b00)
                                            begin
                                    		reference_item_h.TxBuffer_rd_en=1'b0;
											reference_item_h.BiBuffer_rd_en=1'b0;
											reference_item_h.Mux_Sel=2'b10; 
											reference_item_h.SE_Sel=2'b00;
											reference_item_h.OS_rd_en=1'b0;
                                            end
                                        else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end

                                    end


                                else  // won't happen
                                            begin
                                        	reference_item_h.TxBuffer_rd_en=1'bx;
											reference_item_h.BiBuffer_rd_en=1'bx;
											reference_item_h.Mux_Sel=2'bxx; 
											reference_item_h.SE_Sel=2'bxx;
											reference_item_h.OS_rd_en=1'bx;
                                            end
                            end 
                    endcase 
                end
        endcase
end

      endcase

endfunction




