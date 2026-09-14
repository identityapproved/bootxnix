# Replace st's colorname[] block in config.def.h with the Rose Pine palette
# (16 ANSI + cursor/fg/bg at 256-259). The font is set separately with sed in
# the module's postPatch. Everything else in config.def.h is left untouched, so
# a version bump only needs a re-check if the colorname layout itself changed.
/static const char \*colorname\[\] = \{/ {
  print "static const char *colorname[] = {"
  print "\t/* 8 normal colors (Rose Pine) */"
  print "\t\"#26233a\", \"#eb6f92\", \"#9ccfd8\", \"#f6c177\", \"#31748f\", \"#c4a7e7\", \"#ebbcba\", \"#e0def4\","
  print "\t/* 8 bright colors */"
  print "\t\"#47435d\", \"#ff98ba\", \"#c5f9ff\", \"#ffeb9e\", \"#5b9ab7\", \"#eed0ff\", \"#ffe5e3\", \"#fefcff\","
  print "\t[255] = 0,"
  print "\t\"#e0def4\", /* 256: cursor */"
  print "\t\"#191724\", /* 257: reverse cursor */"
  print "\t\"#e0def4\", /* 258: default foreground */"
  print "\t\"#191724\", /* 259: default background */"
  print "};"
  print ""
  print "unsigned int defaultfg = 258;"
  print "unsigned int defaultbg = 259;"
  print "unsigned int defaultcs = 256;"
  print "static unsigned int defaultrcs = 257;"
  skip = 1
  next
}
# swallow the original array and the four default* lines that follow it
skip == 1 {
  if ($0 ~ /defaultrcs/) { skip = 0 }
  next
}
{ print }
