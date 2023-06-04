# SRC SKILLS

| If you are intested in recieving github updates join the community on **[Discord](https://discord.gg/tebex)**! |

* A database held skill/XP system for QBCore and ESX


# PREVIEW
![image-removebg-preview (1)](https://github.com/dollar-src/src-skills/assets/78104813/bfee1461-f2b3-4ba7-bce4-d6b614523502)


**[ Installation ]**
* Download the resource and drop it to your resource folder.
* Import the SQL file to your server's database (if u use QBCore install qb.sql/ if u use ESX use esx.sql)
* Add start src-skills to your server.cfg


**[ Using src-skills ]**
* To Update a skill please use the following export:
```lua
   exports["src-skills"]:UpdateSkill(skill, amount)
```
* For example, to update "Mining"
```lua
    exports["src-skills"]:UpdateSkill("Mining", 1)

```
* The export to check to see if a skill is equal or greater than a particular value is as follows:
```lua
   exports["src-skills"]:CheckSkill(skill, val)

```
* For Example to check skill
```lua
   exports["src-skills"]:CheckSkill("Mining", 100, function(hasskill)
    if hasskill then
        print('Success')
       else
        print('Error')
     end
    end)

```
* To check for skill use this export
```lua
    exports["src-skills"]:GetCurrentSkill(skill)
```
*  For Example to check current skill
```lua
   local skill =  exports["src-skills"]:GetCurrentSkill('Mining')
   print('Skill Level is'..skill)
```
* QBCore SQL 
```sql
ALTER table players
	ADD COLUMN `skills` LONGTEXT;
```
* ESX SQL 
```sql
ALTER table players
	ADD COLUMN `skills` LONGTEXT;
```

# Inspiration
**[Inspiration](https://github.com/MrZainRP/mz-skills/tree/main)**

 
# Dependencies

**[ox_lib](https://github.com/overextended/ox_lib)**

