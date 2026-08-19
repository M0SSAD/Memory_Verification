package mem_pkg;
    localparam int DATA_WIDTH = 32;
    localparam int ADDRESS_WIDTH = 4;
    localparam DW = DATA_WIDTH - 1;
    localparam AW = ADDRESS_WIDTH - 1;
    localparam DEPTH = 1 << ADDRESS_WIDTH;
endpackage