--############################
--##### TRIP'S PALADINUI #####
--############################

-- Full credit to Taste

local TMW											= TMW 
local CNDT											= TMW.CNDT
local Env											= CNDT.Env

local A												= Action
local GetToggle										= A.GetToggle
local InterruptIsValid								= A.InterruptIsValid

local UnitCooldown									= A.UnitCooldown
local Unit											= A.Unit 
local Player										= A.Player 
local Pet											= A.Pet
local LoC											= A.LossOfControl
local MultiUnits									= A.MultiUnits
local EnemyTeam										= A.EnemyTeam
local FriendlyTeam									= A.FriendlyTeam
local TeamCache										= A.TeamCache
local InstanceInfo									= A.InstanceInfo
local TR                                            = Action.TasteRotation
local select, setmetatable							= select, setmetatable

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {      
    DateTime = "v1.20 (3 Nov 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_PALADIN_RETRIBUTION] = {          
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },			
            { -- [1] 1st Row		
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
                }, 
                {
                    E = "Checkbox", 
                    DB = "TasteInterruptList",
                    DBV = true,
                    L = { 
                        enUS = "Use BFA Mythic+ & Raid\nsmart interrupt list", 
                        ruRU = "использование BFA Mythic+ & Raid\nумный список прерываний", 
                        frFR = "Liste d'interrupts intelligente\nBFA Mythic+ & Raid",
                    }, 
                    TT = { 
                        enUS = "If Enabled : Will force a special interrupt list containing all the BFA Mythic+ and Raid stuff WHEN YOU ARE IN MYTHIC+ OR RAID ZONE.\nYou can edit this list in the Interrupts tab\nand customize it as you want",
                        ruRU = "Если включено : Запустит специальный список прерываний, содержащий все BFA Mythic+ и Raid stuff КОГДА ВЫ НАХОДИТЕСЬ В МИФИЧЕСКОЙ + ИЛИ ЗОНЕ RAID.\nВы можете редактировать этот список на вкладке Прерывания\nи настраивай как хочешь",
                        frFR = "Si activé : Force une liste d'interruption spéciale contenant tous les éléments BFA Mythic + et Raid QUAND VOUS ETES EN MYTHIC+ OU EN RAID.\nVous pouvez modifier cette liste dans l'onglet Interruptions\net la personnaliser comme vous le souhaitez", 
                    }, 
                    M = {},
                },					
            }, 	
            { -- [7] Spell Status Frame
                {
                    E = "Header",
                    L = {
                        ANY = " -- Spell Status Frame -- ",
                    },
                },
            },	
			{
                {
                    E         = "Button",
                    H         = 35,
                    OnClick = function(self, button, down)     
                        if button == "LeftButton" then 
							TR.ToggleStatusFrame() 
                        else                
                            Action.CraftMacro("Status Frame", [[/run Action.TasteRotation.ToggleStatusFrame()]], 1, true, true)   
                        end 
                    end, 
                    L = { 
                        ANY = "Status Frame\nMacro Creator",
                    }, 
                    TT = { 
                        enUS = "Click this button to create the special status frame macro.\nStatus Frame is a new windows that allow user to track blocked spells during fight. So you don't have to check your chat anymore.", 
                        ruRU = "Нажмите эту кнопку, чтобы создать специальный макрос статуса.\nStatus Frame - это новые окна, которые позволяют пользователю отслеживать заблокированные заклинания во время боя. Так что вам больше не нужно проверять свой чат.",  
                        frFR = "Cliquez sur ce bouton pour créer la macro de cadre d'état spécial.\nLe cadre d'état est une nouvelle fenêtre qui permet à l'utilisateur de suivre les sorts bloqués pendant le combat. Vous n'avez donc plus besoin de vérifier votre chat.", 
                    },                           
                },
			},	
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Defensives -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FoLHP",
                    DBV = 50, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(19750) .. " (%)",
                    }, 
                    M = {},
                },	
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "WoGHP",
                    DBV = 50, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(85673) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DivineShieldHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(642) .. " (%)",
                    }, 
                    M = {},
                },				
            },
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Trinkets -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "TrinketsAoE",
                    DBV = true,
                    L = { 
                        enUS = "Trinkets\nAoE only", 
                        ruRU = "Trinkets\nAoE only",  
                        frFR = "Trinkets\nAoE only",  
                    }, 
                    TT = { 
                        enUS = "Enable this to option to trinkets for AoE usage ONLY.", 
                        ruRU = "Enable this to option to trinkets for AoE usage ONLY.", 
                        frFR = "Enable this to option to trinkets for AoE usage ONLY.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 30,                            
                    DB = "TrinketsMinTTD",
                    DBV = 10, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min TTD",
                    },
                    TT = { 
                        enUS = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        ruRU = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        frFR = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                    },					
                    M = {},
                },
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 10,                            
                    DB = "TrinketsMinUnits",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min Units",
                    },
                    TT = { 
                        enUS = "Minimum number of units in range to activate Trinkets.", 
                        ruRU = "Minimum number of units in range to activate Trinkets.", 
                        frFR = "Minimum number of units in range to activate Trinkets.",  
                    },					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,                            
                    DB = "TrinketsUnitsRange",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Max AoE range",
                    },
                    TT = { 
                        enUS = "Maximum range for units detection to automatically activate trinkets.", 
                        ruRU = "Maximum range for units detection to automatically activate trinkets.", 
                        frFR = "Maximum range for units detection to automatically activate trinkets.",  
                    },					
                    M = {},
                },
			},

            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- PvP -- ",
                    },
                },
            },
            { -- [5] 5th Row     
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "HammerofJusticePvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(853),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@arena1", value = 1 },
                        { text = "@arena2", value = 2 },
                        { text = "@arena3", value = 3 },
                        { text = "primary", value = 4 },
                    },
                    MULT = true,
                    DB = "HammerofJusticePvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(853) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_PALADIN_PROTECTION] = {          
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },			
            { -- [1] 1st Row
		
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
                }, 
                {
                    E = "Checkbox", 
                    DB = "TasteInterruptList",
                    DBV = true,
                    L = { 
                        enUS = "Use BFA Mythic+ & Raid\nsmart interrupt list", 
                        ruRU = "использование BFA Mythic+ & Raid\nумный список прерываний", 
                        frFR = "Liste d'interrupts intelligente\nBFA Mythic+ & Raid",
                    }, 
                    TT = { 
                        enUS = "If Enabled : Will force a special interrupt list containing all the BFA Mythic+ and Raid stuff WHEN YOU ARE IN MYTHIC+ OR RAID ZONE.\nYou can edit this list in the Interrupts tab\nand customize it as you want",
                        ruRU = "Если включено : Запустит специальный список прерываний, содержащий все BFA Mythic+ и Raid stuff КОГДА ВЫ НАХОДИТЕСЬ В МИФИЧЕСКОЙ + ИЛИ ЗОНЕ RAID.\nВы можете редактировать этот список на вкладке Прерывания\nи настраивай как хочешь",
                        frFR = "Si activé : Force une liste d'interruption spéciale contenant tous les éléments BFA Mythic + et Raid QUAND VOUS ETES EN MYTHIC+ OU EN RAID.\nVous pouvez modifier cette liste dans l'onglet Interruptions\net la personnaliser comme vous le souhaitez", 
                    }, 
                    M = {},
                },	                
            }, 
            { -- [7] Spell Status Frame
                {
                    E = "Header",
                    L = {
                        ANY = " -- Spell Status Frame -- ",
                    },
                },
            },	
			{
                {
                    E         = "Button",
                    H         = 35,
                    OnClick = function(self, button, down)     
                        if button == "LeftButton" then 
							TR.ToggleStatusFrame() 
                        else                
                            Action.CraftMacro("Status Frame", [[/run Action.TasteRotation.ToggleStatusFrame()]], 1, true, true)   
                        end 
                    end, 
                    L = { 
                        ANY = "Status Frame\nMacro Creator",
                    }, 
                    TT = { 
                        enUS = "Click this button to create the special status frame macro.\nStatus Frame is a new windows that allow user to track blocked spells during fight. So you don't have to check your chat anymore.", 
                        ruRU = "Нажмите эту кнопку, чтобы создать специальный макрос статуса.\nStatus Frame - это новые окна, которые позволяют пользователю отслеживать заблокированные заклинания во время боя. Так что вам больше не нужно проверять свой чат.",  
                        frFR = "Cliquez sur ce bouton pour créer la macro de cadre d'état spécial.\nLe cadre d'état est une nouvelle fenêtre qui permet à l'utilisateur de suivre les sorts bloqués pendant le combat. Vous n'avez donc plus besoin de vérifier votre chat.", 
                    },                           
                },
                {
                    E = "Checkbox", 
                    DB = "ChangelogOnStartup",
                    DBV = true,
                    L = { 
                        enUS = "Changelog On Startup", 
                        ruRU = "Журнал изменений при запуске", 
                        frFR = "Journal des modifications au démarrage",
                    }, 
                    TT = { 
                        enUS = "Will show latest changelog of the current rotation when you enter in game.\nDisable this option to block the popup when you enter the game.", 
                        ruRU = "При входе в игру будет отображаться последний список изменений текущего вращения.\nОтключить эту опцию, чтобы заблокировать всплывающее окно при входе в игру.", 
                        frFR = "Affiche le dernier journal des modifications de la rotation actuelle lorsque vous entrez dans le jeu.\nDésactivez cette option pour bloquer la fenêtre contextuelle lorsque vous entrez dans le jeu..", 
                    }, 
                    M = {},
                }, 
			},	
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Utilities -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "SmartHoJ",
                    DBV = true,
                    L = { 
                        enUS = "Smart " .. A.GetSpellInfo(853), 
                        ruRU = "Smart " .. A.GetSpellInfo(853), 
                        frFR = "Smart " .. A.GetSpellInfo(853), 
                    }, 
                    TT = { 
                        enUS = "[BETA] Activate the smart " .. A.GetSpellInfo(853) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        ruRU = "[BETA] Activate the smart " .. A.GetSpellInfo(853) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        frFR = "[BETA] Activate the smart " .. A.GetSpellInfo(853) .. " system working with special list for all Battle For Azeroth Mythic dungeon.",   
                    }, 
                    M = {},
                },				
                {
                    E = "Checkbox", 
                    DB = "UseCavalier",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. A.GetSpellInfo(190784), 
                        ruRU = "Авто " .. A.GetSpellInfo(190784), 
                        frFR = "Auto " .. A.GetSpellInfo(190784), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. A.GetSpellInfo(190784), 
                        ruRU = "Автоматически использовать " .. A.GetSpellInfo(190784), 
                        frFR = "Utiliser automatiquement " .. A.GetSpellInfo(190784), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "CavalierTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = A.GetSpellInfo(190784) .. " if moving for",
                        ruRU = A.GetSpellInfo(190784) .. " если переехать",
                        frFR = A.GetSpellInfo(190784) .. " si vous bougez pendant",
                    },
                    TT = { 
                        enUS = "If " .. A.GetSpellInfo(190784) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. A.GetSpellInfo(190784) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. A.GetSpellInfo(190784) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
                    }, 
                    M = {},
                },	
			},
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Defensives -- ",
                    },
                },
            },
            { -- DivineProtection
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(498) .. " -- ",
                    },
                },
            },
            -- DivineProtection
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 15,                            
                    DB = "DivineProtectionTTD",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(498) .. "\nTTD(sec)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "DivineProtectionHP",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(498) .. "\n(%)",
                    }, 
                    M = {},
                },
			},						
            { -- [1] 1st Row  	
			LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },
                {
                    E = "Checkbox", 
                    DB = "ArdentDefenderIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(31850) .. "\nSkip if " .. A.GetSpellInfo(86659) .. " used",
                        ruRU = A.GetSpellInfo(31850) .. "\nSkip if " .. A.GetSpellInfo(86659) .. " used",  
                        frFR = A.GetSpellInfo(31850) .. "\nSkip if " .. A.GetSpellInfo(86659) .. " used", 
                    }, 
                    M = {},
                }, 		    
                {
                    E = "Checkbox", 
                    DB = "ArdentDefenderCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(31850) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(31850) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(31850) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },				
            },
            {	
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "ArdentDefenderTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(12975) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(12975) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(12975) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "ArdentDefenderHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(12975) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(12975) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(12975) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
			
            { -- [1] 1st Row  	
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
                {
                    E = "Checkbox", 
                    DB = "GuardianofAncientKingsCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(86659) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(86659) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(86659) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },
            },
            {	
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "GuardianofAncientKingsTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(86659) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(86659) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(86659) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "GuardianofAncientKingsHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(86659) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(86659) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(86659) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            },			
			{
			LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },
    			{
				RowOptions = { margin = { top = 10 } },
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 70,                            
                    DB = "WordofGloryHPLost",
                    DBV = 15, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. "\n%HP lost per sec",
                    }, 
                    M = {},
                },
    			{
				RowOptions = { margin = { top = 10 } },
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "WordofGloryHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. " (%)",
                    }, 
                    M = {},
                },
    			{
				RowOptions = { margin = { top = 10 } },
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HandoftheProtectorHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(315924) .. " (%)",
                    }, 
                    M = {},
                },		
            },
            {
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
	            {
                    E = "Checkbox", 
                    DB = "LayonHandsCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(633) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(633) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(633) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },	
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ArdentDefenderHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(31850) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AbyssalHealingPotionHP",
                    DBV = 30, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(301308) .. " (%)",
                    }, 
                    M = {},
                },
			},
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ShieldoftheRighteousHPLost",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(53600) .. " (%) lost/sec",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "WordofGloryHPLost",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. " (%) lost/sec",
                    }, 
                    M = {},
                },
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "WordofGloryHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "GuardianofAncientKingsHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(86659) .. " (%)",
                    }, 
                    M = {},
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(299374) .. " -- ",
                    },
                },
            },
            { -- [4] 4th Row
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "LucidDreamTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(299374) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(299374) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(299374) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "LucidDreamHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(299374) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(299374) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(299374) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            },			
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [6]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Party -- ",
                    },
                },
            }, 
            { -- [7]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@party1", value = 1 },
                        { text = "@party2", value = 2 },
                    },
                    MULT = true,
                    DB = "PartyUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                    }, 
                    L = { 
                        ANY = "Party Units",
                    }, 
                    TT = { 
                        enUS = "Enable/Disable relative party passive rotation\nExample : Dispell over party members.", 
                        ruRU = "Включить/Выключить относительно группы пассивную ротацию\nПример: Разогнать членов группы.", 
						frFR = "Active/Désactive la rotation spécifique aux alliés pour les personnes dans le groupe.\nExemple : Dispell automatique sur les membres du groupe.",
                    }, 
                    M = {},
                }, 
        	    {	    
           	        E = "Checkbox", 
           	        DB = "AutoFreedom",
           	        DBV = true,
           	        L = { 
					    enUS = "Auto " .. A.GetSpellInfo(1044),
                        ruRU = "Auto " .. A.GetSpellInfo(1044),
	                },
           	        TT = { 
					    enUS = "Will auto use " .. A.GetSpellInfo(1044) .. " on friendly party units.",
                        ruRU = "Will auto use " .. A.GetSpellInfo(1044) .. " on friendly party units.",
					},
           	        M = {},
        	    },				
            }, 			            
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "UseSotROffensively",
                    DBV = true,
                    L = { 
                        enUS = "Use SotR Offensively", 
                        ruRU = "Используйте SotR в нападении",  
                        frFR = "Utiliser SotR Offensif", 
                    }, 
                    TT = { 
                        enUS = "Enable this setting if you want the addon to suggest Shield of the Righteous as an offensive ability.", 
                        ruRU = "Включите этот параметр, если вы хотите, чтобы аддон предлагал «Щит праведника» в качестве атакующей способности.", 
                        frFR = "Activez ce paramètre si vous souhaitez que l'addon suggère Bouclier des justes comme capacité offensive.",
                    }, 
                    M = {},
                },
    			{
                    E = "Checkbox", 
                    DB = "AutoTaunt",
                    DBV = true,
                    L = { 
                        enUS = "Automatic Taunt", 
                        ruRU = "Автоматическая Насмешка", 
                        frFR = "Raillerie automatique",
                    }, 
                    TT = { 
                        enUS = "If activated, will use automatically use Growl whenever available.", 
                        ruRU = "Если активирован, будет автоматически использовать Growl при любой возможности.",  
                        frFR = "S'il est activé, utilisera automatiquement Growl dès qu'il sera disponible.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ThreatDamagerLimit",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = "Only 'Damager'\nThreat limit(agro,>= %)",
						ruRU = "Только 'Урон'\nЛимит угрозы(агро,>= %)", 
						frFR = "Seulement 'DPS'\nLimite de menace(аggrо,>= %)", 
					}, 
                    TT = { 
                        enUS = "OFF - No limit\nIf the percentage of the threat (agro) is greater than\nor equal to the specified one, then the\n'safe' rotation will be performed. As far as possible, the\nabilities causing too many threats will be stopped until the\nthreat level (agro) is normalized", 
                        ruRU = "OFF - Нет лимита\nЕсли процент угрозы (агро) больше или равен указанному,\nто будет выполняться 'безопасная' ротация\nПо мере возможности перестанут использоваться способности\nвызывающие слишком много угрозы пока\nуровень угрозы (агро) не нормализуется",  
                        frFR = "OFF - Aucune limite\nSi le pourcentage de la menace (agro) est supérieur ou égal à celui spécifié, alors la rotation\n'safe' sera effectuée. Dans la mesure du possible, les \nabilités causant trop de menaces seront arrêtées jusqu'à ce que le\n niveau de menace (agro) soit normalisé",
					},     
                    M = {},
                },
            },
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- PvP -- ",
                    },
                },
            },
            { -- [5] 5th Row     
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "ImprisonPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(217832),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                        frFR = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Seulement si le joueur de mêlée a des buffs de dégâts\nON COOLDOWN - les moyens seront toujours utilisés sur les joueurs de mêlée\nOFF - Coupé de la rotation mais autorisant toujours le travail dans la file d'attente et Systèmes MSG\nSi vous souhaitez l'éteindre complètement, vous devez définir SetBlocker dans l'onglet 'Actions'", 
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@arena1", value = 1 },
                        { text = "@arena2", value = 2 },
                        { text = "@arena3", value = 3 },
                        { text = "primary", value = 4 },
                    },
                    MULT = true,
                    DB = "ImprisonPvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(217832) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },	
        [ACTION_CONST_PALADIN_HOLY] = {          
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },	
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },
            { -- [1]                             
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@mouseover", 
                        ruRU = "Использовать\n@mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "targettarget",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@targettarget", 
                        ruRU = "Использовать\n@targettarget", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions\nfor enemy @targettarget units", 
                        ruRU = "Разблокирует использование\nдействий для вражеских @targettarget юнитов", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use\nAoE", 
                        ruRU = "Использовать\nAoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "DispelSniper",
                    DBV = true,
                    L = { 
                        ANY = "Use Dispel Sniper",  
                    }, 
                    TT = { 
                        ANY = "Automatically swap targets to dispel"
                    }, 
                    M = {},
                }, 				
            }, 	
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Beacons -- ",
                    },
                },
            },	
            { -- [3]  
                RowOptions = { margin = { top = 10 } },		
                {
                    E = "Dropdown",                                                         
                    OT = {   
                        { text = "TANK", value = "TANK" },                    
                        { text = "Mostly Inc. Damage", value = "Mostly Inc. Damage" },
                        { text = "HPS < Inc. Damage", value = "HPS < Inc. Damage" },
                    },
                    DB = "BeaconWorkMode",
                    DBV = "Tanking Units",
                    L = { 
                        ANY = A.GetSpellInfo(53563) .. "\nMode",
                    }, 
                    TT = { 
                        enUS = "These conditions will be skiped if unit will dying in emergency (critical) situation", 
                        ruRU = "Эти условия будут пропущены если юнит будет умирать в чрезвычайной (критической) ситуациии", 
                    },                    
                    M = {},
                },			
            },			
            { -- Trinkets
                {
                    E = "Header",
                    L = {
                        ANY = " -- Trinkets -- ",
                    },
                },
            },	
            {     			
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Always", value = "Always" },
                        { text = "Burst Synchronized", value = "BurstSync" },                    
                    },
                    DB = "TrinketBurstSyncUP",
                    DBV = "Always",
                    L = { 
					    enUS = "Damager: How to use trinkets",
                        ruRU = "Урон: Как использовать аксессуары", 
					},
                    TT = { 
					    enUS = "Always: On cooldown\nBurst Synchronized: By Burst Mode in 'General' tab",
                        ruRU = "Always: По доступности\nBurst Synchronized: От Режима Бурстов во вкладке 'Общее'", 
					}, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketMana",
                    DBV = 85,
                    ONLYOFF = false,
                    L = { 
					    enUS = "Trinket: Mana(%)",
                        ruRU = "Trinket: Mana(%)",
	                },
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketBurstHealing",
                    DBV = 75,
                    ONLYOFF = false,
                    L = { 
					    enUS = "Healer: Target Health (%)",
                        ruRU = "Лекарь: Здоровье Цели (%)", 
	                },
                    M = {},
                },		
		    },
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Mythic + -- ",
                    },
                },
            },	
			{
      	        {
         	        E = "Checkbox", 
         	        DB = "MythicPlusLogic",
         	        DBV = true,
         	        L = { 
					    enUS = "Smart Mythic+",
                        ruRU = "Smart Mythic+",
					},
          	        TT = { 
					    enUS = "Enable this option to activate critical healing logic depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
                        ruRU = "Enable this option to activate critical healing logic depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
					},
        	        M = {},
       	        },	
      	        {
         	        E = "Checkbox", 
         	        DB = "GrievousWoundsLogic",
         	        DBV = true,
         	        L = { 
					    enUS = "Grievous Wounds\nlogic",
                        ruRU = "Grievous Wounds\nlogic",
					},
          	        TT = { 
					    enUS = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
                        ruRU = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
					},
        	        M = {},
       	        },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "GrievousWoundsMinStacks",                    
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = "Grievous Wounds\nmin stacks",                        
                    },   
          	        TT = { 
					    enUS = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
                        ruRU = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
					},					
                    M = {},
                },				
      	        {
         	        E = "Checkbox", 
         	        DB = "StopCastQuake",
         	        DBV = true,
         	        L = { 
					    enUS = "Stop Cast\nquaking",
                        ruRU = "Stop Cast\nquaking",
					},
          	        TT = { 
					    enUS = "Enable this option to automatically stop your current cast before Quake.",
                        ruRU = "Enable this option to automatically stop your current cast before Quake.",
					},
        	        M = {},
       	        },	
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 3,                            
                    DB = "StopCastQuakeSec",                    
                    DBV = 1,
					Precision = 1,
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Cast\nquaking seconds",                      
                    },
          	        TT = { 
					    enUS = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
                        ruRU = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
					},					
                    M = {},
                },
			},
		    -- Divine Shield 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Defensives -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "DivineShield",
                    DBV = 15,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(642) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "BlessingofProtection",
                    DBV = 25,
                    ONOFF = false,
                    L = { 
                        ANY = "Blessing of Protection (%)",
                    }, 
                    M = {},
                },				
            },	

        },
    },
	
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_PALADIN_RETRIBUTION] = { 
            -- MSG Action Pet Dispell
            ["dispell"] = { Enabled = true, Key = "PetDispell", LUA = [[
                return     A.DispellMagic:IsReady(unit, true) and 
                        (
                            ( 
                                not Unit(thisunit):IsEnemy() and 
                                (
                                    (
                                        not InPvP() and 
                                        Env.Dispel(unit)
                                    ) or 
                                    (
                                        InPvP() and 
                                        EnemyTeam():PlayersInRange(1, 5)
                                    ) 
                                )
                            ) or 
                            ( 
                                Unit(thisunit):IsEnemy() and 
                                Unit(thisunit):GetRange() <= 5 and 
                                Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"TotalImun", "DeffBuffsMagic"}, true) 
                            )                
                        ) 
            ]] },
            -- MSG Action Pet Kick
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
            -- MSG Action Fear
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
        },
        [ACTION_CONST_PALADIN_PROTECTION] = { 
            -- MSG Action Pet Dispell
            ["dispell"] = { Enabled = true, Key = "PetDispell", LUA = [[
                return     A.DispellMagic:IsReady(unit, true) and 
                        (
                            ( 
                                not Unit(thisunit):IsEnemy() and 
                                (
                                    (
                                        not InPvP() and 
                                        Env.Dispel(unit)
                                    ) or 
                                    (
                                        InPvP() and 
                                        EnemyTeam():PlayersInRange(1, 5)
                                    ) 
                                )
                            ) or 
                            ( 
                                Unit(thisunit):IsEnemy() and 
                                Unit(thisunit):GetRange() <= 5 and 
                                Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"TotalImun", "DeffBuffsMagic"}, true) 
                            )                
                        ) 
            ]] },
            -- MSG Action Pet Kick
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
            -- MSG Action Fear
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
        },
        [ACTION_CONST_PALADIN_HOLY] = { 
            -- MSG Action Pet Dispell
            ["dispell"] = { Enabled = true, Key = "PetDispell", LUA = [[
                return     A.DispellMagic:IsReady(unit, true) and 
                        (
                            ( 
                                not Unit(thisunit):IsEnemy() and 
                                (
                                    (
                                        not InPvP() and 
                                        Env.Dispel(unit)
                                    ) or 
                                    (
                                        InPvP() and 
                                        EnemyTeam():PlayersInRange(1, 5)
                                    ) 
                                )
                            ) or 
                            ( 
                                Unit(thisunit):IsEnemy() and 
                                Unit(thisunit):GetRange() <= 5 and 
                                Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"TotalImun", "DeffBuffsMagic"}, true) 
                            )                
                        ) 
            ]] },
            -- MSG Action Pet Kick
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
            -- MSG Action Fear
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
        },
    },
}

-----------------------------------------
--                   PvP  
-----------------------------------------

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].SpearHandStrike and A[A.PlayerSpec].SpearHandStrike:IsReadyP(unit, nil, true) and A[A.PlayerSpec].SpearHandStrike:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "ParalysisPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Paralysis and A[A.PlayerSpec].Paralysis:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Paralysis:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 
