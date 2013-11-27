Terminal Usage Analytics
========================

Simple Ruby script that aims to give insights on the commands used on the terminal, looking for the most used commands, with and without arguments, chains of commands, typos, etc... The data gathered can be use to setup aliases and automations.

> This is a super alpha!

###Usage

_I'm still trying to figure out how to load the zsh history from the ruby script. So for the moment use:_ `ruby terminal_usage_analytics.rb /path/to/histfile`. To find the path just run `echo $HISTFILE` in zsh.

####Memo

You can see your history using the zsh builtin function (giving me so much trouble) `fc`. Run `fc -R; fc -l -n -d -E -1000` to get the last 1000 commands.

###TODOs

* Find commands chains
* Find typos
* Find command options usage regardless the order (`cmd -a -b` should be the same as `cmd -b -a`)
* Output as JSON
* Output as HTML page, using the above mentioned JSON
* Make a gem
* Decouple from `zsh fc`, and possibliy zsh itself.
* Configure history size
* Configure time interval

---

Like this project? Why don't follow me on twitter? [@mokagio](https://twitter.com/mokagio)
