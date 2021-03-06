IP替换
=======
```
:%s/\v<((\d|\d{2}|1\d{2}|2[0-5][0-5])\.){3}(\d|\d{2}|1\d{2}|2[0-5][0-5])>/127.0.0.1/g
```

TMUX
=====================

tmux logging  :  ctrl  + b   : <br>
pipe-pane -o "cat >>/Desktop/#W.log" <br>
pipe-pane -o "cat >>/111.log" <br>
http://hyperpolyglot.org/multiplexers

```
~.tmux.conf改为:
set-option -g history-limit 30000
bind D source-file ~/.tmux/mylayout


 ~/.tmux/mylayout改为:
selectp -t 0    #选中第0个窗格
splitw -v -p 50  #将其分成上下两个，这样就变成了图中的布局了
selectp -t 1
splitw -h -p 50
selectp -t 0     #选回第一个
splitw -h -p 50
selectp -t 3
splitw -h -p 50
selectp -t 2
splitw -h -p 50
selectp -t 1
splitw -h -p 50
selectp -t 0
splitw -h -p 50

tmux    ctrl+b  shift + D

```


MySQL Proxy scripts for devs
============================
https://zhjwpku.com/2018/01/16/mysql-proxy-alternatives.html
This is a repository of useful [MySQL Proxy][mysql-proxy] scripts targetting
mainly developers in quest of debugging.

Requirements
------------

[MySQL Proxy][mysql-proxy] >= 0.8 (May work with earlier version, untested)

Running
-------

```bash
$ mysql-proxy --proxy-lua-script=/absolute/path/to/the/script.lua
```

Scripts
-------

### debug.lua

Prints every SQL command received while cleaning obsolete spaces. Every
command appears on one line with the following additional information:

* an optional informative message about the query,
* the number of rows returned or affected by the query,
* the amout of time (in ms) it took to run the query.

Additionally, colors are used to provide direct information on the queries:

* yellow: when not using a good index (no\_good\_index\_used flag),
* yellow + bold: when not using an index at all,
* red: when an error occured,
* pink: for queries affecting records.

Colors are also used to denote slow queries: time displayed in red instead of
green. When a query returns no rows nor affect records, "<NONE>" is displayed
using red in reverse video.

If you want to force "SQL_NO_CACHE" in your SELECT statements you can set the use_sql_no_cache variable to 1.

### debug-blind.lua

Same as debug.lua, but without shell colors.

### log_all_queries.lua

Same as debug.lua, but logs to a file (/var/log/mysql-proxy/querydebug.log) and with different fields.

### slow.lua

Simulates a server being slow because of huge traffic.

The *sleep* command accepting a float as argument is required to make this
script works out of the box.

The slowdowns can be configured to make all requests longer by a factor or by
a fixed amount of time (or both).

By default, requests are made twice slower with an additional overhead of 0.1s.

[mysql-proxy]: http://forge.mysql.com/wiki/MySQL_Proxy

### no-mysql.lua

仍需要一个后端DB用于校验用户名密码等,但请求不发到后端DB去(已验证),并且性能还可以19474 QPS(单线程)  27264 QPS (6线程)  与6个mysql 客户端一起占用约20% 的CPU.    单线程 与mysql client 一起占用15%左右的CPU  36352  QPS (16线程)
