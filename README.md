

# FiveM FFA (Free) Script

This FiveM script allows you to set up a Free For All (FFA) mode on your server. The following document includes information on installation, configuration, and integration with `ox_inventory`.

Bu FiveM scripti, sunucunuzda FFA (Free For All) modunu kurmanızı sağlar. Aşağıdaki belgede, scriptin kurulumu, yapılandırması ve `ox_inventory` ile entegrasyonu hakkında bilgi bulabilirsiniz.

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

## Özellikler

- **Üç FFA Alanı**: SMG, Pistol ve Rifle alanları.
- **Zamanlı İstatistik Güncellemeleri**: Öldürme ve ölüm istatistikleri için gerçek zamanlı güncellemeler.
- **Dinamik Alan Yönetimi**: Oyuncuların alanlara katılmaları ve çıkmaları için dinamik yönetim.

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

## Kurulum

1. **Script Dosyalarını Yükleyin**:
   - `server.lua` dosyasını sunucunuzun `resources` klasörüne ekleyin.
   - Lua dosyalarını ve SQL dosyasını uygun dizinlere yerleştirin.

2. **Veritabanını Kurun**:
   - SQL dosyasını veritabanınıza yükleyin. Bu dosya, FFA bölgelerindeki oyuncu verilerini saklamak için gerekli tabloları oluşturur. Aşağıdaki SQL sorgularını kullanarak tabloları oluşturabilirsiniz:
   
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

3. **Scripti Yapılandırın**:
   - Konfigürasyon dosyasını (`FastConfig_SH` ve diğer ayarlar) ihtiyaçlarınıza göre düzenleyin.

4. **Scripti Başlatın**:
   - Sunucunuzu yeniden başlatın ve scriptin doğru çalıştığını doğrulayın.

## Configuration

- **`FastConfig_SH`**: Configuration for FFA zones and general settings.
  ```lua
  FastConfig_SH = {
      JoinCoords = vector4(907.89, -2202.23, 32.29, 357.79),
      ExitCoords = vector4(908.79, -2195.9, 30.51, 352.78),
      NpcModel = "csb_talcc",
      MainBucket = 0,
      HitMarker = true,
      Inventory = "ox" -- "ox" or "qb"
  }
  ```

- **`FastConfig_Commands`**: User commands.
- **`FastConfig_Events`**: Server events.
- **`FastConfig_Pistol_Area_Settings`**: Pistol area settings.
- **`FastConfig_Smg_Area_Settings`**: SMG area settings.
- **`FastConfig_Rifle_Area_Settings`**: Rifle area settings.

## Yapılandırma

- **`FastConfig_SH`**: FFA alanları ve genel ayarlar için konfigürasyon.
  ```lua
  FastConfig_SH = {
      JoinCoords = vector4(907.89, -2202.23, 32.29, 357.79),
      ExitCoords = vector4(908.79, -2195.9, 30.51, 352.78),
      NpcModel = "csb_talcc",
      MainBucket = 0,
      HitMarker = true,
      Inventory = "ox" -- "ox" veya "qb"
  }
  ```

- **`FastConfig_Commands`**: Kullanıcı komutları.
- **`FastConfig_Events`**: Sunucu etkinlikleri.
- **`FastConfig_Pistol_Area_Settings`**: Pistol alanı ayarları.
- **`FastConfig_Smg_Area_Settings`**: SMG alanı ayarları.
- **`FastConfig_Rifle_Area_Settings`**: Rifle alanı ayarları.

## Commands and Events

- **`/checkarea`**: Checks the number of players in the FFA area.
- **`/ffa_resetstat`**: Resets statistics for a specific area.
- **`/ffahud`**: Opens the HUD editing mode.
- **`/resethud`**: Resets HUD changes.

- **`f4st-ffa:server:joinarea`**: Adds players to a specific area.
- **`f4st-ffa:server:exitzone`**: Removes players from a specific area.
- **`f4st-ffa:send_scoreboard`**: Sends scoreboard data.

## Komutlar ve Etkinlikler

- **`/checkarea`**: FFA alanındaki oyuncu sayısını kontrol eder.
- **`/ffa_resetstat`**: Belirli bir alanın istatistiklerini sıfırlar.
- **`/ffahud`**: HUD düzenleme modunu açar.
- **`/resethud`**: HUD düzenlemelerini sıfırlar.

- **`f4st-ffa:server:joinarea`**: Oyuncuları belirli bir alana ekler.
- **`f4st-ffa:server:exitzone`**: Oyuncuları belirli bir alandan çıkarır.
- **`f4st-ffa:send_scoreboard`**: Skor tablosu verilerini gönderir.

## ox_inventory Integration

If you are using `ox_inventory`, add the following line below the `weapon.disarm` line in your add this line:
```lua
if exports["f4st-ffa"]:InZone() then return end
```

## ox_inventory Entegrasyonu

Eğer `ox_inventory` kullanıyorsanız, `ox_inventory/modules/weapon/client.lua` içindeki weapon.disarm fonksiyonun altına aşşağıdaki kodu eklemeniz gerekmektedir:
```lua
if exports["f4st-ffa"]:InZone() then return end
