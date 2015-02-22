Please claim things that you're working on!

CONCEPT OVERVIEW:
--------
- "battle arena": opponent, player, math question in the middle, text box to answer question, time limit bar
- grade = score, as you correctly answer your opponents grade goes down until they have a 0
- in battles, player can choose what type of math they are solving in a menu at bottom (+, -, *, /)
--- the game gives them time to prepare when they change math type (3, 2, 1...)
- overworld... player movement, beating back of class kids to front of class (smarter)
-- kids at desks are the ones that will fight you
- random characters in overworld with dialogue on edges of class 
- start with 50/100 health (F), each fight levels you up one grade and gives you more health
- missing an easy question hurts less than missing a difficult one, but difficult correct answers do more damage
- final boss is teacher: teacher chooses what type of math you must do (you go into this fight with an A)

TASKS:
------
----Misc:
- State machine menus -Al, DONE
- "Are you a boy or a girl?" different sprite based on response
- 8 bit bitmap font -Cherie, DONE
- Optional: "What is your name?" store and use in dialogue
- Optional: save and load files?

----Overworld:
- player movement -Al (change to WASD later, works with arrow keys currently)
- collision detection! -Al, DONE
- Display dialogue in box at bottom of screen -Al, DONE 
	(Dialogue is diplayed below the person the player is talking to)
	
- initiate a fight: walk up to student, press enter. Some dialogue, then go into arena!
- Graphic to show who you can fight currently (thought bubble, or '!')
- Cannot fight people out of your rank

----Arena:
- generate math questions - NANCY
- display math questions one at a time
- capture player input in text box
- player pushes enter to submit answer
- test to see if the player was correct, decrement player health if wrong or opponent health if right
- player health goes down if incorrect answer input

- time limit on answering math questions, player loses health if time runs out
- time limit is a bar on the screen
- allow the player to choose what type of math they are solving with a click menu at any time
-- Default to addition

ASSETS:
-------
We are doing an 8-bit style!
- classroom objects: desks...
- overworld students -Cherie
- classroom background
- arena background
- FAIL or PASS for end of fight
- optional: animations for the 'fights' (eg. happy/sad player sprite when questions answered)
- optional: more detailed sprites in fights
- Music - battle and overworld?
- Fight sounds