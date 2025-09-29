
local M = {}

-- Dropdown options
M.note_map = { "C","C#","D","D#","E","F","F#","G","G#","A","A#","B" }
M.octave_map = {0,1,2,3,4,5,6,7,8}
M.root_index = 1
M.octave_index = 5 -- default to octave 4


-- A reusable dropdown function
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
    reaper.ImGui_SetNextWindowSize(ctx, 320, 180, reaper.ImGui_Cond_FirstUseEver())
    local visible, open = reaper.ImGui_Begin(ctx, "Melody Generator", true)

    if visible then
        -- Root note dropdown
        M.root_index = draw_dropdown(ctx, "Root Note", M.note_map, M.root_index)
        -- Octave dropdown
        M.octave_index = draw_dropdown(ctx, "Octave", M.octave_map, M.octave_index)



        -- Generate button
        if reaper.ImGui_Button(ctx, "Generate Melody") then
            local note_name = M.note_map[M.root_index]
            local octave = M.octave_map[M.octave_index]
            create_track(note_name, octave)
        end

        reaper.ImGui_End(ctx)
    end

   if open then
        reaper.defer(function() M.run_ui(ctx, create_track) end)
    end

end

return M

