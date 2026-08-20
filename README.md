# Muls Dexxer Bot

A UO Outlands Razor dexxer bot, forked from Jaseowns' Premium Dexxer Bot

**This fork is not compatible with the original Jaseowns init/base files, and
Jaseowns does not provide support for it.** 

All config variables were renamed
during the fork, so files from the original bot won't work with this one and
vice versa.  This is to ensure there are no unintentional compatibility issues
cause by misuse.

## Files

- `mbot_base.razor` - the bot engine. All combat/support logic lives here.
- `mbot_base_init.razor` - config file. Sets every tunable value, then plays


## Installation

Place both `.razor` files in your Razor Scripts folder at:

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

- Smart Weapon Equip / Smart Shield Equip - automatically re-equips your
  remembered weapon/shield, or finds a quality replacement from your bags
  (aspect/exceptional/supremely/exceedingly/vanquishing/power/invuln)
- Early poison reapplication - comfortably play at 100 poison skill
- Optimized Chivalry
- Optimized Barding
- Optimized combat loop
- Configurable weapon hotbar display for both ability hotbar and codex hotbar

## Subtractions
- Tamer support has been removed

##  Special Thanks
- Orii
- Genkii
- Thane
- R Guild, members, and leadership