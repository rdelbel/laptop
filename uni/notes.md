Module 1: Linux Shell
=
Shell
-
- iterface to OS
- gets the OS to do things for us
- run programs
- manipulate files
- etc.
- echo \$0 to see what shell
- \$ is probably bash
\end{itemize}

Linux File System
-
- files (programs, data)
- directories (considered files) (contains files, other directories)
- directories have a tree structure 

Relative Path - starts from the current directory instead of /. Eg if the
current dir is /u/j24smith then the relative path  cs246/a1/a1.cc is the same
as the absolute path /u/j24smith/cs246/a1/a1.cc. 

Absolute paths: start with /
Relative paths: dont start with /

Special directories:
- . current directory
- .. current directories parent
-  ../.. current directories grandparent
- ~ home directory

Absolute
* home directory
~ userid - userids home direcotry

ls command to de whats in a dir
ls does not show everything
-any file whos name starts with . is hidden
To see everything ls -a

Wildcard Matching
-

What if I want to see just the text files
In unix there is no rules for extensins. Linux does not care. We pick names
with . becuase we are used to it and maybe some programs we use need it.
Nevertheless lets assume we mean files that end with .txt.

ls *.txt
*.txt is called a globbing pattern.
*="Match anything"
*.txt="Match anything ending with .txt"

What happens when I supply a globbing pattern on the command line?

The shell substitutes every file in the current directory that mattches the
pattern onto the command line.
If no match - original glob left unaltered.

EG if dir contains t1.txt t2.txt index.html
then ls *.txt is transformed by the shell to ls t1.txt t2.txt and you get
t1.txt t2.txt. Works for other commands too.

echo hello prints hello
echo *.txt transofmred into echo t1.txt t2.txt and prints t1.txt t2.txt. 

When glob does not match it just prints the glob. eg echo *.textfile prints
*.textfile.
rm *.txt removes both files

What if I really want to print *.txt?
Put it in quotes - single or double

Files
-

cat -displays contesnts of the file
cat /usr/share/dict.words
^c to stop. ^=hold down control

What if you just type cat?
Prints out everything you type in
Useful? If you can capture the output in the file.

cat > output.txt
^D tell program you are done and let it kill its self. maybe do cleanup. at the
beginning of a ine sends the end of file (EOF) signal to cat.

In general, command args > file executes command args, and captures the output
in file instead of sending to the screen. This process is called output
redirection.
