local M = {}

-- Map note names to MIDI numbers (C4 = 0)
M.note_to_midi = {
    C = 0, ["C#"] = 1, D = 2, ["D#"] = 3,
    E = 4, F = 5, ["F#"] = 6, G = 7,
    ["G#"] = 8, A = 9, ["A#"] = 10, B = 11
}


--------------------------------------
-- DEBUG -----------------------------
--------------------------------------
local function print_state() -- Debug function to print current state
    reaper.ShowConsoleMsg("note length: " .. tostring(note_length) .. "\n")
    reaper.ShowConsoleMsg("pos: " .. tostring(pos) .. "\n")
    reaper.ShowConsoleMsg("end pos: " .. tostring(end_pos) .. "\n")
    reaper.ShowConsoleMsg("notes_added: " .. tostring(notes_added) .. "\n")
end

-- Generates a melodic MIDI sequence with weighted rhythms, occasional leaps, and accented beats
function M.create_track(root_note, octave, scale_notes, note_length)
    beats_per_measure = beats_per_measure or 4 -- default 4/4
    reaper.InsertTrackAtIndex(0, true)
    local track = reaper.GetTrack(0, 0)

    -- Create MIDI item (4 measures by default)
    local measures = 4
    local start_pos = 0
    local end_pos = measures * beats_per_measure
    local item = reaper.CreateNewMIDIItemInProj(track, start_pos, end_pos, false)
    local take = reaper.GetMediaItemTake(item, 0)

    local root_midi = M.note_to_midi[root_note] + (octave - 4) * 12

    local pos = 0 -- current position in quarter notes
    local last_index = math.random(#scale_notes)

    -- weighted durations (more likely quarter notes, less likely sixteenth)
    local durations = {0.25, 0.5, 1}          -- sixteenth, eighth, quarter
    local weights   = {0.1, 0.3, 0.6}         -- probability weights
    local function pick_weighted(durations, weights)
        local sum = 0
        for _, w in ipairs(weights) do sum = sum + w end
        local r = math.random() * sum
        local accum = 0
        for i, w in ipairs(weights) do
            accum = accum + w
            if r <= accum then return durations[i] end
        end
        return durations[#durations]
    end

    local notes_added = 0

    -- print_state()

    while pos < end_pos and notes_added < note_length do
        
        -- randomly skip a beat for a rest
        if math.random() < 0.15 then
            pos = pos + 0.25 -- sixteenth rest
        else
            -- melodic step with occasional leap
            local step
            if math.random() < 0.1 then
                step = math.random(1, #scale_notes)
            else
                step = last_index + math.random(-2, 2)
                if step < 1 then step = 1 end
                if step > #scale_notes then step = #scale_notes end
            end

            local midi_note = root_midi + scale_notes[step]

            -- pick weighted duration
            local dur = pick_weighted(durations, weights)

            -- don't exceed item length
            if pos + dur > end_pos then dur = end_pos - pos end

            -- velocity: accented on strong beats (quarter notes)
            local beat_pos = pos % 1
            local velocity = beat_pos == 0 and 120 or 90

            reaper.MIDI_InsertNote(take, false, false, 
                                   reaper.MIDI_GetPPQPosFromProjQN(take, pos),
                                   reaper.MIDI_GetPPQPosFromProjQN(take, pos + dur),
                                   0, midi_note, velocity, false)

            pos = pos + dur
            last_index = step
            notes_added = notes_added + 1
        end
    end

    reaper.MIDI_Sort(take)
    reaper.UpdateArrange()
end

return M
