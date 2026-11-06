#!/usr/bin/env bash
# Claude Code status line: model, directory, context usage, and 5-hour and weekly subscription limits.
# Colors follow the Kanagawa Wave palette; usage turns yellow at 50% and red at 80%.
exec jq -r '
  def paint($rgb): "\u001b[38;2;\($rgb)m\(.)\u001b[0m";
  def violet: "149;127;184";
  def blue: "126;156;216";
  def gray: "114;113;105";
  def usage:
    round as $p
    | "\($p)%" | paint(if $p >= 80 then "228;104;118" elif $p >= 50 then "230;195;132" else "152;187;108" end);
  def k: if . >= 1000 then "\(. / 1000 | round)k" else tostring end;
  def until_reset:
    (. - now | floor) as $s
    | if $s <= 0 then "now"
      elif $s >= 86400 then "\($s / 86400 | floor)d\($s % 86400 / 3600 | floor)h"
      elif $s >= 3600 then "\($s / 3600 | floor)h\($s % 3600 / 60 | floor)m"
      else "\($s / 60 | ceil)m" end;
  def limit($name):
    if . then "\($name | paint(gray)) \(.used_percentage | usage) \("↻\(.resets_at | until_reset)" | paint(gray))" else empty end;
  [ (.model.display_name // empty | paint(violet)),
    (.workspace.current_dir // .cwd // empty | split("/") | last | paint(blue)),
    (.context_window | "\("ctx" | paint(gray)) \(.used_percentage // 0 | usage) \("\(.total_input_tokens // 0 | k)/\(.context_window_size // 0 | k)" | paint(gray))"),
    (.rate_limits.five_hour | limit("5h")),
    (.rate_limits.seven_day | limit("7d")) ]
  | join(" │ " | paint(gray))
'
