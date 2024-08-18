
# 🎮 Cyber Arcade | [Showcase Video](https://youtu.be/pqsBLU7SiWA)

SyncLib's Free, Open Source Cyber Arcade Resource offers players a legitimate business to enhance their skills with various supported hacking minigames commonly used in heists.

## 🛠️ Supported Frameworks
- [QBCore](https://github.com/QBCore-Framework)
## 📋 Requirements

Specific Requirements are optional and configurable in the `config.lua`

**📦 Required Resources:**
- [QBCore](https://github.com/QBCore-Framework)

**🏠 Supported MLO's:**
- [Kiiya Arcade](https://www.gta5-mods.com/maps/arcade-bar-interior-mlo-fivem-sp)
- [Gabz Arcade](https://gabzv.com) - *(Currently not supported, as I don't have a Gabz Subscription. Please message me in the Discord if you can help in any way!)*

**🎯 Supported Minigames:**
- [QBCore Minigames](https://github.com/qbcore-framework/qb-minigames)
- [Haaasib Skillchecks - NoPixel v4 Minigames](https://github.com/Haaasib/skillchecks)
- [Project Sloth UI](https://github.com/Project-Sloth/ps-ui)
- [Utkuali - Finger Print Minigame](https://github.com/Project-Sloth/ps-ui)
## 📂 Installation

- Download `sl-CyberArcade` through latest releases
- Remove any `version numbers` or `-main` after `sl-CyberArcade`
- Drag and drop into any resource folder
- [qb] > qb-core > shared > items.lua
```lua
    arcadetokens                 = { name = 'arcadetokens', label = 'Arcade Tokens', weight = 0, type = 'item', image = 'arcadetokens.png', unique = false, useable = false, shouldClose = false, description = 'Tokens used for playing arcade games' },
```
- [qb] > qb-inventory > html > images
```lua
   Drag sl-CyberArcade/images/arcadetokens.png into above directory
```
- Restart your server