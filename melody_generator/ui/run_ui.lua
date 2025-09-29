
local M = {}

-- Dropdown options
M.note_map = { "C","C#","D","D#","E","F","F#","G","G#","A","A#","B" }
M.octave_map = {0,1,2,3,4,5,6,7,8}
M.root_index = 1
M.octave_index = 5 -- default to octave 4

function M.run_ui(ctx, create_track)
    reaper.ImGui_SetNextWindowSize(ctx, 320, 180, reaper.ImGui_Cond_FirstUseEver())
    local visible, open = reaper.ImGui_Begin(ctx, "Melody Generator", true)

    if visible then
        -- Root note dropdown
        if reaper.ImGui_BeginCombo(ctx, "Root Note", M.note_map[M.root_index]) then
            for i, note in ipairs(M.note_map) do
                local selected = (i == M.root_index)
                if reaper.ImGui_Selectable(ctx, note, selected) then
                    M.root_index = i
                end
                if selected then reaper.ImGui_SetItemDefaultFocus(ctx) end
            end
            reaper.ImGui_EndCombo(ctx)
        end

        -- Octave dropdown
        if reaper.ImGui_BeginCombo(ctx, "Octave", tostring(M.octave_map[M.octave_index])) then
            for i, oct in ipairs(M.octave_map) do
                local selected = (i == M.octave_index)
                if reaper.ImGui_Selectable(ctx, tostring(oct), selected) then
                    M.octave_index = i
                end
                if selected then reaper.ImGui_SetItemDefaultFocus(ctx) end
            end
            reaper.ImGui_EndCombo(ctx)
        end

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
    else
        reaper.ImGui_DestroyContext(ctx)
    end
end

return M

