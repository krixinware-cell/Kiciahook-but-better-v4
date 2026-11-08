--[[
    kicia_obsidian_ui.lua
    Full Obsidian UI wrapper for KiciaRebuild (kiciahook) — Rivals
    Run this AFTER kiciahook_lua.txt

    REQUIRED: add this one line to kiciahook_lua.txt right after:
        local tbl17: { [string]: any } = { cache = {} }
    add:
        getgenv().KiciaTbl17 = tbl17

    FILL: replace OBSIDIAN_URL below with your Obsidian library raw URL
]]

-- ============================================================
-- BOOT GATE: wait for engine
-- ============================================================
local ENGINE_TIMEOUT = 60
local t0 = os.clock()
repeat task.wait(0.2) until getgenv().KiciaTbl17 or os.clock() - t0 > ENGINE_TIMEOUT
if not getgenv().KiciaTbl17 then
    error("[ObsidianUI] KiciaRebuild engine not found after " .. ENGINE_TIMEOUT .. "s — did you add the getgenv line?")
end

local tbl17 = getgenv().KiciaTbl17
local store  = tbl17.bG()      -- ReactiveStore
getgenv().KiciaStore = store

-- ============================================================
-- OBSIDIAN LIBRARY
-- ============================================================
-- FILL: paste the raw URL to your Obsidian library here
local Library = loadstring(game:HttpGet("OBSIDIAN_URL"))()
local Options  = Library.Options   -- populated as elements are added

-- ============================================================
-- STORE HELPERS
-- ============================================================
local function S(path, val)
    local ok, err = pcall(function() store:Set(path, val) end)
    if not ok then warn("[ObsidianUI] Set failed:", err) end
end

local function G(path, default)
    local ok, val = pcall(function() return store:Get(path) end)
    return (ok and val ~= nil) and val or default
end

local function cfg(path)
    return function(v) S(path, v) end
end

-- ============================================================
-- WINDOW
-- ============================================================
local Window = Library:CreateWindow({
    Title   = "KiciaRebuild | by sussy",
    Center  = true,
    AutoShow = true,
})

-- ============================================================
-- TABS
-- ============================================================
local Tabs = {
    Combat    = Window:AddTab("Combat"),
    ESP       = Window:AddTab("ESP"),
    Visuals   = Window:AddTab("Visuals"),
    Movement  = Window:AddTab("Movement"),
    Misc      = Window:AddTab("Misc"),
    Settings  = Window:AddTab("Settings"),
}

-- ============================================================
-- ============================================================
-- COMBAT TAB
-- ============================================================
-- ============================================================

-- ─── AIMBOT (left) ───────────────────────────────────────────
local AB = Tabs.Combat:AddLeftGroupbox("Aimbot")

AB:AddToggle("AimbotEnabled", {
    Text     = "Enable Aimbot",
    Default  = G({"Aimbot","Enabled"}, false),
    Callback = cfg({"Aimbot","Enabled"}),
})

AB:AddDropdown("AimbotMode", {
    Text    = "Aim Mode",
    Values  = { "Silent", "Mouse" },
    Default = G({"Aimbot","Mode"}, "Mouse"),
    Multi   = false,
    Callback = cfg({"Aimbot","Mode"}),
})

AB:AddSlider("AimbotFovRadius", {
    Text     = "FOV Radius",
    Default  = G({"Aimbot","Fov","Radius"}, 100),
    Min = 0, Max = 500, Rounding = 1,
    Callback = cfg({"Aimbot","Fov","Radius"}),
})

AB:AddSlider("AimbotReactionTime", {
    Text     = "Reaction Time (s)",
    Default  = G({"Aimbot","ReactionTime"}, 0),
    Min = 0, Max = 1.0, Rounding = 3,
    Callback = cfg({"Aimbot","ReactionTime"}),
})

AB:AddSlider("AimbotSwitchDelay", {
    Text     = "Switch Delay (s)",
    Default  = G({"Aimbot","SwitchDelay"}, 0),
    Min = 0, Max = 2.0, Rounding = 3,
    Callback = cfg({"Aimbot","SwitchDelay"}),
})

AB:AddDropdown("AimbotHitboxPoint", {
    Text    = "Hitbox Point",
    Values  = { "Head", "Neck", "Torso", "Closest", "Random" },
    Default = G({"Aimbot","HitboxPoint"}, "Head"),
    Multi   = false,
    Callback = cfg({"Aimbot","HitboxPoint"}),
})

AB:AddDropdown("AimbotHitboxSelection", {
    Text    = "Hitbox Selection",
    Values  = { "Closest To Crosshair", "Closest To Player", "Random" },
    Default = G({"Aimbot","HitboxSelection"}, "Closest To Crosshair"),
    Multi   = false,
    Callback = cfg({"Aimbot","HitboxSelection"}),
})

AB:AddLabel("── Target Conditions ──")

AB:AddToggle("AimbotTCVisible", {
    Text     = "Visible Only",
    Default  = G({"Aimbot","TargetConditions","Visible"}, true),
    Callback = cfg({"Aimbot","TargetConditions","Visible"}),
})

AB:AddToggle("AimbotTCWithinFov", {
    Text     = "Within FOV Only",
    Default  = G({"Aimbot","TargetConditions","WithinFov"}, true),
    Callback = cfg({"Aimbot","TargetConditions","WithinFov"}),
})

AB:AddToggle("AimbotTCVulnerable", {
    Text     = "Vulnerable Only",
    Default  = G({"Aimbot","TargetConditions","Vulnerable"}, false),
    Callback = cfg({"Aimbot","TargetConditions","Vulnerable"}),
})

AB:AddToggle("AimbotTCNotDeflecting", {
    Text     = "Not Deflecting",
    Default  = G({"Aimbot","TargetConditions","NotDeflecting"}, true),
    Callback = cfg({"Aimbot","TargetConditions","NotDeflecting"}),
})

AB:AddToggle("AimbotTCNotShielded", {
    Text     = "Not Shielded",
    Default  = G({"Aimbot","TargetConditions","NotShielded"}, false),
    Callback = cfg({"Aimbot","TargetConditions","NotShielded"}),
})

AB:AddLabel("── FOV Circle ──")

AB:AddToggle("AimbotFovVisible", {
    Text     = "Show FOV Circle",
    Default  = G({"Aimbot","Fov","Circle","Visible"}, true),
    Callback = cfg({"Aimbot","Fov","Circle","Visible"}),
})

AB:AddColorpicker("AimbotFovColor", {
    Text     = "FOV Circle Color",
    Default  = G({"Aimbot","Fov","Circle","Color"}, Color3.fromRGB(255,255,255)),
    Callback = function(v) S({"Aimbot","Fov","Circle","Color"}, v) end,
})

AB:AddToggle("AimbotFovFollow", {
    Text     = "FOV Follows Target",
    Default  = G({"Aimbot","Fov","Circle","FollowTarget","Enabled"}, true),
    Callback = cfg({"Aimbot","Fov","Circle","FollowTarget","Enabled"}),
})

AB:AddSlider("AimbotFovFollowSpeed", {
    Text     = "Follow Speed",
    Default  = G({"Aimbot","Fov","Circle","FollowTarget","Speed"}, 20),
    Min = 1, Max = 100, Rounding = 1,
    Callback = cfg({"Aimbot","Fov","Circle","FollowTarget","Speed"}),
})

