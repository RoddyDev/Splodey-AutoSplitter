/* 
Splodey Auto Splitter
Written by roddy
Date: June 26, 2024 (v1.1.2)
      May 12, 2025  (v1.1.4)
*/

state("Splodey", "1.1.2")
{
    byte room_id: "Splodey.exe", 0xC2C498;
    float player_x: "Splodey.exe", 0xC2C460, 0x1A0, 0x320, 0x78, 0x18, 0x70, 0x38, 0xE8;
}

state("Splodey", "1.1.4")
{
    byte room_id: "Splodey.exe", 0xBB1880;
    float player_x: "Splodey.exe", 0xAE4608, 0x1E0, 0x600, 0xC60, 0x3B0, 0x830, 0x1B8, 0x174;

    // these might be valid too
    // float player_x: "Splodey.exe", 0xAE4608, 0x1E0, 0xB00, 0x900, 0xA70, 0x830, 0x1B8, 0x174;
    // float player_x: "Splodey.exe", 0xDF7920, 0x6A8, 0x380, 0x6D8, 0xBF0, 0x830, 0x1B8, 0x174;
    // float player_x: "Splodey.exe", 0xDF7928, 0x6A8, 0x380, 0x6D8, 0xBF0, 0x830, 0x1B8, 0x174;
    // float player_x: "Splodey.exe", 0xAE4608, 0x1E0, 0x900, 0x8B8, 0xC90, 0x830, 0x1B8, 0x174;
    // float player_x: "Splodey.exe", 0xDF7918, 0x6c8, 0x8, 0x818, 0xf50, 0x830, 0x1b8, 0x174;
    // float player_x: "Splodey.exe", 0xdf7920, 0x360, 0x108, 0xd80, 0x9d0, 0x830, 0x1b8, 0x174;
    // float player_x: "Splodey.exe", 0xdf7928, 0x360, 0x108, 0xd80, 0x9d0, 0x830, 0x1b8, 0x174;
    // float player_x: "Splodey.exe", 0xae4608, 0x1e0, 0x600, 0xcb8, 0xc90, 0x830, 0x1b8, 0x174;

    // probably not this one
	//float player_x: "Splodey.exe", 0xBAF2E8, 0x300, 0x58, 0x10, 0x1A0, 0x128;
}

init {
    version = "";

    if (modules.First().ModuleMemorySize == 13488128) {
        version = "1.1.2";
    }

    if (modules.First().ModuleMemorySize == 15241216) {
        version = "1.1.4";
    }

    // Show warning if game version is not up to date.
    if (version != "1.1.4") {
        var versionMessage = MessageBox.Show (
			"Warning: Wrong game version found. Expecting v1.1.4\n"+
			"This means that either the autosplitter or the game is outdated. Please check.\n",
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
        163, 165, 166, 167, 105, 0
    };

    vars.last_levels = new List<int>{
        134, 60, 84, 105
    };
    print(modules.First().ModuleMemorySize.ToString());
}

startup {
    // This script runs 60 times per second, same as the game. Change this to whatever you'd like, like a little lower if it lags your game.
    refreshRate = 60;

    // Ask the player to switch to Real Time if LiveSplit is set to Game Time.
    if (timer.CurrentTimingMethod == TimingMethod.GameTime){
		var timingMessage = MessageBox.Show (
			"This autosplitter uses Real Time as the timing method.\n"+
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
    }
    // If Per Level setting is enabled
    if (settings["per_level"]) {
        // If room changed and the new room is the one expected for the next split
        if (old.room_id != current.room_id) {
            // Split if old room was the expected one for this split.
            return (old.room_id == vars.room_ids[timer.CurrentSplitIndex]);
        }
    } else {
        // If per world setting is enabled, only split if player is back to hub and the old room was the expected one.
        return (current.room_id == 188 && old.room_id == vars.last_levels[timer.CurrentSplitIndex]);
    }
}


/*
maybe this? idk
if (vars.last_levels.Contains(old.room_id)) {
    if (current.room_id == 188) {
        return true;
    }
}
*/
