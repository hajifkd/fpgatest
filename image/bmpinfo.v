`define STDIN (32'h8000_0000)
`define STDOUT (32'h8000_0001)
`define EOF (32'hFFFF_FFFF)

module bmpinfo;

reg [31:0] ret, index;
reg [7:0] data[2**20 - 1:0];

initial begin
  index = 0;
  ret = $fgetc(`STDIN);
  while (ret != `EOF) begin
    data[index] = ret[7:0];
    index = index + 1;
    ret = $fgetc(`STDIN);
  end

  $write("bftype:           %c%c\n", data[0], data[1]);
  $write("bfsize:           %10d\n", {data[5], data[4], data[3], data[2]});
end

endmodule
