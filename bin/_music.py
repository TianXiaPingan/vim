#!/usr/bin/env python

from sys import stdout
from os import system, path, listdir
from time import time
from math import exp, log
from optparse import OptionParser
from random import sample, random
from threading import Thread


class PlayThread:
  def __init__(self, play_cmd):
    self.cmd = play_cmd

  def __call__(self):
    system(self.cmd)

class Sound:
  SOUND_DIR = "/Users/world/inf/study/bin/music"
  SID = 0
  SOUND_TABLE = []

  def __init__(self, name):
    self.name = name
    self.sid = Sound.SID
    Sound.SID += 1

  @staticmethod
  def gen_all_sounds(level):
    types = [("-", "34567"), ("", "1234567"), ("+", "1234567"), ("++", "123")]

    ret = []
    for t, ns in types:
      for s in ns:
        name = "%s%s" % (s, t)
        ret.append(Sound(name))
        Sound.SOUND_TABLE.append(name)
        if s not in "37":
          ret.append(Sound("#" + name))
          Sound.SOUND_TABLE.append("#" + name)
    ret.append(Sound("4++"))
    Sound.SOUND_TABLE.append("4++")
    print Sound.SOUND_TABLE

    if level == "1":
      f, t = Sound.SOUND_TABLE.index("1"), Sound.SOUND_TABLE.index("7")
    elif level == "2":
      f, t = Sound.SOUND_TABLE.index("1"), Sound.SOUND_TABLE.index("7+")
    elif level == "3":
      f, t = Sound.SOUND_TABLE.index("-3"), Sound.SOUND_TABLE.index("7+")
    elif level == "4":
      f, t = 0, len(Sound.SOUND_TABLE) - 1

    return ret[f: t + 1]

  def play(self):
    # increase to standard.
    if self.name not in ["correct", "incorrect"]:
      idx = Sound.SOUND_TABLE.index(self.name) + 1
      name = Sound.SOUND_TABLE[idx]
    else:
      name = self.name
    cmd = "afplay -t 2 %s/%s.aiff" % (Sound.SOUND_DIR, name)
    Thread(target=PlayThread(cmd)).run()


class Music:
  def __init__(self, level):
    self.sounds = filter(lambda sd: "#" not in sd.name, 
                         Sound.gen_all_sounds(level))
    self.incor_sounds = Sound("incorrect")
    self.cor_sounds = Sound("correct")

  def learn(self):
    for sound in self.sounds * 100:
      key = raw_input("push any key to halt, and push ""
                      'enter' to practice: ").strip()
      if key != "":
        break
      print "name: ", sound.name
      sound.play()

  def guess(self):
    score = 0.0
    ite = 0
    last_music = None
    while True:
      while True:
        sound = sample(self.sounds, 1)[0]
        if sound != last_music:
          last_music = sound
          break
      print "listen..."
      sound.play()
      iname = raw_input("input name (e.g. 3+, 1-, #4-): ").strip()
      if iname == sound.name:
        self.cor_sounds.play()
      else:
        self.incor_sounds.play()
        print "again..."
        sound.play()
        searched = [sd for sd in self.sounds if sd.name == iname]
        if searched == []:
          print "input error"
        else:
          score += abs(searched[0].sid - sound.sid)
      ite += 1
      print "names:", sound.name, ", your score (smaller, better):", score / ite

  def compare(self):
    while True:
      while True:
        s1, s2 = sample(self.sounds, 2)
        if 0 < abs(s1.sid - s2.sid) <= 4:
          break
      print "listening..."
      s1.play()
      s2.play()
      v = input("input the maximum one: (1, 2): ")
      v = 1 if v == 1 else -1
      if cmp(s1.sid, s2.sid) * v < 0:
        self.incor_sounds.play()
      else:
        self.cor_sounds.play()


if __name__ == "__main__":
  parser = OptionParser(usage="cmd [optons] ..]")
  # parser.add_option("-q", "--quiet", action = "store_true", dest = 
  # "verbose", default = False, help = "don't print status messages to stdout")
  parser.add_option("--learn", action="store_true", dest="learn", default=False,
                    help="learning the frequency of all sounds")
  parser.add_option("--guess", action="store_true", dest="guess", default=False,
                    help="guess the sound when hearing")
  parser.add_option("--compare", action="store_true", dest="compare",
                    default=False, help="compare")
  parser.add_option("--level", dest="level", default="1", help="level: 1-4")
  (options, args) = parser.parse_args()

  music = Music(options.level)
  if options.learn:
    music.learn()
  elif options.guess:
    music.guess()
  elif options.compare:
    music.compare()