AB:AddSlider("AimbotFovFollowDamper", {
    Text     = "Follow Damper",
    Default  = G({"Aimbot","Fov","Circle","FollowTarget","Damper"}, 0.7),
    Min = 0.1, Max = 1.0, Rounding = 2,
    Callback = cfg({"Aimbot","Fov","Circle","FollowTarget","Damper"}),
})

AB:AddSlider("AimbotFovSnapDist", {
    Text     = "Snap Distance",
    Default  = G({"Aimbot","Fov","Circle","FollowTarget","SnapDistance"}, 50),
    Min = 0, Max = 200, Rounding = 1,
    Callback = cfg({"Aimbot","Fov","Circle","FollowTarget","SnapDistance"}),
})

AB:AddLabel("── Target Lock ──")

AB:AddToggle("AimbotTLEnabled", {
    Text     = "Target Lock",
    Default  = G({"Aimbot","TargetLock","Enabled"}, false),
    Callback = cfg({"Aimbot","TargetLock","Enabled"}),
})

AB:AddDropdown("AimbotTLMode", {
    Text    = "Lock Mode",
    Values  = { "Closest", "FOV", "Distance" },
    Default = G({"Aimbot","TargetLock","Mode"}, "Closest"),
    Multi   = false,
    Callback = cfg({"Aimbot","TargetLock","Mode"}),
})

AB:AddKeybind("AimbotTLBind", {
    Text    = "Target Lock Bind",
    Default = Enum.KeyCode.C,
    ChangedCallback = function(v)
        S({"Aimbot","TargetLock","Bind"}, v)
    end,
})

AB:AddKeybind("AimbotBind", {
    Text    = "Aimbot Bind",
    Default = Enum.KeyCode.C,
    ChangedCallback = function(v)
        S({"Aimbot","Bind"}, v)
    end,
})

-- ─── TRIGGERBOT (right) ──────────────────────────────────────
local TB = Tabs.Combat:AddRightGroupbox("Triggerbot")

TB:AddToggle("TrigEnabled", {
    Text     = "Enable Triggerbot",
    Default  = G({"Triggerbot","Enabled"}, false),
    Callback = cfg({"Triggerbot","Enabled"}),
})

TB:AddSlider("TrigReaction", {
    Text     = "Reaction Time (s)",
    Default  = G({"Triggerbot","ReactionTime"}, 0.05),
    Min = 0, Max = 0.5, Rounding = 3,
    Callback = cfg({"Triggerbot","ReactionTime"}),
})

TB:AddSlider("TrigRelease", {
    Text     = "Release Time (s)",
    Default  = G({"Triggerbot","ReleaseTime"}, 0.1),
    Min = 0, Max = 0.5, Rounding = 3,
    Callback = cfg({"Triggerbot","ReleaseTime"}),
})

TB:AddToggle("TrigTCVisible", {
    Text     = "Visible Only",
    Default  = G({"Triggerbot","TargetConditions","Visible"}, true),
    Callback = cfg({"Triggerbot","TargetConditions","Visible"}),
})

TB:AddToggle("TrigTCVulnerable", {
    Text     = "Vulnerable Only",
    Default  = G({"Triggerbot","TargetConditions","Vulnerable"}, false),
    Callback = cfg({"Triggerbot","TargetConditions","Vulnerable"}),
})

TB:AddToggle("TrigTCNotDeflecting", {
    Text     = "Not Deflecting",
    Default  = G({"Triggerbot","TargetConditions","NotDeflecting"}, true),
    Callback = cfg({"Triggerbot","TargetConditions","NotDeflecting"}),
})

TB:AddToggle("TrigTCNotShielded", {
    Text     = "Not Shielded",
    Default  = G({"Triggerbot","TargetConditions","NotShielded"}, false),
    Callback = cfg({"Triggerbot","TargetConditions","NotShielded"}),
})

TB:AddKeybind("TrigBind", {
    Text    = "Triggerbot Bind",
    Default = Enum.KeyCode.None,
    ChangedCallback = function(v)
        S({"Triggerbot","Bind"}, v)
    end,
})

-- ─── FLICKBOT (right, below triggerbot) ──────────────────────
local FB = Tabs.Combat:AddRightGroupbox("Flickbot")

FB:AddToggle("FlickEnabled", {
    Text     = "Enable Flickbot",
    Default  = G({"Flickbot","Enabled"}, false),
    Callback = cfg({"Flickbot","Enabled"}),
})

FB:AddSlider("FlickDuration", {
    Text     = "Flick Duration (ms)",
    Default  = G({"Flickbot","FlickDuration"}, 150),
    Min = 50, Max = 600, Rounding = 1,
    Callback = cfg({"Flickbot","FlickDuration"}),
})

FB:AddSlider("FlickCurvature", {
    Text     = "Curvature",
    Default  = G({"Flickbot","Curvature"}, 0.5),
    Min = 0, Max = 1.0, Rounding = 2,
    Callback = cfg({"Flickbot","Curvature"}),
})

FB:AddSlider("FlickHumanness", {
    Text     = "Humanness",
    Default  = G({"Flickbot","Humanness"}, 0.5),
    Min = 0, Max = 1.0, Rounding = 2,
    Callback = cfg({"Flickbot","Humanness"}),
})

FB:AddToggle("FlickShoot", {
    Text     = "Shoot After Flick",
    Default  = G({"Flickbot","Shoot"}, true),
    Callback = cfg({"Flickbot","Shoot"}),
})

FB:AddSlider("FlickShotDelay", {
    Text     = "Shot Delay (ms)",
    Default  = G({"Flickbot","ShotDelay"}, 50),
    Min = 0, Max = 500, Rounding = 1,
    Callback = cfg({"Flickbot","ShotDelay"}),
})

FB:AddSlider("FlickCooldown", {
    Text     = "Cooldown (ms)",
    Default  = G({"Flickbot","Cooldown"}, 500),
    Min = 0, Max = 5000, Rounding = 1,
    Callback = cfg({"Flickbot","Cooldown"}),
})

FB:AddKeybind("FlickBind", {
    Text    = "Flickbot Bind",
    Default = Enum.KeyCode.None,
    ChangedCallback = function(v)
        S({"Flickbot","Bind"}, v)
    end,
})

-- ─── RAGEBOT (left, below aimbot) ────────────────────────────
local RB = Tabs.Combat:AddLeftGroupbox("Ragebot")

RB:AddToggle("RagebotEnabled", {
    Text     = "Enable Ragebot",
    Default  = G({"Ragebot","Enabled"}, false),
    Callback = cfg({"Ragebot","Enabled"}),
})

RB:AddLabel("── Weapons ──")

RB:AddToggle("RagebotPrimary", {
    Text     = "Primary",
    Default  = G({"Ragebot","Weapons","Enabled","Primary"}, true),
    Callback = cfg({"Ragebot","Weapons","Enabled","Primary"}),
})

RB:AddToggle("RagebotSecondary", {
    Text     = "Secondary",
    Default  = G({"Ragebot","Weapons","Enabled","Secondary"}, true),
    Callback = cfg({"Ragebot","Weapons","Enabled","Secondary"}),
})

RB:AddToggle("RagebotMelee", {
    Text     = "Melee",
    Default  = G({"Ragebot","Weapons","Enabled","Melee"}, false),
    Callback = cfg({"Ragebot","Weapons","Enabled","Melee"}),
})

