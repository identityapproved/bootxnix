# Replace slstatus's args[] block in config.def.h with cpu / ram / datetime.
# Everything else in config.def.h (interval, maxstr, unknown_str) is left as-is.
/static const struct arg args\[\] = \{/ {
  print "static const struct arg args[] = {"
  print "\t/* function     format             argument */"
  print "\t{ cpu_perc,     \"  %s%% cpu \",     NULL },"
  print "\t{ ram_perc,     \" %s%% ram \",      NULL },"
  print "\t{ datetime,     \" %s \",            \"%d.%m.%Y %H:%M\" },"
  skip = 1
  next
}
skip == 1 { if ($0 ~ /^\};/) skip = 0; next }
{ print }
