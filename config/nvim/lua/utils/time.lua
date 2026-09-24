local M = {}

function M.get_zettel_timestamp()
  local weekdays = {
    [1] = "воскресенье",
    [2] = "понедельник",
    [3] = "вторник",
    [4] = "среда",
    [5] = "четверг",
    [6] = "пятница",
    [7] = "суббота"
  }

  local date_table = os.date("*t")
  local weekday_name = weekdays[date_table.wday]

  local timezone_offset = os.date("%z")
  local gmt_zone = "GMT" .. timezone_offset:sub(1, 3):gsub("^%+0", "+"):gsub("^%-0", "-")
  local time_str = os.date("%d-%m-%Y %H:%M:%S")

  return string.format("%s, %s %s", weekday_name, time_str, gmt_zone)
end

return M