RB:AddDropdown("RagebotOnEmpty", {
    Text    = "On Empty Weapon",
    Values  = { "Primary", "Secondary", "Melee", "None" },
    Default = G({"Ragebot","Weapons","OnEmpty"}, "None"),
    Multi   = false,
    Callback = cfg({"Ragebot","Weapons","OnEmpty"}),
})

RB:AddSlider("RagebotStability", {
    Text     = "Stability",
    Default  = G({"Ragebot","Stability"}, 0.5),
    Min = 0, Max = 2.0, Rounding = 2,
    Callback = cfg({"Ragebot","Stability"}),
})

RB:AddLabel("── Evasion ──")

RB:AddToggle("RagebotEvasion", {
    Text     = "Enable Evasion",
    Default  = G({"Ragebot","Evasion","Enabled"}, false),
    Callback = cfg({"Ragebot","Evasion","Enabled"}),
})

RB:AddToggle("RagebotProjBreaker", {
    Text     = "Projectile Breaker",
    Default  = G({"Ragebot","Evasion","ProjectileBreaker","Enabled"}, false),
    Callback = cfg({"Ragebot","Evasion","ProjectileBreaker","Enabled"}),
})

RB:AddSlider("RagebotProjInterval", {
    Text     = "Reposition Interval (s)",
    Default  = G({"Ragebot","Evasion","ProjectileBreaker","RepositionInterval"}, 0.5),
    Min = 0.1, Max = 3.0, Rounding = 2,
    Callback = cfg({"Ragebot","Evasion","ProjectileBreaker","RepositionInterval"}),
})

RB:AddToggle("RagebotTranslocate", {
    Text     = "Translocate",
    Default  = G({"Ragebot","Evasion","Translocate","Enabled"}, false),
    Callback = cfg({"Ragebot","Evasion","Translocate","Enabled"}),
})

RB:AddSlider("RagebotTransOffset", {
    Text     = "Translocate Y Offset",
    Default  = G({"Ragebot","Evasion","Translocate","Offset"}, 2),
    Min = -10, Max = 10, Rounding = 1,
    Callback = cfg({"Ragebot","Evasion","Translocate","Offset"}),
})

RB:AddSlider("RagebotRandomRadius", {
    Text     = "Random Base Radius",
    Default  = G({"Ragebot","Evasion","Random","BaseRadius"}, 50),
    Min = 0, Max = 500, Rounding = 1,
    Callback = cfg({"Ragebot","Evasion","Random","BaseRadius"}),
})

RB:AddSlider("RagebotRandomFactor", {
    Text     = "Random Radius Factor",
    Default  = G({"Ragebot","Evasion","Random","RadiusRandomFactor"}, 0.5),
    Min = 0, Max = 2.0, Rounding = 2,
    Callback = cfg({"Ragebot","Evasion","Random","RadiusRandomFactor"}),
})

RB:AddToggle("RagebotRandomAnchor", {
    Text     = "Anchor From Character",
    Default  = G({"Ragebot","Evasion","Random","AnchorFromCharacter"}, false),
    Callback = cfg({"Ragebot","Evasion","Random","AnchorFromCharacter"}),
})

-- ─── ITEM MODIFIERS (right, below flickbot) ──────────────────
local IM = Tabs.Combat:AddRightGroupbox("Item Modifiers")

IM:AddSlider("IMDoubleJumps", {
    Text     = "Max Double Jumps",
    Default  = G({"ItemModifiers","MaxDoubleJumps","Count"}, 1),
    Min = 0, Max = 10, Rounding = 0,
    Callback = cfg({"ItemModifiers","MaxDoubleJumps","Count"}),
})

IM:AddSlider("IMMeleeCooldown", {
    Text     = "Melee Cooldown Mult",
    Default  = G({"ItemModifiers","MeleeCooldown","Percentage"}, 1.0),
    Min = 0.05, Max = 2.0, Rounding = 2,
    Callback = cfg({"ItemModifiers","MeleeCooldown","Percentage"}),
})

IM:AddSlider("IMDashCooldown", {
    Text     = "Dash Cooldown Mult",
    Default  = G({"ItemModifiers","DashCooldown","Percentage"}, 1.0),
    Min = 0.05, Max = 2.0, Rounding = 2,
    Callback = cfg({"ItemModifiers","DashCooldown","Percentage"}),
})

IM:AddSlider("IMAimSpeed", {
    Text     = "Aim Speed Mult",
    Default  = G({"ItemModifiers","AimSpeed","Percentage"}, 1.0),
    Min = 0.05, Max = 2.0, Rounding = 2,
    Callback = cfg({"ItemModifiers","AimSpeed","Percentage"}),
})

IM:AddSlider("IMFireCooldown", {
    Text     = "Fire Cooldown Mult",
    Default  = G({"ItemModifiers","FireCooldown","Percentage"}, 1.0),
    Min = 0.05, Max = 2.0, Rounding = 2,
    Callback = cfg({"ItemModifiers","FireCooldown","Percentage"}),
})

IM:AddSlider("IMShootRecoil", {
    Text     = "Shoot Recoil Mult",
    Default  = G({"ItemModifiers","ShootRecoil","Percentage"}, 1.0),
    Min = 0, Max = 2.0, Rounding = 2,
    Callback = cfg({"ItemModifiers","ShootRecoil","Percentage"}),
})

IM:AddToggle("IMAutomatic", {
    Text     = "Auto Weapon Spam (0 CD)",
    Default  = G({"ItemModifiers","AutomaticWeapon","Enabled"}, false),
    Callback = cfg({"ItemModifiers","AutomaticWeapon","Enabled"}),
})

IM:AddToggle("IMAlwaysBackstab", {
    Text     = "Always Backstab",
    Default  = G({"ItemModifiers","AlwaysBackstab"}, false),
    Callback = cfg({"ItemModifiers","AlwaysBackstab"}),
})

IM:AddToggle("AntiKatana", {
    Text     = "Anti-Katana",
    Default  = G({"AntiKatana","Enabled"}, false),
    Callback = cfg({"AntiKatana","Enabled"}),
})

-- ============================================================
-- ============================================================
-- ESP TAB
-- ============================================================
-- ============================================================

-- ─── MAIN ESP SETTINGS (left) ────────────────────────────────
local ESPMain = Tabs.ESP:AddLeftGroupbox("Main Settings")

ESPMain:AddToggle("EspEnabled", {
    Text     = "Enable ESP",
    Default  = G({"Esp","Main","Enabled"}, false),
    Callback = cfg({"Esp","Main","Enabled"}),
})

ESPMain:AddDropdown("EspMainMode", {
    Text    = "Box Fit",
    Values  = { "Static", "Dynamic" },
    Default = G({"Esp","Main","Mode"}, "Static"),
    Multi   = false,
    Callback = cfg({"Esp","Main","Mode"}),
})

ESPMain:AddToggle("EspUseDisplayName", {
    Text     = "Use Display Names",
    Default  = G({"Esp","Settings","UseDisplayName"}, false),
    Callback = cfg({"Esp","Settings","UseDisplayName"}),
})

ESPMain:AddDropdown("EspFont", {
    Text    = "Font",
    Values  = { "Roboto", "Proggy Clean", "Proggy Tiny", "GothamSemibold", "Ubuntu Mono" },
    Default = G({"Esp","Settings","Font"}, "Roboto"),
    Multi   = false,
    Callback = cfg({"Esp","Settings","Font"}),
})

ESPMain:AddSlider("EspFontSize", {
    Text     = "Font Size",
    Default  = G({"Esp","Settings","FontSize"}, 14),
    Min = 8, Max = 32, Rounding = 0,
    Callback = cfg({"Esp","Settings","FontSize"}),
})

