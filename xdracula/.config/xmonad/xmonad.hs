--imports

import XMonad
import System.Exit
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Util.Run
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Actions.Submap
import Graphics.X11.ExtraTypes.XF86
import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Actions.WindowBringer
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Theme
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

myTerminal :: String
myTerminal = "urxvtc"

myModMask :: KeyMask
myModMask = mod4Mask

myFilemanager :: String
myFilemanager = "Thunar"

myTabedBrowser :: String
myTabedBrowser = "firefox"

myMail :: String
myMail = "st -e neomutt"

myMusicplayer :: String
myMusicplayer = "st -e cums"

myFocusFollowsMouse :: Bool

myFocusFollowsMouse = True

myClickJustFocuses :: Bool

myClickJustFocuses = False

myBorderWidth   = 2

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

--myNormalBorderColor  = "dddddd"

myFocusedBorderColor = "#bd9cf9"

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
      -- spawm applications
      ((modm                  ,  xK_t                    ), spawn $ XMonad.terminal conf)
    , ((modm                  ,  xK_f                    ), spawn myFilemanager)
    , ((modm .|. shiftMask    ,  xK_b                    ), spawn myTabedBrowser)
      -- prompts and memues
    , ((modm                  ,  xK_space                ), spawn("dmenu_run"))
    , ((modm .|. shiftMask    ,  xK_a                    ), bringMenu)
      -- layout change focus
    , ((modm                  ,  xK_Tab                  ), windows W.focusDown)
    , ((modm                  ,  xK_n                    ), windows W.focusDown)
    , ((modm                  ,  xK_e;                    ), windows W.focusUp)
    , ((modm                  ,  xK_Return               ), windows W.swapMaster)
    -- kill compile and exit
    , ((modm                  ,  xK_q                    ), kill)
    , ((modm                  ,  xK_c                    ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm .|. shiftMask    ,  xK_c                    ), io (exitWith ExitSuccess)) 
    -- shift windows
    , ((modm .|. shiftMask    ,  xK_y                    ), windows W.swapDown)
    , ((modm .|. shiftMask    ,  xK_o                    ), windows W.swapUp)
      -- change layoout
    , ((modm                  ,  xK_l                    ), sendMessage NextLayout)
    , ((modm .|. shiftMask    ,  xK_l                    ), setLayout $ XMonad.layoutHook conf)
      -- resize windows
    , ((modm                  ,  xK_f                    ), sendMessage Shrink)  
    , ((modm                  ,  xK_u                    ), sendMessage Expand)
    , ((modm .|. shiftMask    ,  xK_t                    ), withFocused $ windows . W.sink)
      -- gaps and struts
    , ((modm .|. controlMask  ,  xK_j                    ), sendMessage $ ToggleGaps)
    , ((modm .|. controlMask  ,  xK_p                    ), sendMessage  ToggleStruts)
      -- volume
    , ((0                     ,  xF86XK_AudioRaiseVolume ), spawn "amixer sset Master 5%+")
    , ((0                     ,  xF86XK_AudioLowerVolume ), spawn "amixer sset Master 5%-")
    , ((0                     ,  xF86XK_AudioMute        ), spawn "amixer sset Master toggle")
      -- backlight 
    , ((0                     ,  xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc +5")    
    , ((0                     ,  xF86XK_MonBrightnessDown), spawn "xbacklight -dec +5")   
    ]
    ++
      --change workspace
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
     --move windows to workspaces
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))                                                    
        | (key, sc) <- zip [xK_w, xK_e, xK_i
        ] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]  
    ++
     --other prompts submaps
    [((modm,          xK_o), submap . M.fromList $                                                                           
    [ ((0, xK_m),     manPrompt promptconfig) 
    , ((0,  xK_t),     themePrompt promptconfig)
    ])]
-------------------------------------------------------------------------------------------
--add custom search engines

stackoverflow = S.searchEngine "stackoverflow" "https://stackoverflow.com/search?q="
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
reddit = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--searchengines

searchEngineMap method = M.fromList $
                         [ ((0, xK_g), method S.google)
                          ,((0, xK_y), method S.youtube)
                          ,((0, xK_w), method S.wikipedia)
			  ,((0, xK_d), method S.duckduckgo)
			  ,((0, xK_s), method stackoverflow)
			  ,((0, xK_a), method archwiki)
                          ,((0, xK_r), method reddit )
                          ,((0, xK_u), method urban)
                         ]
                         
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--prompt config

promptconfig :: XPConfig
promptconfig = def
      { font                = "xft:Hack-Bold:size=11:Bold:antialias=true" 
      , bgColor             = "#282a36"
      , fgColor             = "#f8f8f2"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#bd93f9"
      , promptBorderWidth   = 3
      , position            = Top--CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 } 
      , height              = 23
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , showCompletionOnTab = False
      , alwaysHighlight     = True
      , searchPredicate     = fuzzyMatch
      , maxComplRows        = Nothing
      }

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))			-- mod-button1, Set the window to floating mode and move by dragging
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))				            	-- mod-button2, Raise the window to the top of the stack
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))		-- mod-button3, Set the window to floating mode and resize by dragging
    ]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Layouts:

myLayout = avoidStruts( Tall 1 (3/100) (1/2) ||| Full ||| simpleTabbed)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Window rules:

myManageHook = composeAll
    [ className  =? "Steam"       --> doFloat
     ,className  =? "vlc" --> doFloat
     ,className  =? "Picture in picture" --> doFloat
     ,className  =? "Freetube" --> doFloat
     ,className  =? "VirtualBox Manager" --> doFloat
     ,className =? "Steam"     --> doShift ( myWorkspaces !! 2 )
     ,className =? "csgo_linux64"     --> doShift ( myWorkspaces !! 3)]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Event handling

myEventHook = mempty

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Status bars and logging for StdinReader 

--windowCount :: X (Maybe String)
--windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

_topXmobarPP h = xmobarPP {
    ppCurrent = xmobarColor "#50fa7b" "" . wrap "[" "]"
    , ppVisible = xmobarColor "#bd93f9" "" . wrap "" ""
    , ppHidden = xmobarColor "#f1fa8c" "" . wrap "" ""
    , ppHiddenNoWindows = xmobarColor "#c792ea" ""
    , ppSep = "<fc=#ffffff> | </fc>" 
    , ppTitle = xmobarColor "#8be9fd" "" . shorten 60
    , ppLayout = xmobarColor "#ff79c6" ""
    , ppOutput = hPutStrLn h
    --, ppExtras  = [windowCount]
    , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]}
    

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Startup hook

myStartupHook = return ()
	  --spawnOnce "udiskie --no-automount --no-notify --tray &"

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
main :: IO ()
main = do 
  _topXmobar <- spawnPipe "xmobar -x 0 /home/herod/.config/xmobar/xmobar.config"
  xmonad $ docks $ ewmh def
     {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        layoutHook         = spacingRaw False (Border 0 4 4 4) True (Border 4 4 4 4) True $ gaps [(U,25), (D,6), (R,6), (L,6)] $ smartBorders $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP $ _topXmobarPP _topXmobar,
        startupHook        = myStartupHook
    }
 
