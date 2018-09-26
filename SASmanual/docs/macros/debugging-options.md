### `MLOGIC` Option

The `MLOGIC` option prints messages that indicate macro actions that were taken during macro execution.
```
OPTIONS MLOGIC | NOMLOGIC;
```

When the `MLOGIC` system option is in effect, the messages that SAS displays in the log include information about the following:
* The beginning of macro execution
* The values of any parameters
* The results of arithmetic and logical macro operations
* The end of macro execution

When you're working with a program that uses SAS macro language, you should typically turn the `MLOGIC` option, along with the `MPRINT` option and the `SYMBOLGEN` option
* `on` for development and debugging purposes
* `off` when the program is in production mode
