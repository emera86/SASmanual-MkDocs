Después de crear un código de recodificación con el wizard
click derecho en el workflow, create as code, template, save code

## DATA Step Debugger

!!! summary "Check these websites"
    * [Demo: DATA Step Debugging in Enterprise Guide](http://video.sas.com/sasgf17/detail/videos/general-sessions/video/5383313949001/demo:-data-step-debugging-in-enterprise-guide)
    * [Using the DATA step debugger in SAS Enterprise Guide](https://blogs.sas.com/content/sasdummy/2016/11/30/data-step-debugger-sas-eg/)
    
This tool is for debugging `DATA` step code. It can't be used to debug `PROC SQL` or `PROC IML` or SAS macro programs. 

It can't be used to debug `DATA` steps that read data from `CARDS` or `DATALINES`. That's an unfortunate limitation, but it's a side effect of the way the `DATA` step *debug* mode works with client applications like SAS Enterprise Guide. To workaround this limitation you can load your data in a separate step and then debug your more complex `DATA` step logic in a subsequent step.
