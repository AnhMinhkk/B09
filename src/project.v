`default_nettype none

module tt_um_onehot_binary_b09 (
    input  wire [7:0] ui_in,    // Dedicated inputs: One-hot input
    output wire [7:0] uo_out,   // Dedicated outputs: Result & valid flag
    input  wire [7:0] uio_in,   // IOs Input: [2:0] Binary, [3] Direction select
    output wire [7:0] uio_out,  // IOs Output (not used)
    output wire [7:0] uio_oe,   // IOs Enable: 0 for input mode
    input  wire       ena,      // Enable signal
    input  wire       clk,      // Clock (unused for combinational circuit)
    input  wire       rst_n     // Reset (unused for combinational circuit)
);

    // Khử cảnh báo tín hiệu không sử dụng trong mạch tổ hợp
    wire _unused = &{clk, rst_n, ena, uio_in[7:4]};

    // Đặt uio về chế độ Input
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    wire mode = uio_in[3];             // 0: One-Hot -> Binary, 1: Binary -> One-Hot
    wire [2:0] bin_in = uio_in[2:0];   // Đầu vào nhị phân 3-bit

    // Mạch kiểm tra 'đúng một bit bật' (Valid Flag)
    wire is_valid_onehot = (ui_in != 8'h00) && ((ui_in & (ui_in - 8'h01)) == 8'h00);

    // Chuyển từ One-Hot sang Nhị phân (Encoder)
    reg [2:0] bin_out;
    always @(*) begin
        case (ui_in)
            8'b00000001: bin_out = 3'd0;
            8'b00000010: bin_out = 3'd1;
            8'b00000100: bin_out = 3'd2;
            8'b00001000: bin_out = 3'd3;
            8'b00010000: bin_out = 3'd4;
            8'b00100000: bin_out = 3'd5;
            8'b01000000: bin_out = 3'd6;
            8'b10000000: bin_out = 3'd7;
            default:     bin_out = 3'd0;
        endcase
    end

    // Chuyển từ Nhị phân sang One-Hot (Decoder)
    reg [7:0] onehot_out;
    always @(*) begin
        onehot_out = 8'b00000001 << bin_in;
    end

    // Ánh xạ cổng ra uo_out
    assign uo_out = (mode == 1'b0) ? {is_valid_onehot, 4'b0000, bin_out} : onehot_out;

endmodule
