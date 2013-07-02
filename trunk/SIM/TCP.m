import java.net.*;
import java.io.*;
 
 %% Create Socket
 port = 20;
    %input('Enter port number: ');
 Server = ServerSocket (port);
 disp('Waiting for a connection...')
 connected = Server.accept;
 
 iStream = connected.getInputStream;
 oStream = connected.getOutputStream;
 
 % Greets the client
 oStream.sendS('Welcome client!')
 
 % Waiting for messages from client
 while ~(iStream.available)
 end
 readS(iStream);
 
 %% Communication
 msg = '';
 while isempty(strfind(msg,'!q'))
  % Waits for messages from client
  while ~(iStream.available)
  end
  msg = readS(iStream);
 
  if isempty(strfind(msg,'!q'))
   % Sends message to client
   disp 'Server''s turn!'
   %cmd = input('Toclient>> ', 's');
      cmd = 'hey im feeling okey!'
   oStream.sendS(cmd);
 
  else
   oStream.sendS('!q');
  end
 end
 
 pause(1)
 connected.close;
disp (['Connection ended: ' datestr(now)]);