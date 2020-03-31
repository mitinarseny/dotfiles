#!/bin/sh

if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

echo '› Setting Russian configurations'
echo '  › Set languages to English and Russian'
defaults write NSGlobalDomain AppleLanguages -array "en" "ru"

echo '  › Set locale to US and currency to RUB'
defaults write NSGlobalDomain AppleLocale -string "ru_RU@currency=RUB"

echo '  › Set measurement units to centimeters'
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"

echo '  › Set termperature units to Celsuis'
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsuis"

echo '  › Set metric units'
defaults write NSGlobalDomain AppleMetricUnits -bool true

# see `sudo systemsetup -listtimezones` for other timezones
echo '  › Set the timezone'
sudo systemsetup -settimezone "Europe/Moscow" > /dev/null
