
	addon.name      = 'Chainy';
	addon.author    = 'cerseii';
	addon.version   = '1.0';
	addon.desc      = 'Chain cobos';
	addon.link      = 'N/A';


	

	require('common');
	local chat = require('chat');
	local fonts = require('fonts');
	local scaling = require('scaling');
	local settings = require('settings');
	local bit = require('bit');
	local d3d8 = require('d3d8');
	local ffi = require('ffi');
	local imgui = require('imgui');
	--local inspect = require('arch/inspect');
	
local function mysplit (inputstr, sep)
        if sep == nil then
			sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end
        return t
end

function sortByLastWord(arr)
    table.sort(arr, function(a, b)
        -- Function to extract the last word from a string
        local function getLastWord(str)
            local lastSpace = str:find("%S*$", 1) -- Find the last non-space sequence
            if lastSpace then
                return str:sub(lastSpace)
            else
                return "" -- Handle empty strings or strings with no words
            end
        end

        local lastWordA = getLastWord(a)
        local lastWordB = getLastWord(b)

        return lastWordA < lastWordB
    end)
    return arr
end	

skillbylevel = {5,7,10,13,16,19,22,25,28,31,34,36,39,42,45,48,51,54,57,60,63,65,68,71,74,77,80,83,86,89,92,94,97,100,103,106,109,112,115,
		118,121,123,126,129,132,135,138,141,144,147,151,156,161,166,171,176,181,186,191,196,199,202,205,208,212,215,215,221,225,228,232,236,240,
		245,250};
	
local function levelbyskill(skill)
	for i = 1, 75 do
		if (skillbylevel[i]>=skill) then
			return(i);
			end
		end
	return(0);	
end
	

skillchains = {"Liquefaction [Fire]",
"Impaction [Lightning]",
"Detonation [Wind]",
"Scission [Earth]",
"Reverberation [Water]",
"Induration [Ice]",
"Compression [Dark]",
"Transfixion [Light]",
"Fusion [Fire/Light]",
"Fragmentation [Lightning/Wind]",
"Gravitation [Dark/Earth",
"Distortion [Ice/Water]",
"Light [Light]",
"Darkness [Dark]"}
	
