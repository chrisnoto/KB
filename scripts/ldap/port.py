#!/usr/bin/env python3
import http.server
import socketserver
import threading
import socket



class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        client_ip = self.client_address[0]
        server_port = self.server.server_address[1]
        with open('/root/port.log','a') as f:
            f.write(f"Client IP: {client_ip}, Server Port: {server_port}, Message: {format % args}\n")

def serve_on_port(port):
    handler = CustomHandler
    httpd = socketserver.TCPServer(("", port), handler)
    httpd.allow_reuse_address = True
    httpd.serve_forever()

ports = [389, 636]  # 这里自定义需要监听的端口
for port in ports:
    threading.Thread(target=serve_on_port, args=[port]).start()
