## Examples of Shell Scripting in SAS

```
data _null_;
	X %unquote(%str(%'copy "original path/file to move.txt" "new path\" /y%'));
  
  X "cd path-to-enter/";
  
  X "mkdir new_folder";
run;
```