ESPMain:AddDropdown("EspTextCase", {
    Text    = "Text Case",
    Values  = { "Standard", "UPPERCASE", "lowercase" },
    Default = G({"Esp","Settings","TextCase"}, "Standard"),
    Multi   = false,
    Callback = cfg({"Esp","Settings","TextCase"}),
})

ESPMain:AddDropdown("EspTextSurround", {
    Text    = "Text Surround",
    Values  = { "None", "[]", "()", "<>", "{}" },
    Default = G({"Esp","Settings","TextSurround"}, "None"),
    Multi   = false,
    Callback = cfg({"Esp","Settings","TextSurround"}),
})

ESPMain:AddToggle("EspDistScaling", {
    Text     = "Scale With Distance",
    Default  = G({"Esp","Settings","DistanceScaling"}, false),
    Callback = cfg({"Esp","Settings","DistanceScaling"}),
})

ESPMain:AddSlider("EspDistScalingRef", {
    Text     = "Reference Distance",
    Default  = G({"Esp","Settings","DistanceScalingRef"}, 100),
    Min = 10, Max = 300, Rounding = 0,
    Callback = cfg({"Esp","Settings","DistanceScalingRef"}),
})

ESPMain:AddLabel("── Flags ──")

ESPMain:AddDropdown("EspFlagFont", {
    Text    = "Flag Font",
    Values  = { "Roboto", "Proggy Clean", "Proggy Tiny" },
    Default = G({"Esp","Settings","FlagFont"}, "Proggy Clean"),
    Multi   = false,
    Callback = cfg({"Esp","Settings","FlagFont"}),
})

ESPMain:AddSlider("EspFlagFontSize", {
    Text     = "Flag Font Size",
    Default  = G({"Esp","Settings","FlagFontSize"}, 10),
    Min = 6, Max = 24, Rounding = 0,
    Callback = cfg({"Esp","Settings","FlagFontSize"}),
})

ESPMain:AddDropdown("EspFlagTextCase", {
    Text    = "Flag Text Case",
    Values  = { "Standard", "UPPERCASE", "lowercase" },
    Default = G({"Esp","Settings","FlagTextCase"}, "Standard"),
    Multi   = false,
    Callback = cfg({"Esp","Settings","FlagTextCase"}),
})

ESPMain:AddDropdown("EspFlagSurround", {
    Text    = "Flag Surround",
    Values  = { "None", "[]", "()", "<>", "{}" },
    Default = G({"Esp","Settings","FlagTextSurround"}, "None"),
    Multi   = false,
    Callback = cfg({"Esp","Settings","FlagTextSurround"}),
})

ESPMain:AddLabel("── Rank Spoof ──")

ESPMain:AddToggle("EspRankSpoof", {
    Text     = "Spoof Rank",
    Default  = G({"Esp","RankSpoof","Enabled"}, false),
    Callback = cfg({"Esp","RankSpoof","Enabled"}),
})

ESPMain:AddInput("EspRankSpoofText", {
    Text        = "Rank Text",
    Default     = G({"Esp","RankSpoof","Text"}, ""),
    Placeholder = "Rank label...",
    Callback    = cfg({"Esp","RankSpoof","Text"}),
})

ESPMain:AddInput("EspRankSpoofIcon", {
    Text        = "Rank Icon",
    Default     = G({"Esp","RankSpoof","Icon"}, ""),
    Placeholder = "Icon id / emoji...",
    Callback    = cfg({"Esp","RankSpoof","Icon"}),
})

-- ─── ENEMY ESP (left) ────────────────────────────────────────
local EE = Tabs.ESP:AddLeftGroupbox("Enemy ESP")

EE:AddToggle("EspEnemyEnabled", {
    Text     = "Enable Enemy ESP",
    Default  = G({"Esp","Enemy","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Enabled"}),
})

EE:AddLabel("── Name ──")
EE:AddToggle("EspEnemyName", {
    Text = "Name", Default = G({"Esp","Enemy","Name","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Name","Enabled"}),
})
EE:AddColorpicker("EspEnemyNameColor", {
    Text = "Name Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Enemy","Name","Color"}, v) end,
})

EE:AddLabel("── Box ──")
EE:AddToggle("EspEnemyBox", {
    Text = "Box", Default = G({"Esp","Enemy","Box","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Box","Enabled"}),
})
EE:AddColorpicker("EspEnemyBoxColor", {
    Text = "Box Color", Default = Color3.fromRGB(255,0,0),
    Callback = function(v) S({"Esp","Enemy","Box","Color"}, v) end,
})
EE:AddDropdown("EspEnemyBoxStyle", {
    Text = "Box Style", Values = {"Full","Corner"}, Default = "Full", Multi = false,
    Callback = cfg({"Esp","Enemy","Box","Style"}),
})

EE:AddLabel("── Filled Box ──")
EE:AddToggle("EspEnemyFilledBox", {
    Text = "Filled Box", Default = G({"Esp","Enemy","FilledBox","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","FilledBox","Enabled"}),
})
EE:AddColorpicker("EspEnemyFilledBoxColor", {
    Text = "Filled Box Color", Default = Color3.fromRGB(255,0,0),
    Callback = function(v) S({"Esp","Enemy","FilledBox","Color"}, v) end,
})
EE:AddSlider("EspEnemyFilledBoxTransp", {
    Text = "Filled Box Transparency", Default = G({"Esp","Enemy","FilledBox","Transparency"}, 0.7),
    Min = 0, Max = 1, Rounding = 2,
    Callback = cfg({"Esp","Enemy","FilledBox","Transparency"}),
})

EE:AddLabel("── Health Bar ──")
EE:AddToggle("EspEnemyHealthBar", {
    Text = "Health Bar", Default = G({"Esp","Enemy","HealthBar","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","HealthBar","Enabled"}),
})
EE:AddColorpicker("EspEnemyHealthBarColor", {
    Text = "Health Bar Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Enemy","HealthBar","Color"}, v) end,
})
EE:AddDropdown("EspEnemyHealthBarMode", {
    Text = "Color Mode", Values = {"Solid","Gradient","Reactive"}, Default = "Solid", Multi = false,
    Callback = cfg({"Esp","Enemy","HealthBar","ColorMode"}),
})

EE:AddLabel("── Health Number ──")
EE:AddToggle("EspEnemyHealthNum", {
    Text = "Health Number", Default = G({"Esp","Enemy","HealthNumber","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","HealthNumber","Enabled"}),
})
EE:AddColorpicker("EspEnemyHealthNumColor", {
    Text = "Health Number Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Enemy","HealthNumber","Color"}, v) end,
})

EE:AddLabel("── Held Weapon ──")
EE:AddToggle("EspEnemyHeldWeapon", {
    Text = "Held Weapon", Default = G({"Esp","Enemy","HeldWeapon","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","HeldWeapon","Enabled"}),
})
EE:AddColorpicker("EspEnemyHeldWeaponColor", {
    Text = "Weapon Color", Default = Color3.fromRGB(255,230,0),
    Callback = function(v) S({"Esp","Enemy","HeldWeapon","Color"}, v) end,
})

