Terminal Usage Analytics
========================

Simple Ruby script that aims to give insights on the commands used on the terminal, looking for the most used commands, with and without arguments, chains of commands, typos, etc... The data gathered can be use to setup aliases and automations.

> This is a super alpha!

###TODOs

* Find commands chains
* Find typos
* Find command options usage regardless the order (`cmd -a -b` should be the same as `cmd -b -a`)
* Output as JSON
* Output as HTML page, using the above mentioned JSON
* Make a gem
* Decouple from `zsh fc`
* Configure history size
* Configure time interval

---

Like this project? Why don't follow me on twitter? [@mokagio](https://twitter.com/mokagio)
