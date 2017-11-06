classdef App < handle
    
    properties
    end
    
    properties (Access = private)
    
        % {omega.UTCUSB 1x1}
        utcusb
        
        % {timer 1x1}
        timer
        
        % {double 1x1} timer period (s)
        
        % dPeriod = 5
        % dSizeBuffer = 2
                
        dPeriod = 60; 
        dSizeBuffer = 20;
        
        dTempMaxC = 18.5;
        dTempMinC = 15;
        dTempNowC = 0;
        
        % {Buffer 1x1}
        buffer
        
    end
    
    
    methods
        
        function this = App()
            
            this.utcusb = omega.UTCUSB(...
                'cPort', 'COM4' ...
            );

            this.utcusb.init();
            this.utcusb.connect();
            this.configureSendmail();
            
            this.buffer = Buffer(this.dSizeBuffer);
            
            % Create timer
            this.timer = timer( ...
                'TimerFcn', @this.onTimer, ...
                'Period', this.dPeriod, ...
                'ExecutionMode', 'fixedRate', ...
                'Name', 'MET Temperature Email Warning System' ...
            );
            start(this.timer);
            
            
            
        end
        
        function onTimer(this, src, evt)
            
            try
                % fprintf('tasks executed = %1.0f\n', src.TasksExecuted);
                
                % Temperature in Celcius
                this.dTempNowC = this.utcusb.getTemperatureC();
                this.buffer.push(this.dTempNowC);

                if mod(this.timer.TasksExecuted, this.dSizeBuffer) == 0
                    if (this.buffer.getAvg() >= this.dTempMaxC || ...
                        this.buffer.getAvg() <= this.dTempMinC)
                        this.email();
                    else 
                        fprintf(...
                            'MET room temp OK.  %1.1f C. %s.  (room temp is avg of %1.0f readings over last %1.1f min)\n', ...
                            this.buffer.getAvg(), ...
                            datestr(now), ...
                            this.dSizeBuffer, ...
                            this.dSizeBuffer * this.dPeriod / 60 ...
                        );
                    end
                    
                    
                end
                
                if this.timer.TasksExecuted == 1
                    this.sendAliveEmail();
                else
                    this.sendAliveEmailIfCorrectTime();
                end
                                
            catch ME
                rethrow(ME)
            end
            
        end
        
        function sendAliveEmailIfCorrectTime(this)
           
            
            c = clock; % [year month day hour minute seconds]
            hourNow = c(4);
            minNow = c(5);
            
            hourEmail = 9;
            minEmail = 0;
            
            if (hourNow == hourEmail && ...
                minNow == minEmail)
                this.sendAliveEmail();
            end
            
        end
        
        function configureSendmail(this)
            
            % https://www.mathworks.com/matlabcentral/answers/93383-how-do-i-use-sendmail-to-send-email-from-matlab-7-2-r2006a-via-the-gmail-server-or-yahoo-server
            
            setpref('Internet','E_mail', 'metmatlab@gmail.com');
            setpref('Internet','SMTP_Server', 'smtp.gmail.com');
            setpref('Internet','SMTP_Username', 'metmatlab');
            setpref('Internet','SMTP_Password', 'ilbl1201!');
            props = java.lang.System.getProperties;
            props.setProperty('mail.smtp.auth', 'true');
            props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
            props.setProperty('mail.smtp.socketFactory.port', '465');
            props.setProperty('mail.smtp.starttls.enable', 'true');
            
        end
        
        function sendAliveEmail(this)
            
            cRecipients = {'cnanderson@lbl.gov', 'pnaulleau@lbl.gov', 'msjones@lbl.gov', 'wholcomb@lbl.gov'};
            cTitle = sprintf(...
                'MET Room Temp Alert System is Alive (%1.1f C)', ...
                this.dTempNowC ...
            );
        
            cBody = [...
                sprintf(...
                    'room temp = %1.1f C.  allowed range = %1.1f C to %1.1f C', ...
                    this.buffer.getAvg(), ...
                    this.dTempMinC, ...
                    this.dTempMaxC ...
                ), ...
                sprintf( ...
                    ' (room temp is avg of %1.0f readings over last %1.1f min)\n', ...
                    this.dSizeBuffer, ...
                    this.dSizeBuffer * this.dPeriod / 60 ...
                ) ...
            ];
        
            sendmail(cRecipients, cTitle, cBody);
            
            fprintf('sending alive email\n'); 
        end
        
        function email(this)
            
            
            cRecipients = {'cnanderson@lbl.gov', 'pnaulleau@lbl.gov', 'msjones@lbl.gov', 'wholcomb@lbl.gov'};
            cTitle = sprintf(...
                'MET Room Temp Out of Range (%1.1f C)', ...
                this.dTempNowC ...
            );
        
            cBody = [...
                sprintf(...
                    'room temp = %1.1f C.  allowed range = %1.1f C to %1.1f C', ...
                    this.buffer.getAvg(), ...
                    this.dTempMinC, ...
                    this.dTempMaxC ...
                ), ...
                sprintf( ...
                    ' (room temp is avg of %1.0f readings over last %1.1f min)\n', ...
                    this.dSizeBuffer, ...
                    this.dSizeBuffer * this.dPeriod / 60 ...
                ) ...
            ];
        
            sendmail(cRecipients, cTitle, cBody);
            
            fprintf('sending email. %s\n', cTitle); 
        end
      
        
        function delete(this)
            try
                if isvalid(this.timer)
                    if strcmp(this.timer.Running, 'on')
                        stop(this.timer)
                    end
                end
            catch ME
               rethrow(ME) 
            end
            delete(this.utcusb);
        end
        
        
    end
    
end

