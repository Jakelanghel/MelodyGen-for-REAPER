local M = {}

-- Map note names to MIDI numbers for octave 4
M.note_to_midi = {
    C = 0, ["C#"] = 1, D = 2, ["D#"] = 3,
    E = 4, F = 5, ["F#"] = 6, G = 7,
    ["G#"] = 8, A = 9, ["A#"] = 10, B = 11
}

function M.create_track(note_name, octave)
    local midi_base = M.note_to_midi[note_name] or 0
    local midi_note = midi_base + (octave + 1) * 12  -- MIDI octave 0 = 12, octave 4 = 60+

    -- Insert new track
    reaper.InsertTrackAtIndex(0, true)
    local track = reaper.GetTrack(0, 0)

    -- Create MIDI item
    local start_pos, end_pos = 0, 4
    local item = reaper.CreateNewMIDIItemInProj(track, start_pos, end_pos, false)
    local take = reaper.GetMediaItemTake(item, 0)

    -- Insert single note
    local start_ppq = reaper.MIDI_GetPPQPosFromProjQN(take, 0)
    local end_ppq   = reaper.MIDI_GetPPQPosFromProjQN(take, 1)
    reaper.MIDI_InsertNote(take, false, false, start_ppq, end_ppq, 0, midi_note, 100, false)

    reaper.MIDI_Sort(take)
    reaper.UpdateArrange()
end

return M