EE:AddLabel("── Ammo Bar ──")
EE:AddToggle("EspEnemyAmmoBar", {
    Text = "Ammo Bar", Default = G({"Esp","Enemy","AmmoBar","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","AmmoBar","Enabled"}),
})
EE:AddColorpicker("EspEnemyAmmoBarColor", {
    Text = "Ammo Bar Color", Default = Color3.fromRGB(255,220,0),
    Callback = function(v) S({"Esp","Enemy","AmmoBar","Color"}, v) end,
})
EE:AddDropdown("EspEnemyAmmoBarMode", {
    Text = "Ammo Color Mode", Values = {"Solid","Gradient","Reactive"}, Default = "Solid", Multi = false,
    Callback = cfg({"Esp","Enemy","AmmoBar","ColorMode"}),
})

EE:AddLabel("── Distance ──")
EE:AddToggle("EspEnemyDist", {
    Text = "Distance", Default = G({"Esp","Enemy","Distance","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Distance","Enabled"}),
})
EE:AddColorpicker("EspEnemyDistColor", {
    Text = "Distance Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Enemy","Distance","Color"}, v) end,
})

EE:AddLabel("── Rank ──")
EE:AddToggle("EspEnemyRank", {
    Text = "Rank", Default = G({"Esp","Enemy","Rank","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Rank","Enabled"}),
})
EE:AddColorpicker("EspEnemyRankColor", {
    Text = "Rank Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Enemy","Rank","Color"}, v) end,
})

EE:AddLabel("── Win Streak ──")
EE:AddToggle("EspEnemyWS", {
    Text = "Win Streak", Default = G({"Esp","Enemy","Winstreak","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Winstreak","Enabled"}),
})
EE:AddColorpicker("EspEnemyWSColor", {
    Text = "Win Streak Color", Default = Color3.fromRGB(255,215,0),
    Callback = function(v) S({"Esp","Enemy","Winstreak","Color"}, v) end,
})

EE:AddLabel("── Deflecting ──")
EE:AddToggle("EspEnemyDeflecting", {
    Text = "Deflecting", Default = G({"Esp","Enemy","Deflecting","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Deflecting","Enabled"}),
})
EE:AddColorpicker("EspEnemyDeflectColor", {
    Text = "Deflecting Color", Default = Color3.fromRGB(0,200,255),
    Callback = function(v) S({"Esp","Enemy","Deflecting","Color"}, v) end,
})

EE:AddLabel("── Chams ──")
EE:AddToggle("EspEnemyChams", {
    Text = "Chams", Default = G({"Esp","Enemy","Chams","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Chams","Enabled"}),
})
EE:AddDropdown("EspEnemyChamsKind", {
    Text = "Chams Kind", Values = {"Legacy","Highlight"}, Default = "Legacy", Multi = false,
    Callback = cfg({"Esp","Enemy","Chams","Kind"}),
})
EE:AddColorpicker("EspEnemyChamsInner", {
    Text = "Fill Color", Default = Color3.fromRGB(255,0,0),
    Callback = function(v) S({"Esp","Enemy","Chams","InnerColor"}, v) end,
})
EE:AddSlider("EspEnemyChamsInnerTransp", {
    Text = "Fill Transparency", Default = G({"Esp","Enemy","Chams","InnerTransparency"}, 0.5),
    Min = 0, Max = 1, Rounding = 2,
    Callback = cfg({"Esp","Enemy","Chams","InnerTransparency"}),
})
EE:AddColorpicker("EspEnemyChamsOutline", {
    Text = "Outline Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Enemy","Chams","OutlineColor"}, v) end,
})
EE:AddSlider("EspEnemyChamsOutlineTransp", {
    Text = "Outline Transparency", Default = G({"Esp","Enemy","Chams","OutlineTransparency"}, 0),
    Min = 0, Max = 1, Rounding = 2,
    Callback = cfg({"Esp","Enemy","Chams","OutlineTransparency"}),
})
EE:AddToggle("EspEnemyChamsGlow", {
    Text = "Glow", Default = G({"Esp","Enemy","Chams","Glow"}, false),
    Callback = cfg({"Esp","Enemy","Chams","Glow"}),
})
EE:AddColorpicker("EspEnemyChamsGlowColor", {
    Text = "Glow Color", Default = Color3.fromRGB(255,0,0),
    Callback = function(v) S({"Esp","Enemy","Chams","GlowColor"}, v) end,
})

EE:AddLabel("── Skeleton ──")
EE:AddToggle("EspEnemySkeleton", {
    Text = "Skeleton", Default = G({"Esp","Enemy","Skeleton","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Skeleton","Enabled"}),
})
EE:AddColorpicker("EspEnemySkeletonColor", {
    Text = "Skeleton Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Enemy","Skeleton","Color"}, v) end,
})
EE:AddSlider("EspEnemySkeletonThick", {
    Text = "Thickness", Default = G({"Esp","Enemy","Skeleton","Thickness"}, 1),
    Min = 1, Max = 6, Rounding = 0,
    Callback = cfg({"Esp","Enemy","Skeleton","Thickness"}),
})

EE:AddLabel("── Head Marker ──")
EE:AddToggle("EspEnemyHM", {
    Text = "Head Marker", Default = G({"Esp","Enemy","HeadMarker","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","HeadMarker","Enabled"}),
})
EE:AddColorpicker("EspEnemyHMColor", {
    Text = "Head Marker Color", Default = Color3.fromRGB(255,0,0),
    Callback = function(v) S({"Esp","Enemy","HeadMarker","Color"}, v) end,
})
EE:AddDropdown("EspEnemyHMShape", {
    Text = "Shape", Values = {"Cross","Circle","Diamond"}, Default = "Cross", Multi = false,
    Callback = cfg({"Esp","Enemy","HeadMarker","Shape"}),
})
EE:AddToggle("EspEnemyHMFilled", {
    Text = "Filled", Default = G({"Esp","Enemy","HeadMarker","Filled"}, false),
    Callback = cfg({"Esp","Enemy","HeadMarker","Filled"}),
})
EE:AddToggle("EspEnemyHMOutline", {
    Text = "Outline", Default = G({"Esp","Enemy","HeadMarker","Outline"}, false),
    Callback = cfg({"Esp","Enemy","HeadMarker","Outline"}),
})
EE:AddColorpicker("EspEnemyHMOutlineColor", {
    Text = "Outline Color", Default = Color3.fromRGB(0,0,0),
    Callback = function(v) S({"Esp","Enemy","HeadMarker","OutlineColor"}, v) end,
})

EE:AddLabel("── Tracer ──")
EE:AddToggle("EspEnemyTracer", {
    Text = "Tracer", Default = G({"Esp","Enemy","Tracer","Enabled"}, false),
    Callback = cfg({"Esp","Enemy","Tracer","Enabled"}),
})
EE:AddColorpicker("EspEnemyTracerColor", {
    Text = "Tracer Color", Default = Color3.fromRGB(255,0,0),
    Callback = function(v) S({"Esp","Enemy","Tracer","Color"}, v) end,
})
EE:AddSlider("EspEnemyTracerThick", {
    Text = "Thickness", Default = G({"Esp","Enemy","Tracer","Thickness"}, 1),
    Min = 1, Max = 6, Rounding = 0,
    Callback = cfg({"Esp","Enemy","Tracer","Thickness"}),
})
EE:AddDropdown("EspEnemyTracerOrigin", {
    Text = "Origin", Values = {"Bottom","Center","Top","Mouse"}, Default = "Bottom", Multi = false,
    Callback = cfg({"Esp","Enemy","Tracer","Origin"}),
})
EE:AddDropdown("EspEnemyTracerTarget", {
    Text = "Target", Values = {"Feet","Head"}, Default = "Feet", Multi = false,
    Callback = cfg({"Esp","Enemy","Tracer","Target"}),
})
EE:AddToggle("EspEnemyTracerOutline", {
    Text = "Tracer Outline", Default = G({"Esp","Enemy","Tracer","Outline"}, false),
    Callback = cfg({"Esp","Enemy","Tracer","Outline"}),
})
EE:AddColorpicker("EspEnemyTracerOutlineColor", {
    Text = "Outline Color", Default = Color3.fromRGB(0,0,0),
    Callback = function(v) S({"Esp","Enemy","Tracer","OutlineColor"}, v) end,
})
EE:AddSlider("EspEnemyTracerOutlineThick", {
    Text = "Outline Thickness", Default = G({"Esp","Enemy","Tracer","OutlineThickness"}, 1),
    Min = 1, Max = 6, Rounding = 0,
    Callback = cfg({"Esp","Enemy","Tracer","OutlineThickness"}),
})

