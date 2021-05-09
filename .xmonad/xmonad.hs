import           XMonad
import           XMonad.Actions.CopyWindow
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.SetWMName
import           XMonad.Util.SpawnOnce
import           XMonad.Util.Run
import qualified XMonad.Layout.Fullscreen as FS
import           XMonad.Layout.SimpleFloat
import           XMonad.Layout.PerWorkspace (onWorkspace)
import           XMonad.Layout.Spacing

import           System.Exit

import qualified Data.Map                  as M
import qualified XMonad.StackSet           as W

-- Basic Stuff
myTerminal          = "alacritty"
myBorderWidth       = 2
myModMask           = mod4Mask
myWorkspaces        = ["term", "web", "code"] ++ map show [4..9]

-- Layout management
defaultLayout = spacing $ avoidStruts $ tiled ||| Mirror tiled ||| full 
  where
    tiled        = FS.fullscreenFull $ Tall nmaster delta ratio
    full         = FS.fullscreenFull Full
    spacing      = spacingRaw False screenBorder True windowBorder True
    screenBorder = Border 5 5 5 5
    windowBorder = Border 5 5 5 5
    nmaster      = 1
    ratio        = 1 / 2
    delta        = 2 / 100

myLayout = onWorkspace "9" simpleFloat defaultLayout

-- Startup applications
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "udiskie &"
    spawnOnce "redshift-gtk &"
    spawnOnce "lxqt-policykit-agent &"
    spawnOnce "nm-applet &"
    spawnOnce "ulauncher --hide-window --no-window-shadow &"
    -- spawnOnce "/home/dknite/.config/polybar/launch.sh &"
    spawnOnce "picom &"
    spawnOnce "xsetroot -cursor_name left_ptr &"
    spawnOnce "trayer --edge bottom --align right --width 5 --height 25 --distancefrom bottom --distance -10 --alpha 0 --tint 0x222222 --transparent true &"
    setWMName "LG3D"

-- Key bindings
myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- run ranger
    , ((modm,               xK_a     ), spawn $ myTerminal ++ " ranger")
    
    -- Lock screen
    , ((controlMask .|. mod1Mask, xK_l), spawn "slock")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Hide docks
    , ((modm,               xK_b     ), sendMessage ToggleStruts)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Take full screen screenshot
    , ((noModMask, xK_Print), spawn "scrot \'%Y-%m-%d_$wx$h.png\' -e \'mv $f ~/Pictures/\'")
    
    -- Take rectangle screenshot
    , ((shiftMask, xK_Print), spawn "sleep 0.1; scrot -s \'%Y-%m-%d_$wx$h.png\' -e \'mv $f ~/Pictures/\'")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Window rules
myManageHook = composeAll 
    [ isFullscreen    -->  doFullFloat
    , FS.fullscreenManageHook
    , className =? "Gimp-2.10" --> doFloat
    , title =? "Picture-in-Picture" --> doFloat
    , title =? "Picture-in-Picture" --> doF copyToAll
    , title =? "Oracle VM VirtualBox Manager" --> doFloat
    , className =? "mullvad vpn" --> doFloat
    , manageDocks
    ]

-- Add a underline in xmobar
-- Argument 1: Color
-- Argument 2: String to print
xmobarUnderline :: String -> String -> String
xmobarUnderline color output = "<box type=Bottom width=2 color=" ++ color ++ ">" ++ output ++ "</box>"

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh $ docks def {
        -- Basic Stuff
          terminal          = myTerminal
        , borderWidth       = myBorderWidth
        , modMask           = myModMask
        , workspaces        = myWorkspaces

        -- Bindings
        , keys              = myKeys

        -- Hooks
        , layoutHook        = myLayout
        , startupHook       = myStartupHook
        , manageHook        = myManageHook
        , handleEventHook   = FS.fullscreenEventHook
        , logHook           = dynamicLogWithPP $ xmobarPP
            {
                 ppOutput = hPutStrLn xmproc
               , ppCurrent = xmobarUnderline "#fba922" . xmobarColor "#ffffff" "#3f3f3f"
               , ppHidden = xmobarUnderline "#555555"
               , ppHiddenNoWindows = xmobarColor "#555555" "#222"
               , ppUrgent = xmobarUnderline "#9b0a20" . xmobarColor "#000000" "#bd2c40"
               , ppWsSep = xmobarColor "#222" "#222" " "
               , ppLayout = const ""
            }
    }
