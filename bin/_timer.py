#!/usr/bin/env python
#coding: utf8

from algorithm import *

debug = False

class Timer:
  def __init__(self, minute, message):
    self.message = message
    self.minute = minute

  @staticmethod
  def calc_remaining_time(time_str):
    reg = re.compile(r"(\d+):(\d+)(am|pm)?", re.IGNORECASE)
    match = reg.findall(time_str.lower())
    if match == []:
      print "Error: -t time format is illegal"
      exit(1)
    match = match[0]
    hour, minute, mark = int(match[0]), int(match[1]), match[2]
    if mark == "pm":
      hour += 12
    minutes = hour * 60 + minute
    if debug:
      print "predefined time: %s hour %s minute" %(hour, minute)

    cur_time = time.localtime()
    cur_hour, cur_min = cur_time.tm_hour, cur_time.tm_min
    cur_minutes = cur_hour * 60 + cur_min
    if debug:
      print "currrent time: %s hour %s minute" %(cur_hour, cur_min)

    if minutes <= cur_minutes:
      print "Error: -t time too early"
      exit(1)

    return minutes - cur_minutes

  def run(self):
    self._say("开始倒计时%s分钟" %self.minute)
    minute = self.minute
    while minute >= 0:
      print "remaining: %2s minutes\r" %minute,
      sys.stdout.flush()
      if minute == 0:
        break
      if debug:
        time.sleep(1)
      else:
        time.sleep(60)
      minute -= 1

    for freq in xrange(9):
      self._say("夏天先生你应该" + self.message + "了")
      time.sleep(3)

  def _say(self, message):
    cmd = "say -v Ting-Ting %s" %message
    if debug:
      print cmd
    os.system(cmd)

if __name__ == "__main__":
  parser = optparse.OptionParser(usage = "cmd [10 minutes]")
  parser.add_option("-d", "--debug", action = "store_true", dest = "debug",
                    default = False, help = "debug mode")
  parser.add_option("-m", "--minute", dest = "minute", type = "int",
                    default = 0, help = "minute")
  parser.add_option("-t", "--time", dest = "time", type = "string",
                    default = "", help = "example, 10:20am or 10:20 or 2:30pm")
  (options, args) = parser.parse_args()

  debug = options.debug
  if options.minute > 0:
    minutes = options.minute
  else:
    minutes = Timer.calc_remaining_time(options.time)

  message = "".join(args).strip()
  assert message != ""

  timer = Timer(minutes, message)
  timer.run()
