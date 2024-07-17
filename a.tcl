package require Tk

# Create a main window
set mainWindow [tk::frame .main]
pack $mainWindow -fill both -expand 1

# Create a label to display messages
label $mainWindow.label -text "Click the button below:"
pack $mainWindow.label -padx 10 -pady 10

# Create a button
button $mainWindow.button -text "Click Me"

# Define the event handler for button click
proc onButtonClick {} {
    tk_messageBox -message "Button was clicked!" -type ok
}

# Bind the button click event to the event handler
bind $mainWindow.button <Button-1> onButtonClick

# Pack the button into the window
pack $mainWindow.button -padx 10 -pady 10

# Start the Tk main event loop
tk::mainloop