skillchain = {


		
		["Impaction"] = {
			["Liquefaction"] = "Liquefaction",
			["Detonation"] = "Detonation",
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Scission"] = {
			["Detonation"] = "Detonation",
			["Liquefaction"] = "Liquefaction",
			["Reverberation"] = "Reverberation",
			["Impaction"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Reverberation"] = {
			["Impaction"] = "Impaction",
			["Induration"] = "Induration",
			["Scission"] = nil,
			["Detonation"] = nil,
			["Liquefaction"] = nil,
			["Compression"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Induration"] = {
			["Impaction"] = "Impaction",
			["Compression"] = "Compression",
			["Reverberation"] = "Fragmentation",
			["Scission"] = nil,
			["Detonation"] = nil,
			["Liquefaction"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Compression"] = {
			["Detonation"] = "Detonation",
			["Transfixion"] = "Transfixion",
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Liquefaction"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Liquefaction"] = {
			["Scission"] = "Scission",
			["Impaction"] = "Fusion",
			["Detonation"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Detonation"] = {
			["Scission"] = "Scission",
			["Compression"] = "Gravitation",
			["Impaction"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Liquefaction"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Transfixion"] = {
			["Reverberation"] = "Reverberation",
			["Compression"] = "Compression",
			["Scission"] = "Distortion",
			["Impaction"] = nil,
			["Induration"] = nil,
			["Detonation"] = nil,
			["Liquefaction"] = nil,
			["Distortion"] = nil,
			["Gravitation"] = nil,
			["Fusion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Distortion"] = {
			["Fusion"] = "Fusion",
			["Gravitation"] = "Darkness",
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Liquefaction"] = nil,
			["Detonation"] = nil,
			["Transfixion"] = nil,
			["Fragmentation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Gravitation"] = {
			["Fragmentation"] = "Fragmentation",
			["Distortion"] = "Darkness",
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Liquefaction"] = nil,
			["Detonation"] = nil,
			["Transfixion"] = nil,
			["Fusion"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Fusion"] = {
			["Gravitation"] = "Gravitation",
			["Fragmentation"] = "Light",
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Liquefaction"] = nil,
			["Detonation"] = nil,
			["Transfixion"] = nil,
			["Distortion"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		["Fragmentation"] = {
			["Distortion"] = "Distortion",
			["Fusion"] = "Light",
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Liquefaction"] = nil,
			["Detonation"] = nil,
			["Transfixion"] = nil,
			["Gravitation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},
		
		["Light"] = {
			["Light"] = nil,
			["Fusion"] =  nil,
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Liquefaction"] = nil,
			["Detonation"] = nil,
			["Transfixion"] = nil,
			["Gravitation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		},


		["Darkness"] = {
			["Distortion"] = nil,
			["Fusion"] = nil,
			["Impaction"] = nil,
			["Scission"] = nil,
			["Reverberation"] = nil,
			["Induration"] = nil,
			["Compression"] = nil,
			["Liquefaction"] = nil,
			["Detonation"] = nil,
			["Transfixion"] = nil,
			["Gravitation"] = nil,
			["Light"] = nil,
			["Darkness"] = nil
		}		
		
		
}
	


	
local function combo(s1,s2,s3,e1,e2,e3)
	
			if(s1~="" and e1~="") then
			if (skillchain[s1][e1] ~= nil) then
				return(skillchain[s1][e1]);
			end
			end	

			if(s1~="" and e2~="") then	
			if (skillchain[s1][e2] ~= nil) then
				return(skillchain[s1][e2]);
			end
			end

			
			if(s1~="" and e3~="") then		
			if (skillchain[s1][e3] ~= nil) then
				return(skillchain[s1][e3]);
			end
			end



			if(s2~="" and e1~="") then
			if (skillchain[s2][e1] ~= nil) then
				return(skillchain[s2][e1]);
			end
			end			

			if(s2~="" and e2~="") then
			if (skillchain[s2][e2] ~= nil) then
				return(skillchain[s2][e2]);
			end	
			end			

			if(s2~="" and e3~="") then
			if (skillchain[s2][e3] ~= nil) then
				return(skillchain[s2][e3]);
			end
			end			

			if(s3~="" and e1~="") then
			if (skillchain[s3][e1] ~= nil) then
				return(skillchain[s3][e1]);
			end
			end			

			if(s3~="" and e2~="") then
			if (skillchain[s3][e2] ~= nil) then
				return(skillchain[s3][e2]);
			end
			end			

			if(s3~="" and e3~="") then			
			if (skillchain[s3][e3] ~= nil) then
				return(skillchain[s3][e3]);
			end
			end			

		
		return("");
				
		end
	
		class = {"Archery","Axe","Club","Dagger","Great Axe","Great Katana","Great Sword","Hand-to-Hand","Katana","Marksmanship",
		"Polearm","Scythe","Staff","Sword","Summoner"}
		
		skill = {  
		{"Archery","Flaming Arrow",levelbyskill(5),"Liquefaction","Transfixion",""},
		{"Archery","Piercing Arrow",levelbyskill(40),"Reverberation","Transfixion",""},
		{"Archery","Dulling Arrow",levelbyskill(80),"Liquefaction","Transfixion",""},			
		{"Archery","Sidewinder",levelbyskill(175),"Reverberation","Transfixion","Detonation"},				
		{"Archery","Blast Arrow",levelbyskill(200),"Induration","Transfixion",""},		
		{"Archery","Arching Arrow",levelbyskill(225),"Fusion","",""},			
		{"Archery","Empyreal Arrow",levelbyskill(250),"Fusion","Transfixion",""},		
		
		{"Axe","Raging Axe",levelbyskill(5),"Detonation","Impaction",""},		
		{"Axe","Smash Axe",levelbyskill(40),"Induration","Reverberation",""},		
		{"Axe","Gale Axe",levelbyskill(70),"Detonation","",""},			
		{"Axe","Avalanche Axe",levelbyskill(100),"Scission","Impaction",""},			
		{"Axe","Spinning Axe",levelbyskill(150),"Liquefaction","Scission","Impaction"},			
		{"Axe","Rampage",levelbyskill(175),"Scission","",""},				
		{"Axe","Calamity",levelbyskill(200),"Scission","Impaction",""},		
		{"Axe","Mistral Axe",levelbyskill(225),"Fusion","",""},				
		{"Axe","Decimation",levelbyskill(240),"Fusion","Reverberation",""},		
		
		{"Club","Shining Strike",levelbyskill(5),"Impaction","",""},			
		{"Club","Seraph Strike",levelbyskill(40),"Impaction","",""},			
		{"Club","Brainshaker",levelbyskill(70),"Reverberation","",""},			
		{"Club","Skillbreaker",levelbyskill(150),"Induration","Reverberation",""},			
		{"Club","True Strike",levelbyskill(175),"Detonation","Impaction",""},			
		{"Club","Judgement",levelbyskill(200),"Impaction","",""},				
		{"Club","Hexa Strike",levelbyskill(220),"Fusion","",""},			
		{"Club","Black Halo",levelbyskill(230),"Fragmentation","Compression",""},			
		
		{"Dagger","Wasp Sting",levelbyskill(5),"Scission","",""},
		{"Dagger","Gust Slash",levelbyskill(40),"Detonation","",""},
		{"Dagger","Shadowstitch",levelbyskill(70),"Reverberation","",""},
		{"Dagger","Viper Bite",levelbyskill(100),"Scission","",""},
		{"Dagger","Cyclone",levelbyskill(125),"Detonation","Impaction",""},
		{"Dagger","Dancing Edge",levelbyskill(200),"Scission","Detonation",""},
		{"Dagger","Shark Bite",levelbyskill(225),"Fragmentation","",""},
		{"Dagger","Evisceration",levelbyskill(230),"Gravitation","Transfixion",""},

		{"Great Axe","Shield Break",levelbyskill(5),"Impaction","",""},
		{"Great Axe","Iron Tempest",levelbyskill(40),"Scission","",""},
		{"Great Axe","Sturmwind",levelbyskill(70),"Reverberation","Scission",""},
		{"Great Axe","Armor Break",levelbyskill(100),"Impaction","",""},
		{"Great Axe","Keen Edge",levelbyskill(150),"Compression","",""},		
		{"Great Axe","Weapon Break",levelbyskill(175),"Impaction","",""},
		{"Great Axe","Raging Rush",levelbyskill(200),"Induration","Reverberation",""},
		{"Great Axe","Full Break",levelbyskill(225),"Distortion","",""},
		{"Great Axe","Steel Cyclone",levelbyskill(225),"Distortion","Detonation",""},
		
		{"Great Katana","Tachi: Enpi",levelbyskill(5),"Transfixion","Scission",""},		
		{"Great Katana","Tachi: Hobaku",levelbyskill(30),"Induration","",""},		
		{"Great Katana","Tachi: Goten",levelbyskill(70),"Transfixion","Impaction",""},		
		{"Great Katana","Tachi: Kagero",levelbyskill(100),"Liquefaction","",""},		
		{"Great Katana","Tachi: Jinpu",levelbyskill(150),"Scission","Detonation",""},		
		{"Great Katana","Tachi: Koki",levelbyskill(175),"Reverberation","Impaction",""},
		{"Great Katana","Tachi: Yukikaze",levelbyskill(200),"Induration","Detonation",""},
		{"Great Katana","Tachi: Gekko",levelbyskill(225),"Distortion","Reverberation",""},
		{"Great Katana","Tachi: Kasha",levelbyskill(250),"Fusion","Compression",""},
		
		{"Great Sword", "Hard Slash", levelbyskill(5), "Scission", "", ""},
		{"Great Sword", "Power Slash", levelbyskill(40), "Transfixion", "", ""},
		{"Great Sword", "Frostbite", levelbyskill(70), "Induration", "", ""},
		{"Great Sword", "Freezebite", levelbyskill(100), "Induration", "Detonation", ""},
		{"Great Sword", "Shockwave", levelbyskill(150), "Reverberation", "", ""},
		{"Great Sword", "Crescent Moon", levelbyskill(175), "Scission", "", ""},
		{"Great Sword", "Sickle Moon", levelbyskill(200), "Scission", "Impaction", ""},
		{"Great Sword", "Spinning Slash", levelbyskill(225), "Fragmentation", "", ""},
		{"Great Sword", "Ground Strike", levelbyskill(250), "Fragmentation", "Distortion", ""},		
		
		{"Hand-to-Hand", "Combo", levelbyskill(5), "Impaction", "", ""},
		{"Hand-to-Hand", "Shoulder Tackle", levelbyskill(40), "Reverberation", "Impaction", ""},
		{"Hand-to-Hand", "One Inch Punch", levelbyskill(75), "Compression", "", ""},
		{"Hand-to-Hand", "Backhand Blow", levelbyskill(100), "Detonation", "", ""},
		{"Hand-to-Hand", "Raging Fists", levelbyskill(125), "Impaction", "", ""},
		{"Hand-to-Hand", "Spinning Attack", levelbyskill(150), "Liquefaction", "Impaction", ""},
		{"Hand-to-Hand", "Howling Fist", levelbyskill(200), "Transfixion", "Impaction", ""},
		{"Hand-to-Hand", "Dragon Kick", levelbyskill(225), "Fragmentation", "", ""},
		{"Hand-to-Hand", "Asuran Fists", levelbyskill(250), "Gravitation", "Liquefaction", ""},
		
		{"Katana", "Blade: Rin", levelbyskill(5), "Transfixion", "", ""},
		{"Katana", "Blade: Retsu", levelbyskill(30), "Scission", "", ""},
		{"Katana", "Blade: Teki", levelbyskill(70), "Reverberation", "", ""},
		{"Katana", "Blade: To", levelbyskill(100), "Induration", "Detonation", ""},
		{"Katana", "Blade: Chi", levelbyskill(150), "Transfixion", "Impaction", ""},
		{"Katana", "Blade: Ei", levelbyskill(175), "Compression", "", ""},
		{"Katana", "Blade: Jin", levelbyskill(200), "Detonation", "Impaction", ""},
		{"Katana", "Blade: Ten", levelbyskill(225), "Gravitation", "", ""},
		{"Katana", "Blade: Ku", levelbyskill(250), "Gravitation", "Transfixion", ""},
		
		{"Marksmanship", "Hot Shot", levelbyskill(5), "Liquefaction", "Transfixion", ""},
		{"Marksmanship", "Split Shot", levelbyskill(40), "Reverberation", "Transfixion", ""},
		{"Marksmanship", "Sniper Shot", levelbyskill(80), "Liquefaction", "Transfixion", ""},
		{"Marksmanship", "Slug Shot", levelbyskill(175), "Reverberation", "Transfixion", "Detonation"},
		{"Marksmanship", "Blast Shot", levelbyskill(200), "Induration", "Transfixion", ""},
		{"Marksmanship", "Heavy Shot", levelbyskill(225), "Fusion", "", ""},
		{"Marksmanship", "Detonator", levelbyskill(250), "Fusion", "Transfixion", ""},		
		
		{"Polearm", "Double Thrust", levelbyskill(5), "Transfixion", "",""},
		{"Polearm", "Thunder Thrust", levelbyskill(30), "Transfixion", "Impaction", ""},
		{"Polearm", "Raiden Thrust", levelbyskill(70), "Transfixion", "Impaction", ""},
		{"Polearm", "Leg Sweep", levelbyskill(100), "Impaction", "", ""},
		{"Polearm", "Penta Thrust", levelbyskill(150), "Compression", "", ""},
		{"Polearm", "Vorpal Thrust", levelbyskill(175), "Reverberation", "Transfixion", ""},
		{"Polearm", "Skewer", levelbyskill(200), "Transfixion", "Impaction", ""},
		{"Polearm", "Wheeling Thrust", levelbyskill(225), "Fusion", "", ""},
		{"Polearm", "Impulse Drive", levelbyskill(240), "Gravitation", "Induration", ""},
		
		{"Scythe", "Slice", levelbyskill(5), "Scission", "", ""},
		{"Scythe", "Dark Harvest", levelbyskill(30), "Reverberation", "", ""},
		{"Scythe", "Shadow of Death", levelbyskill(70), "Induration", "Reverberation", ""},
		{"Scythe", "Nightmare Scythe", levelbyskill(100), "Compression", "Scission", ""},
		{"Scythe", "Spinning Scythe", levelbyskill(125), "Reverberation", "Scission", ""},
		{"Scythe", "Vorpal Scythe", levelbyskill(150), "Transfixion", "Scission",""},
		{"Scythe", "Guillotine", levelbyskill(200), "Induration", "", ""},
		{"Scythe", "Cross Reaper", levelbyskill(225), "Distortion", "", ""},
		{"Scythe", "Spiral Hell", levelbyskill(240), "Distortion", "Scission", ""},
		
		{"Staff", "Heavy Swing", levelbyskill(5), "Impaction", "",""},
		{"Staff", "Rock Crusher", levelbyskill(40), "Impaction", "",""},
		{"Staff", "Earth Crusher", levelbyskill(70), "Detonation", "Impaction",""},
		{"Staff", "Starburst", levelbyskill(100), "Compression", "Reverberation",""},
		{"Staff", "Sunburst", levelbyskill(150), "Compression", "Reverberation",""},
		{"Staff", "Shell Crusher", levelbyskill(175), "Detonation", "",""},
		{"Staff", "Full Swing", levelbyskill(200), "Liquefaction", "Impaction",""},
		{"Staff", "Retribution", levelbyskill(230), "Gravitation", "Reverberation",""},		
		
		{"Sword", "Fast Blade", levelbyskill(5), "Scission", "",""},
		{"Sword", "Burning Blade", levelbyskill(30), "Liquefaction", "",""},
		{"Sword", "Red Lotus Blade", levelbyskill(50), "Liquefaction", "Detonation", ""},
		{"Sword", "Flat Blade", levelbyskill(75), "Impaction", "",""},
		{"Sword", "Shining Blade", levelbyskill(100), "Scission", "",""},
		{"Sword", "Seraph Blade", levelbyskill(125), "Scission", "",""},
		{"Sword", "Circle Blade", levelbyskill(150), "Reverberation", "Impaction", ""},
		{"Sword", "Vorpal Blade", levelbyskill(200), "Scission", "Impaction", ""},
		{"Sword", "Swift Blade", levelbyskill(225), "Gravitation", "", ""},
		{"Sword", "Savage Blade", levelbyskill(240), "Fragmentation", "Scission", ""},		
		
		{"Summoner", "Ifrit: Punch", 1, "Liquefaction", "",""},
		{"Summoner", "Shiva: Axe Kick", 1, "Induration", "",""},
		{"Summoner", "Garuda: Claw", 1, "Detonation", "",""},
		{"Summoner", "Titan: Rock Throw", 1, "Scission", "",""},
		{"Summoner", "Ramuh: Shock Strike", 1, "Impaction", "",""},
		{"Summoner", "Leviathan: Barracuda Dive", 1, "Reverberation", "",""},
		{"Summoner", "Diabolos: Camisado", 1, "Compression", "",""},
		{"Summoner", "Carbuncle: Poison Nails", 5, "Transfixion", "",""},
		{"Summoner", "Fenrir: Moonlit Charge", 5, "Compression", "",""},
		{"Summoner", "Fenrir: Crescent Fang", 10, "Transfixion", "",""},
		{"Summoner", "Titan: Rock Buster", 21, "Reverberation", "",""},
		{"Summoner", "Ifrit: Burning Strike", 23, "Impaction", "",""},
		{"Summoner", "Leviathan: Tail Whip", 26, "Detonation", "",""},
		{"Summoner", "Ifrit: Double Punch", 30, "Compression", "",""},
		{"Summoner", "Titan: Megalith Throw", 35, "Induration", "",""},
		{"Summoner", "Shiva: Double Slap", 50, "Scission", "",""},
		{"Summoner", "Fenrir: Eclipse Bite", 65, "Gravitation", "Scission",""},
		{"Summoner", "Ifrit: Flaming Crush", 70, "Fusion", "Reverberation",""},
		{"Summoner", "Titan: Mountain Buster", 70, "Gravitation", "Induration",""},
		{"Summoner", "Leviathan: Spinning Dive", 70, "Distortion", "Detonation",""},
		{"Summoner", "Garuda: Predator Claws", 70, "Fragmentation", "Scission",""},
		{"Summoner", "Shiva: Rush", 70, "Distortion", "Transfixion",""},
		{"Summoner", "Ramuh: Chaotic Strike", 70, "Fragmentation", "Scission",""}
		
		
		}
		

	filter = true;
	member = {};
	local player = AshitaCore:GetMemoryManager():GetPlayer();
	level = player:GetMainJobLevel();
	target = "";
	steps = "";
	
function compilememberskills()	
	
	memberskills = {};

	for i = 1, table.getn(member) do
		
		memberskills[i] = {};
		
		for c = 1, table.getn(skill) do
			
			if(skill[c][1]==member[i]  ) then
			
				if (skill[c][3]<=level or filter ==false) then
				memberskills[i][table.getn(memberskills[i])+1] = skill[c];
				end
				
			end
			
		end
		
	end
	
end

function remove_duplicates(arr)
  -- Create a table to keep track of seen values.  Using a table
  -- for this is generally faster than searching the array repeatedly.
  local seen = {};
  -- Create a new table to store the unique values.  We don't modify
  -- the original array in place, but return a new one.  This is often
  -- safer and more predictable.
  local unique_arr = {};

  -- Iterate over the input array.  #arr gets the length of the array.
  for i = 1, #arr do
    local value = arr[i];
    -- Check if we've seen this value before.  Lua tables use the value
    -- as a key.  If the key doesn't exist, seen[value] is nil.
    if not seen[value] then
      -- If we haven't seen it, mark it as seen by assigning a non-nil
      -- value (true) to seen[value].  The actual value assigned doesn't
      -- matter; we're only interested in the key's existence.
      seen[value] = true;
      -- Add the unique value to our new array.
      table.insert(unique_arr, value);
    end
  end
 return unique_arr;
end

local function printcombos()

	combolist = {};	

	for memberstart = 1, table.getn(member) do

		for memberend = 1, table.getn(member) do

			if memberstart ~= memberend then
			
				for memberstartc = 1, table.getn(memberskills[memberstart]) do
			
					--print(memberskills[memberstart][memberstartc][2]);
					
					for memberendc = 1, table.getn(memberskills[memberend]) do			
		
	
						thecombo = 
						combo(
						
						memberskills[memberstart][memberstartc][4]
						,
						memberskills[memberstart][memberstartc][5]
						,
						memberskills[memberstart][memberstartc][6]
						,
						memberskills[memberend][memberendc][4]
						,
						memberskills[memberend][memberendc][5]
						,
						memberskills[memberend][memberendc][6]
						);
				

						if (thecombo~="") then
							
								for thirdmember = 1, table.getn(member) do
						
									if thirdmember ~= memberstart and thirdmember ~= memberend  then
						
										for thirdmemberc = 1, table.getn(memberskills[thirdmember]) do
										
											thirdcombo = combo(thecombo,"","",memberskills[thirdmember][thirdmemberc][4],
											memberskills[thirdmember][thirdmemberc][5],
											memberskills[thirdmember][thirdmemberc][6]
											)
										
												if (thirdcombo~="") then
												
												
												if (target=="" or (target ~="" and thirdcombo ==target)) then
												
												if (steps~=2) then
												combolist[table.getn(combolist)+1] = memberskills[memberstart][memberstartc][2].." -> "..memberskills[memberend][memberendc][2].." -> "..memberskills[thirdmember][thirdmemberc][2].." = "..thirdcombo;
												end
											end
												
										end
										
									end
						
								end
							end			
						end
				

				
						if (thecombo~="") then
						
							if (target=="" or (target ~="" and thecombo ==target)) then	
								if (steps~=3) then						
									combolist[table.getn(combolist)+1] = memberskills[memberstart][memberstartc][2].." -> "..memberskills[memberend][memberendc][2].." = "..thecombo;
								end
							end
						end
			
				
			
			
					end
				end
			end
		end
	end

combolist = remove_duplicates(combolist);
sortByLastWord(combolist);


end





show_my_dialog = false;


ashita.events.register('command', 'chainy_command', function (e)

    local args = e.command:args();
    if (#args == 1 and args[1]=="/chainy") then
			local player = AshitaCore:GetMemoryManager():GetPlayer();
			level = player:GetMainJobLevel();
        show_my_dialog = not(show_my_dialog);
	end
end)

local tcursor = T{

color = 0xFFFFFFFF,
		font_family = 'Calibri',
		font_height = scaling.scale_f(12),

		position_x = scaling.scale_w(450),
		position_y = scaling.scale_h(-200),	

		visible = true,
		text = "^",
		padding = 0,
		
		background = T{
		visible = false,
		}
			
	}	
	
	
	cursor = fonts.new(tcursor);


ashita.events.register('mouse', '__fontlib_mouse_cb3', function (e)
if (e.message == 512) then
	
	cursor.visible=show_my_dialog;
	
	
	if (scaling.scale_w(e.x) > windowstartx and scaling.scale_w(e.x) < windowendx
	and scaling.scale_h(e.y) > windowstarty and scaling.scale_h(e.y) < windowendy-5
	)  then
	
	cursor.position_x = scaling.scale_w(e.x);
	cursor.position_y = scaling.scale_w(e.y);
		
	end
end
end);




local testcm = AshitaCore:GetChatManager();

windowstartx = 0;
windowendx = 0;
windowstarty = 0;
windowendy = 0;



ashita.events.register('d3d_present', 'present_cb', function ()
if show_my_dialog then
update = false;		
		

    imgui.SetNextWindowBgAlpha(0.5);
	imgui.Begin('Chainy');
    imgui.SetNextWindowSize({ 250, -1, }, ImGuiCond_Always);
	
	imgui.Text(" ");
	imgui.Text("               ");
	imgui.SameLine();
	if(imgui.Button("RESET"))then
		filter = true;
		member = {};
		target = "";
		steps = "";
			
		update = true;
	end
	imgui.SameLine();
	imgui.Text(" ");
	imgui.SameLine();			
	if(imgui.Button("CLOSE"))then
		show_my_dialog=false;
	end		
	imgui.Text(" ");			
	imgui.Separator();	
	
	
	
	
	
	if (filter == true ) then		
		imgui.Text("Estimate available skills based on level: ".."Enabled");		
	else
		imgui.Text("Estimate available skills based on level: ".."Disabled");	
	end
	
	
	if(imgui.Button("Enable (recommended)"))then
		filter = true;
		update = true;
	end	
	if(imgui.Button("Disable"))then
		filter = false;
		update = true;
	end	
	
	imgui.Separator();	
	
	if (steps == "")then	
	imgui.Text("Steps: ".."ANY");		
	else	
	imgui.Text("Steps: "..steps);		
	end	

	if(imgui.Button("Any Steps"))then
	steps = "";
	update = true;
	end	
	if(imgui.Button("2 Steps"))then
	steps = 2;
	update = true;
	end
	if(imgui.Button("3 Steps"))then
	steps = 3;
	update = true;
	end
	
	imgui.Separator();	
	
	if (target == "")then
	imgui.Text("Target Skill Chain:".." ANY");
	else
	imgui.Text("Target Skill Chain: "..target);	
	end
	
	if (imgui.Button("Any Skillchain")) then
	target = "";
		update = true;
	end
	
	--RGB

	imgui.PushStyleColor(ImGuiCol_Button,        {0.30, 0.30, .30, .50}); --dark
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.30, 0.30, .30, .80}); --dark
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.30, 0.30, .30, 1.0}); --dark
	imgui.PushStyleColor(ImGuiCol_Button,        {0.70, 0.80, .80, .50}); --light
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.80, 0.80, .80, .80}); --light	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.80, 0.80, .80, 1.0}); --light	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.40, 0.40, .40, .50}); --distortion
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.40, 0.40, .40, .80}); --distortion
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.40, 0.40, .40, 1.0}); --distortion	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.40, 0.40, .40, .50}); --gravitation
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.40, 0.40, .40, .80}); --gravitation	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.40, 0.40, .40, 1.0}); --gravitation	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.40, 0.40, .40, .50}); --fragmentation
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.40, 0.40, .40, .80}); --fragmentation
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.40, 0.40, .40, 1.0}); --fragmentation	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.40, 0.40, .40, .50}); --fusion
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.40, 0.40, .40, .80}); --fusion	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.40, 0.40, .40, 1.0}); --fusion	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.80, 0.80, .80, .50}); --transfixtion
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.80, 0.80, .80, .80}); --transfixtion	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.80, 0.80, .80, 1.0}); --transfixtion		
	imgui.PushStyleColor(ImGuiCol_Button,        {0.30, 0.30, .30, .50}); --compression
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.30, 0.30, .30, .80}); --compression	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.30, 0.30, .30, 1.0}); --compression	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.50, .50, 1.0, .50}); --induration
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.50, .50, 1.0, .80}); --induration	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.50, .50, 1.0, 1.0}); --induration	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.0, 0.0, 1.0, .50}); --reverberation
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.0, 0.0, 1.0, 1.0}); --reverberation	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.0, 0.0, 1.0, 1.0}); --reverberation	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.70, 0.30, 0.0, .50}); --scission
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.70, 0.30, 0.0, .80}); --scission	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.70, 0.30, 0.0, 1.0}); --scission		
	imgui.PushStyleColor(ImGuiCol_Button,        {0.0, 1.0, 0.0, .50}); --detonation
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.0, 1.0, 0.0, .70}); --detonation
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.0, 1.0, 0.0, 1.0}); --detonation	
	imgui.PushStyleColor(ImGuiCol_Button,        {0.60, 0.0, 1.0, .50}); --impaction
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {0.60, 0.0, 1.0, .80}); --impaction	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {0.60, 0.0, 1.0, 1.0}); --impaction		
	imgui.PushStyleColor(ImGuiCol_Button,        {1.0, 0.0, 0.0, .50});	--liquefaction
	imgui.PushStyleColor(ImGuiCol_ButtonHovered,        {1.0, 0.0, 0.0, .80});	--liquefaction	
	imgui.PushStyleColor(ImGuiCol_ButtonActive,        {1.0, 0.0, 0.0, 1.0});	--liquefaction	
	
	skillbutton = {};
		for x=1, table.getn(skillchains) do
			skillbutton[x] = imgui.Button(skillchains[x]);
			imgui.PopStyleColor(3);
			
			if(skillbutton[x])then
				target = mysplit(skillchains[x]," ")[1];
					update = true;
			end
		end

	imgui.Separator();	













	imgui.Text("Add Weapons");
	button = {};	
	for x=1, table.getn(class) do
		
		button[x] = imgui.Button(class[x]);
		if(x~=5 and x~=8 and x~=12 and x~=#class)then
			imgui.SameLine() 
		end
			
		if(button[x])then
			member[table.getn(member)+1]=class[x];
			update = true;
		end
		
	end
		
	
	imgui.Separator();		
	imgui.Text("Selected Weapons");



	removebutton = {};
	for x=1, table.getn(member) do
		if (x<table.getn(member)+1) then
			c = 0;
			for y=1, x do
				if(member[y]==member[x])then
					c=c+1;
				end
			end
		
		
			if(c>1)then
				removebutton[x] = imgui.Button("- "..member[x].."("..c..")");
			else
				removebutton[x] = imgui.Button("- "..member[x]);
			end
		
		
			if(removebutton[x])then
				table.remove(member,x);
				update = true;
			end	
		end
	end





	if(table.getn(member)<2 or table.getn(combolist)<2) then
		imgui.Separator();	
		imgui.Text("No results");
	else
		imgui.Separator();	
		imgui.Text("Print to Party");
	end

	if(table.getn(member)>1) then

		if (update == true) then

			compilememberskills();
			printcombos();

		end

		combobutton = {};	
		for x=1, table.getn(combolist) do
		
			combobutton[x] = imgui.Button(combolist[x]);
			
			if (combobutton[x]) then
				testcm:QueueCommand(1,"/p "..combolist[x]);
			end
	
		end
	end









		
			x1,y1 = imgui.GetWindowPos();		
			x2,y2 = imgui.GetWindowSize();			
			
			windowstartx = x1;
			windowendx = x1+x2;
			windowstarty = y1;
			windowendy = y1+y2;
		    imgui.End();
		

end	
end)

	  









	compilememberskills();
	printcombos();