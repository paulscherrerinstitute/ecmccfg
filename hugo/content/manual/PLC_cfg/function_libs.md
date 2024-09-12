+++  
title = "function libs"
weight = 17
chapter = false  
+++

## function libs
Function libraries can be loaded into ecmc PLCs by loadPLCLib.cmd. The command takes these parameters:
* FILE PLC: definition file, i.e. ./plc/homeSlit.plc
* PLC_ID: (optional) PLC number, default last loaded PLC
* PLC_MACROS: (optional) Substitution macros for PLC code. The macros "SELF_ID","SELF",M_ID, and M are reserved:
  - "SELF_ID" = PLC Id of this plc
  - "SELF"    = "plc${SELF_ID}"
  - "M_ID"    = EtherCAT master ID
  - "M"       = "ec${M_ID}"
* INC: (optional) List of directories for include files to pass to MSI (if several paths then divide with ':').
* TMP_PATH: (optional) directory to dump the temporary plc file after macro substitution
* PRINT_PLC_FILE: (optional) 1/0, printout msi parsed plc file (default enable(1)).

Example:
```bash
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}loadPLCLib.cmd,     "FILE=./plc/test.plc_lib, PLC_MACROS='OFFSET=3'"
```

The functions must be defined accordning to this template (max 5 parameters):
```C
function <name>(<param1>,...,<param5>) {
  <code body>;
}
```

also without param is allowed:
```C
function <name>() {
  <code body>;
}
```

* Several functions can be defined in the same file.
* For syntax of the "code body", check [plc syntax](../syntax) and the exprtk website.
* The parameters aswell as the return value must be scalars, however, local vectors can be defined and used in calculations (initiations of vector can be done with MACROS, constants or parameters).
* "#" as a first char in a line is considered a comment (the line will be removed before compile).
* The lib file will be parsed through MSI allowing macro expansion, "include" and "subsitute" commands. For more info check [best practice](../best_practice) and msi documentation/help.

### can be used in a functions
1. The parameters
2. Other functions (also recursive)
3. The normal ecmc function libs:
  * motion: mc_*
  * ethercat: ec_*
  * data storages: ds_*,
  * master 2 master: m2m_*
4. the exprtk functions libs:
  * println
  * print
  * open
  * close
  * write
  * read",  
  * getline
  * eof
 5. vectors in the calculations (but NOT as parameter or return value).

### can _NOT_ be used in functions
"ecmc variables" can _NOT_ be  used/accessed in functions:
1. EtherCAT I/0 direct access ec<mid>.s<sid>.*
2. Data storage variables: ds.*
3. Motion variables: ax<axid>.*
4. Static variables: static.*
5. Global variables: global.*
6. Vectors as parameter or return value (only first value will be passed).

### example function lib file
```
# Nothing fancy
function add(a,b,c,d,e) {
  println('This is add:            ',  a+b+c+d+e)
  return[a+b+c+d+e+${OFFSET=0}];
};

function prod(a,b,c,d,e) {  
  println('This is prod, add2 :    ',  add(a,b,c,d,e));
  println('This is prod, prod:     ',  a*b*c*d*e);
  return [a * b * c * d * e + ${OFFSET=0}];
};

# function with vector calcs (inside)
function testLocalArray(a) {
  var test[5]:={a,a,a,a,a};
  println('This is testLocalArray: ',test);
  return [dot(test,test)];
};

# function without arg
function one() {
  println('This is one:              ',1);
  return [1+${OFFSET=0}];
}

# function with ecmc function inside
function testm2m() {
  m2m_write(0,m2m_read(0)+${OFFSET=0});
  println('This is testmt2: elem 0: ',m2m_read(0));
}
```

### debugging
Unfortunately debugging of function libs is not as easy as normal PLC:s since exprtk returns less infomation at compile failure.

{{% notice tip %}}
In order to troubleshoot, load the code as a normal PLC instead. This way you will get more diagnostics. Also remember, ecmc varaibles cannot be accessed in plc libs.
{{% /notice %}}
