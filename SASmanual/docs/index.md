Hope this site help you with your SAS programming.
Contact me if you want any content to be added to this brief (hopefully not so brief in the future) manual. 
I will be glad to include it.

Enjoy! :)
    
---

If this is your starting point with SAS programming, maybe these readings could be useful:

* [Getting Started with SAS Programming](https://support.sas.com/edu/OLTRN/ECPRG193/m411/m411_5_a_sum.htm)
* [Working with SAS Programs](https://support.sas.com/edu/OLTRN/ECPRG193/m412/m412_3_a_sum.htm)
* [Interesting configuration tips and tricks](http://support.sas.com/resources/papers/proceedings14/SAS331-2014.pdf)
* Print out the available SAS packages according to your license and the expiration dates: 

```
PROC SETINIT; 
RUN;
```

* Comments:

```
/* comment */
* comment statement;
```

* When you name a process flow `Autoexec`, SAS Enterprise Guide prompts you to run the process flow when you open the project. This makes it easy to recreate your data when you return to the project.

* How to [compare SAS programs](http://blogs.sas.com/content/sasdummy/2015/04/03/compare-sas-programs-in-sas-enterprise-guide/) in SAS Enterprise Guide

* Send an [email](http://support.sas.com/documentation/cdl/en/lestmtsref/63323/HTML/default/viewer.htm#n0ig2krarrz6vtn1aw9zzvtez4qo.htm) with some coding

### Shortcuts

| Shortcut | Function |
|----------|----------|
| F3 | Run selection or run all if there's nothing selected |
| Ctrl + I | Beautify code (proper indentation) |
| Ctrl + Shift + U | Convert to uppercase |
| Ctrl + Shift + L | Convert to lowercase |
| Ctrl + / | Wrap selection (or current line) in a comment |
| Ctrl + Shift + / | Unwrap selection (or current line) from a comment | 
| Ctrl + G | Go to line (prompts for a line number) |
| Ctrl + [, Ctrl + ] | Move caret to matching parenthesis/brace |
| Alt + [, Alt + ] | Move caret to matching DO/END keyword |

!!! seealso
    [5 keyboard shortcuts in SAS that will change your life](http://blogs.sas.com/content/sasdummy/2013/10/29/five-keyboard-shortcuts/)

