let usage = df --output=pcent / | str replace -ra '[^0-9]' '' | into int
if $usage > 90 {
  let headers = {
    Title: $"Disk usage \((hostname))",
    Markdown: yes,
    Tags: "warning",
  }

  http put --headers $headers http://notify.adtailnet/logs $"`(hostname)` disk usage at ($usage)%"
}
