`timescale 1ns/1ps

module tb;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg        ena, clk, rst_n;

    // Gọi module RTL cần kiểm thử
    tt_um_onehot_binary_b09 dut (
        .ui_in(ui_in), .uo_out(uo_out),
        .uio_in(uio_in), .uio_out(uio_out), .uio_oe(uio_oe),
        .ena(ena), .clk(clk), .rst_n(rst_n)
    );

    initial begin
        // Tạo file dữ liệu sóng để GTKWave đọc
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb);

        ena = 1; clk = 0; rst_n = 1;
        ui_in = 8'b0; uio_in = 8'b0;
        #10;

        // --- Mode 0: One-Hot -> Binary (uio_in[3] = 0) ---
        uio_in[3] = 1'b0;
        ui_in = 8'b00000001; #10;
        ui_in = 8'b00000010; #10;
        ui_in = 8'b00000100; #10;
        ui_in = 8'b00001000; #10;
        ui_in = 8'b00010000; #10;
        ui_in = 8'b00100000; #10;
        ui_in = 8'b01000000; #10;
        ui_in = 8'b10000000; #10;

        // Mã không hợp lệ: Toàn 0 & Multi-hot
        ui_in = 8'b00000000; #10;
        ui_in = 8'b00000011; #10;
        ui_in = 8'b10000001; #10; // Ca biên tự bổ sung

        // --- Mode 1: Binary -> One-Hot (uio_in[3] = 1) ---
        uio_in[3] = 1'b1;
        uio_in[2:0] = 3'd0; #10;
        uio_in[2:0] = 3'd3; #10;
        uio_in[2:0] = 3'd7; #10;

        $finish;
    end
endmodule
