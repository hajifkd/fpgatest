`define STDIN   (32'h8000_0000)
`define STDOUT  (32'h8000_0001)
`define EOF     (32'hFFFF_FFFF)


module cat;
  reg [31:0] ret;

  initial begin
    ret = $fgetc(`STDIN);

    while (ret != `EOF) begin
      ret = $fputc(ret[7:0], `STDOUT);
      ret = $fgetc(`STDIN);
    end
  end

endmodule
