module counterclass;
    
class counter;
int count; 

function new(input int count = 0);
    this.count = count;
endfunction

function void load(input int count);
    this.count = count;
endfunction

function int getcount(); 
    return count;
endfunction
endclass

class upcounter extends counter;
function new(input int count);
    super.new(count);
endfunction

function void next();
    count++;
    $display("Current Count: %0d", count);
endfunction
endclass

class downcounter extends counter;
function new(input int count);
    super.new(count);
endfunction

function void next();
    count--;
    $display("Current Count: %0d", count);
endfunction
endclass

endmodule
