`include "math.sv"
module dpi;

import "DPI" function int system ( input string s );
import "DPI" function string getenv ( input string name );
import "DPI" function real sin ( input real arg );

string syscmd;
real s, v;
int ok;

initial begin
  ok = system("echo 'hello world'");
  $display("date");
  ok = system("date");

  $display("UNIX PATH = %s", getenv( "PATH" ) );

  for (int i =0; i<8; i++) begin
  s = `M_PI_4 * i;
  v =  sin(s);
  $display("sin(%f) = %f", s, v);
  end
end

endmodule
