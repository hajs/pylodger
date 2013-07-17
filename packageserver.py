#!/usr/bin/env python
"""
Very simple single-process/single-threaded/non-async web server to provide packages
"""
import sys
import os
import socket
import argparse
from SimpleHTTPServer import SimpleHTTPRequestHandler
from BaseHTTPServer import HTTPServer

__version__ = "0.1"


def condarc(port):
	template = """
  channels:
	- %(url)s

"""
	host = socket.gethostname()
	url = "http://%s" % host
	if port != 80:
		url = "%s:%s" % (url, port)
	print "Please create a conda configuration file called $HOME/.condarc with the following contents (yaml format)"
	print template % vars()


def serve(port):
	server_address = ('', port)
	httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
	sa = httpd.socket.getsockname()
	condarc(port)
	print "Serving HTTP on", sa[0], "port", sa[1], "from", os.getcwd(), "..."
	httpd.serve_forever()


def main():
	parser = argparse.ArgumentParser(description=__doc__, version=__version__)
	default_doc_root = os.path.join(sys.prefix, "conda-bld")
	parser.add_argument("--port", "-p", type=int, default=8000,
	                    help="default port for listening is %(default)s")
	parser.add_argument("--root", "-r", default=default_doc_root,
	                    help="default document root is %(default)r")
	args = parser.parse_args()
	os.chdir(args.root)
	serve(args.port)


if __name__ == "__main__":
	sys.exit(main() or 0)