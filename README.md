# Melody Generator for REAPER

A modular Lua-based melody generator for **REAPER** using **ReaImGui**.  
Create melodies interactively by selecting a root note and scale, then automatically plotting MIDI notes in a new track.

## Features

- Interactive **ReaImGui**-based UI for selecting root note and scale  
- Modular design for easy expansion  
- Automatically inserts a new track with generated MIDI notes  
- Designed for quick prototyping and experimentation

## Requirements

- **REAPER** (64-bit recommended)  
- **ReaImGui** (native REAPER ImGui binding included with REAPER)  
- Lua 5.4 (comes with REAPER)  

> The script is fully Lua-based; Python is not required for running the current version.

## Installation

1. Clone or download this repository to your REAPER scripts folder:

```text
reaper_scripts/lua/melody_generator/
```

2. Ensure the folder structure remains intact:  
     melody_generator/
        main.lua
        melody/
            melody.lua
        reaper_integration/
            create_track.lua
        ui/
            run_ui.lua
   
3. Open REAPER and go to Actions → Show Action List → ReaScript → Load.
Select main.lua from the melody_generator folder.

4. Run the script from the Action List. A small ReaImGui window will appear allowing you to select a root note, choose a scale, and generate a melody.


## Usage
  1. Open the Melody Generator window.
  2. Select a Root Note from the dropdown.
  3. Select a Scale (future versions may include this feature).
  4. Click Generate Melody to insert a new track with the MIDI notes.

## Project Structure
  melody/	                 Functions for melody data and generation logic
  reaper_integration/	     Functions for interacting with REAPER (track creation, MIDI insertion)
  ui/	                     ReaImGui user interface components
  main.lua	               Entry point script that runs the UI loop
  

