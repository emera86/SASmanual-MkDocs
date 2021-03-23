## Applying Certain Encoding to a Full Library

```
LIBNAME sas-library "path\to\library" inencoding='wlatin1';

LIBNAME sas-library "path\to\library" outencoding='wlatin1';
```

## Applying Certain Encoding to a Dataset

```
DATA sas-dataset-encoded;
    SET sas-dataset-original(ENCODING=any);
RUN;
```

See [more](https://documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.5&docsetId=nlsref&docsetTarget=n0utx4w7x4exijn1wt7pk0srrxz5.htm&locale=en) on encoding.
