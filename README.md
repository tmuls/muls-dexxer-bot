# Muls Dexxer Bot

A UO Outlands Razor dexxer bot, forked from Jaseowns' Premium Dexxer Bot

**This fork is not compatible with the original Jaseowns init/base files, and
Jaseowns does not provide support for it.** 

All config variables were renamed
during the fork, so files from the original bot won't work with this one and
vice versa.  This is to ensure there are no unintentional compatibility issues
cause by misuse.

## What's Included

- **Dex Bot** (`mbot_base`, `mbot_base_init`) - the full PvM combat/support engine plus its config file.
- **PvP Bot** (`mbot_pvp_base`, `mbot_pvp_base_init`) - a stripped-down engine for structured PvP, plus its config file.
- **Auto Equip** (`mbot_auto_equip`) - re-dresses gear from your backpack using state recorded by Dex Bot.
- **Auto-Disarm Enabler** (`mbot_ensure_autodisarm`) - one-shot toggle to turn on permanent auto-disarm mode.
- **Recall Home** (`mbot_recall_home`) - the recall macro Dex Bot calls when it can't find your gear; edit to match your own recall method.
- **Linux Installer** (`dexbot_install.sh`) - downloads the latest release and installs/updates it into your Scripts folder.


## Installation

Place all of the `.razor` files in your Razor Scripts folder at:

```
Scripts\Combat\Dexxer\
```

Both files need to be in this exact folder - `mbot_base_init.razor` launches
`mbot_base.razor` via `Play Script: Combat\Dexxer\mbot_base`, so the path has
to match.

Run `mbot_base_init.razor` to start the bot. Edit its config values first
(see below) to match your character's build.

## Configuring

All tunables live at the top of `mbot_base_init.razor` 
grouped under comments (Potions, Parry, Chivalry, Bard Abilities,
Weapon Abilities, target overhead messages, ignore list, etc.). Edit values
there - don't edit `mbot_base.razor` directly unless you're changing the
bot's actual logic.

## Additions

- Instant equip and attack
- Smart Weapon Equip / Smart Shield Equip - automatically re-equips your
  remembered weapon/shield, or finds a quality replacement from your bags
  (aspect/exceptional/supremely/exceedingly/vanquishing/power/invuln)
- Reliable auto re-equip
- Auto recall home if you forgot to bring your weapon or shield (not enabled by default)
- Early poison reapplication - comfortably play at 100 poison skill
- Configurable weapon hotbar display for both ability hotbar and codex hotbar
- Optimized Chivalry
- Optimized Barding (testing needed)
- Optimized main run loop (moved several init-once items outside of the main run loop)
- New Features
- Automatic old init version detection

## Subtractions
- Tamer support has been removed

##  Special Thanks
- Jaseowns for his awesome scripts and for his [website](https://uoaddicts.com)
- Orii
- Genkii
- Thane
- R Guild, members, and leadership
