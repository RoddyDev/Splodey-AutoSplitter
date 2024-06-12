/* 
Splodey Auto Splitter
Written by roddy
Date: June 12, 2024
*/

state("Splodey", "1.0.6")
{
    byte room_id: "Splodey.exe", 0xC135D8;
}

state("Splodey", "1.0.7")
{
    byte room_id: "Splodey.exe", 0xC15798;
}

state("Splodey", "1.0.8")
{
    byte room_id: "Splodey.exe", 0xC1FB88;
    float player_x: "Splodey.exe", 0xa0ca50, 0x0, 0xc40, 0x18, 0x70, 0x10, 0x198, 0xe8;
}


init {
    switch(modules.First().ModuleMemorySize) {
        // old versions won't really work because I don't see a reason to use them
        // I mean, they will still split but it won't split on 4-25 because I'm not tracking for player X position and I don't really want to track for their pointers.
        case 13381632: 
            version = "1.0.6";
        break;

        case 13389824:
            version = "1.0.7";
        break;

        case 13434880:
            version = "1.0.8";
        break;
    }

    vars.room_ids = new List<int>{
        // Academy
        018, 027, 008, 005, 035,
        012, 017, 004, 015, 006, 
        021, 028, 007, 106, 13, 
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

    /*
    vars.room_ids = new List<int>{
        //18
        27, 8, 5, 35,
        12, 17, 4, 15, 6, 
        21, 28, 7, 106, 13, 
        23, 107, 11, 29, 34, 
        31, 22, 33, 9, 134, 188,

        //37
        39, 40, 41, 44, 
        46, 154, 47, 49, 59, 
        50, 51, 38, 54, 42, 
        52, 56, 48, 57, 58, 
        152, 153, 155, 61, 60, 188,

        // 62
        63, 64, 65, 66,
        157, 10, 72, 162, 69,
        73, 76, 77, 75, 78, 
        80, 82, 81, 156, 68,
        159, 160, 161, 158, 84, 188,

        //91
        99, 86, 87, 85, 
        100, 89, 95, 101, 92, 
        164, 20, 94, 96, 98, 
        88, 168, 102, 103, 93, 
        163, 165, 166, 167, 105
    };
    */

    vars.last_levels = new List<int>{
        134, 60, 84, 105
    };
    //print(modules.First().ModuleMemorySize.ToString());
}

startup {
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
    if (current.room_id == 18) {
        vars.current_split = 0;
        return true;
    }
}

reset {
    // Reset on main menu (room_menu, ID 2)
    return (current.room_id == 2);
}

split {
    if (current.room_id != 105) {
        if (settings["per_level"]) {
            if (old.room_id == vars.room_ids[timer.CurrentSplitIndex]) {
                return true;
            }
        } else {
            if (current.room_id == 188 && old.room_id == vars.last_levels[timer.CurrentSplitIndex]) {
                return true;
            }
        }
    } else {
        return current.player_x >= 15893;
    }
}