-- ─── TEAM ESP (right, mirrors enemy) ─────────────────────────
local TE = Tabs.ESP:AddRightGroupbox("Teammate ESP")

TE:AddToggle("EspTeamEnabled", {
    Text = "Enable Team ESP", Default = G({"Esp","Team","Enabled"}, false),
    Callback = cfg({"Esp","Team","Enabled"}),
})

TE:AddLabel("── Name ──")
TE:AddToggle("EspTeamName", {
    Text = "Name", Default = G({"Esp","Team","Name","Enabled"}, false),
    Callback = cfg({"Esp","Team","Name","Enabled"}),
})
TE:AddColorpicker("EspTeamNameColor", {
    Text = "Name Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","Name","Color"}, v) end,
})

TE:AddLabel("── Box ──")
TE:AddToggle("EspTeamBox", {
    Text = "Box", Default = G({"Esp","Team","Box","Enabled"}, false),
    Callback = cfg({"Esp","Team","Box","Enabled"}),
})
TE:AddColorpicker("EspTeamBoxColor", {
    Text = "Box Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","Box","Color"}, v) end,
})
TE:AddDropdown("EspTeamBoxStyle", {
    Text = "Box Style", Values = {"Full","Corner"}, Default = "Full", Multi = false,
    Callback = cfg({"Esp","Team","Box","Style"}),
})

TE:AddLabel("── Filled Box ──")
TE:AddToggle("EspTeamFilledBox", {
    Text = "Filled Box", Default = G({"Esp","Team","FilledBox","Enabled"}, false),
    Callback = cfg({"Esp","Team","FilledBox","Enabled"}),
})
TE:AddColorpicker("EspTeamFilledBoxColor", {
    Text = "Filled Box Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","FilledBox","Color"}, v) end,
})

TE:AddLabel("── Health Bar ──")
TE:AddToggle("EspTeamHealthBar", {
    Text = "Health Bar", Default = G({"Esp","Team","HealthBar","Enabled"}, false),
    Callback = cfg({"Esp","Team","HealthBar","Enabled"}),
})
TE:AddColorpicker("EspTeamHealthBarColor", {
    Text = "Health Bar Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","HealthBar","Color"}, v) end,
})
TE:AddDropdown("EspTeamHealthBarMode", {
    Text = "Color Mode", Values = {"Solid","Gradient","Reactive"}, Default = "Solid", Multi = false,
    Callback = cfg({"Esp","Team","HealthBar","ColorMode"}),
})

TE:AddLabel("── Health Number ──")
TE:AddToggle("EspTeamHealthNum", {
    Text = "Health Number", Default = G({"Esp","Team","HealthNumber","Enabled"}, false),
    Callback = cfg({"Esp","Team","HealthNumber","Enabled"}),
})
TE:AddColorpicker("EspTeamHealthNumColor", {
    Text = "Health Number Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Team","HealthNumber","Color"}, v) end,
})

TE:AddLabel("── Held Weapon ──")
TE:AddToggle("EspTeamHeldWeapon", {
    Text = "Held Weapon", Default = G({"Esp","Team","HeldWeapon","Enabled"}, false),
    Callback = cfg({"Esp","Team","HeldWeapon","Enabled"}),
})
TE:AddColorpicker("EspTeamHeldWeaponColor", {
    Text = "Weapon Color", Default = Color3.fromRGB(0,255,100),
    Callback = function(v) S({"Esp","Team","HeldWeapon","Color"}, v) end,
})

TE:AddLabel("── Ammo Bar ──")
TE:AddToggle("EspTeamAmmoBar", {
    Text = "Ammo Bar", Default = G({"Esp","Team","AmmoBar","Enabled"}, false),
    Callback = cfg({"Esp","Team","AmmoBar","Enabled"}),
})
TE:AddColorpicker("EspTeamAmmoBarColor", {
    Text = "Ammo Bar Color", Default = Color3.fromRGB(0,200,255),
    Callback = function(v) S({"Esp","Team","AmmoBar","Color"}, v) end,
})
TE:AddDropdown("EspTeamAmmoBarMode", {
    Text = "Ammo Color Mode", Values = {"Solid","Gradient","Reactive"}, Default = "Solid", Multi = false,
    Callback = cfg({"Esp","Team","AmmoBar","ColorMode"}),
})

TE:AddLabel("── Chams ──")
TE:AddToggle("EspTeamChams", {
    Text = "Chams", Default = G({"Esp","Team","Chams","Enabled"}, false),
    Callback = cfg({"Esp","Team","Chams","Enabled"}),
})
TE:AddDropdown("EspTeamChamsKind", {
    Text = "Chams Kind", Values = {"Legacy","Highlight"}, Default = "Legacy", Multi = false,
    Callback = cfg({"Esp","Team","Chams","Kind"}),
})
TE:AddColorpicker("EspTeamChamsInner", {
    Text = "Fill Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","Chams","InnerColor"}, v) end,
})
TE:AddSlider("EspTeamChamsInnerTransp", {
    Text = "Fill Transparency", Default = G({"Esp","Team","Chams","InnerTransparency"}, 0.5),
    Min = 0, Max = 1, Rounding = 2,
    Callback = cfg({"Esp","Team","Chams","InnerTransparency"}),
})
TE:AddColorpicker("EspTeamChamsOutline", {
    Text = "Outline Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"Esp","Team","Chams","OutlineColor"}, v) end,
})
TE:AddToggle("EspTeamChamsGlow", {
    Text = "Glow", Default = G({"Esp","Team","Chams","Glow"}, false),
    Callback = cfg({"Esp","Team","Chams","Glow"}),
})
TE:AddColorpicker("EspTeamChamsGlowColor", {
    Text = "Glow Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","Chams","GlowColor"}, v) end,
})

TE:AddLabel("── Skeleton ──")
TE:AddToggle("EspTeamSkeleton", {
    Text = "Skeleton", Default = G({"Esp","Team","Skeleton","Enabled"}, false),
    Callback = cfg({"Esp","Team","Skeleton","Enabled"}),
})
TE:AddColorpicker("EspTeamSkeletonColor", {
    Text = "Skeleton Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","Skeleton","Color"}, v) end,
})
TE:AddSlider("EspTeamSkeletonThick", {
    Text = "Thickness", Default = G({"Esp","Team","Skeleton","Thickness"}, 1),
    Min = 1, Max = 6, Rounding = 0,
    Callback = cfg({"Esp","Team","Skeleton","Thickness"}),
})

