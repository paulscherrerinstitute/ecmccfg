## Conventions

- declare variables with `epicsEnvSet`
- functions calls in the following two forms:
    1.  `fooBar arg1 arg2`
    2.  `fooBar(arg1, arg2)`

No mixes please, keep the code nice.
- Macros
    - put double quotes (`"`) around macros
    - use _UPPERCASE_ for macros
    - use _curly brackets_ for macros
    - i.e.: `"${MY_MIGHTY_MACRO}"`

- Example: `epicsEnvSet("DEV", "${SYS}")`
