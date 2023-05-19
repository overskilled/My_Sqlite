# Welcome to My Sqlite
***

## Table of contents
* [Task](#Task)
* [Description](#Description)
* [Installation](#Installation)
* [Usage](#Usage)

## Task

### Part 00
This project require to reproduce the behavoir that a request will have on the real Sqlite. So as to be able to query a database or a fill and get the disired result following the sqlite syntax.

### Part 01
Here, it was required to get the request from the **Comand Line Inteface (CLI)**, process it and print out the result of the request.

## Description
This project is created using :
* Ruby version : 3.1.2
* Readline module

### Ruby
This project require the use of various features availiable on ruby such as **class**, where it was required to create a class called **MySqliteRequest** in the file [my_sqlite_request.rb](my_sqlite_request.rb), and a **class** called **MySqlite** in the file [my_sqlite_cli.rb](my_sqlite_cli.rb). In this classes, various methods where implemented in other to process the data entered in the request

### READLINE module
This project require the implementation of a **CLI**. This was made posible by the use of the readline module. The CLI allows users to copy and paste texte using **Ctrl + Shift + c and Ctrl + Shift + v** respectively. The text write will be taking as query and if it respects the sqlite syntax/format, the demanded operation will be executed.

To exit the CLI simply type in **quit**


## Installation
To run this project with the CLI, run the file with:

```
$ ruby my_sqlite_cli.rb"
```
Or type in the request in the following format for the [my_sqlite_request.rb](my_sqlite_request.rb) file:

```
 request = MySqliteRequest.new
 request = request.from(file/database name)
 request = request.select(column name)
 request = request.where(column nam, criteria)
 request.run
```


## Usage
**Example 00**
```
$>ruby my_sqlite_cli.rb
MySQLite version 0.1 20XX-XX-XX
my_sqlite_cli> SELECT * FROM students.db;
Jane|me@janedoe.com|A|http://blog.janedoe.com
my_sqlite_cli>INSERT INTO students.db VALUES (John, john@johndoe.com, A, https://blog.johndoe.com);
my_sqlite_cli>UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Jane';
my_sqlite_cli>DELETE FROM students WHERE name = 'John';
my_sqlite_cli>quit
$>
```

### The Core Team


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>
