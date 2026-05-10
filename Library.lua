-- MeyyHubLib styled after Library.lua
-- Tính năng: giữ nguyên toàn bộ MeyyHubLib
-- Style: glassmorphism trắng trong, animated gradient strokes, snowflakes, themes

local MeyyHub = {}
MeyyHub.Version = "1.0.0"

local TweenService  = game:GetService("TweenService")
local UserInput     = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local Players       = game:GetService("Players")
local CoreGui       = game:GetService("CoreGui")
local HttpService   = game:GetService("HttpService")
local LocalPlayer   = Players.LocalPlayer

local isfolder   = isfolder   or function() return false end
local makefolder = makefolder or function() end
local writefile  = writefile  or function() end
local readfile   = readfile   or function() return "{}" end
local isfile     = isfile     or function() return false end

MeyyHub.Flags     = {}
MeyyHub.IsLoading = false
MeyyHub._conns    = {}
MeyyHub._gui      = nil
MeyyHub._window   = nil

-- ============================================================
-- LIBRARY.LUA STYLE SYSTEM
-- ============================================================

local UI_Elements = {
    AnimatedGradients  = {},
    AnimatedStrokes    = {},
    RowStrokes         = {},
    RowStrokeGradients = {},
    DivGradients       = {},
    TabGradients       = {},
    Switches           = {},
}

local CurrentTheme = "Sakura"

local Themes = {
    Sakura = {
        MainStroke = Color3.fromRGB(255, 235, 240),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(240, 240, 240)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(140, 140, 140)),
        }),
        TitleStroke = Color3.fromRGB(255, 235, 240),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 210, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 235, 240)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 210, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 235, 240)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 250, 250)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.new(1, 1, 1),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 210, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 235, 240)),
        }),
        ToggleActive = Color3.fromRGB(255, 235, 240),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(220, 240, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 240, 245)),
        }),
        SnowIcon = "129633366976969",
        Accent      = Color3.fromRGB(255, 160, 190),
        AccentDim   = Color3.fromRGB(200, 100, 140),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(220, 200, 210),
        TextDim     = Color3.fromRGB(180, 160, 170),
        Toggle      = Color3.fromRGB(255, 180, 210),
        ToggleOff   = Color3.fromRGB(160, 130, 145),
        Danger      = Color3.fromRGB(255, 100, 120),
        Success     = Color3.fromRGB(120, 220, 160),
        Warning     = Color3.fromRGB(255, 200, 100),
        Scrollbar   = Color3.fromRGB(255, 200, 220),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(255, 245, 250),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(255, 235, 245),
    },
    Moonlight = {
        MainStroke = Color3.fromRGB(180, 180, 180),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(20, 20, 40)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 240)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(20, 20, 40)),
        }),
        TitleStroke = Color3.fromRGB(150, 150, 150),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(200, 200, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(180, 180, 180)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 150, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(150, 150, 150)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
            ColorSequenceKeypoint.new(1,   Color3.new(0, 0, 0)),
        }),
        RowStroke = Color3.fromRGB(100, 100, 100),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 150, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(150, 150, 150)),
        }),
        ToggleActive = Color3.fromRGB(200, 200, 200),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(150, 150, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(150, 150, 150)),
        }),
        SnowIcon = "116750779040036",
        Accent      = Color3.fromRGB(180, 200, 255),
        AccentDim   = Color3.fromRGB(100, 130, 220),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(200, 210, 230),
        TextDim     = Color3.fromRGB(160, 170, 190),
        Toggle      = Color3.fromRGB(180, 210, 255),
        ToggleOff   = Color3.fromRGB(130, 140, 160),
        Danger      = Color3.fromRGB(255, 100, 120),
        Success     = Color3.fromRGB(100, 220, 160),
        Warning     = Color3.fromRGB(255, 200, 80),
        Scrollbar   = Color3.fromRGB(180, 190, 220),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(245, 248, 255),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(230, 235, 255),
    },
    Blue = {
        MainStroke = Color3.new(1, 1, 1),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(180, 180, 180)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 120, 120)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(140, 140, 140)),
        }),
        TitleStroke = Color3.fromRGB(130, 190, 250),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 180, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(200, 240, 255)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 180, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(200, 240, 255)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 220, 255)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.new(1, 1, 1),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 180, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(200, 240, 255)),
        }),
        ToggleActive = Color3.fromRGB(100, 180, 255),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(180, 230, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(180, 230, 255)),
        }),
        SnowIcon = "137906289429512",
        Accent      = Color3.fromRGB(80, 180, 255),
        AccentDim   = Color3.fromRGB(40, 120, 210),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(180, 220, 255),
        TextDim     = Color3.fromRGB(130, 170, 210),
        Toggle      = Color3.fromRGB(80, 190, 255),
        ToggleOff   = Color3.fromRGB(100, 130, 160),
        Danger      = Color3.fromRGB(255, 100, 120),
        Success     = Color3.fromRGB(80, 220, 160),
        Warning     = Color3.fromRGB(255, 200, 80),
        Scrollbar   = Color3.fromRGB(140, 200, 255),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(240, 250, 255),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(220, 240, 255),
    },
    Rose = {
        MainStroke = Color3.fromRGB(255, 180, 180),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(240, 200, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 230)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(240, 200, 200)),
        }),
        TitleStroke = Color3.fromRGB(255, 160, 160),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 160, 180)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 200, 200)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 160, 180)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 200, 200)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 210, 220)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.fromRGB(255, 180, 190),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 160, 180)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 200, 210)),
        }),
        ToggleActive = Color3.fromRGB(255, 160, 180),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 200, 210)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 180, 200)),
        }),
        SnowIcon = "129633366976969",
        Accent      = Color3.fromRGB(255, 100, 140),
        AccentDim   = Color3.fromRGB(200, 60, 100),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(255, 200, 210),
        TextDim     = Color3.fromRGB(220, 160, 180),
        Toggle      = Color3.fromRGB(255, 120, 160),
        ToggleOff   = Color3.fromRGB(180, 120, 140),
        Danger      = Color3.fromRGB(255, 80, 100),
        Success     = Color3.fromRGB(100, 220, 150),
        Warning     = Color3.fromRGB(255, 200, 80),
        Scrollbar   = Color3.fromRGB(255, 170, 190),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(255, 245, 248),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(255, 235, 240),
    },
    Ocean = {
        MainStroke = Color3.fromRGB(100, 200, 255),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(180, 230, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 245, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(160, 210, 240)),
        }),
        TitleStroke = Color3.fromRGB(80, 180, 240),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 190, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(140, 220, 255)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 190, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(140, 220, 255)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 220, 255)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.fromRGB(100, 200, 255),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 190, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(140, 220, 255)),
        }),
        ToggleActive = Color3.fromRGB(0, 200, 255),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(140, 220, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(100, 200, 240)),
        }),
        SnowIcon = "137906289429512",
        Accent      = Color3.fromRGB(0, 190, 255),
        AccentDim   = Color3.fromRGB(0, 130, 200),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(180, 230, 255),
        TextDim     = Color3.fromRGB(130, 190, 220),
        Toggle      = Color3.fromRGB(0, 200, 255),
        ToggleOff   = Color3.fromRGB(100, 150, 180),
        Danger      = Color3.fromRGB(255, 100, 120),
        Success     = Color3.fromRGB(0, 220, 160),
        Warning     = Color3.fromRGB(255, 210, 60),
        Scrollbar   = Color3.fromRGB(120, 210, 255),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(240, 250, 255),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(220, 245, 255),
    },
    Emerald = {
        MainStroke = Color3.fromRGB(100, 220, 160),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(180, 240, 210)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 255, 235)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(160, 230, 200)),
        }),
        TitleStroke = Color3.fromRGB(60, 200, 130),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 200, 130)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(130, 220, 170)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 200, 130)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(130, 220, 170)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 230, 180)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.fromRGB(100, 220, 160),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(60, 200, 130)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(130, 220, 170)),
        }),
        ToggleActive = Color3.fromRGB(60, 210, 140),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(130, 230, 180)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(100, 210, 155)),
        }),
        SnowIcon = "137906289429512",
        Accent      = Color3.fromRGB(48, 210, 130),
        AccentDim   = Color3.fromRGB(26, 150, 90),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(180, 240, 210),
        TextDim     = Color3.fromRGB(130, 200, 170),
        Toggle      = Color3.fromRGB(48, 210, 130),
        ToggleOff   = Color3.fromRGB(100, 160, 130),
        Danger      = Color3.fromRGB(255, 100, 100),
        Success     = Color3.fromRGB(48, 210, 130),
        Warning     = Color3.fromRGB(220, 200, 60),
        Scrollbar   = Color3.fromRGB(100, 210, 160),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(240, 255, 248),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(220, 250, 235),
    },
    Violet = {
        MainStroke = Color3.fromRGB(180, 140, 255),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(210, 190, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 225, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(190, 165, 245)),
        }),
        TitleStroke = Color3.fromRGB(160, 120, 255),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 100, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(210, 180, 255)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 100, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(210, 180, 255)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 170, 255)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.fromRGB(180, 140, 255),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(160, 100, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(210, 180, 255)),
        }),
        ToggleActive = Color3.fromRGB(160, 110, 255),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(200, 175, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(175, 140, 255)),
        }),
        SnowIcon = "116750779040036",
        Accent      = Color3.fromRGB(158, 100, 255),
        AccentDim   = Color3.fromRGB(110, 60, 200),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(210, 190, 255),
        TextDim     = Color3.fromRGB(170, 145, 220),
        Toggle      = Color3.fromRGB(158, 100, 255),
        ToggleOff   = Color3.fromRGB(140, 110, 180),
        Danger      = Color3.fromRGB(255, 90, 110),
        Success     = Color3.fromRGB(80, 210, 140),
        Warning     = Color3.fromRGB(230, 190, 60),
        Scrollbar   = Color3.fromRGB(175, 145, 255),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(248, 244, 255),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(235, 225, 255),
    },
    Amber = {
        MainStroke = Color3.fromRGB(255, 200, 80),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 230, 160)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 245, 200)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(245, 215, 140)),
        }),
        TitleStroke = Color3.fromRGB(245, 180, 40),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(245, 180, 40)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 215, 110)),
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(245, 180, 40)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 215, 110)),
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 130)),
            ColorSequenceKeypoint.new(1,   Color3.new(1, 1, 1)),
        }),
        RowStroke = Color3.fromRGB(255, 200, 80),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(245, 180, 40)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 215, 110)),
        }),
        ToggleActive = Color3.fromRGB(245, 185, 40),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 215, 110)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(245, 185, 80)),
        }),
        SnowIcon = "137906289429512",
        Accent      = Color3.fromRGB(245, 180, 40),
        AccentDim   = Color3.fromRGB(190, 130, 20),
        TextPri     = Color3.new(1, 1, 1),
        TextSec     = Color3.fromRGB(255, 230, 160),
        TextDim     = Color3.fromRGB(220, 190, 110),
        Toggle      = Color3.fromRGB(245, 185, 40),
        ToggleOff   = Color3.fromRGB(180, 150, 80),
        Danger      = Color3.fromRGB(255, 100, 100),
        Success     = Color3.fromRGB(80, 210, 130),
        Warning     = Color3.fromRGB(245, 180, 40),
        Scrollbar   = Color3.fromRGB(245, 200, 100),
        Card        = Color3.fromRGB(255, 255, 255),
        CardHover   = Color3.fromRGB(255, 252, 240),
        Input       = Color3.fromRGB(255, 255, 255),
        Tag         = Color3.fromRGB(255, 245, 210),
    },
}
MeyyHub.Themes = Themes

