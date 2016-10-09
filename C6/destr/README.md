## Summary
`Destr.txt` script is made to make bot farming with destroyer vaiable.  
Script automaticaly uses conversion SA gun in combination with HP-consuming skills on mobs to lower character's HP below 30%, 
then equips `mainGun` and wait until there is no frenzy in buff list.
Script includes option to pause other character actions while in DEHP process.

### Usage
bot has to be configured not to attack w/o frenzy buff (`Fre.xml` included).
### Limitations
Script wont be very beneficial with characters lower than 77lvl (with Armor Crush skill), since dehp dehp will take too long to complete.  
It is strongly advised to use skript only with 78+ _titans_.
### Requires
#### `_other.pas`
1. 

### Known issues (to be fixed)
1. Acasionaly script will use frenzy witouth equiping dagger which will cause frenzy not to be ready for next time. 
2. Script does not check if frenzy reuse will be ready by the time dehp will be done, which causes character to die if frenzy is not ready in time.
3. 

### Features
Uses rage if there is no rage and Frenzy timeleft > 


### Tested on
Script was tested on these servers:
- `l2blaze.net`
- `l2neo.com`