TE:AddLabel("── Head Marker ──")
TE:AddToggle("EspTeamHM", {
    Text = "Head Marker", Default = G({"Esp","Team","HeadMarker","Enabled"}, false),
    Callback = cfg({"Esp","Team","HeadMarker","Enabled"}),
})
TE:AddColorpicker("EspTeamHMColor", {
    Text = "Head Marker Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","HeadMarker","Color"}, v) end,
})
TE:AddDropdown("EspTeamHMShape", {
    Text = "Shape", Values = {"Cross","Circle","Diamond"}, Default = "Cross", Multi = false,
    Callback = cfg({"Esp","Team","HeadMarker","Shape"}),
})
TE:AddToggle("EspTeamHMFilled", {
    Text = "Filled", Default = G({"Esp","Team","HeadMarker","Filled"}, false),
    Callback = cfg({"Esp","Team","HeadMarker","Filled"}),
})

TE:AddLabel("── Tracer ──")
TE:AddToggle("EspTeamTracer", {
    Text = "Tracer", Default = G({"Esp","Team","Tracer","Enabled"}, false),
    Callback = cfg({"Esp","Team","Tracer","Enabled"}),
})
TE:AddColorpicker("EspTeamTracerColor", {
    Text = "Tracer Color", Default = Color3.fromRGB(0,255,0),
    Callback = function(v) S({"Esp","Team","Tracer","Color"}, v) end,
})
TE:AddSlider("EspTeamTracerThick", {
    Text = "Thickness", Default = G({"Esp","Team","Tracer","Thickness"}, 1),
    Min = 1, Max = 6, Rounding = 0,
    Callback = cfg({"Esp","Team","Tracer","Thickness"}),
})
TE:AddDropdown("EspTeamTracerOrigin", {
    Text = "Origin", Values = {"Bottom","Center","Top","Mouse"}, Default = "Bottom", Multi = false,
    Callback = cfg({"Esp","Team","Tracer","Origin"}),
})
TE:AddDropdown("EspTeamTracerTarget", {
    Text = "Target", Values = {"Feet","Head"}, Default = "Feet", Multi = false,
    Callback = cfg({"Esp","Team","Tracer","Target"}),
})
TE:AddToggle("EspTeamTracerOutline", {
    Text = "Tracer Outline", Default = G({"Esp","Team","Tracer","Outline"}, false),
    Callback = cfg({"Esp","Team","Tracer","Outline"}),
})
TE:AddSlider("EspTeamTracerOutlineThick", {
    Text = "Outline Thickness", Default = G({"Esp","Team","Tracer","OutlineThickness"}, 1),
    Min = 1, Max = 6, Rounding = 0,
    Callback = cfg({"Esp","Team","Tracer","OutlineThickness"}),
})

-- ============================================================
-- ============================================================
-- VISUALS TAB
-- ============================================================
-- ============================================================

-- ─── VIEWMODEL WIREFRAME ─────────────────────────────────────
local VMW = Tabs.Visuals:AddLeftGroupbox("Viewmodel Wireframe")

VMW:AddToggle("VMWArmsEnabled", {
    Text = "Arms Wireframe", Default = G({"ViewModelWireframe","Arms","Enabled"}, false),
    Callback = cfg({"ViewModelWireframe","Arms","Enabled"}),
})
VMW:AddSlider("VMWArmsWidth", {
    Text = "Arms Width", Default = G({"ViewModelWireframe","Arms","Width"}, 1),
    Min = 1, Max = 10, Rounding = 1,
    Callback = cfg({"ViewModelWireframe","Arms","Width"}),
})
VMW:AddColorpicker("VMWArmsColor", {
    Text = "Arms Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"ViewModelWireframe","Arms","Color"}, v) end,
})

VMW:AddToggle("VMWItemEnabled", {
    Text = "Item Wireframe", Default = G({"ViewModelWireframe","Item","Enabled"}, false),
    Callback = cfg({"ViewModelWireframe","Item","Enabled"}),
})
VMW:AddSlider("VMWItemWidth", {
    Text = "Item Width", Default = G({"ViewModelWireframe","Item","Width"}, 1),
    Min = 1, Max = 10, Rounding = 1,
    Callback = cfg({"ViewModelWireframe","Item","Width"}),
})
VMW:AddColorpicker("VMWItemColor", {
    Text = "Item Color", Default = Color3.fromRGB(255,255,255),
    Callback = function(v) S({"ViewModelWireframe","Item","Color"}, v) end,
})

-- ─── VIEWMODEL OFFSET ────────────────────────────────────────
local VMO = Tabs.Visuals:AddRightGroupbox("Viewmodel Offset")

VMO:AddToggle("VMOffsetEnabled", {
    Text = "Enable Viewmodel Offset", Default = G({"ViewModelOffset","Enabled"}, false),
    Callback = cfg({"ViewModelOffset","Enabled"}),
})
VMO:AddSlider("VMOffsetX", {
    Text = "X", Default = G({"ViewModelOffset","X"}, 0), Min = -5, Max = 5, Rounding = 2,
    Callback = cfg({"ViewModelOffset","X"}),
})
VMO:AddSlider("VMOffsetY", {
    Text = "Y", Default = G({"ViewModelOffset","Y"}, 0), Min = -5, Max = 5, Rounding = 2,
    Callback = cfg({"ViewModelOffset","Y"}),
})
VMO:AddSlider("VMOffsetZ", {
    Text = "Z", Default = G({"ViewModelOffset","Z"}, 0), Min = -5, Max = 5, Rounding = 2,
    Callback = cfg({"ViewModelOffset","Z"}),
})
VMO:AddSlider("VMOffsetPitch", {
    Text = "Pitch", Default = G({"ViewModelOffset","Pitch"}, 0), Min = -90, Max = 90, Rounding = 1,
    Callback = cfg({"ViewModelOffset","Pitch"}),
})
VMO:AddSlider("VMOffsetYaw", {
    Text = "Yaw", Default = G({"ViewModelOffset","Yaw"}, 0), Min = -180, Max = 180, Rounding = 1,
    Callback = cfg({"ViewModelOffset","Yaw"}),
})
VMO:AddSlider("VMOffsetRoll", {
    Text = "Roll", Default = G({"ViewModelOffset","Roll"}, 0), Min = -180, Max = 180, Rounding = 1,
    Callback = cfg({"ViewModelOffset","Roll"}),
})

-- ─── WEATHER ─────────────────────────────────────────────────
local WX = Tabs.Visuals:AddLeftGroupbox("Weather")

