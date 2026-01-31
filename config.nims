import os
import strutils

--nimcache:".nimcache"
--path:"src"

task test, "Run tests":
  for testFile in listFiles("tests"):
    if testFile.endsWith(".nim"):
      exec "nim c -r " & testFile
