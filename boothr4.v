module boothr4(
  input clk_i,
  input rst_i,
  input [7:0]inbus_i,
  input begin_i,
  output reg end_o,
  output reg [7:0]outbus_o
);

reg [3:0]state_reg, state_nxt;
reg [8:0] a_reg,a_nxt;
reg [7:0] m_reg,m_nxt;
reg [7:0] q_reg,q_nxt;
reg qminus_reg,qminus_nxt;
reg [7:0] outbus_reg,outbus_nxt;
reg end_reg,end_nxt;
reg [1:0] count_reg,count_nxt;

always@(posedge clk_i,negedge rst_i)
 begin
    if(!rst_i)
     begin
       q_reg<=8'd0;
       qminus_reg<=1'd0;
       a_reg<=9'd0;
       m_reg<=8'd0;
       count_reg<=2'd0;
       outbus_reg<=16'd0;
       end_reg<=1'b0;
       state_reg<=4'd0;
     end
    else
     begin
       q_reg<=q_nxt;
       qminus_reg<=qminus_nxt;
       a_reg<=a_nxt;
       m_reg<=m_nxt;
       count_reg<=count_nxt;
       outbus_reg<=outbus_nxt;
       end_reg<=end_nxt;
       state_reg<=state_nxt;
    end
 end

always@(*)
 begin
    case(state_reg)
      4'd0: begin
              if(begin_i==1'd1)
               begin
                 q_nxt[7:0]=inbus_i;
                 a_nxt<=9'd0;
                 qminus_nxt=1'd0;
                 count_nxt=2'd0;
                 state_nxt=4'd1;
              end
            else
              state_nxt=4'd0; 
          end
     4'd1: begin
              m_nxt=inbus_i;
              state_nxt=4'd2;
         end
     4'd2: begin
              case({q_reg[1:0],qminus_reg})
                3'b001: a_nxt=a_reg+{m_reg[7],m_reg};
                3'b010: a_nxt=a_reg+{m_reg[7],m_reg};
                3'b101: a_nxt=a_reg-{m_reg[7],m_reg};
                3'b110: a_nxt=a_reg-{m_reg[7],m_reg};
                3'b011: a_nxt=a_reg+({m_reg[7],m_reg}<<1);
                3'b100: a_nxt=a_reg-({m_reg[7],m_reg}<<1);
            endcase
              state_nxt=4'd3;
          end
     4'd3: begin
              {a_nxt[6:0],q_nxt[7:0],qminus_nxt}={a_nxt,q_nxt[7:1]};
              a_nxt[7]=a_reg[8];
              a_nxt[8]=a_reg[8];
              state_nxt=4'd4;
         end
     4'd4: begin
              if(!(count_nxt[1]&&count_nxt[0]))
                begin
                  count_nxt=count_reg+1;
                  state_nxt=4'd2;
                end
              else
                state_nxt=4'd5;
         end
     4'd5: begin
             //outbus_nxt=a_reg;
             outbus_o<=a_reg[7:0];
             state_nxt=4'd6;
        end
     4'd6: begin
             // outbus_nxt=q_reg;
              outbus_o<=q_reg;
              end_nxt=1'd1;
              //state_nxt=4'd0;
           end
  endcase
 end
                                
endmodule       