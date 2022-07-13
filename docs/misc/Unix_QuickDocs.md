# Unix Quick Docs
## File types
LS_COLORS | LSCOLORS
--------- | --------
Regular			| ------
Directory		| Directory
Symbolic link	| Symbolic link
Executable		| Executable
Socket			| Socket
FIFO			| Pipe
Block device	| Block special
Character device| Character special
Orphan			| ------
Mi				| ------
------			| Setuid
------			| Setgid
------			| Sticky
------			| Non-Sticky

## I/O Redirection

* `>`  operator redirects to file/device*
* `>>` operator appends to file/device*

\* StdOut stream is always assumed if a number is not specified

### StdIn, StdOut, StdErr
https://askubuntu.com/questions/350208/what-does-2-dev-null-mean

* `StdIn`     = Standard Input (Terminal input)
* `StdOut`    = Standard Output (Print to terminal)
* `StdErr`    = Standard Error (Print to terminal)
* `/dev/null` = Null Device: silently discard/suppress any output

#### File numbers/descriptors
A file descriptor is nothing more that a positive integer that represents an open file. If you have
100 open files, you will have 100 file descriptors for them.

* 0: Input descriptor
* 1: Output descriptor
* 2: Error descriptor

Syntax:`[file descriptor]>[target]`

* file descriptor = a number (0-2 typically, other programs define more numbers)
* target = a filename or '&'(another file descriptor)

```
Output  to target: '1>', '>'
Error   to target: '2>'

Out,Err to target: ' 2>&1 ' (POSIX), '&>' (Bashism)
Out,Err to pipe:   '2>&1 |' (POSIX), '&|' (Bashism)

Output  to StdErr: '1>&2', '>&2'
    To discard logging output that isn't the actual result of the computation, that
    is, sending the logging to standard error ensures that it won't get included
    with the real output that was redirected to target, i.e.: a output file
```

##### Examples:
```
StdOut
foo   >  bar.txt|/dev/null
foo  1>  bar.txt|/dev/null

StdErr
foo  2>  bar.txt|/dev/null

Both
foo 2>&1   bar.txt|/dev/null (To target)

foo    >   /dev/null 2>&1    (To discard - POSIX)
    Redirects stdout (1>,>) to /dev/null, and then, redirect stderr (2>) to
    whatever stdout (&1) was pointing to at the time (/dev/null)


foo   &>   /dev/null         (To discard - Bashism)
    Redirects stderr (2>) to whatever stdout (&1) was pointing to at the time
    (the tty), that is, (> /dev/null).


(No-Op)
foo 2>&1 > /dev/null        (No-Op for discarding err)
    Redirects stderr (2>) to whatever stdout (&1) was pointing to at the time
    (the tty) and then redirects stdout to /dev/null (> /dev/null), thus
    resulting in stderr still going to the tty.
```