local function TH() return Themes[CurrentTheme] end

local function normalizeTheme(name)
    if type(name) ~= "string" then return nil end
    if Themes[name] then return name end
    local lower = string.lower(name)
    for k in pairs(Themes) do
        if string.lower(k) == lower then return k end
    end
    return nil
end

local function tw(obj, props, t, s, d)
    pcall(function()
        TweenService:Create(obj,
            TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out),
            props):Play()
    end)
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function pad(p, l, r, t, b)
    local u = Instance.new("UIPadding", p)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    return u
end

local function mkStroke(p, thick, col, mode)
    local s = Instance.new("UIStroke", p)
    s.Thickness = thick or 1
    s.Color = col or TH().RowStroke
    s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    return s
end

local function mkGrad(p, colSeq)
    local g = Instance.new("UIGradient", p)
    g.Color = colSeq or TH().TextGrad
    return g
end

local function listLayout(p, gap, ha, va)
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, gap or 0)
    l.HorizontalAlignment = ha or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va or Enum.VerticalAlignment.Top
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

-- Apply theme function - updates all registered elements
local function applyTheme(name)
    local th = Themes[name]
    if not th then return end
    CurrentTheme = name

    for _, item in pairs(UI_Elements.AnimatedStrokes) do
        if item.Obj and item.Obj.Parent then
            tw(item.Obj, {Color = th[item.Type]})
        end
    end
    for _, s in pairs(UI_Elements.RowStrokes) do
        if s and s.Parent then tw(s, {Color = th.RowStroke}) end
    end
    for _, g in pairs(UI_Elements.AnimatedGradients) do
        if g and g.Parent then g.Color = th.TextGrad end
    end
    for _, g in pairs(UI_Elements.RowStrokeGradients) do
        if g and g.Parent then g.Color = th.RowStrokeGrad end
    end
    for _, g in pairs(UI_Elements.TabGradients) do
        if g and g.Parent then g.Color = th.TabGrad end
    end
    for _, d in pairs(UI_Elements.DivGradients) do
        if d and d.Parent then d.Color = th.DivGrad end
    end
    for _, sw in pairs(UI_Elements.Switches) do
        if sw.track and sw.track.Parent then
            tw(sw.track, {BackgroundColor3 = sw.active and th.ToggleActive or Color3.fromRGB(150,150,150)})
        end
    end
end

MeyyHub.GetThemes = function(self)
    local names = {}
    for k in pairs(Themes) do table.insert(names, k) end
    table.sort(names)
    return names
end

MeyyHub.SetTheme = function(self, name)
    local themeName = normalizeTheme(name)
    if themeName then applyTheme(themeName) end
end

-- ============================================================
-- NOTIFICATION  (Library.lua style)
-- ============================================================
local notifList = {}

