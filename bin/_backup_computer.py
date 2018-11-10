#!/usr/bin/env python3

from algorithm_3x import *

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons]")
  parser.add_option("--driver", default="gdrive",
                    help="['*gdrive', 'warehouse']")
  parser.add_option("-d", action = "store_true", dest="delete")
  parser.add_option("--no_debug", action = "store_true", dest="no_debug")
  parser.add_option("--action", default="backup", help="['backup', 'restore']")
  (options, args) = parser.parse_args()

  assert options.driver in ["gdrive", "warehouse"]
  assert options.action in ["backup", "restore"]

  src_path = os.path.expanduser("~/inf")
  assert os.path.isdir(src_path)
  os.chdir(src_path)
  src_path = "."

  if options.driver == "gdrive":
    target_path = "/Volumes/gdrive/inf"
  elif options.driver == "warehouse":
    target_path = "/Volumes/warehouse/inf"
  assert os.path.isdir(target_path)

  if options.action == "restore":
    src_path, target_path = target_path, src_path

  cmd = f"_supdate.py {src_path} {target_path}"
  if options.delete:
    cmd += " -d"

  print("--" * 64)
  print(f"drive       : {options.driver}")
  print(f"to delete   : {options.delete}")
  print(f"no_debug    : {options.no_debug}")
  print(f"action      : {options.action}")
  print()

  print(f"pwd: {os.getcwd()}")
  print(f"cmd to excute: {cmd}")

  print("--" * 64, "\n")

  if options.no_debug:
    answer = input("continue [y|n]? >> ")
    if answer == "y":
      start_time = time.time()
      executeCmd(cmd)
      duration = time.time() - start_time
      print(f"time: {duration} seconds.")

