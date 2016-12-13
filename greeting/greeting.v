`define STDIN   (32'h80000000)
`define MAX_LEN (16)

module greeting;

  reg ret;
  reg [`MAX_LEN*8 - 1 : 0] name;

  initial begin
    $write("your name? ");
    ret = $fgets(name, `STDIN);
    $write("Hello, %0s", name);
  end

endmodule
