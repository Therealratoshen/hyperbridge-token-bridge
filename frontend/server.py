#!/usr/bin/env python3
"""
Simple HTTP server to serve the Hyperbridge Token Bridge frontend
"""
import http.server
import socketserver
import os

class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'X-Requested-With')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

if __name__ == '__main__':
    # Change to frontend directory
    os.chdir('frontend')

    PORT = 8000
    with socketserver.TCPServer(("", PORT), CORSRequestHandler) as httpd:
        print(f"Serving Hyperbridge Token Bridge frontend at http://localhost:{PORT}")
        print("Open this URL in your browser to use the bridge interface")
        httpd.serve_forever()