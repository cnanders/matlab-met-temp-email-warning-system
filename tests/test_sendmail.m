
cEmail = 'metmatlab@gmail.com';

setpref('Internet','E_mail', cEmail);
setpref('Internet','SMTP_Server', 'smtp.gmail.com');
setpref('Internet','SMTP_Username', 'metmatlab');
setpref('Internet','SMTP_Password', 'ilbl1201!');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth', 'true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port', '465');
props.setProperty('mail.smtp.starttls.enable', 'true');

% Send the email.  Note that the first input is the address you are sending the email to

sendmail(...
    'cnanders@gmail.com', ...
    'Test From MATLAB!', ...
    'Thanks for using sendmail.' ...
);