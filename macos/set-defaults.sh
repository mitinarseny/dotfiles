#!/bun/sh

if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

echo "› Close any open System Preferences panes, to prevent them from overriding settings we’re about to change"
osascript -e 'tell application "System Preferences" to quit'

echo "› System:"
echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Show the ~/Library folder"
chflags nohidden ~/Library

echo "  › Show the /Volumes folder"
sudo chflags nohidden /Volumes

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  › Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "  › Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  › Avoid the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "  › Avoid creating .DS_Store files on USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Show battery percent"
defaults write com.apple.menuextra.battery ShowPercent -bool true

echo "  › Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
  -kill -r -domain local -domain system -domain user

echo "  › Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

echo "  › Hide battery time remaining"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

echo "  › Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "  › Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "  › Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "  › Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "  › Disable automatic capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo '  › Disable smart dashes'
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo '  › Disable automatic period substitution'
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo '  › Disable smart quotes'
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo '  › Disable auto-correct'
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo '  › Show language menu in the top right corner of the boot screen'
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

echo '  › Set clock to digital'
defaults write com.apple.menuextra.clock IsAnalog -bool false

echo '  › Set clock format'
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm" && killall SystemUIServer

echo '  › Save screenshots to ~/screenshots'
defaults write com.apple.screencapture location -string "${HOME}/screenshots"

# other options: BMP, GIF, JPG, PDF, TIFF
echo '  › Save screenshots in PNG format'
defaults write com.apple.screencapture type -string "png"

echo '  › Disable shadow in screenshots'
defaults write com.apple.screencapture disable-shadow -bool true


echo '› Finder:'
echo '  › Set ~ as the default location for new Finder windows'
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo '  › Show external hard drives on desktop'
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo '  › Do not show hard drives on desktop'
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

echo '  › Show mounted servers on desktop'
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

echo '  › Show removable media on desktop'
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo '  › Show sidebar'
defaults write com.apple.finder ShowSidebar -bool true

echo '  › Do not show status bar'
defaults write com.apple.finder ShowStatusBar -bool false

echo '  › Do not show recent tags'
defaults write com.apple.finder ShowRecentTags -bool false

echo '  › Do not show preview pane'
defaults write com.apple.finder ShowPreviewPane -bool false

echo '  › Show path bar'
defaults write com.apple.finder ShowPathbar -bool true

echo '  › Show all filename extensions'
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo '  › Display full POSIX path as Finder window title'
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo '  › Keep folders on top when sorting by name'
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo '  › When performing a search, search the current folder by default'
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo '  › Disable the warning when changing a file extension'
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo '  › Enable spring loading for directories'
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo '  › Remove the spring loading delay for directories'
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo '  › Automatically open a new Finder window when a volume is mounted'
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo '  › Enable snap-to-grid for icons on the desktop and in other icon views'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo '  › Use panes view in all Finder windows by default'
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

echo '  › Enable AirDrop over Ethernet and on unsupported Macs running Lion'
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo '  › Expand panes in File Info - “General”, “Open with”, and “Sharing & Permissions”'
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true


echo '› Photos:'
echo '  › Disable Photos.app from starting everytime a device is plugged in'
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


echo '› Dock:'
echo '  › Set the icon size of Dock items to 32 pixels'
defaults write com.apple.dock tilesize -int 32

echo '  › Do not minimize windows into their application’s icon'
defaults write com.apple.dock minimize-to-application -bool false

echo '  › Show indicator lights for open applications in the Dock'
defaults write com.apple.dock show-process-indicators -bool true

echo '  › Automatically hide and show the Dock'
defaults write com.apple.dock autohide -bool true

echo '  › Don’t show recent applications in Dock'
defaults write com.apple.dock show-recents -bool false

echo '› Browsers:'
echo '  › Safari:'
echo '    › Show status bar'
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

echo '    › Privacy: don’t send search queries to Apple'
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo '    › Press Tab to highlight each item on a web page'
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

echo '    › Prevent Safari from opening ‘safe’ files automatically after downloading'
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo '    › Hide Safari’s bookmarks bar by default'
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo '    › Hide Safari’s sidebar in Top Sites'
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo '    › Remove useless icons from Safari’s bookmarks bar'
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo '    › Enable continuous spellchecking'
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

echo '    › Disable auto-correct'
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

echo '    › Warn about fraudulent websites'
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

echo '    › Block pop-up windows'
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

echo '    › Enable “Do Not Track”'
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo '    › Update extensions automatically'
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