function MeyyHub:Notify(cfg)
    cfg = cfg or {}
    local th = TH()

    local sg = Instance.new("ScreenGui")
    sg.Name = "MeyyNotif_" .. math.random(10000, 99999)
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local nf = Instance.new("Frame", sg)
    nf.Name = "Notif"
    nf.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    nf.BackgroundTransparency = 0.3
    nf.Size = UDim2.new(0, 268, 0, 78)
    nf.AnchorPoint = Vector2.new(1, 1)
    nf.Position = UDim2.new(1, 60, 1, -18)
    corner(nf, 10)

    local nStroke = Instance.new("UIStroke", nf)
    nStroke.Thickness = 2.5
    nStroke.Color = th.MainStroke
    table.insert(UI_Elements.AnimatedStrokes, {Obj = nStroke, Type = "MainStroke"})

    local nGrad = mkGrad(nStroke, th.LoopSeq)
    table.insert(UI_Elements.AnimatedGradients, nGrad)

    local bgGrad = mkGrad(nf, ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(240, 248, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(224, 240, 255)),
    }))

    local acBar = Instance.new("Frame", nf)
    acBar.Size = UDim2.new(0, 3, 0.7, 0)
    acBar.Position = UDim2.new(0, 0, 0.15, 0)
    acBar.BackgroundColor3 = cfg.Color or th.Accent
    acBar.BorderSizePixel = 0
    corner(acBar, 2)

    local statusGrads = {}

    local function mkNotifLabel(pos, txt, sz, bold)
        local lbl = Instance.new("TextLabel", nf)
        lbl.Size = UDim2.new(1, -22, 0, 24)
        lbl.Position = UDim2.new(0.5, 0, 0, pos)
        lbl.AnchorPoint = Vector2.new(0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
        lbl.Text = txt
        lbl.TextSize = sz or 12
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local stroke = Instance.new("UIStroke", lbl)
        stroke.Thickness = 1.2
        stroke.Color = th.TitleStroke
        table.insert(UI_Elements.AnimatedStrokes, {Obj = stroke, Type = "TitleStroke"})
        local g = mkGrad(lbl, th.TextGrad)
        table.insert(statusGrads, g)
        table.insert(UI_Elements.AnimatedGradients, g)
        return lbl
    end

    mkNotifLabel(10, cfg.Title or "Notice", 14, true)
    local dl = mkNotifLabel(34, cfg.Content or "", 11, false)
    dl.Size = UDim2.new(1, -22, 0, 30)
    dl.TextWrapped = true

    for i, n in ipairs(notifList) do
        if n and n.Parent then
            tw(n, {Position = UDim2.new(1, -18, 1, -18 - i * 90)}, 0.16)
        end
    end
    table.insert(notifList, 1, nf)
    if #notifList > 6 then
        local old = table.remove(notifList, 7)
        if old then
            tw(old, {Position = UDim2.new(1, 320, 1, old.Position.Y.Offset)}, 0.16)
            task.delay(0.2, function() if old.Parent then old.Parent:Destroy() end end)
        end
    end

    tw(nf, {Position = UDim2.new(1, -18, 1, -18)}, 0.4, Enum.EasingStyle.Back)

    task.delay(cfg.Duration or 4, function()
        for i, n in ipairs(notifList) do
            if n == nf then table.remove(notifList, i) break end
        end
        tw(nf, {Position = UDim2.new(1, 320, 1, nf.Position.Y.Offset)}, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.32, function()
            sg:Destroy()
            for i2, n in ipairs(notifList) do
                if n and n.Parent then
                    tw(n, {Position = UDim2.new(1, -18, 1, -18 - (i2 - 1) * 90)}, 0.16)
                end
            end
        end)
    end)
end
MeyyHub.SendNotification = MeyyHub.Notify

-- ============================================================
-- CONFIG SAVE / LOAD  (original MeyyHub)
-- ============================================================
function MeyyHub:SaveConfig(name, silent)
    local folder = self._folder or "MeyyHub"
    if not isfolder(folder) then makefolder(folder) end
    local d = {}
    for flag, elem in pairs(self.Flags) do d[flag] = elem.Value end
    pcall(writefile, folder .. "/" .. name .. ".json", HttpService:JSONEncode(d))
    if not silent then self:Notify({Title = "Config", Content = "Saved: " .. name}) end
end

function MeyyHub:LoadConfig(name, silent)
    local folder = self._folder or "MeyyHub"
    local path = folder .. "/" .. name .. ".json"
    if not isfile(path) then
        if not silent then self:Notify({Title = "Config", Content = "Not found: " .. name}) end
        return false
    end
    local ok, d = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if ok and type(d) == "table" then
        self.IsLoading = true
        for flag, val in pairs(d) do
            if self.Flags[flag] and self.Flags[flag].Set then
                pcall(self.Flags[flag].Set, val)
            end
        end
        self.IsLoading = false
        if not silent then self:Notify({Title = "Config", Content = "Loaded: " .. name}) end
        return true
    end
    return false
end

-- ============================================================
-- CREATE WINDOW  (Library.lua UI style + MeyyHub features)
-- ============================================================
function MeyyHub:CreateWindow(cfg)
    cfg = cfg or {}

    if self._window then
        warn("[MeyyHub] CreateWindow called more than once — returning nil")
        return nil
    end

    local WIN_W     = (cfg.Size and cfg.Size.X.Offset) or 700
    local WIN_H     = (cfg.Size and cfg.Size.Y.Offset) or 500
    local SIDE_W    = cfg.SideBarWidth or 190
    local TOP_H     = 55
    local FOLDER    = cfg.Folder or "MeyyHub"
    local MinKey    = cfg.ToggleKey or cfg.MinimizeKey or Enum.KeyCode.RightShift
    local Resizable = cfg.Resizable ~= false
    local MacBtns   = cfg.Topbar and cfg.Topbar.ButtonsType == "Mac"

    self._folder = FOLDER

    local themeName = normalizeTheme(cfg.Theme) or "Sakura"
    CurrentTheme = themeName

    if getgenv and getgenv().__MeyyHub_Root then
        pcall(function() getgenv().__MeyyHub_Root:Destroy() end)
    end
    self.Flags  = {}
    self._conns = {}
    UI_Elements.AnimatedGradients  = {}
    UI_Elements.AnimatedStrokes    = {}
    UI_Elements.RowStrokes         = {}
    UI_Elements.RowStrokeGradients = {}
    UI_Elements.DivGradients       = {}
    UI_Elements.TabGradients       = {}
    UI_Elements.Switches           = {}

    local Root = Instance.new("ScreenGui")
    Root.Name = "MeyyHub_" .. math.random(10000, 99999)
    Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Root.ResetOnSpawn = false
    Root.IgnoreGuiInset = true
    pcall(function() Root.Parent = CoreGui end)
    if not Root.Parent then Root.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    if getgenv then getgenv().__MeyyHub_Root = Root end
    self._gui = Root

    local th = TH()

    -- Main Window (glassmorphism white)
    local Win = Instance.new("Frame", Root)
    Win.Name = "Window"
    Win.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Win.BackgroundTransparency = 0.5
    Win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
    Win.Position = UDim2.new(0.5, 0, 0.5, 0)
    Win.AnchorPoint = Vector2.new(0.5, 0.5)
    Win.ClipsDescendants = true
    corner(Win, 15)

    local normalSize = UDim2.new(0, WIN_W, 0, WIN_H)
    local normalPos  = UDim2.new(0.5, 0, 0.5, 0)
    local isMini, isMax, isHidden = false, false, false

    -- Animated main stroke
    local winStroke = Instance.new("UIStroke", Win)
    winStroke.Thickness = 4.5
    winStroke.Color = th.MainStroke
    table.insert(UI_Elements.AnimatedStrokes, {Obj = winStroke, Type = "MainStroke"})
    local winStrokeGrad = mkGrad(winStroke, th.LoopSeq)

    -- Wave background
    local waveBg = Instance.new("Frame", Win)
    waveBg.Name = "WaveBg"
    waveBg.Size = UDim2.new(1, 0, 1, 0)
    waveBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    waveBg.BackgroundTransparency = 0.7
    waveBg.ZIndex = 0
    corner(waveBg, 15)
    local waveGrad = mkGrad(waveBg, th.Wave)

    -- Snow particles
    local SnowContainer = Instance.new("Frame", Win)
    SnowContainer.Name = "SnowContainer"
    SnowContainer.Size = UDim2.new(1, -20, 1, -20)
    SnowContainer.Position = UDim2.new(0, 10, 0, 10)
    SnowContainer.BackgroundTransparency = 1
    SnowContainer.ZIndex = 0
    SnowContainer.ClipsDescendants = true
    corner(SnowContainer, 15)

    task.spawn(function()
        while task.wait(0.18) do
            if not Win.Visible or isMini then continue end
            local flake = Instance.new("ImageLabel", SnowContainer)
            flake.BackgroundTransparency = 1
            flake.Image = "rbxthumb://type=Asset&id=" .. TH().SnowIcon .. "&w=150&h=150"
            local sz = math.random(13, 21)
            flake.Size = UDim2.new(0, sz, 0, sz)
            flake.Position = UDim2.new(math.random(), 0, -0.1, 0)
            flake.ImageTransparency = math.random(2, 6) / 10
            local speed = math.random(40, 75) / 10
            local t2 = TweenService:Create(flake, TweenInfo.new(speed, Enum.EasingStyle.Linear), {
                Position = UDim2.new(flake.Position.X.Scale, 0, 1.1, 0),
                Rotation = math.random(-180, 180),
            })
            t2:Play()
            t2.Completed:Connect(function() flake:Destroy() end)
        end
    end)

    -- Title bar
    local Topbar = Instance.new("Frame", Win)
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, TOP_H)
    Topbar.BackgroundTransparency = 1
    Topbar.ZIndex = 10

    -- Icon
    local titleX = 20
    if cfg.Icon and cfg.Icon ~= "" then
        local ico = Instance.new("ImageLabel", Topbar)
        ico.Size = UDim2.new(0, 22, 0, 22)
        ico.Position = UDim2.new(0, 14, 0.5, 0)
        ico.AnchorPoint = Vector2.new(0, 0.5)
        ico.BackgroundTransparency = 1
        ico.Image = tostring(cfg.Icon):match("^%d+$") and ("rbxassetid://" .. cfg.Icon) or cfg.Icon
        ico.ZIndex = 12
        titleX = 42
    end

    local titleLbl = Instance.new("TextLabel", Topbar)
    titleLbl.Size = UDim2.new(0, 300, 1, 0)
    titleLbl.Position = UDim2.new(0, titleX, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = cfg.Title or "MeyyHub"
    titleLbl.TextColor3 = Color3.new(1, 1, 1)
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local titleStroke = Instance.new("UIStroke", titleLbl)
    titleStroke.Thickness = 1.2
    titleStroke.Color = th.TitleStroke
    titleStroke.Transparency = 0.2
    table.insert(UI_Elements.AnimatedStrokes, {Obj = titleStroke, Type = "TitleStroke"})
    local titleGrad = mkGrad(titleLbl, th.TextGrad)
    table.insert(UI_Elements.AnimatedGradients, titleGrad)

    if cfg.Author and cfg.Author ~= "" then
        local authL = Instance.new("TextLabel", Topbar)
        authL.Size = UDim2.new(0, 200, 0, 14)
        authL.Position = UDim2.new(0, titleX + 2, 0, TOP_H - 16)
        authL.BackgroundTransparency = 1
        authL.Font = Enum.Font.Gotham
        authL.Text = cfg.Author
        authL.TextColor3 = Color3.new(1, 1, 1)
        authL.TextSize = 10
        authL.TextXAlignment = Enum.TextXAlignment.Left
        local aGrad = mkGrad(authL, th.TextGrad)
        table.insert(UI_Elements.AnimatedGradients, aGrad)
    end

    -- Window buttons  (Library.lua style)
    local function mkWinBtn(text, xOff, isDanger)
        local b = Instance.new("TextButton", Topbar)
        b.Size = UDim2.new(0, 30, 0, 30)
        b.Position = MacBtns and UDim2.new(0, xOff, 0.5, 0) or UDim2.new(1, xOff, 0.5, 0)
        b.AnchorPoint = Vector2.new(0, 0.5)
        b.BackgroundTransparency = 1
        b.Font = Enum.Font.GothamBold
        b.Text = text
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 14
        b.ZIndex = 12
        b.AutoButtonColor = false
        local bs = Instance.new("UIStroke", b)
        bs.Thickness = 1
        bs.Color = isDanger and Color3.fromRGB(255,120,120) or th.TitleStroke
        table.insert(UI_Elements.AnimatedStrokes, {Obj = bs, Type = "TitleStroke"})
        local bg = mkGrad(b, isDanger and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,160,160)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,160,160)),
        }) or th.TextGrad)
        table.insert(UI_Elements.AnimatedGradients, bg)
        return b
    end

    local BtnMin, BtnMax, BtnClose
    if MacBtns then
        BtnMin   = mkWinBtn("−", 12, false)
        BtnMax   = mkWinBtn("□", 40, false)
        BtnClose = mkWinBtn("×", 68, true)
    else
        BtnMin   = mkWinBtn("--",  -105, false)
        BtnMax   = mkWinBtn("▢",   -70,  false)
        BtnClose = mkWinBtn("X",   -35,  true)
    end

    -- Top Divider
    local TopDivider = Instance.new("Frame", Win)
    TopDivider.Name = "TopDivider"
    TopDivider.Size = UDim2.new(1, -40, 0, 1)
    TopDivider.Position = UDim2.new(0, 20, 0, TOP_H)
    TopDivider.BackgroundColor3 = Color3.new(1, 1, 1)
    TopDivider.BorderSizePixel = 0
    TopDivider.ZIndex = 3
    local topDivGrad = mkGrad(TopDivider, th.DivGrad)
    topDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    table.insert(UI_Elements.DivGradients, topDivGrad)

    -- Left Divider
    local LeftDivider = Instance.new("Frame", Win)
    LeftDivider.Name = "LeftDivider"
    LeftDivider.Size = UDim2.new(0, 1, 1, -80)
    LeftDivider.Position = UDim2.new(0, SIDE_W, 0, 65)
    LeftDivider.BackgroundColor3 = Color3.new(1, 1, 1)
    LeftDivider.BorderSizePixel = 0
    LeftDivider.ZIndex = 3
    local leftDivGrad = mkGrad(LeftDivider, th.DivGrad)
    leftDivGrad.Rotation = 90
    leftDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    table.insert(UI_Elements.DivGradients, leftDivGrad)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame", Win)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SIDE_W - 10, 1, -75)
    Sidebar.Position = UDim2.new(0, 5, 0, 62)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ZIndex = 2
    local sideLayout = listLayout(Sidebar, 5, Enum.HorizontalAlignment.Center)

    -- Content area
    local ContentArea = Instance.new("ScrollingFrame", Win)
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -(SIDE_W + 20), 1, -(TOP_H + 20))
    ContentArea.Position = UDim2.new(0, SIDE_W + 10, 0, TOP_H + 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ScrollBarThickness = 0
    ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentArea.ZIndex = 2

    -- Open/Toggle button (Library.lua style)
    local OpenBtn = Instance.new("ImageButton", Root)
    OpenBtn.Name = "OpenBtn"
    OpenBtn.Size = UDim2.new(0, 45, 0, 45)
    OpenBtn.Position = UDim2.new(0, 16, 1, -65)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.BackgroundTransparency = 0.5
    OpenBtn.Image = "rbxassetid://6031090990"
    OpenBtn.ZIndex = 50
    OpenBtn.AutoButtonColor = false
    corner(OpenBtn, 23)
    local obStroke = Instance.new("UIStroke", OpenBtn)
    obStroke.Thickness = 2
    obStroke.Color = th.MainStroke
    table.insert(UI_Elements.AnimatedStrokes, {Obj = obStroke, Type = "MainStroke"})
    local obGrad = mkGrad(obStroke, th.LoopSeq)
    table.insert(UI_Elements.AnimatedGradients, obGrad)

    -- Open button drag
    local obDrag, obMoved, obStart, obPos = false, false, nil, nil
    local openCfg = cfg.OpenButton or {}
    local draggableOB = openCfg.Draggable ~= false
    if draggableOB then
        OpenBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                obDrag = true; obMoved = false
                obStart = i.Position; obPos = OpenBtn.Position
            end
        end)
        local cOB = UserInput.InputChanged:Connect(function(i)
            if obDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - obStart
                if d.Magnitude > 5 then obMoved = true end
                OpenBtn.Position = UDim2.new(obPos.X.Scale, obPos.X.Offset + d.X, obPos.Y.Scale, obPos.Y.Offset + d.Y)
            end
        end)
        local cOBE = UserInput.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then obDrag = false end
        end)
        table.insert(self._conns, cOB)
        table.insert(self._conns, cOBE)
    end

    local function toggleUI()
        if isHidden then
            isHidden = false; Win.Visible = true
            local ts = isMini and UDim2.new(0, WIN_W, 0, TOP_H) or (isMax and UDim2.new(1, 0, 1, 0) or normalSize)
            local tp = isMini and UDim2.new(0.5, 0, 0, 22) or normalPos
            Win.Size = UDim2.new(0, 0, 0, 0)
            tw(Win, {Size = ts, Position = tp}, 0.5, Enum.EasingStyle.Back)
        else
            isHidden = true
            tw(Win, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.delay(0.32, function() Win.Visible = false end)
        end
    end

    OpenBtn.MouseButton1Click:Connect(function()
        if not obMoved then toggleUI() end
    end)

    local cKey = UserInput.InputBegan:Connect(function(i, gpe)
        if gpe then return end
        if i.KeyCode == MinKey then toggleUI() end
    end)
    table.insert(self._conns, cKey)

    -- Minimize / Maximize / Close
    local function restoreContent()
        Sidebar.Visible = true
        LeftDivider.Visible = true
        TopDivider.Visible = true
        ContentArea.Visible = true
    end

    -- Dialog function
    local function showDialog(dcfg)
        dcfg = dcfg or {}
        local ovl = Instance.new("Frame", Root)
        ovl.Name = "Overlay"
        ovl.Size = UDim2.new(1, 0, 1, 0)
        ovl.BackgroundColor3 = Color3.new(0, 0, 0)
        ovl.BackgroundTransparency = 0.5
        ovl.ZIndex = 200

        local dlg = Instance.new("Frame", ovl)
        dlg.Name = "Dialog"
        dlg.Size = UDim2.new(0, dcfg.Width or 320, 0, 0)
        dlg.AutomaticSize = Enum.AutomaticSize.Y
        dlg.Position = UDim2.new(0.5, 0, 0.42, 0)
        dlg.AnchorPoint = Vector2.new(0.5, 0.5)
        dlg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dlg.BackgroundTransparency = 0.2
        dlg.ZIndex = 201
        corner(dlg, 12)

        local dlgStroke = Instance.new("UIStroke", dlg)
        dlgStroke.Thickness = 2.5
        dlgStroke.Color = TH().MainStroke
        local dlgStrokeGrad = mkGrad(dlgStroke, TH().LoopSeq)

        listLayout(dlg, 0)
        pad(dlg, 16, 16, 16, 16)

        local dT = Instance.new("TextLabel", dlg)
        dT.LayoutOrder = 1
        dT.Size = UDim2.new(1, 0, 0, 26)
        dT.BackgroundTransparency = 1
        dT.Font = Enum.Font.GothamBold
        dT.Text = dcfg.Title or "Dialog"
        dT.TextColor3 = Color3.new(1, 1, 1)
        dT.TextSize = 15
        dT.TextXAlignment = Enum.TextXAlignment.Left
        local dTGrad = mkGrad(dT, TH().TextGrad)

        local dD = Instance.new("TextLabel", dlg)
        dD.LayoutOrder = 2
        dD.Size = UDim2.new(1, 0, 0, 0)
        dD.AutomaticSize = Enum.AutomaticSize.Y
        dD.BackgroundTransparency = 1
        dD.Font = Enum.Font.Gotham
        dD.Text = dcfg.Content or ""
        dD.TextColor3 = Color3.new(1, 1, 1)
        dD.TextSize = 12
        dD.TextXAlignment = Enum.TextXAlignment.Left
        dD.TextWrapped = true
        dD.TextTruncate = Enum.TextTruncate.None

        local spacer = Instance.new("Frame", dlg)
        spacer.Size = UDim2.new(1, 0, 0, 12)
        spacer.BackgroundTransparency = 1
        spacer.LayoutOrder = 3

        local btnsRow = Instance.new("Frame", dlg)
        btnsRow.Size = UDim2.new(1, 0, 0, 36)
        btnsRow.BackgroundTransparency = 1
        btnsRow.LayoutOrder = 4
        local bRow = listLayout(btnsRow, 8, Enum.HorizontalAlignment.Right)
        bRow.FillDirection = Enum.FillDirection.Horizontal

        local buttons = dcfg.Buttons or {
            {Title = "Cancel", Variant = "Secondary", Callback = function() end},
            {Title = "Close",  Variant = "Primary",   Callback = function()
                tw(Win, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.35, function()
                    for _, c in ipairs(MeyyHub._conns) do pcall(function() c:Disconnect() end) end
                    Root:Destroy(); MeyyHub._window = nil
                end)
            end},
        }

        for _, bcfg in ipairs(buttons) do
            local isPri = bcfg.Variant == "Primary"
            local bb = Instance.new("TextButton", btnsRow)
            bb.Size = UDim2.new(0, 0, 0, 32)
            bb.AutomaticSize = Enum.AutomaticSize.X
            bb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            bb.BackgroundTransparency = isPri and 0.3 or 0.6
            bb.Font = Enum.Font.GothamBold
            bb.Text = bcfg.Title or "OK"
            bb.TextColor3 = Color3.new(1, 1, 1)
            bb.TextSize = 12
            bb.ZIndex = 202
            bb.AutoButtonColor = false
            corner(bb, 7)
            pad(bb, 14, 14, 0, 0)
            local bbGrad = mkGrad(bb, isPri and TH().TextGrad or ColorSequence.new(Color3.new(0.8, 0.8, 0.8)))
            local bbStroke = Instance.new("UIStroke", bb)
            bbStroke.Color = isPri and TH().MainStroke or Color3.new(0.7, 0.7, 0.7)
            bbStroke.Thickness = 1.5
            bb.MouseEnter:Connect(function() tw(bb, {BackgroundTransparency = isPri and 0.1 or 0.4}) end)
            bb.MouseLeave:Connect(function() tw(bb, {BackgroundTransparency = isPri and 0.3 or 0.6}) end)
            bb.MouseButton1Click:Connect(function()
                ovl:Destroy()
                if bcfg.Callback then bcfg.Callback() end
            end)
        end

        dlg.Position = UDim2.new(0.5, 0, 0.36, 0)
        tw(dlg, {Position = UDim2.new(0.5, 0, 0.42, 0)}, 0.3, Enum.EasingStyle.Back)

        ovl.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                tw(dlg, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.delay(0.22, function() ovl:Destroy() end)
            end
        end)
        return ovl
    end

    BtnClose.MouseButton1Click:Connect(function()
        showDialog({
            Title   = "Close UI",
            Content = "Are you sure you want to close the UI?",
            Buttons = {
                {Title = "Cancel", Variant = "Secondary", Callback = function() end},
                {Title = "Close",  Variant = "Primary",   Callback = function()
                    tw(Win, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    task.delay(0.35, function()
                        for _, c in ipairs(MeyyHub._conns) do pcall(function() c:Disconnect() end) end
                        Root:Destroy(); MeyyHub._window = nil
                    end)
                end},
            }
        })
    end)

    BtnMin.MouseButton1Click:Connect(function()
        if not isMini then
            isMini = true; isMax = false
            tw(Win, {Size = UDim2.new(0, WIN_W, 0, TOP_H + 2), Position = UDim2.new(0.5, 0, 0, 22)}, 0.3, Enum.EasingStyle.Quart)
            task.delay(0.04, function()
                Sidebar.Visible = false; LeftDivider.Visible = false
                TopDivider.Visible = false; ContentArea.Visible = false
            end)
        else
            isMini = false
            tw(Win, {Size = normalSize, Position = normalPos}, 0.45, Enum.EasingStyle.Back)
            task.delay(0.18, restoreContent)
        end
    end)

    BtnMax.MouseButton1Click:Connect(function()
        if not isMax then
            isMax = true; isMini = false
            tw(Win, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Quart)
            restoreContent()
        else
            isMax = false
            tw(Win, {Size = normalSize, Position = normalPos}, 0.3, Enum.EasingStyle.Quart)
        end
    end)

    -- Dragging
    local drag, dStart, dWP = false, nil, nil
    Topbar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; dStart = i.Position; dWP = Win.Position
        end
    end)
    local cD1 = UserInput.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dStart
            Win.Position = UDim2.new(dWP.X.Scale, dWP.X.Offset + d.X, dWP.Y.Scale, dWP.Y.Offset + d.Y)
        end
    end)
    local cD2 = UserInput.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    table.insert(self._conns, cD1)
    table.insert(self._conns, cD2)

    -- Resize handle
    if Resizable then
        local rh = Instance.new("Frame", Win)
        rh.Name = "ResizeHandle"
        rh.Size = UDim2.new(0, 18, 0, 18)
        rh.Position = UDim2.new(1, -18, 1, -18)
        rh.BackgroundTransparency = 1
        rh.ZIndex = 12
        local rImg = Instance.new("ImageLabel", rh)
        rImg.Size = UDim2.new(1, 0, 1, 0)
        rImg.BackgroundTransparency = 1
        rImg.Image = "rbxassetid://6031280882"
        rImg.ZIndex = 13
        local rGrad = mkGrad(rImg, th.TextGrad)
        table.insert(UI_Elements.AnimatedGradients, rGrad)

        local MIN_W, MAX_W = 540, 960
        local MIN_H, MAX_H = 340, 640
        local resizing, rsStart, rsWSize = false, nil, nil
        rh.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true; rsStart = i.Position
                rsWSize = Vector2.new(Win.AbsoluteSize.X, Win.AbsoluteSize.Y)
            end
        end)
        local cR1 = UserInput.InputChanged:Connect(function(i)
            if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - rsStart
                local nw = math.clamp(rsWSize.X + d.X, MIN_W, MAX_W)
                local nh = math.clamp(rsWSize.Y + d.Y, MIN_H, MAX_H)
                Win.Size = UDim2.new(0, nw, 0, nh)
                normalSize = UDim2.new(0, nw, 0, nh)
            end
        end)
        local cR2 = UserInput.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
        end)
        table.insert(self._conns, cR1)
        table.insert(self._conns, cR2)
    end

    -- ============================================================
    -- RENDER LOOP  (Library.lua style animations)
    -- ============================================================
    local rotAngle = 0
    local cLoop = RunService.RenderStepped:Connect(function()
        rotAngle = (rotAngle + 1.5) % 360

        winStrokeGrad.Rotation = rotAngle
        winStrokeGrad.Color = TH().LoopSeq

        if waveGrad then
            waveGrad.Rotation = math.sin(tick() * 0.5) * 12
            waveGrad.Offset = Vector2.new(math.sin(tick() * 1.2) * 0.5, 0)
        end

        local animOffset = Vector2.new(math.sin(tick() * 2) * 0.4, 0)
        for _, g in pairs(UI_Elements.AnimatedGradients) do
            if g and g.Parent then g.Offset = animOffset end
        end
        for _, g in pairs(UI_Elements.RowStrokeGradients) do
            if g and g.Parent then g.Offset = animOffset end
        end
        for _, g in pairs(UI_Elements.TabGradients) do
            if g and g.Parent then g.Offset = animOffset end
        end
        -- Sync strokes colors
        for _, item in pairs(UI_Elements.AnimatedStrokes) do
            if item.Obj and item.Obj.Parent then
                local col = TH()[item.Type]
                if col then item.Obj.Color = col end
            end
        end
    end)
    table.insert(self._conns, cLoop)

    -- ============================================================
    -- ELEMENT BUILDER
    -- ============================================================
    local function makeRow(parent, lo, h, auto)
        local row = Instance.new("Frame", parent)
        row.Name = "Row"
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.BackgroundTransparency = 0.8
        if auto then
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.Size = UDim2.new(1, -4, 0, 0)
        else
            row.Size = UDim2.new(1, -4, 0, h or 42)
        end
        row.LayoutOrder = lo or 0
        corner(row, 8)

        local rs = Instance.new("UIStroke", row)
        rs.Color = TH().RowStroke
        rs.Thickness = 1.2
        rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(UI_Elements.RowStrokes, rs)

        local rg = mkGrad(rs, TH().RowStrokeGrad)
        table.insert(UI_Elements.RowStrokeGradients, rg)
        table.insert(UI_Elements.AnimatedGradients, rg)

        row.MouseEnter:Connect(function() tw(row, {BackgroundTransparency = 0.65}) end)
        row.MouseLeave:Connect(function() tw(row, {BackgroundTransparency = 0.8}) end)
        return row
    end

    local function mkLabel(p, txt, font, sz, xa, zi)
        local l = Instance.new("TextLabel", p)
        l.BackgroundTransparency = 1
        l.Font = font or Enum.Font.GothamMedium
        l.Text = txt or ""
        l.TextSize = sz or 13
        l.TextColor3 = Color3.new(1, 1, 1)
        l.TextXAlignment = xa or Enum.TextXAlignment.Left
        l.ZIndex = zi or ((p.ZIndex or 2) + 1)

        local ls = Instance.new("UIStroke", l)
        ls.Thickness = 0.5
        ls.Color = TH().TitleStroke
        ls.Transparency = 0.2
        table.insert(UI_Elements.AnimatedStrokes, {Obj = ls, Type = "TitleStroke"})

        local lg = mkGrad(l, TH().TextGrad)
        table.insert(UI_Elements.AnimatedGradients, lg)
        return l
    end

    local function buildElements(Tab, page)
        local eo = 0
        local function N() eo = eo + 1; return eo end
        local BZ = (page.ZIndex or 2)

        function Tab:Space(h)
            local f = Instance.new("Frame", page)
            f.Size = UDim2.new(1, 0, 0, h or 6)
            f.BackgroundTransparency = 1
            f.LayoutOrder = N()
        end

        function Tab:Divider()
            local div = Instance.new("Frame", page)
            div.Size = UDim2.new(1, -4, 0, 1)
            div.BackgroundColor3 = Color3.new(1, 1, 1)
            div.BorderSizePixel = 0
            div.LayoutOrder = N()
            local dg = mkGrad(div, TH().DivGrad)
            dg.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1),
            })
            table.insert(UI_Elements.DivGradients, dg)
        end

        function Tab:Section(c2)
            c2 = c2 or {}
            if c2.Title and c2.Title ~= "" then
                local sl = Instance.new("TextLabel", page)
                sl.Size = UDim2.new(1, -10, 0, 20)
                sl.BackgroundTransparency = 1
                sl.Font = Enum.Font.GothamBold
                sl.Text = (c2.Title or ""):upper()
                sl.TextSize = 10
                sl.TextColor3 = Color3.new(1, 1, 1)
                sl.TextXAlignment = Enum.TextXAlignment.Left
                sl.LayoutOrder = N()
                local sg2 = mkGrad(sl, TH().TextGrad)
                table.insert(UI_Elements.AnimatedGradients, sg2)
            end
        end

        function Tab:Paragraph(c2)
            c2 = c2 or {}
            local row = makeRow(page, N(), nil, true)
            listLayout(row, 4)
            pad(row, 13, 13, 10, 10)

            if c2.Title and c2.Title ~= "" then
                local tl = mkLabel(row, c2.Title, Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
                tl.Size = UDim2.new(1, 0, 0, 0)
                tl.AutomaticSize = Enum.AutomaticSize.Y
                tl.LayoutOrder = 1
                tl.TextWrapped = true
                tl.TextTruncate = Enum.TextTruncate.None
            end
            if c2.Content and c2.Content ~= "" then
                local dl = Instance.new("TextLabel", row)
                dl.Size = UDim2.new(1, 0, 0, 0)
                dl.AutomaticSize = Enum.AutomaticSize.Y
                dl.BackgroundTransparency = 1
                dl.Font = Enum.Font.Gotham
                dl.Text = c2.Content
                dl.TextSize = 11
                dl.TextColor3 = Color3.new(1, 1, 1)
                dl.TextXAlignment = Enum.TextXAlignment.Left
                dl.TextWrapped = true
                dl.TextTruncate = Enum.TextTruncate.None
                dl.LayoutOrder = 2
                local dlg2 = mkGrad(dl, TH().TextGrad)
                table.insert(UI_Elements.AnimatedGradients, dlg2)
            end
        end

        function Tab:Label(c2)
            c2 = c2 or {}
            Tab:Paragraph({Title = c2.Title or c2.Text, Content = c2.Content or c2.Desc})
        end

        function Tab:Button(c2)
            c2 = c2 or {}
            local hasDesc = c2.Desc and c2.Desc ~= ""
            local h = hasDesc and 56 or 42
            local row = makeRow(page, N(), h)

            local acBar = Instance.new("Frame", row)
            acBar.Size = UDim2.new(0, 3, 0.55, 0)
            acBar.Position = UDim2.new(0, 0, 0.5, 0)
            acBar.AnchorPoint = Vector2.new(0, 0.5)
            acBar.BackgroundColor3 = c2.Color or TH().Accent
            acBar.BorderSizePixel = 0
            corner(acBar, 2)

            local tl = mkLabel(row, c2.Title or "Button", Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(1, -16, 0, hasDesc and 22 or h)
            tl.Position = UDim2.new(0, 16, 0, hasDesc and 8 or 0)

            if hasDesc then
                local dl = Instance.new("TextLabel", row)
                dl.Size = UDim2.new(1, -16, 0, 18)
                dl.Position = UDim2.new(0, 16, 0, 28)
                dl.BackgroundTransparency = 1
                dl.Font = Enum.Font.Gotham
                dl.Text = c2.Desc
                dl.TextSize = 10
                dl.TextColor3 = Color3.new(1, 1, 1)
                dl.TextXAlignment = Enum.TextXAlignment.Left
                local dlg2 = mkGrad(dl, TH().TextGrad)
                table.insert(UI_Elements.AnimatedGradients, dlg2)
            end

            local cz = Instance.new("TextButton", row)
            cz.Size = UDim2.new(1, 0, 1, 0)
            cz.BackgroundTransparency = 1
            cz.Text = ""
            cz.ZIndex = row.ZIndex + 3

            cz.MouseButton1Down:Connect(function()
                tw(row, {BackgroundTransparency = 0.6}, 0.08)
            end)
            cz.MouseButton1Up:Connect(function()
                tw(row, {BackgroundTransparency = 0.8}, 0.1)
            end)
            cz.MouseButton1Click:Connect(function()
                if c2.Callback then c2.Callback() end
                MeyyHub:Notify({Title = "Button", Content = c2.Title or ""})
            end)

            local El = {}
            function El:SetTitle(t2) tl.Text = t2 end
            function El:Lock()   cz.Active = false end
            function El:Unlock() cz.Active = true end
            return El
        end

        function Tab:Toggle(c2)
            c2 = c2 or {}
            local hasDesc = c2.Desc and c2.Desc ~= ""
            local h = hasDesc and 56 or 42
            local row = makeRow(page, N(), h)
            local active = c2.Value == true
            local isCheck = c2.Type == "Checkbox"

            local tl = mkLabel(row, c2.Title or "Toggle", Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(1, -62, 0, hasDesc and 22 or h)
            tl.Position = UDim2.new(0, 15, 0, hasDesc and 8 or 0)

            if hasDesc then
                local dl = Instance.new("TextLabel", row)
                dl.Size = UDim2.new(1, -62, 0, 18)
                dl.Position = UDim2.new(0, 15, 0, 28)
                dl.BackgroundTransparency = 1
                dl.Font = Enum.Font.Gotham
                dl.Text = c2.Desc
                dl.TextSize = 10
                dl.TextColor3 = Color3.new(1, 1, 1)
                dl.TextXAlignment = Enum.TextXAlignment.Left
                local dlg2 = mkGrad(dl, TH().TextGrad)
                table.insert(UI_Elements.AnimatedGradients, dlg2)
            end

            local track, knob, chkIcon
            local sw = {active = active}

            if isCheck then
                track = Instance.new("Frame", row)
                track.Size = UDim2.new(0, 22, 0, 22)
                track.Position = UDim2.new(1, -42, 0.5, 0)
                track.AnchorPoint = Vector2.new(0, 0.5)
                track.BackgroundColor3 = active and TH().ToggleActive or Color3.fromRGB(150,150,150)
                corner(track, 5)
                chkIcon = Instance.new("TextLabel", track)
                chkIcon.Size = UDim2.new(1, 0, 1, 0)
                chkIcon.BackgroundTransparency = 1
                chkIcon.Font = Enum.Font.GothamBold
                chkIcon.Text = active and "✓" or ""
                chkIcon.TextColor3 = Color3.new(1, 1, 1)
                chkIcon.TextSize = 14
                chkIcon.TextXAlignment = Enum.TextXAlignment.Center
                sw.track = track

                local function Set(v)
                    active = v; sw.active = v
                    tw(track, {BackgroundColor3 = v and TH().ToggleActive or Color3.fromRGB(150,150,150)})
                    chkIcon.Text = v and "✓" or ""
                    if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value = v end
                    if c2.Callback then c2.Callback(v) end
                    if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
                end
                if c2.Flag then MeyyHub.Flags[c2.Flag] = {Value = active, Set = Set} end
                table.insert(UI_Elements.Switches, sw)
                local cz = Instance.new("TextButton", row)
                cz.Size = UDim2.new(1, 0, 1, 0)
                cz.BackgroundTransparency = 1
                cz.Text = ""
                cz.ZIndex = row.ZIndex + 4
                cz.MouseButton1Click:Connect(function()
                    if not c2.Locked then Set(not active) end
                end)
                local El = {}
                function El:Set(v) Set(v) end
                function El:Get() return active end
                function El:Lock() c2.Locked = true end
                function El:Unlock() c2.Locked = false end
                return El
            else
                -- Library.lua style toggle (pill)
                track = Instance.new("TextButton", row)
                track.Size = UDim2.new(0, 40, 0, 20)
                track.Position = UDim2.new(1, -55, 0.5, 0)
                track.AnchorPoint = Vector2.new(0, 0.5)
                track.BackgroundColor3 = active and TH().ToggleActive or Color3.fromRGB(150,150,150)
                track.Text = ""
                track.AutoButtonColor = false
                track.ZIndex = row.ZIndex + 2
                corner(track, 10)
                sw.track = track
                table.insert(UI_Elements.Switches, sw)

                knob = Instance.new("Frame", track)
                knob.Size = UDim2.new(0, 16, 0, 16)
                knob.Position = active and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                knob.AnchorPoint = Vector2.new(0, 0.5)
                knob.BackgroundColor3 = Color3.new(1, 1, 1)
                corner(knob, 8)

                local function Set(v)
                    active = v; sw.active = v
                    tw(track, {BackgroundColor3 = v and TH().ToggleActive or Color3.fromRGB(150,150,150)})
                    tw(knob,  {Position = v and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
                    if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value = v end
                    if c2.Callback then c2.Callback(v) end
                    if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
                end
                if c2.Flag then MeyyHub.Flags[c2.Flag] = {Value = active, Set = Set} end

                track.MouseButton1Click:Connect(function()
                    if not c2.Locked then Set(not active) end
                end)

                local El = {}
                function El:Set(v) Set(v) end
                function El:Get() return active end
                function El:Lock() c2.Locked = true end
                function El:Unlock() c2.Locked = false end
                return El
            end
        end

        -- Library.lua style alias for Toggle
        function Tab:CreateSwitch(text, default, callback)
            return Tab:Toggle({Title = text, Value = default, Callback = callback})
        end

        function Tab:Slider(c2)
            c2 = c2 or {}
            local vc     = c2.Value or {}
            local minV   = vc.Min or (type(c2.Min)  == "number" and c2.Min)  or 0
            local maxV   = vc.Max or (type(c2.Max)  == "number" and c2.Max)  or 100
            local defV   = vc.Default or (type(c2.Default) == "number" and c2.Default) or 50
            local step   = c2.Step or 1
            local hasD   = c2.Desc and c2.Desc ~= ""
            local h      = hasD and 70 or 60
            local curVal = defV

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, h)
            container.BackgroundTransparency = 1
            container.LayoutOrder = N()

            local row = makeRow(container, 0, h)
            row.Size = UDim2.new(1, 0, 1, 0)

            local tl = mkLabel(row, c2.Title or "", Enum.Font.GothamMedium, 14, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(0.6, 0, 0, 26)
            tl.Position = UDim2.new(0, 15, 0, 6)

            if hasD then
                local dl = Instance.new("TextLabel", row)
                dl.Size = UDim2.new(0.6, 0, 0, 14)
                dl.Position = UDim2.new(0, 15, 0, 28)
                dl.BackgroundTransparency = 1
                dl.Font = Enum.Font.Gotham
                dl.Text = c2.Desc
                dl.TextSize = 10
                dl.TextColor3 = Color3.new(1, 1, 1)
                dl.TextXAlignment = Enum.TextXAlignment.Left
                local dlg2 = mkGrad(dl, TH().TextGrad)
                table.insert(UI_Elements.AnimatedGradients, dlg2)
            end

            local inputField = Instance.new("TextBox", row)
            inputField.Size = UDim2.new(0, 52, 0, 22)
            inputField.Position = UDim2.new(1, -66, 0, 8)
            inputField.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            inputField.BackgroundTransparency = 0.9
            inputField.Font = Enum.Font.GothamBold
            inputField.Text = tostring(defV)
            inputField.TextColor3 = Color3.new(1, 1, 1)
            inputField.TextSize = 12
            inputField.ZIndex = row.ZIndex + 3
            inputField.ClearTextOnFocus = false
            inputField.TextXAlignment = Enum.TextXAlignment.Center
            corner(inputField, 5)
            local inpStroke = Instance.new("UIStroke", inputField)
            inpStroke.Thickness = 1
            inpStroke.Color = TH().TitleStroke
            inpStroke.Transparency = 0.5
            table.insert(UI_Elements.AnimatedStrokes, {Obj = inpStroke, Type = "TitleStroke"})

            local sliderBg = Instance.new("Frame", row)
            sliderBg.Size = UDim2.new(1, -30, 0, 6)
            sliderBg.Position = UDim2.new(0, 15, 0, h - 16)
            sliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderBg.BackgroundTransparency = 0.9
            corner(sliderBg, 4)

            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.Size = UDim2.new(math.clamp((defV - minV) / (maxV - minV), 0, 1), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.new(1, 1, 1)
            sliderFill.BorderSizePixel = 0
            corner(sliderFill, 4)

            local fillGrad = mkGrad(sliderFill, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, fillGrad)

            local circle = Instance.new("Frame", sliderFill)
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = UDim2.new(1, 0, 0.5, 0)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundColor3 = Color3.new(1, 1, 1)
            corner(circle, 7)
            local circStroke = Instance.new("UIStroke", circle)
            circStroke.Thickness = 2
            circStroke.Color = TH().TitleStroke
            table.insert(UI_Elements.AnimatedStrokes, {Obj = circStroke, Type = "TitleStroke"})

            local function Set(v)
                v = math.clamp(math.floor(v / step + 0.5) * step, minV, maxV)
                curVal = v
                local pct = math.clamp((v - minV) / (maxV - minV), 0, 1)
                tw(sliderFill, {Size = UDim2.new(pct, 0, 1, 0)})
                inputField.Text = tostring(v)
                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value = v end
                if c2.Callback then c2.Callback(v) end
            end
            if c2.Flag then MeyyHub.Flags[c2.Flag] = {Value = defV, Set = Set} end

            local function fromX(i)
                local pct = math.clamp((i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                Set(minV + (maxV - minV) * pct)
            end

            local slid = false
            circle.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then slid = true end
            end)
            sliderBg.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then fromX(i) end
            end)
            local cSl = UserInput.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and slid then
                    slid = false
                    if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
                end
            end)
            local cSlM = UserInput.InputChanged:Connect(function(i)
                if slid and i.UserInputType == Enum.UserInputType.MouseMovement then fromX(i) end
            end)
            table.insert(self._conns, cSl)
            table.insert(self._conns, cSlM)

            inputField.FocusLost:Connect(function()
                Set(tonumber(inputField.Text) or curVal)
                if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
            end)

            local El = {}
            function El:Set(v) Set(v) end
            function El:Get() return curVal end
            return El
        end

        function Tab:Input(c2)
            c2 = c2 or {}
            local isArea = c2.Type == "Textarea"
            local hasD   = c2.Desc and c2.Desc ~= ""
            local h      = isArea and (hasD and 102 or 88) or (hasD and 56 or 42)
            local row    = makeRow(page, N(), h)

            local tl = mkLabel(row, c2.Title or "Input", Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(0.42, 0, 0, isArea and h or 42)
            tl.Position = UDim2.new(0, 14, 0, 0)

            local ib = Instance.new("TextBox", row)
            ib.Size = UDim2.new(0, 200, 0, isArea and (h - 12) or 28)
            ib.Position = UDim2.new(1, -214, 0.5, 0)
            ib.AnchorPoint = Vector2.new(0, 0.5)
            ib.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ib.BackgroundTransparency = 0.75
            ib.Font = Enum.Font.Gotham
            ib.Text = c2.Value or ""
            ib.PlaceholderText = c2.Placeholder or "Type here..."
            ib.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            ib.TextColor3 = Color3.new(1, 1, 1)
            ib.TextSize = 12
            ib.ZIndex = row.ZIndex + 2
            ib.TextWrapped = isArea
            ib.MultiLine = isArea
            ib.TextXAlignment = Enum.TextXAlignment.Left
            ib.ClearTextOnFocus = false
            corner(ib, 6)
            local ibStroke = Instance.new("UIStroke", ib)
            ibStroke.Color = TH().TitleStroke
            ibStroke.Thickness = 1
            table.insert(UI_Elements.AnimatedStrokes, {Obj = ibStroke, Type = "TitleStroke"})
            pad(ib, 8, 8, 4, 4)
            local ibGrad = mkGrad(ib, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, ibGrad)

            ib.Focused:Connect(function() tw(ib, {BackgroundTransparency = 0.55}) end)
            ib.FocusLost:Connect(function()
                tw(ib, {BackgroundTransparency = 0.75})
                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value = ib.Text end
                if c2.Callback then c2.Callback(ib.Text) end
                if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
            end)
            if c2.Flag then MeyyHub.Flags[c2.Flag] = {Value = c2.Value or "", Set = function(v) ib.Text = v end} end

            local El = {}
            function El:Set(v) ib.Text = v end
            function El:Get() return ib.Text end
            return El
        end

        function Tab:Keybind(c2)
            c2 = c2 or {}
            local row     = makeRow(page, N(), 42)
            local curKey  = c2.Value or "None"
            local isListen = false

            local tl = mkLabel(row, c2.Title or "Keybind", Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(0.55, 0, 1, 0)
            tl.Position = UDim2.new(0, 14, 0, 0)

            local kb = Instance.new("TextButton", row)
            kb.Size = UDim2.new(0, 100, 0, 28)
            kb.Position = UDim2.new(1, -114, 0.5, 0)
            kb.AnchorPoint = Vector2.new(0, 0.5)
            kb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            kb.BackgroundTransparency = 0.75
            kb.Font = Enum.Font.GothamBold
            kb.Text = curKey
            kb.TextColor3 = Color3.new(1, 1, 1)
            kb.TextSize = 11
            kb.ZIndex = row.ZIndex + 2
            kb.AutoButtonColor = false
            corner(kb, 6)
            local kbStroke = Instance.new("UIStroke", kb)
            kbStroke.Color = TH().TitleStroke
            kbStroke.Thickness = 1
            table.insert(UI_Elements.AnimatedStrokes, {Obj = kbStroke, Type = "TitleStroke"})
            local kbGrad = mkGrad(kb, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, kbGrad)

            kb.MouseButton1Click:Connect(function()
                if isListen then return end
                isListen = true; kb.Text = "..."
                local cKB
                cKB = UserInput.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        isListen = false; cKB:Disconnect()
                        curKey = tostring(i.KeyCode):gsub("Enum%.KeyCode%.", "")
                        kb.Text = curKey
                        if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value = curKey end
                        if c2.Callback then c2.Callback(curKey) end
                        if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
                    end
                end)
            end)
            if c2.Flag then MeyyHub.Flags[c2.Flag] = {Value = curKey, Set = function(v) curKey = v; kb.Text = v end} end

            local El = {}
            function El:Get() return curKey end
            return El
        end

        function Tab:Dropdown(c2)
            c2 = c2 or {}
            local isMulti = c2.Multi == true
            local vals    = c2.Values or c2.Options or {}
            local isOpen  = false
            local selected

            local outer = Instance.new("Frame", page)
            outer.Name = "DropOuter"
            outer.Size = UDim2.new(1, -4, 0, 46)
            outer.BackgroundTransparency = 1
            outer.LayoutOrder = N()
            outer.ClipsDescendants = false

            local row = makeRow(outer, 0, 42)
            row.Size = UDim2.new(1, 0, 0, 42)
            row.LayoutOrder = 0

            local tl = mkLabel(row, c2.Title or "Dropdown", Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(0.5, 0, 1, 0)
            tl.Position = UDim2.new(0, 15, 0, 0)

            local dBtn = Instance.new("TextButton", row)
            dBtn.Size = UDim2.new(0, 136, 0, 30)
            dBtn.Position = UDim2.new(1, -150, 0.5, 0)
            dBtn.AnchorPoint = Vector2.new(0, 0.5)
            dBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dBtn.BackgroundTransparency = 0.8
            dBtn.Font = Enum.Font.GothamMedium
            dBtn.TextColor3 = Color3.new(1, 1, 1)
            dBtn.TextSize = 12
            dBtn.TextTruncate = Enum.TextTruncate.AtEnd
            dBtn.TextXAlignment = Enum.TextXAlignment.Left
            dBtn.AutoButtonColor = false
            dBtn.ZIndex = row.ZIndex + 2
            corner(dBtn, 6)
            local dBtnStroke = Instance.new("UIStroke", dBtn)
            dBtnStroke.Color = TH().TitleStroke
            dBtnStroke.Thickness = 1
            table.insert(UI_Elements.AnimatedStrokes, {Obj = dBtnStroke, Type = "TitleStroke"})
            local dBtnGrad = mkGrad(dBtn, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, dBtnGrad)
            pad(dBtn, 8, 22, 0, 0)

            local arrow = Instance.new("TextLabel", dBtn)
            arrow.Size = UDim2.new(0, 18, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = Color3.new(1, 1, 1)
            arrow.TextSize = 10
            arrow.ZIndex = dBtn.ZIndex + 1

            local dList = Instance.new("ScrollingFrame", outer)
            dList.Name = "DList"
            dList.Size = UDim2.new(1, 0, 0, 0)
            dList.Position = UDim2.new(0, 0, 0, 48)
            dList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dList.BackgroundTransparency = 0.2
            dList.BorderSizePixel = 0
            dList.ScrollBarThickness = 2
            dList.Visible = false
            dList.ClipsDescendants = true
            dList.ZIndex = 30
            corner(dList, 8)
            local dListStroke = Instance.new("UIStroke", dList)
            dListStroke.Color = TH().TitleStroke
            dListStroke.Thickness = 1.2
            table.insert(UI_Elements.AnimatedStrokes, {Obj = dListStroke, Type = "TitleStroke"})
            pad(dList, 4, 4, 4, 4)
            listLayout(dList, 2, Enum.HorizontalAlignment.Center)

            local function initSel()
                if isMulti then
                    selected = {}
                    if type(c2.Value) == "table" then
                        for _, v in ipairs(c2.Value) do selected[v] = true end
                    end
                else
                    local dv = c2.Value or c2.Default
                    if type(dv) == "string" then
                        selected = dv
                    elseif type(dv) == "number" and vals[dv] then
                        local v = vals[dv]
                        selected = type(v) == "table" and v.Title or v
                    else
                        local v = vals[1]
                        selected = v and (type(v) == "table" and v.Title or v) or "Select..."
                    end
                end
            end
            initSel()

            local function getText()
                if isMulti then
                    local names = {}
                    for k in pairs(selected) do table.insert(names, k) end
                    table.sort(names)
                    if #names == 0 then return "None" end
                    if #names == 1 then return names[1] end
                    return "(" .. #names .. " selected)"
                else
                    return type(selected) == "table" and selected.Title or tostring(selected or "Select...")
                end
            end
            dBtn.Text = getText()

            local optBtns = {}
            local function refreshList()
                for _, ob in ipairs(optBtns) do pcall(function() ob:Destroy() end) end
                optBtns = {}
                for _, val in ipairs(vals) do
                    if type(val) == "table" and val.Type == "Divider" then
                        local div2 = Instance.new("Frame", dList)
                        div2.Size = UDim2.new(1, -8, 0, 1)
                        div2.BackgroundColor3 = Color3.new(1, 1, 1)
                        div2.BackgroundTransparency = 0.5
                        div2.BorderSizePixel = 0
                        div2.ZIndex = 31
                        table.insert(optBtns, div2)
                    else
                        local optTitle = type(val) == "table" and val.Title or tostring(val)
                        local isSel = isMulti
                            and (selected[optTitle] == true)
                            or (selected == optTitle or (type(selected) == "table" and selected.Title == optTitle))

                        local ob = Instance.new("TextButton", dList)
                        ob.Size = UDim2.new(1, -6, 0, 30)
                        ob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        ob.BackgroundTransparency = isSel and 0.6 or 0.9
                        ob.Font = Enum.Font.GothamMedium
                        ob.Text = optTitle
                        ob.TextColor3 = Color3.new(1, 1, 1)
                        ob.TextSize = 12
                        ob.TextXAlignment = Enum.TextXAlignment.Left
                        ob.AutoButtonColor = false
                        ob.ZIndex = 31
                        corner(ob, 6)
                        pad(ob, 10, 10, 0, 0)
                        local obGrd = mkGrad(ob, isSel and TH().TextGrad or ColorSequence.new(Color3.new(0.85,0.85,0.85)))
                        table.insert(UI_Elements.AnimatedGradients, obGrd)

                        ob.MouseEnter:Connect(function() tw(ob, {BackgroundTransparency = 0.7}) end)
                        ob.MouseLeave:Connect(function() tw(ob, {BackgroundTransparency = isSel and 0.6 or 0.9}) end)

                        ob.MouseButton1Click:Connect(function()
                            if isMulti then
                                isSel = not isSel
                                selected[optTitle] = isSel or nil
                                ob.BackgroundTransparency = isSel and 0.6 or 0.9
                                obGrd.Color = isSel and TH().TextGrad or ColorSequence.new(Color3.new(0.85,0.85,0.85))
                                dBtn.Text = getText()
                                if c2.Flag and MeyyHub.Flags[c2.Flag] then
                                    local arr = {}
                                    for k in pairs(selected) do table.insert(arr, k) end
                                    MeyyHub.Flags[c2.Flag].Value = arr
                                end
                                if c2.Callback then
                                    local arr = {}
                                    for k in pairs(selected) do table.insert(arr, k) end
                                    c2.Callback(arr)
                                end
                            else
                                selected = type(val) == "table" and val or optTitle
                                dBtn.Text = optTitle
                                isOpen = false
                                tw(outer, {Size = UDim2.new(1, -4, 0, 46)}, 0.18)
                                tw(arrow, {Rotation = 0}, 0.18)
                                task.delay(0.2, function() dList.Visible = false end)
                                if c2.Flag and MeyyHub.Flags[c2.Flag] then
                                    MeyyHub.Flags[c2.Flag].Value = optTitle
                                end
                                if c2.Callback then c2.Callback(type(val) == "table" and val or optTitle) end
                            end
                            if not MeyyHub.IsLoading then MeyyHub:SaveConfig("AutoSave", true) end
                        end)
                        table.insert(optBtns, ob)
                    end
                end
            end
            refreshList()

            dBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local tH = isOpen and math.min(#vals * 34 + 12, 170) or 0
                if isOpen then dList.Visible = true end
                tw(outer, {Size = UDim2.new(1, -4, 0, 46 + tH + 4)}, 0.2)
                tw(arrow, {Rotation = isOpen and 180 or 0}, 0.2)
                if not isOpen then task.delay(0.22, function() dList.Visible = false end) end
            end)

            if c2.Flag then
                MeyyHub.Flags[c2.Flag] = {
                    Value = isMulti and {} or getText(),
                    Set = function(v)
                        if isMulti then
                            selected = {}
                            if type(v) == "table" then for _, k in ipairs(v) do selected[k] = true end end
                        else selected = v end
                        dBtn.Text = getText(); refreshList()
                    end
                }
            end

            local El = {}
            function El:Refresh(newVals) vals = newVals; refreshList() end
            function El:Get()
                if isMulti then
                    local a = {}; for k in pairs(selected) do table.insert(a, k) end; return a
                else return selected end
            end
            function El:Lock() dBtn.Active = false end
            function El:Unlock() dBtn.Active = true end
            return El
        end

        -- Library.lua aliases
        function Tab:CreateDropdown(text, default, optionsList, callback)
            return Tab:Dropdown({Title = text, Value = default, Values = optionsList, Callback = callback})
        end

        function Tab:CreateMultiDropdown(text, defaultSelections, optionsList, callback)
            return Tab:Dropdown({Title = text, Value = defaultSelections, Values = optionsList, Multi = true, Callback = callback})
        end

        function Tab:CreateButton(text, callback)
            return Tab:Button({Title = text, Callback = callback})
        end

        function Tab:CreateSlider(text, minV, maxV, default, callback)
            return Tab:Slider({Title = text, Min = minV, Max = maxV, Default = default, Callback = callback})
        end

        function Tab:CreatePageTitle(text)
            local titleWrapper = Instance.new("Frame", page)
            titleWrapper.Size = UDim2.new(1, 0, 0, 45)
            titleWrapper.BackgroundTransparency = 1
            titleWrapper.LayoutOrder = N()
            local title = Instance.new("TextLabel", titleWrapper)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            title.TextColor3 = Color3.new(1, 1, 1)
            title.TextSize = 26
            title.TextXAlignment = Enum.TextXAlignment.Left
            local ts = Instance.new("UIStroke", title)
            ts.Thickness = 1.5
            ts.Color = TH().TitleStroke
            table.insert(UI_Elements.AnimatedStrokes, {Obj = ts, Type = "TitleStroke"})
            local tg = mkGrad(title, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, tg)
        end

        function Tab:CreatePageSubTitle(text)
            local w = Instance.new("Frame", page)
            w.Size = UDim2.new(1, 0, 0, 32)
            w.BackgroundTransparency = 1
            w.LayoutOrder = N()
            local title = Instance.new("TextLabel", w)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            title.TextColor3 = Color3.new(1, 1, 1)
            title.TextSize = 18
            title.TextXAlignment = Enum.TextXAlignment.Left
            local ts = Instance.new("UIStroke", title)
            ts.Thickness = 1.2
            ts.Color = TH().TitleStroke
            table.insert(UI_Elements.AnimatedStrokes, {Obj = ts, Type = "TitleStroke"})
            local tg = mkGrad(title, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, tg)
        end

        function Tab:Colorpicker(c2)
            c2 = c2 or {}
            local current = c2.Default or Color3.fromRGB(255, 255, 255)
            local isOpen2 = false
            local hue = 0

            local row = makeRow(page, N(), 42)

            local tl = mkLabel(row, c2.Title or "Color", Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left, row.ZIndex + 1)
            tl.Size = UDim2.new(0.55, 0, 1, 0)
            tl.Position = UDim2.new(0, 14, 0, 0)

            local hexL = Instance.new("TextLabel", row)
            hexL.Size = UDim2.new(0, 60, 0, 16)
            hexL.Position = UDim2.new(1, -140, 0.5, 0)
            hexL.AnchorPoint = Vector2.new(0, 0.5)
            hexL.BackgroundTransparency = 1
            hexL.Font = Enum.Font.Gotham
            hexL.Text = "#" .. string.format("%02X%02X%02X", math.floor(current.R*255), math.floor(current.G*255), math.floor(current.B*255))
            hexL.TextColor3 = Color3.new(1,1,1)
            hexL.TextSize = 10
            hexL.ZIndex = row.ZIndex + 1
            local hexGrad = mkGrad(hexL, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, hexGrad)

            local preview = Instance.new("TextButton", row)
            preview.Size = UDim2.new(0, 58, 0, 26)
            preview.Position = UDim2.new(1, -72, 0.5, 0)
            preview.AnchorPoint = Vector2.new(0, 0.5)
            preview.BackgroundColor3 = current
            preview.Text = ""
            preview.AutoButtonColor = false
            preview.ZIndex = row.ZIndex + 2
            corner(preview, 6)
            local prevStroke = Instance.new("UIStroke", preview)
            prevStroke.Color = TH().TitleStroke
            prevStroke.Thickness = 1.5
            table.insert(UI_Elements.AnimatedStrokes, {Obj = prevStroke, Type = "TitleStroke"})

            local pickerFrame = Instance.new("Frame", row)
            pickerFrame.Size = UDim2.new(1, -2, 0, 0)
            pickerFrame.Position = UDim2.new(0, 1, 1, 4)
            pickerFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
            pickerFrame.BackgroundTransparency = 0.2
            pickerFrame.Visible = false
            pickerFrame.ZIndex = row.ZIndex + 10
            corner(pickerFrame, 8)
            local pkStroke = Instance.new("UIStroke", pickerFrame)
            pkStroke.Color = TH().MainStroke
            pkStroke.Thickness = 1.5
            table.insert(UI_Elements.AnimatedStrokes, {Obj = pkStroke, Type = "MainStroke"})
            listLayout(pickerFrame, 6)
            pad(pickerFrame, 10, 10, 10, 10)

            local hueBar = Instance.new("Frame", pickerFrame)
            hueBar.Size = UDim2.new(1, 0, 0, 12)
            hueBar.LayoutOrder = 1
            corner(hueBar, 4)
            local hueGrad = Instance.new("UIGradient", hueBar)
            hueGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,     Color3.fromRGB(255, 0,   0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0,   255, 0)),
                ColorSequenceKeypoint.new(0.5,   Color3.fromRGB(0,   255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0,   0,   255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0,   255)),
                ColorSequenceKeypoint.new(1,     Color3.fromRGB(255, 0,   0)),
            })
            local hKnob = Instance.new("Frame", hueBar)
            hKnob.Size = UDim2.new(0, 10, 0, 10)
            hKnob.Position = UDim2.new(0, 0, 0.5, 0)
            hKnob.AnchorPoint = Vector2.new(0.5, 0.5)
            hKnob.BackgroundColor3 = Color3.new(1,1,1)
            corner(hKnob, 5)
            Instance.new("UIStroke", hKnob).Thickness = 1.5

            local hexBox = Instance.new("TextBox", pickerFrame)
            hexBox.LayoutOrder = 2
            hexBox.Size = UDim2.new(1, 0, 0, 28)
            hexBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
            hexBox.BackgroundTransparency = 0.7
            hexBox.Font = Enum.Font.GothamBold
            hexBox.Text = "#" .. string.format("%02X%02X%02X", math.floor(current.R*255), math.floor(current.G*255), math.floor(current.B*255))
            hexBox.TextColor3 = Color3.new(1,1,1)
            hexBox.TextSize = 12
            hexBox.ZIndex = pickerFrame.ZIndex + 1
            hexBox.ClearTextOnFocus = false
            hexBox.TextXAlignment = Enum.TextXAlignment.Center
            corner(hexBox, 5)
            local hexStroke = Instance.new("UIStroke", hexBox)
            hexStroke.Color = TH().TitleStroke
            table.insert(UI_Elements.AnimatedStrokes, {Obj = hexStroke, Type = "TitleStroke"})
            local hbGrad = mkGrad(hexBox, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, hbGrad)

            local function updateColor(col)
                current = col
                preview.BackgroundColor3 = col
                local hx = string.format("%02X%02X%02X", math.floor(col.R*255), math.floor(col.G*255), math.floor(col.B*255))
                hexL.Text = "#" .. hx
                hexBox.Text = "#" .. hx
                if c2.Flag and MeyyHub.Flags[c2.Flag] then MeyyHub.Flags[c2.Flag].Value = col end
                if c2.Callback then c2.Callback(col) end
            end

            local hDrag = false
            hueBar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    hDrag = true
                    local p = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hue = p; hKnob.Position = UDim2.new(p, 0, 0.5, 0)
                    updateColor(Color3.fromHSV(hue, 1, 1))
                end
            end)
            local cH1 = UserInput.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hDrag = false end
            end)
            local cH2 = UserInput.InputChanged:Connect(function(i)
                if hDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local p = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hue = p; hKnob.Position = UDim2.new(p, 0, 0.5, 0)
                    updateColor(Color3.fromHSV(hue, 1, 1))
                end
            end)
            table.insert(self._conns, cH1)
            table.insert(self._conns, cH2)

            hexBox.FocusLost:Connect(function()
                local hx2 = hexBox.Text:gsub("#",""):gsub("%s","")
                if #hx2 == 6 then
                    local r2 = tonumber("0x"..hx2:sub(1,2)) or 255
                    local g2 = tonumber("0x"..hx2:sub(3,4)) or 255
                    local b2 = tonumber("0x"..hx2:sub(5,6)) or 255
                    updateColor(Color3.fromRGB(r2, g2, b2))
                end
            end)

            preview.MouseButton1Click:Connect(function()
                isOpen2 = not isOpen2
                pickerFrame.Visible = isOpen2
                if isOpen2 then
                    tw(pickerFrame, {Size = UDim2.new(1, -2, 0, 80)}, 0.2)
                else
                    tw(pickerFrame, {Size = UDim2.new(1, -2, 0, 0)}, 0.2)
                    task.delay(0.22, function() pickerFrame.Visible = false end)
                end
            end)

            if c2.Flag then MeyyHub.Flags[c2.Flag] = {Value = current, Set = updateColor} end
            local El = {}
            function El:Set(v) updateColor(v) end
            function El:Get() return current end
            return El
        end

        function Tab:Code(c2)
            c2 = c2 or {}
            local lines = c2.Content or ""
            local lineCount = 0
            for _ in lines:gmatch("[^\n]+") do lineCount = lineCount + 1 end
            local h = math.min(math.max(lineCount * 18 + 24, 56), 200)
            local row = makeRow(page, N(), h)
            listLayout(row, 0)
            pad(row, 12, 12, 10, 10)

            local codeL = Instance.new("TextLabel", row)
            codeL.Size = UDim2.new(1, 0, 1, 0)
            codeL.BackgroundTransparency = 1
            codeL.Font = Enum.Font.RobotoMono
            codeL.Text = lines
            codeL.TextSize = 11
            codeL.TextColor3 = Color3.new(1,1,1)
            codeL.TextXAlignment = Enum.TextXAlignment.Left
            codeL.TextWrapped = true
            codeL.TextTruncate = Enum.TextTruncate.None
            codeL.TextYAlignment = Enum.TextYAlignment.Top
            codeL.ZIndex = row.ZIndex + 1
            local clGrad = mkGrad(codeL, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, clGrad)

            local copyBtn = Instance.new("TextButton", row)
            copyBtn.Size = UDim2.new(0, 50, 0, 20)
            copyBtn.Position = UDim2.new(1, -10, 0, 8)
            copyBtn.AnchorPoint = Vector2.new(1, 0)
            copyBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
            copyBtn.BackgroundTransparency = 0.65
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.Text = "Copy"
            copyBtn.TextColor3 = Color3.new(1,1,1)
            copyBtn.TextSize = 10
            copyBtn.ZIndex = row.ZIndex + 2
            copyBtn.AutoButtonColor = false
            corner(copyBtn, 5)
            local cbGrad = mkGrad(copyBtn, TH().TextGrad)
            table.insert(UI_Elements.AnimatedGradients, cbGrad)
            copyBtn.MouseButton1Click:Connect(function()
                pcall(setclipboard, lines)
                copyBtn.Text = "Copied!"
                task.delay(1.4, function() copyBtn.Text = "Copy" end)
            end)
        end
    end

    -- ============================================================
    -- WINDOW TAB API
    -- ============================================================
    local tabObjects  = {}
    local pageObjects = {}
    local tabLO       = 0
    local activePageRef = nil

    local function makePage(name, active)
        local pg = Instance.new("ScrollingFrame", ContentArea)
        pg.Name = name .. "_Page"
        pg.Size = UDim2.new(1, 0, 1, 0)
        pg.BackgroundTransparency = 1
        pg.BorderSizePixel = 0
        pg.ScrollBarThickness = 0
        pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
        pg.ZIndex = 2
        pg.Visible = active
        local pLayout = listLayout(pg, 8, Enum.HorizontalAlignment.Center)
        pad(pg, 10, 18, 10, 28)
        if active then activePageRef = pg end
        return pg
    end

    local Window = {}

    function Window:Tab(c2)
        c2 = c2 or {}
        local isFirst = #tabObjects == 0

        local btn = Instance.new("TextButton", Sidebar)
        btn.LayoutOrder = tabLO; tabLO = tabLO + 1
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamMedium
        btn.Text = "      " .. (c2.Title or "Tab")
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.ZIndex = 6

        local ind = Instance.new("Frame", btn)
        ind.Name = "Indicator"
        ind.Size = UDim2.new(0, 4, 0, 18)
        ind.Position = UDim2.new(0, 8, 0.5, 0)
        ind.AnchorPoint = Vector2.new(0, 0.5)
        ind.BackgroundColor3 = Color3.new(1, 1, 1)
        ind.BorderSizePixel = 0
        ind.Visible = isFirst
        corner(ind, 2)
        local indGrad = mkGrad(ind, TH().TextGrad)
        table.insert(UI_Elements.AnimatedGradients, indGrad)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Thickness = 2.2
        btnStroke.Color = TH().TitleStroke
        btnStroke.Transparency = 1.5
        table.insert(UI_Elements.AnimatedStrokes, {Obj = btnStroke, Type = "TitleStroke"})

        local tabGrad = mkGrad(btn, TH().TabGrad)
        table.insert(UI_Elements.TabGradients, tabGrad)
        table.insert(UI_Elements.AnimatedGradients, tabGrad)
        table.insert(tabObjects, {btn = btn, ind = ind})

        local page = makePage(c2.Title or "Tab", isFirst)
        table.insert(pageObjects, page)

        btn.MouseEnter:Connect(function()
            if not ind.Visible then tw(btn, {BackgroundTransparency = 0}) end
        end)
        btn.MouseLeave:Connect(function()
            if not ind.Visible then tw(btn, {BackgroundTransparency = 1}) end
        end)
        btn.MouseButton1Click:Connect(function()
            for _, p in ipairs(pageObjects) do p.Visible = false end
            for _, tb in ipairs(tabObjects) do tb.ind.Visible = false end
            page.Visible = true
            ind.Visible = true
        end)

        local Tab = {}
        buildElements(Tab, page)
        return Tab
    end

    -- Library.lua-style CreateTab alias
    function Window:CreateTab(name, isFirstPage)
        local tab = Window:Tab({Title = name})
        if isFirstPage then
            -- make this tab active
            for _, p in ipairs(pageObjects) do p.Visible = false end
            for _, tb in ipairs(tabObjects) do tb.ind.Visible = false end
            local pg = pageObjects[#pageObjects]
            local tb = tabObjects[#tabObjects]
            if pg then pg.Visible = true end
            if tb then tb.ind.Visible = true end
        end
        return tab
    end

    function Window:Section(c2)
        c2 = c2 or {}
        local sec = Instance.new("TextButton", Sidebar)
        sec.LayoutOrder = tabLO; tabLO = tabLO + 1
        sec.Size = UDim2.new(1, -10, 0, 22)
        sec.BackgroundTransparency = 1
        sec.Font = Enum.Font.GothamBold
        sec.Text = (c2.Title or ""):upper()
        sec.TextColor3 = Color3.new(1, 1, 1)
        sec.TextSize = 9
        sec.TextXAlignment = Enum.TextXAlignment.Left
        sec.AutoButtonColor = false
        sec.ZIndex = 6
        pad(sec, 6, 0, 0, 0)
        local sg2 = mkGrad(sec, TH().TextGrad)
        table.insert(UI_Elements.AnimatedGradients, sg2)
    end

    function Window:Divider()
        local div2 = Instance.new("Frame", Sidebar)
        div2.Size = UDim2.new(1, -10, 0, 1)
        div2.BackgroundColor3 = Color3.new(1, 1, 1)
        div2.BorderSizePixel = 0
        div2.LayoutOrder = tabLO; tabLO = tabLO + 1
        local dg2 = mkGrad(div2, TH().DivGrad)
        dg2.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.3),
            NumberSequenceKeypoint.new(1, 1),
        })
        table.insert(UI_Elements.DivGradients, dg2)
    end

    function Window:Tag(c2)
        c2 = c2 or {}
        local tag = Instance.new("TextButton", Topbar)
        tag.Size = UDim2.new(0, 0, 0, 20)
        tag.AutomaticSize = Enum.AutomaticSize.X
        tag.Position = UDim2.new(0.5, 0, 0.5, 0)
        tag.AnchorPoint = Vector2.new(0.5, 0.5)
        tag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tag.BackgroundTransparency = 0.5
        tag.Font = Enum.Font.GothamBold
        tag.Text = c2.Title or ""
        tag.TextColor3 = Color3.new(1, 1, 1)
        tag.TextSize = 10
        tag.ZIndex = 12
        tag.AutoButtonColor = false
        corner(tag, 5)
        pad(tag, 8, 8, 0, 0)
        local tagGrad = mkGrad(tag, TH().TextGrad)
        table.insert(UI_Elements.AnimatedGradients, tagGrad)
        if c2.Border then
            local tStroke = Instance.new("UIStroke", tag)
            tStroke.Color = TH().TitleStroke
            tStroke.Thickness = 1
            table.insert(UI_Elements.AnimatedStrokes, {Obj = tStroke, Type = "TitleStroke"})
        end
    end

    function Window:Dialog(c2) showDialog(c2) end

    function Window:Open()
        isHidden = false; Win.Visible = true
        tw(Win, {Size = normalSize, Position = normalPos}, 0.45, Enum.EasingStyle.Back)
    end

    function Window:Close()
        isHidden = true
        tw(Win, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.32, function() Win.Visible = false end)
    end

    function Window:Toggle() toggleUI() end

    function Window:Destroy()
        tw(Win, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.35, function()
            for _, c in ipairs(MeyyHub._conns) do pcall(function() c:Disconnect() end) end
            Root:Destroy(); MeyyHub._window = nil
        end)
    end

    function Window:SetTitle(t2) titleLbl.Text = t2 end
    function Window:SetToggleKey(k) MinKey = k end

    function Window:EditOpenButton(c2)
        c2 = c2 or {}
        if c2.Enabled == false then OpenBtn.Visible = false
        elseif c2.Enabled == true then OpenBtn.Visible = true end
    end

    -- ApplyTheme (Library.lua style)
    function Window:ApplyTheme(name)
        local n2 = normalizeTheme(name)
        if n2 then
            applyTheme(n2)
            MeyyHub:Notify({Title = "Theme", Content = "Applied: " .. n2})
        end
    end

    -- Built-in Settings Tab
    local SettingsTab = Window:Tab({Title = "Settings"})
    local lastEntry   = tabObjects[#tabObjects]
    if lastEntry then lastEntry.btn.LayoutOrder = 99999 end

    SettingsTab:Dropdown({
        Flag   = "__MeyyHub_Theme",
        Title  = "Theme",
        Values = {"Sakura", "Moonlight", "Blue", "Rose", "Ocean", "Emerald", "Violet", "Amber"},
        Value  = CurrentTheme,
        Callback = function(v)
            local name = type(v) == "table" and v.Title or v
            applyTheme(name)
            MeyyHub:Notify({Title = "Theme", Content = "Applied: " .. name})
        end,
    })

    local kStr = tostring(MinKey):gsub("Enum%.KeyCode%.", "")
    SettingsTab:Paragraph({Title = "Toggle Shortcut", Content = kStr .. "  —  toggle UI visibility"})
    SettingsTab:Paragraph({Title = "Open Button",     Content = "The floating button is draggable anywhere on screen."})
    SettingsTab:Space()
    SettingsTab:Button({Title = "Save Config",  Callback = function() MeyyHub:SaveConfig("ManualSave") end})
    SettingsTab:Button({Title = "Load Config",  Callback = function() MeyyHub:LoadConfig("ManualSave") end})

    -- Open animation
    Win.Size = UDim2.new(0, 0, 0, 0)
    local openTw = TweenService:Create(Win, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = normalSize})
    openTw:Play()

    task.spawn(function()
        task.wait(1.5)
        MeyyHub:LoadConfig("AutoSave", true)
    end)

    MeyyHub:Notify({Title = "MeyyHub v" .. MeyyHub.Version, Content = "Ready — " .. (cfg.Title or "MeyyHub")})
    self._window = Window
    return Window
end

return MeyyHub