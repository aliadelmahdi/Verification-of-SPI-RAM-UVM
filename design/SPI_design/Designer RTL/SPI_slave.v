module SPI_slave(clk,rst_n,SS_n,MOSI,MISO,tx_valid,tx_data,rx_data,rx_valid);

  input clk,rst_n,SS_n,MOSI;
  input wire tx_valid;
  input wire[7:0]tx_data;
  output reg rx_valid;
  output reg MISO;
  output reg [9:0]rx_data;
  reg done_receiving;

  parameter IDLE=3'b000;
  parameter CHK_CMD=3'b001;
  parameter READ_ADD=3'b010;
  parameter READ_DATA=3'b011;
  parameter WRITE=3'b100;


  reg [3:0]counter;
  reg read_address_received;

  (* fsm_encoding = "gray" *)
  reg[2:0]cs,ns;

  // RAM_SPI m1(rx_data,rx_valid,clk,rst_n,tx_valid,tx_data);

  //State Memory
  always@(posedge clk)begin
    if(!rst_n)begin
      cs<=IDLE;
    end
    else
      cs<=ns;
  end

  //output logic
  always@(posedge clk)begin
    case(cs)
      IDLE:begin
          rx_valid<=0;
          counter<=0;
          done_receiving<=0;         
          MISO<=0;
          rx_data<=0;
          end
      CHK_CMD:begin 
              MISO<=0;
              rx_valid<=0;
              end
      READ_ADD:begin 
              rx_data[9-counter]<=MOSI;
              counter<=counter+1;
              MISO<=0;
              if(counter==10)begin
              rx_valid<=1;
              counter<=0;
              read_address_received<=1;
              end
              end
      READ_DATA:if(done_receiving==0)begin
                rx_data[9-counter]<=MOSI;
                counter<=counter+1;
                MISO<=0;
                if(counter==10)begin
                  counter<=0;
                  done_receiving<=1;
                end
                end
                else begin
                  MISO<=tx_data[7-counter];
                  counter<=counter+1;
                  if(counter==7)begin
                    counter<=0;
                    done_receiving<=0;
                    read_address_received<=0;
                  end
                end
      WRITE:begin
                rx_data[9-counter]<=MOSI;
                counter<=counter+1;
                MISO<=0;
                read_address_received<=0; 
                if(counter==10)begin
                  rx_valid<=1;
                  counter<=0;
                end
                end
      endcase
  end

  //Next State Logic
  always@(cs,MOSI,SS_n)begin
    case(cs)
      IDLE:if(SS_n==1)
          ns=IDLE;
          else if(!SS_n) // Fixed this line for the designer #verfication team
          ns=CHK_CMD;
          else// Fixed this line for the designer #verfication team
          ns=IDLE;// Fixed this line for the designer #verfication team

      CHK_CMD:if((SS_n==0 && MOSI==1)&&(read_address_received==0))begin
              ns=READ_ADD;
              //read_address_received=1;
              end
              else if((SS_n==0 && MOSI==1)&&(read_address_received==1))begin
              ns=READ_DATA;
              //read_address_received=0;
              end
              else if(SS_n==0 && MOSI==0)
              ns=WRITE;
              else 
              ns=IDLE;
      READ_ADD:if(SS_n==0 && counter<10)
                ns=READ_ADD;
                else begin
                ns=IDLE;
                //counter=0;
                end
      READ_DATA:if(SS_n==0 && read_address_received==1)
                ns=READ_DATA; 
                else begin
                ns=IDLE;
                //counter=0;
                end
      WRITE:if(SS_n==0 && counter<10)
                ns=WRITE; 
                else begin
                ns=IDLE;
                 //counter=0;
                end         
      endcase
  end
endmodule