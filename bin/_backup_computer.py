#!/usr/bin/env python3

from algorithm_3x import *
import common as nlp

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [optons]")
  parser.add_option("--driver", default="server",
                    help="['gdrive', 'warehouse', '*server']")
  parser.add_option("-d", action="store_true", dest="delete",
                    help="to delete additional files.")
  parser.add_option("--action", default="backup", help="['*backup', 'restore']")
  (options, args) = parser.parse_args()

  src_path = os.path.expanduser("~/inf")
  assert os.path.isdir(src_path)
  os.chdir(src_path)
  src_path = "."

  if options.driver == "gdrive":
    target_path = "/Volumes/gdrive/inf"
    assert os.path.isdir(target_path)
  elif options.driver == "warehouse":
    target_path = "/Volumes/warehouse/inf"
    assert os.path.isdir(target_path)
  elif options.driver == "server":
    target_path = "gpu2@/media/workspace/summer/backup/inf"
  else:
    assert False

  assert options.action in ["backup", "restore"]
  if options.action == "restore":
    src_path, target_path = target_path, src_path

  cmd = f"_supdate.py {src_path} {target_path}"
  if options.delete:
    cmd += " -d"

  print("--" * 64)
  print(f"drive       : {options.driver}")
  print(f"to delete   : {options.delete}")
  print(f"action      : {options.action}")
  print()

  print(f"pwd: {os.getcwd()}")
  print(f"cmd to excute: {cmd}")

  print("--" * 64, "\n")

  answer = input("continue [y | n] ? >> ")
  if answer == "y":
    start_time = time.time()

    nlp.execute_cmd(cmd)
    cmd = "_clone_file_tag.py --cmd gen"
    nlp.execute_cmd(cmd)

    duration = time.time() - start_time
    print(f"time: {duration} seconds.")

