#!/usr/bin/env python3

from pyquery import PyQuery  # install using
import json

# weather icons
weather_icons = {
    "default": " ",
    "sunnyDay": " ",
    "clearNight": "望 ",
    "cloudyFoggyDay": "  ",
    "cloudyFoggyNight": " ",
    "rainyDay": " ",
    "rainyNight": " ",
    "snowyIcyDay": " ",
    "snowyIcyNight": " ",
    "severe": " ",
}

# get location_id
location_id = "eda4ec7275d74ab8c1ec41b63210e4cd19550c578702676d979e80d71aedb6b6"

# get html page
url = "https://weather.com/en-IN/weather/today/l/" + location_id
html_data = PyQuery(url)

# current temperature
temperature = html_data("span[data-testid='TemperatureValue']").eq(0).text()

# current status phrase
status = html_data("div[data-testid='wxPhrase']").text()
status = f"{status[:15]}..." if len(status) > 17 else status

# status code
class_attr = html_data("#regionHeader").attr("class").split(" ")[2].split("-")[2]

# status icon
icon = weather_icons.get(class_attr, " ")

# print waybar module data
output = {
    "icon": icon,
    "status": status,
    "class": class_attr,
    "temperature": temperature,
}
print(json.dumps(output))
