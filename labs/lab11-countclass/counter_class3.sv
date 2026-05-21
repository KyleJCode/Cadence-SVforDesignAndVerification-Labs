// Adds 

module counterclass;
    
    class counter;
        int count; 
        int min;
        int max;

        function new(input int count = 0, input int min, input int max);
            this.count = count;
            this.min = min;
            this.max = max;
            check_limit(min, max);
            check_set(count);
        endfunction

        function void load(input int count);
            this.count = count;
            check_set(count);
        endfunction

        function int getcount(); 
            return count;
        endfunction

        function void check_limit(input int in1, input int in2);
            if(in1 > in2) begin
                max = in1;
                min = in2;
            end
            else if(in2 > in1) begin
                max = in2;
                min = in1;
            end
            else begin // equal case not specified - used this because it seemed appropriate.
                max = in1;
                min = in2;
            end
        endfunction

        function void check_set(input int set);
            if((set > max) || (set < min)) begin
                count = min;
                $warning("Warning: Input argument is not within min-max limits.");
            end
            else
                count = set;
        endfunction
    endclass

    class upcounter extends counter;
        function new(input int count, input int min, input int max);
            super.new(count, min, max);
        endfunction

        function void next();
            if((count+1) > max) 
                count = min;
            else
                count++;
            $display("Current Count: %0d", count);
        endfunction
    endclass

    class downcounter extends counter;
        function new(input int count, input int min, input int max);
            super.new(count, min, max);
        endfunction

        function void next();
            if((count-1) < min) 
                count = max;
            else
                count--;
            $display("Current Count: %0d", count);
        endfunction
    endclass

endmodule
