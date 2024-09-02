journalctl -f -n 0 -p warning -o json | lines | each {
  # `into value` creates a table, we want a record (aka, first row)
  let data = from json | into value | first
  let priority = match $data.PRIORITY {
    0 => "urgent",
    1 => "high",
    2 => "high",
    3 => "default",
    4 => "low",
  }
  let emoji = match $priority {
    "low"     => "warning",
    "default" => "triangular_flag_on_post",
    "high"    => "rotating_light",
    "urgent"  => "fire",
  }
  let headers = {
    Title:    $"syslog \(($data._HOSTNAME))",
    Priority: $priority,
    Tags:     $emoji,
    Markdown: yes,
  }

  http put --headers $headers "http://notify.adtailnet/logs" $"
    From `($data | get --ignore-errors SYSLOG_IDENTIFIER)`:
    ```($data.MESSAGE)```
  "
}
