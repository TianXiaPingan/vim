#! /usr/bin/env python

from algorithm import *
import subprocess

debug = False

def write_file_tag(fn, tags):
  # writes the list of tags to three xattr fields on a file-by file basis:
  # kMDItemFinderComment, _kMDItemUserTags, kMDItemOMUserTags.
  # Uses subprocess instead of xattr module. Slower but no dependencies.
  # To check if it worked, use xattr -l FileName 

  plistFront = '''
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" \
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <array>'''
  plistEnd = '''</array></plist>'''

  plistTagString = " ".join(["<string> %s </string>" %tag for tag in tags])
  tag_text = (plistFront + plistTagString + plistEnd).encode("utf8")

  opt_tag = "com.apple.metadata:"
  XattrList = ["kMDItemFinderComment", "_kMDItemUserTags", "kMDItemOMUserTags"]

  result = ""
  for field in XattrList:  
    xattr_cmd = '''xattr -w %s '%s' "%s"''' %(opt_tag + field, tag_text, fn)
    if debug:
      print xattr_cmd
    r = subprocess.check_output(xattr_cmd, stderr = subprocess.STDOUT, 
                                shell = True) 
    result += r
  return result

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons] 'tag1 tag2 ...'" 
                                 "file1 file2 ...")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose",
                     #default = False, help = "")
  (options, args) = parser.parse_args()
  if len(args) >= 2:
    tags = args[0].split() 
    for f in args[1:]: 
      write_file_tag(f, tags)
      print "%s is done" %f     
