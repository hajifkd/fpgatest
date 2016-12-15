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

  for (i = 0; i < width * height; i = i + 1) begin
    b = {8'h00, data[3 * i + offset]};
    g = {8'h00, data[3 * i + offset + 1]};
    r = {8'h00, data[3 * i + offset + 2]};
    val = (77 * r + 150 * g + 29 * b) >> 8;
    data[3 * i + offset] = val;
    data[3 * i + offset + 1] = val;
    data[3 * i + offset + 2] = val;
  end

  for (i = 0; i < index; i = i + 1) begin
    ret = $fputc(data[i], `STDOUT);
  end
end

endmodule
