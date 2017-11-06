classdef Buffer < handle
        
    properties
                

    end
    
    properties (Access = private)
                
        dSize
        dPushes = 0;
        dValues
       
    end
    
    events
        
    end
    
       
    methods (Static)
        
    end
    
    methods
        
        
        function this = Buffer(dSize)
            
            this.dSize      = dSize;
            this.dValues    = zeros(1, this.dSize);
            
        end
        
        % Pushes a new value to the front of the buffer spilling the
        % last value out of the end of the buffer
        function push(this, dVal)
            
           % circshift sucks 
           % this.dValues     = circshift(this.dValues', 1)';
           
           this.dValues     = [dVal, this.dValues(1:end-1)];           
           this.dPushes     = this.dPushes + 1;
                   
        end
        
        % Returns the average value of the buffer as
        % @return {double 1x1}
        function d = getAvg(this)
            d = mean(this.dValues);
        end
        
        % Returns the buffer array {double 1xm}
        % @return {double 1xm}
        function d = get(this)
            d = this.dValues;
        end
        
        % Returns {logical} true if the buffer is full, false otherwise
        % @return {logical 1x1} 
        function l = getIsFull(this)
            
            l = this.dPushes >= this.dSize;
            
        end
        
        % Fills the buffer with zeros and resets dPushes
        function purge(this)
           
            this.dPushes = 0;
            this.dValues = zeros(1, this.dSize);
            
        end
        
                
    end
end
    
    
    