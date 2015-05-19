tell application "System Events"
	set desktopCount to count of desktops
	set hoff to (random number from 1 to 4) as text
	repeat with desktopNumber from 1 to desktopCount
		tell desktop desktopNumber
			set picture to "/Volumes/STICK/" & hoff & "hoff.jpg"
		end tell
	end repeat
end tell
