import socket
import time

# Create a socket object
s = socket.socket()
port = 8080
s.connect(('localhost', port))

while True:
  # The maximum amount of data to be received at once is specified by bufsize
  data = s.recv(4096)
  print('Client receive: ' + data.decode())
  st = 'Hello from client'
  byt = st.encode('ascii')
  time.sleep(5)
  s.close()
  break