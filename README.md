

# FiveM FFA (Free) Script

This FiveM script allows you to set up a Free For All (FFA) mode on your server. The following document includes information on installation, configuration, and integration with `ox_inventory`.

- For Map: https://www.gta5-mods.com/maps/de_dust-2-from-counter-strike-1-6
- Preview: https://www.youtube.com/watch?v=o_7_49obsIU

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Commands and Events](#commands-and-events)
5. [Database Configuration](#database-configuration)
6. [ox_inventory Integration](#ox_inventory-integration)

## Features

- **Three FFA Zones**: SMG, Pistol, and Rifle zones.
- **Real-time Statistics Updates**: Real-time updates for kills and deaths.
- **Dynamic Zone Management**: Dynamic management of player entries and exits.


## Installation

1. **Upload Script Files**:
   - Add the `server.lua` file to your server's `resources` folder.
   - Place Lua files and SQL files in the appropriate directories.

2. **Set Up Database**:
   - Load the SQL file into your database. This file creates the necessary tables for storing player data in FFA zones. Use the following SQL queries to create the tables:
   
   ```sql
   CREATE TABLE IF NOT EXISTS `fast_ffa_pistolzone` (
     `playername` varchar(50) DEFAULT NULL,
     `citizenid` text DEFAULT NULL,
     `kill` int(11) DEFAULT 0,
     `death` int(11) DEFAULT 0
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

   CREATE TABLE IF NOT EXISTS `fast_ffa_riflezone` (
     `playername` varchar(50) DEFAULT NULL,
     `citizenid` text DEFAULT NULL,
     `kill` int(11) DEFAULT 0,
     `death` int(11) DEFAULT 0
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

   CREATE TABLE IF NOT EXISTS `fast_ffa_smgzone` (
     `playername` varchar(50) DEFAULT NULL,
     `citizenid` text DEFAULT NULL,
     `kill` int(11) DEFAULT 0,
     `death` int(11) DEFAULT 0
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
   ```

3. **Configure the Script**:
   - Adjust the configuration file (`FastConfig_SH` and other settings) to meet your needs.

4. **Start the Script**:
   - Restart your server and verify that the script is functioning correctly.


## ox_inventory Integration

If you are using `ox_inventory`, add the following line below the `weapon.disarm` line in your add this line:
```lua
if exports["f4st-ffa"]:InZone() then return end
```

