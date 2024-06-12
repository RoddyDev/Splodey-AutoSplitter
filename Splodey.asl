/* 
Splodey Auto Splitter
Written by roddy
Date: June 12, 2024
*/
state("Splodey", "1.0.8")
{
    byte room_id: "Splodey.exe", 0xC1FB88;
    float player_x: "Splodey.exe", 0xa0ca50, 0x0, 0xc40, 0x18, 0x70, 0x10, 0x198, 0xe8;
}

init {
    version = "";

    switch(modules.First().ModuleMemorySize) {
        case 13434880:
            version = "1.0.8";
        break;
    }

    // Show warning if game version is not up to date.
    if (version != "1.0.8") {
        var versionMessage = MessageBox.Show (
			"Warning: You are using an outdated version of Splodey.\n"+
			"This script only works with the latest version of the game, v1.0.8.\n"+
			"Please update your game.",
			"Splodey Autosplitter",
		MessageBoxButtons.OK, MessageBoxIcon.Warning);
    }
    
    // These are the room IDs for the levels. World 5 is not included here.
    vars.room_ids = new List<int>{
        // Academy
        018, 027, 008, 005, 035,
        012, 017, 004, 015, 006, 
        021, 028, 007, 106, 013, 
        023, 107, 011, 029, 034, 
        031, 022, 033, 009, 134,

        // Forest
        037, 039, 040, 041, 044, 
        046, 154, 047, 049, 059, 
        050, 051, 038, 054, 042, 
        052, 056, 048, 057, 058, 
        152, 153, 155, 061, 060,

        // Volcano
        062, 063, 064, 065, 066,
        157, 010, 072, 162, 069,
        073, 076, 077, 075, 078, 
        080, 082, 081, 156, 068,
        159, 160, 161, 158, 084,

        // Moon
        091, 099, 086, 087, 085, 
        100, 089, 095, 101, 092, 
        164, 020, 094, 096, 098, 
        088, 168, 102, 103, 093, 
        163, 165, 166, 167, 105
    };

    vars.last_levels = new List<int>{
        134, 60, 84, 105
    };
    //print(modules.First().ModuleMemorySize.ToString());
}

startup {
    // This script runs 60 times per second, same as the game. Change this to whatever you'd like, like a little lower if it lags your game.
    refreshRate = 60;

    // Ask the player to switch to Real Time if LiveSplit is set to Game Time.
    if (timer.CurrentTimingMethod == TimingMethod.GameTime){
		var timingMessage = MessageBox.Show (
			"This contest uses Real Time as the timing method.\n"+
			"LiveSplit is currently set to show Game Time (IGT).\n"+
			"Would you like to set the timing method to Real Time?",
			"Splodey Autosplitter",
		MessageBoxButtons.YesNo,MessageBoxIcon.Question);
		
		if (timingMessage == DialogResult.Yes){
			timer.CurrentTimingMethod = TimingMethod.RealTime;
		}
	}

    settings.Add("per_level", false, "Split per level");
    settings.SetToolTip("per_level", "If unchecked, it will split per world instead.");
}

start {
    // Start on Level 1-1
    return (current.room_id == 18);
}

reset {
    // Reset on main menu (room_menu, ID 2)
    return (current.room_id == 2);
}

split {
    // Check if current room is Level 4-25
    if (current.room_id == 105) {
        // Check if player is past the portal
        if (current.player_x >= 15893) {
            return true;
        }
    } else {
        // If Per Level setting is enabled
        if (settings["per_level"]) {
            // If room changed and the new room is the one expected for the next split
            if (old.room_id != current.room_id && current.room_id == vars.room_ids[timer.CurrentSplitIndex+1]) {
                // Split if old room was the expected one for this split.
                return (old.room_id == vars.room_ids[timer.CurrentSplitIndex]);
            }
        } else {
            // If per world setting is enabled, only split if player is back to hub and the old room was the expected one.
            return (current.room_id == 188 && old.room_id == vars.last_levels[timer.CurrentSplitIndex]);
        }
    }
}