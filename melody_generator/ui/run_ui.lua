local M = {}

-- Root Note
M.root_index = 1
M.root_note_map = { "C","C#","D","D#","E","F","F#","G","G#","A","A#","B" }

-- Octave
M.octave_index = 5 -- default to octave 4
M.octave_map = {0,1,2,3,4,5,6,7,8}

-- Scales
M.scale_index = 1
M.scale_names = {"Major", "Natural Minor", "Harmonic Minor", 
                 "Melodic Minor", "Pentatonic Major", "Pentatonic Minor",
                 "Blues", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Locrian"}
M.scale_map = {
    {0, 2, 4, 5, 7, 9, 11},  -- Major
    {0, 2, 3, 5, 7, 8, 10},  -- Natural Minor
    {0, 2, 3, 5, 7, 8, 11},  -- Harmonic Minor
    {0, 2, 3, 5, 7, 9, 11},  -- Melodic Minor
    {0, 2, 4, 7, 9},          -- Pentatonic Major
    {0, 3, 5, 7, 10},         -- Pentatonic Minor
    {0, 3, 5, 6, 7, 10},      -- Blues
    {0, 2, 3, 5, 7, 9, 10},   -- Dorian
    {0, 1, 3, 5, 7, 8, 10},   -- Phrygian
    {0, 2, 4, 6, 7, 9, 11},   -- Lydian
    {0, 2, 4, 5, 7, 9, 10},   -- Mixolydian
    {0, 1, 3, 5, 6, 8, 10}    -- Locrian
}

-- Note Length
M.note_length_index = 1
M.note_length_map = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 , 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

-- Beats Per Measure
M.beats_per_measure_index = 1
M.beats_per_measure_names = {"4/4", "3/4", "6/8", "5/4", "7/8", "2/4"}
M.beats_per_measure_map = {4, 3, 6, 5, 7, 2}

--------------------------------------
-- DEBUG -----------------------------
--------------------------------------
local function print_state() -- Debug function to print current state
    reaper.ShowConsoleMsg("\n--- DEBUG STATE ---\n")
    reaper.ShowConsoleMsg("note length index: " .. tostring(M.note_length_index) .. "\n")
    reaper.ShowConsoleMsg("Root Index: " .. tostring(M.root_index) .. "\n")
    reaper.ShowConsoleMsg("Root Note: " .. tostring(M.root_note_map[M.root_index]) .. "\n")
    reaper.ShowConsoleMsg("Octave Index: " .. tostring(M.octave_index) .. "\n")
    reaper.ShowConsoleMsg("Octave: " .. tostring(M.octave_map[M.octave_index]) .. "\n")
    reaper.ShowConsoleMsg("Scale Index: " .. tostring(M.scale_index) .. "\n")
    reaper.ShowConsoleMsg("Scale Name: " .. tostring(M.scale_names[M.scale_index]) .. "\n")
    reaper.ShowConsoleMsg("Scale Notes: ")
    local scale = M.scale_map[M.scale_index]
    if scale then
        for i, n in ipairs(scale) do
            reaper.ShowConsoleMsg(n .. " ")
        end
        reaper.ShowConsoleMsg("\n")
    else
        reaper.ShowConsoleMsg("nil\n")
    end
    reaper.ShowConsoleMsg("--- END DEBUG ---\n")
end

--------------------------------------
-- A reusable dropdown function ------
--------------------------------------
local function draw_dropdown(ctx, label, options, selected_index)
    
    if reaper.ImGui_BeginCombo(ctx, label, options[selected_index]) then
        for i, option in ipairs(options) do
           
            local selected = (i == selected_index)
            if reaper.ImGui_Selectable(ctx, option, selected) then
                selected_index = i
            end
            if selected then reaper.ImGui_SetItemDefaultFocus(ctx) end
        end
        reaper.ImGui_EndCombo(ctx)
    end
    return selected_index
end




function M.run_ui(ctx, create_track)
reaper.ImGui_SetNextWindowSize(ctx, 425, 270, reaper.ImGui_Cond_Always())
    local visible, open = reaper.ImGui_Begin(ctx, "Melody Generator", true)

    if visible then
        reaper.ImGui_Indent(ctx, 20)  -- indent 20 pixels from the left
        reaper.ImGui_Dummy(ctx, 0, 12)   -- 5px padding
        -- Root note dropdown
        M.root_index = draw_dropdown(ctx, "Root Note", M.root_note_map, M.root_index)
        reaper.ImGui_Dummy(ctx, 0, 8)   -- 5px padding
        -- Octave dropdown
        M.octave_index = draw_dropdown(ctx, "Octave", M.octave_map, M.octave_index)
        reaper.ImGui_Dummy(ctx, 0, 8)   -- 5px padding
        -- Scale Dropdown
        M.scale_index = draw_dropdown(ctx, "Scale", M.scale_names, M.scale_index)
        reaper.ImGui_Dummy(ctx, 0, 8)   -- 5px padding
        -- Note Length
        M.note_length_index = draw_dropdown(ctx, "Number of notes", M.note_length_map, M.note_length_index)
        reaper.ImGui_Dummy(ctx, 0, 8)   -- 5px padding
        M.beats_per_measure_index = draw_dropdown(ctx, "Beats Per Measure", M.beats_per_measure_map, M.beats_per_measure_index)
        reaper.ImGui_Dummy(ctx, 0, 8)   -- 5px padding





        -- Generate button
        if reaper.ImGui_Button(ctx, "Generate Melody") then
            -- print_state() -- Debugger function
            local note_name = M.root_note_map[M.root_index]
            local octave = M.octave_map[M.octave_index]
            local scale_notes = M.scale_map[M.scale_index]
            local note_length = M.note_length_map[M.note_length_index]
            local beats_per_measure = M.beats_per_measure_map[M.beats_per_measure_index]
            create_track(note_name, octave, scale_notes, note_length)
        end

        reaper.ImGui_End(ctx)
    end

   if open then
        reaper.defer(function() M.run_ui(ctx, create_track) end)
    end

end

return M

