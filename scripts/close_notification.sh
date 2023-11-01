#!/usr/bin/osascript

tell application "System Events"
   try
     set _groups to groups of UI element 1 of scroll area 1 of group 1 of window "Notification Center" of application process "NotificationCenter"
    repeat with _group in _groups
      set temp to value of static text 1 of _group
      if temp contains "Disk Not Ejected Properly" then
        perform (first action of _group where description is "Close")
       end if
    end repeat
  end try 
end tell