echo '    › Set up Safari for development:'
echo '      › Enable Safari’s debug menu'
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo '      › Enable the Develop menu'
defaults write com.apple.Safari IncludeDevelopMenu -bool true

echo '      › Enable the Web Inspector in Safari'
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

echo '      › Enable the Develop menu and the Web Inspector in Safari'
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo '      › Add a context menu item for showing the Web Inspector in web views'
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


echo '› Mail:'
echo '  › Disable send and reply animations in Mail.app'
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail DisableReplyAnimations -bool true

echo '  › Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app'
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo '  › Disable inline attachments (just show the icons)'
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo '  › Disable opening Mail.app in split view while in Full Screen mode'
defaults write com.apple.mail FullScreenPreferSplit -bool false

echo '› Spotlight:'
echo '  › Change indexing order and disable some search results'
defaults write com.apple.spotlight orderedItems -array '{"enabled" = 1;"name" = "APPLICATIONS";}' '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' '{"enabled" = 1;"name" = "DIRECTORIES";}' '{"enabled" = 1;"name" = "PDF";}' '{"enabled" = 1;"name" = "FONTS";}' '{"enabled" = 1;"name" = "MENU_DEFINITION";}' '{"enabled" = 1;"name" = "MENU_OTHER";}' '{"enabled" = 1;"name" = "MENU_CONVERSION";}' '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' '{"enabled" = 1;"name" = "DOCUMENTS";}' '{"enabled" = 1;"name" = "MESSAGES";}' '{"enabled" = 1;"name" = "CONTACT";}' '{"enabled" = 1;"name" = "EVENT_TODO";}' '{"enabled" = 1;"name" = "IMAGES";}' '{"enabled" = 1;"name" = "BOOKMARKS";}' '{"enabled" = 1;"name" = "MUSIC";}' '{"enabled" = 1;"name" = "MOVIES";}' '{"enabled" = 1;"name" = "PRESENTATIONS";}' '{"enabled" = 1;"name" = "SPREADSHEETS";}' '{"enabled" = 1;"name" = "SOURCE";}' '{"enabled" = 1;"name" = "MENU_WEBSEARCH";}' '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

echo '  › Make sure indexing is enabled for the main volume'
sudo mdutil -i on / > /dev/null

echo '› Terminal.app:'
echo '  › Only use UTF-8 in Terminal.app'
defaults write com.apple.terminal StringEncodings -array 4

echo '› Time machine:'
echo '  › Prevent Time Machine from prompting to use new hard drives as backup volume'
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo '  › Disable local Time Machine backups'
hash tmutil &> /dev/null && sudo tmutil disable

echo '› Activity monitor:'
echo '  › Show the main window when launching Activity Monitor'
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo '  › Visualize CPU usage in the Activity Monitor Dock icon'
defaults write com.apple.ActivityMonitor IconType -int 5

echo '  › Show all processes in Activity Monitor'
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo '  › Sort Activity Monitor results by CPU usage'
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"

echo '  › Sort Activity Monitor results in descending order'
defaults write com.apple.ActivityMonitor SortDirection -int 0


echo '› TextEdit.app:'
echo '  › Use plain text mode for new TextEdit documents'
defaults write com.apple.TextEdit RichText -int 0

echo '  › Open and save files as UTF-8 in TextEdit'
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


echo '› Disk Unility.app:'
echo '  › Enable the debug menu in Disk Utility'
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true


echo '› QuickTime Player.app:'
echo '  › Auto-play videos when opened with QuickTime Player'
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true


echo '› Mac App Store:'
echo '  › Enable the WebKit Developer Tools in the Mac App Store'
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo '  › Enable Debug Menu in the Mac App Store'
defaults write com.apple.appstore ShowDebugMenu -bool true

echo '  › Enable the automatic update check'
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo '  ›  Download newly available updates in background'
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo '  › Install System data files & security updates'
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo '  › Turn on app auto-update'
defaults write com.apple.commerce AutoUpdate -bool true

echo '› Transmission.app'
echo '  › Use `~/torrents` to store incomplete downloads'
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/torrents"
defaults write org.m0k.transmission DownloadLocationConstant -bool true

echo '  › Hide the donate message'
defaults write org.m0k.transmission WarningDonate -bool false

echo '  › Trash original torrent files'
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo '  › Don’t prompt for confirmation before removing non-downloading active transfers'
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

echo '  › Hide the legal disclaimer'
defaults write org.m0k.transmission WarningLegal -bool false


echo "› Kill related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
	"Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
	"Terminal" "Transmission" "Photos"; do
	killall "$app" >/dev/null 2>&1
done
set -e
