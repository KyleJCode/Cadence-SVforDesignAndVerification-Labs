// Adds an aggregate class '

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
        static int inst_cnt = 0;
        bit carry;

        function new(input int count, input int min, input int max);
            super.new(count, min, max);
            carry = 0;
            inst_cnt++;
        endfunction

        function void next();
            if((count+1) > max) begin
                count = min;
                carry = 1;
            end
            else begin
                count++;
                carry = 0;
            end
            $display("Current Count: %0d", count);
        endfunction

        static function int get_inst_count();
            return inst_cnt;
        endfunction

    endclass

    class downcounter extends counter;
        static int inst_cnt = 0;
        bit borrow;

        function new(input int count, input int min, input int max);
            super.new(count, min, max);
            borrow = 0;
            inst_cnt++;
        endfunction

        function void next();
            if((count-1) < min) begin
                count = max;
                borrow = 1;
            end
            else begin
                count--;
                borrow = 0;
            end
            $display("Current Count: %0d", count);
        endfunction

        static function int get_inst_count();
            return inst_cnt;
        endfunction
    endclass

    class timer;
        upcounter hours, minutes, seconds;

        function new(input int hours = 0, int minutes = 0, int seconds = 0);
            this.hours = new(hours, 0, 23);
            this.minutes = new(minutes, 0, 59);
            this.seconds = new(seconds, 0, 59);
        endfunction

        function void load(input int hours, int minutes, int seconds);
            this.hours.load(hours);
            this.minutes.load(minutes);
            this.seconds.load(seconds);
        endfunction

        function void showval();
            $display("Current Counter Time: %0d:%0d:%0d", hours.getcount(), minutes.getcount(), seconds.getcount());
        endfunction

        function void next();
            seconds.next();
            if(seconds.carry) begin
                minutes.next();
                if(minutes.carry) 
                    hours.next();
            end
            showval();
        endfunction
        
    endclass

endmodule
