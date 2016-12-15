`define STDIN (32'h8000_0000)
`define STDOUT (32'h8000_0001)
`define EOF (32'hFFFF_FFFF)

module grayfor;

reg [31:0] ret, index;
reg [7:0] data[2**20 - 1:0];

reg [31:0] offset, width, height;
reg [31:0] i = 0;
reg [16:0] r, g, b;
reg [16:0] val;

reg clk = 1'b0;
reg done = 1'b0;

reg [1:0] state = 2'b00;

always @(posedge clk) begin
  if (i < width * height) begin
    if (state == 0) begin
      b <= {8'h00, data[3 * i + offset]};
      g <= {8'h00, data[3 * i + offset + 1]};
      r <= {8'h00, data[3 * i + offset + 2]};
      state <= 1;
    end else if (state == 1) begin
      val <= (77 * r + 150 * g + 29 * b) >> 8;
      state <= 2;
    end else begin
      data[3 * i + offset] <= val;
      data[3 * i + offset + 1] <= val;
      data[3 * i + offset + 2] <= val;
      i <= i + 1;
      state <= 0;
    end
  end else begin
    done = 1;
  end
end

initial begin
  index = 0;
  ret = $fgetc(`STDIN);
  while (ret != `EOF) begin
    data[index] = ret[7:0];
    index = index + 1;
    ret = $fgetc(`STDIN);
  end

  offset = {data[13], data[12], data[11], data[10]};
  width = {data[21], data[20], data[19], data[18]};
  height = {data[25], data[24], data[23], data[22]};

  while (!done) begin
    clk = 0; #10;
    clk = 1; #10;
  end

  for (i = 0; i < index; i = i + 1) begin
    ret = $fputc(data[i], `STDOUT);
  end

  $finish(0);

end

endmodule
