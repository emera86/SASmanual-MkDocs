Después de crear un código de recodificación con el wizard
click derecho en el workflow, create as code, template, save code

## DATA Step Debugger

!!! summary "Check these websites"
    * [Demo: DATA Step Debugging in Enterprise Guide](http://video.sas.com/sasgf17/detail/videos/general-sessions/video/5383313949001/demo:-data-step-debugging-in-enterprise-guide)
    * [Using the DATA step debugger in SAS Enterprise Guide](https://blogs.sas.com/content/sasdummy/2016/11/30/data-step-debugger-sas-eg/)
    
This tool is for debugging `DATA` step code. It can't be used to debug `PROC SQL` or `PROC IML` or SAS macro programs. 

It can't be used to debug `DATA` steps that read data from `CARDS` or `DATALINES`. That's an unfortunate limitation, but it's a side effect of the way the `DATA` step *debug* mode works with client applications like SAS Enterprise Guide. To workaround this limitation you can load your data in a separate step and then debug your more complex `DATA` step logic in a subsequent step.

* When a variable changes its value, it's colored red. If the value hasn't changed it will remain black.
* If you want the `DATA` step to break processing when a certain variable changes value, check the **Watch** box for that variable.
* You can set and clear line-specific breakpoints by clicking in the left space next to the line number.
* In the **Debug Console** window you can introduce more complex breakpoints through commands:
   * [`BREAK`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p1oerjnpbn69x6n15k9tssu7ckl4.htm&docsetVersion=9.4&locale=es) suspends program execution at an executable statement
   * [`CALCULATE`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p0ot38ebrzxe0wn1m9zmqywud42m.htm&docsetVersion=9.4&locale=es) evaluates a debugger expression and displays the result
   * [`DELETE`](http://documentation.sas.com/?docsetId=basess&docsetTarget=n1xm0q51gfxajxn14vmlm4m6rf29.htm&docsetVersion=9.4&locale=es) deletes breakpoints or the watch status of variables in the `DATA` step
   * [`DESCRIBE`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p11qz7mnrt3x3yn1vetbm8xp1uxb.htm&docsetVersion=9.4&locale=es) displays the attributes of one or more variables
   * [`ENTER`](http://documentation.sas.com/?docsetId=basess&docsetTarget=n03u7i92wc602bn13dpsprsepr6r.htm&docsetVersion=9.4&locale=es) assigns one or more debugger commands to the **ENTER** key
   * [`EXAMINE`](http://documentation.sas.com/?docsetId=basess&docsetTarget=n00l1yv3npppndn11chwcn4hvsvk.htm&docsetVersion=9.4&locale=es) displays the value of one or more variables
   * [`GO`](http://documentation.sas.com/?docsetId=basess&docsetTarget=n0bwwhfeeur11mn13sixnvhuf87g.htm&docsetVersion=9.4&locale=es) starts or resumes execution of the `DATA` step
   * [`HELP`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p1tihgmmwzxkhwn1y2gsfusewwcr.htm&docsetVersion=9.4&locale=es) displays information about debugger commands
   * [`JUMP`](http://documentation.sas.com/?docsetId=basess&docsetTarget=n0d3dutsjoojf9n15fdab81uzswh.htm&docsetVersion=9.4&locale=es) restarts execution of a suspended program
   * [`LIST`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p0p56fh9a3wjm1n1lljyes7aixnt.htm&docsetVersion=9.4&locale=es) displays all occurrences of the item that is listed in the argument
   * [`QUIT`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p1q0lqpobxkqaxn1wexgtpq9f73r.htm&docsetVersion=9.4&locale=es) terminates a debugger session
   * [`SET`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p16f8ld3w72rn7n1fkr3ud0hzl9z.htm&docsetVersion=9.4&locale=es) assigns a new value to a specified variable
   * [`STEP`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p03samiyetemuun1m3v7spm9mrhp.htm&docsetVersion=9.4&locale=es) executes statements one at a time in the active program
   * [`SWAP`](http://documentation.sas.com/?docsetId=basess&docsetTarget=n05gwfgzb50fysn10os9gvmjin6a.htm&docsetVersion=9.4&locale=es) switches control between the **SOURCE** window and the **LOG** window
   * [`TRACE`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p0e1gr0riclt9kn1767jf9p4ska9.htm&docsetVersion=9.4&locale=es) controls whether the debugger displays a continuous record of the `DATA` step execution
   * [`WATCH`](http://documentation.sas.com/?docsetId=basess&docsetTarget=p1p7wyve105lmnn1kqhnijcbswwp.htm&docsetVersion=9.4&locale=es) suspends execution when the value of a specified variable changes

!!! note "Examples"
    `break 8 when (running_price > 100)` will break on line 8 when the value of running_price exceeds 100
    `break 8 after 5` will break on line 8 after 5 passes through the `DATA` step
