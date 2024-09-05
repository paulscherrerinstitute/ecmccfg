## PLC function libs:
Function libs can be loaded into ecmc-PLCs
```
${SCRIPTEXEC} ${ECMC_CONFIG_ROOT}loadPLCLib.cmd,     "FILE=./plc/test.plc_lib, PLC_MACROS='OFFSET=3'"
```
The functions must be defined accordning to template: 
```
function <name>(<param1>,...<param5>) {
  <code body>;
}

also without param is allowed:
function <name>() {
  <code body>;
}

```
* For syntax of the "code body", check the exprtk website.
* Several functions can be defined in the same file.
* The parameters aswell as the return value must be scalars, however, local vectors can be defined and used in calculations (initiations of vector can be done with MACROS, constants or parameters).
* "#" as a first char in a line is considered a comment (the line will be removed before compile).
* MSI: The lib file will be parsed through MSI allowing macro expansion, "include" and "subsitute" commands. For more info check the msi documentation/help.
  
### Can be used in a function:
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

### "ecmc variables" can _NOT_ be  used/accessed in a functions:
1. EtherCAT I/0 direct access ec<mid>.s<sid>.*
2. Data storage variables: ds.*
3. Motion variables: ax<axid>.*
4. Static variables: static.*
5. Global variables: global.*
6. Vectors as parameter or return value (only first value will be passed).

### A function lib example
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
