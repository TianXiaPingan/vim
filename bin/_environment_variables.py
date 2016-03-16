#!/usr/bin/env python

import sys
if "/nfs/18/wsu0215/include" not in sys.path:
    sys.path.append("/nfs/18/wsu0215/include")
from algorithm import *
import os

if __name__ == "__main__":
    parser = OptionParser(usage = "cmd [optons] ..]")
    #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", default = False, help = "don't print status messages to stdout")
    (options, args) = parser.parse_args()

    keys = ["PATH", "CPLUS_INCLUDE_PATH", "LIBRARY_PATH", "LD_LIBRARY_PATH"]
    for key in keys:
        values = os.environ.get(key, None)
        if values is None:
            print "No %s in the environment" %key
            continue
        print "*" * 32, key, "*" * 32
        for vi, v in enumerate(values.split(":")):
            print vi, v
        print