WX:AddToggle("WeatherEnabled", {
    Text = "Enable Weather", Default = G({"Weather","Enabled"}, false),
    Callback = cfg({"Weather","Enabled"}),
})
WX:AddColorpicker("WeatherColor", {
    Text = "Weather Color", Default = Color3.fromRGB(200,200,220),
    Callback = function(v) S({"Weather","Color"}, v) end,
})
WX:AddDropdown("WeatherPreset", {
    Text = "Preset", Values = {"Snow","Rain","Blizzard"}, Default = "Snow", Multi = false,
    Callback = cfg({"Weather","Preset"}),
})
WX:AddSlider("WeatherIntensity", {
    Text = "Intensity", Default = G({"Weather","Intensity"}, 1), Min = 0, Max = 2, Rounding = 2,
    Callback = cfg({"Weather","Intensity"}),
})
WX:AddSlider("WeatherRate", {
    Text = "Rate", Default = G({"Weather","Rate"}, 1), Min = 0, Max = 3, Rounding = 2,
    Callback = cfg({"Weather","Rate"}),
})
WX:AddSlider("WeatherHeight", {
    Text = "Height", Default = G({"Weather","Height"}, 50), Min = 10, Max = 100, Rounding = 0,
    Callback = cfg({"Weather","Height"}),
})
WX:AddSlider("WeatherSpeed", {
    Text = "Speed", Default = G({"Weather","Speed"}, 1), Min = 0.5, Max = 3, Rounding = 2,
    Callback = cfg({"Weather","Speed"}),
})
WX:AddSlider("WeatherGlow", {
    Text = "Glow", Default = G({"Weather","Glow"}, 0), Min = 0, Max = 1, Rounding = 2,
    Callback = cfg({"Weather","Glow"}),
})
WX:AddSlider("WeatherSize", {
    Text = "Size", Default = G({"Weather","Size"}, 1), Min = 0.5, Max = 2, Rounding = 2,
    Callback = cfg({"Weather","Size"}),
})
WX:AddSlider("WeatherSpread", {
    Text = "Spread", Default = G({"Weather","Spread"}, 1), Min = 0, Max = 3, Rounding = 2,
    Callback = cfg({"Weather","Spread"}),
})
WX:AddSlider("WeatherWindStrength", {
    Text = "Wind Strength", Default = G({"Weather","Wind","Strength"}, 0), Min = 0, Max = 20, Rounding = 1,
    Callback = cfg({"Weather","Wind","Strength"}),
})
WX:AddSlider("WeatherWindAngle", {
    Text = "Wind Angle", Default = G({"Weather","Wind","Angle"}, 0), Min = 0, Max = 360, Rounding = 0,
    Callback = cfg({"Weather","Wind","Angle"}),
})

-- ─── WATERMARK ───────────────────────────────────────────────
local WMK = Tabs.Visuals:AddRightGroupbox("Watermark")

WMK:AddToggle("WatermarkVisible", {
    Text = "Show Watermark", Default = G({"Watermark","Visible"}, true),
    Callback = cfg({"Watermark","Visible"}),
})

-- ============================================================
-- ============================================================
-- MOVEMENT TAB
-- ============================================================
-- ============================================================

local MV = Tabs.Movement:AddLeftGroupbox("Long Jump")

MV:AddToggle("LJEnabled", {
    Text = "Enable Long Jump", Default = G({"Movement","LongJump","Enabled"}, false),
    Callback = cfg({"Movement","LongJump","Enabled"}),
})
MV:AddDropdown("LJMode", {
    Text = "Mode", Values = {"Forward","Under Feet"}, Default = G({"Movement","LongJump","Mode"}, "Forward"),
    Multi = false, Callback = cfg({"Movement","LongJump","Mode"}),
})
MV:AddSlider("LJForce", {
    Text = "Force", Default = G({"Movement","LongJump","Force"}, 100), Min = 0, Max = 600, Rounding = 0,
    Callback = cfg({"Movement","LongJump","Force"}),
})
MV:AddSlider("LJUpVelocity", {
    Text = "Upward Velocity", Default = G({"Movement","LongJump","UpwardVelocity"}, 0), Min = -50, Max = 100, Rounding = 1,
    Callback = cfg({"Movement","LongJump","UpwardVelocity"}),
})
MV:AddSlider("LJBehind", {
    Text = "Behind", Default = G({"Movement","LongJump","Behind"}, 0), Min = -5, Max = 5, Rounding = 2,
    Callback = cfg({"Movement","LongJump","Behind"}),
})
MV:AddKeybind("LJKeybind", {
    Text = "Long Jump Bind", Default = Enum.KeyCode.Space,
    ChangedCallback = function(v) S({"Movement","LongJump","Keybind"}, v) end,
})

-- ============================================================
-- ============================================================
-- MISC TAB
-- ============================================================
-- ============================================================

local MSC = Tabs.Misc:AddLeftGroupbox("Misc")

MSC:AddToggle("SubspaceAutoTrigger", {
    Text = "Subspace Tripmine Auto-Trigger",
    Default = G({"SubspaceTripmines","AutoTrigger"}, false),
    Callback = cfg({"SubspaceTripmines","AutoTrigger"}),
})

MSC:AddToggle("SubspaceTeamTrigger", {
    Text = "Tripmine Allow Team Trigger",
    Default = G({"SubspaceTripmines","TeamTrigger"}, false),
    Callback = cfg({"SubspaceTripmines","TeamTrigger"}),
})

MSC:AddButton({
    Text = "Anti-AFK (Idle Bypass)",
    Func = function()
        local t = getgenv().KiciaTbl17
        if t and t.jg then
            local fn = t.jg()
            if type(fn) == "function" then pcall(fn) end
        end
    end,
    DoubleClick = false,
})

MSC:AddButton({
    Text = "⚠ Unload KiciaRebuild",
    Func = function()
        if getgenv().KiciaRebuild and getgenv().KiciaRebuild.Unload then
            pcall(getgenv().KiciaRebuild.Unload)
        end
        pcall(function() Library:Destroy() end)
    end,
    DoubleClick = true,  -- require double-click to avoid accidents
})

-- ============================================================
-- ============================================================
-- SETTINGS TAB
-- ============================================================
-- ============================================================

-- ─── CONFIG MANAGER ──────────────────────────────────────────
local CFG = Tabs.Settings:AddLeftGroupbox("Config Manager")

CFG:AddInput("ConfigName", {
    Text        = "Config Name",
    Default     = "myconfig",
    Placeholder = "type config name...",
    Callback    = function() end,  -- just stores the value in Options.ConfigName.Value
})

CFG:AddButton({
    Text = "Save Config",
    Func = function()
        local name = Options.ConfigName.Value
        if not name or name == "" then return end
        local ok, err = pcall(function()
            store:SaveToFile(name)
        end)
        if not ok then warn("[ObsidianUI] Save failed:", err) end
    end,
    DoubleClick = false,
})

CFG:AddButton({
    Text = "Load Config",
    Func = function()
        local name = Options.ConfigName.Value
        if not name or name == "" then return end
        local ok, err = pcall(function()
            store:LoadFromFile(name)
        end)
        if not ok then warn("[ObsidianUI] Load failed:", err) end
    end,
    DoubleClick = false,
})

CFG:AddButton({
    Text = "Reset to Defaults",
    Func = function()
        local ok, err = pcall(function()
            store:_ApplyLoadedData(store.Default)
        end)
        if not ok then warn("[ObsidianUI] Reset failed:", err) end
    end,
    DoubleClick = true,
})

-- ─── KEYBINDS ────────────────────────────────────────────────
local KBX = Tabs.Settings:AddRightGroupbox("Keybinds")

KBX:AddKeybind("MenuToggleBind", {
    Text    = "Toggle Menu",
    Default = Enum.KeyCode.Insert,
    ChangedCallback = function(v)
        pcall(function() Library:SetMenuKeybind(v) end)
    end,
})

KBX:AddLabel("All combat binds are set")
KBX:AddLabel("in their respective sections.")

-- ─── LIBRARY INFO ────────────────────────────────────────────
local INFO = Tabs.Settings:AddLeftGroupbox("Info")
INFO:AddLabel("KiciaRebuild — Obsidian UI")
INFO:AddLabel("by sussy | discord.gg/RDeKV57sc5")
INFO:AddLabel("All changes apply live to the engine.")

-- ============================================================
-- DONE
-- ============================================================
print("[ObsidianUI] Loaded — every config mapped.")
