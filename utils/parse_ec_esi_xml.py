#!/bin/env dls-python

# need system python for libxml2 support with xpath

#- Originally written by Dimaond Light EPICS EtherCAT support.

#- Copied and rewritten/edited by Anders Sandström for use with ecmc (generating hardware support)

import libxml2
import sys

reqs = set()
base = None
verbose = False
printedPDOHeader = False

def parseInt(text):
    if text.startswith("#x") or text.startswith("0x"):
        return int(text.replace("#x", ""), 16)
    else:
        return int(text)
def getPdoName(node):
    name = node.xpathEval("Name")[0].content
    name = name.replace(" ", "")
    return name

def getPdoIndex(node):
    indexstr = node.xpathEval("Index")[0].content
    return parseInt(indexstr)

def hasEntryName(node):
    try:
        name= node.xpathEval("Name")[0].content
        subindex = node.xpathEval("SubIndex")[0].content
    except:
        return False
    return True

def getEntryName(node):
    name= node.xpathEval("Name")[0].content
    name= name.replace(" ", "")
    return name

def getEntryIndex(node):
    index= node.xpathEval("Index")[0].content
    index= index.replace(" ", "")
    index= index.replace("#", "")
    return int("0"+index,16)

def getEntrySubIndex(node):
    index= node.xpathEval("SubIndex")[0].content
    index= index.replace(" ", "")
    return int(index)

def getEntryDataType(node):
    dt= node.xpathEval("DataType")[0].content
    dt= dt.replace(" ", "")
    return dt

def getSDODataType(node):
    dt= node.xpathEval("Type")[0].content
    dt= dt.replace(" ", "")
    return dt

def getEntryBitLen(node):
    bitlen= node.xpathEval("BitLen")[0].content
    bitlen= bitlen.replace(" ", "")
    return int(bitlen)

def getSDOBitSize(node):
    bitlen= node.xpathEval("BitSize")[0].content
    bitlen= bitlen.replace(" ", "")
    return int(bitlen)

def printEcmcAddEntry(vendor,product,pdo,entry,direction,updateInRT,outputfile):
    # <TxPdo Fixed="1" Sm="3">
    sm = pdo.prop("Sm")
    pdoName = getPdoName(pdo)
    pdoIndex = getPdoIndex(pdo)
    entryName = getEntryName(entry)
    entryIndex = getEntryIndex(entry)
    entrySubIndex = getEntrySubIndex(entry)
    dt = getEntryDataType(entry)
    dataLen = getEntryBitLen(entry)
    print('ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},0x%x,0x%x,%d,%d,0x%x,0x%x,0x%x,%s_%d,%s,%d)' % (vendor, product, int(direction), int(sm), pdoIndex, entryIndex, entrySubIndex, dt, int(dataLen), entryName ,int(updateInRT) ),file=outputfile)

def printEcmcAddEntryEmpty(vendor,product,pdo,entry,direction,emptyIndex,outputfile):
    # <TxPdo Fixed="1" Sm="3">
    sm = int(pdo.prop("Sm"))
    pdoName = getPdoName(pdo)
    pdoIndex = getPdoIndex(pdo)
    entryName = "ec${ECMC_EC_MASTER_ID}.s${ECMC_EC_SLAVE_NUM}.sm" + str(sm) + ".pdo" + str(pdo) + ".empty" + str(emptyIndex)
    entryIndex = getEntryIndex(entry)
    dataLen = getEntryBitLen(entry)
    print(entry,file=outputfile)

def printPDOHeader(outputfile):
    print("#- =================================== ",file=outputfile)
    print("#- PDOs ",file=outputfile)
    print("#-",file=outputfile)

def printSDOHeader(outputfile):
    print("",file=outputfile)
    print("#- =================================== ",file=outputfile)
    print("#- SDOs ",file=outputfile)
    print("#-",file=outputfile)

def printSDO(sdoObject,dtlist,outputfile):    
    sdoName    = getEntryName(sdoObject)
    sdoIndex   = getEntryIndex(sdoObject)
    datatype   = getSDODataType(sdoObject)
    dataLen    = getSDOBitSize(sdoObject)
    byteCount  = dataLen/8
    bitsExByte = dataLen-byteCount*8
    print("#- SDO 0x%x, %s (%d.%d), %s" % (sdoIndex,datatype, byteCount, bitsExByte, sdoName),file=outputfile)
    dtlist[datatype].printRecursive(" ",dtlist)

class ecDataType:
    def __init__(self,outputfile):
        self.f = outputfile
        self.name = ""
        self.subIdx = -1
        self.bits = -1
        self.bitoffset = -1
        self.type = ""
        self.subItems = []
        self.bytes = -1

    def print(self, indentStr):
        self.bytes = self.bits/8
        if len(self.subItems) == 0 and self.subIdx >= 0:
            print("#- %s 0x%02x %20s %5d.%d (%3d): %s" % (indentStr,self.subIdx, self.type, self.bytes, self.bits-self.bytes*8, self.bitoffset, self.name),file=self.f)

    # Loop until "native" type
    def printRecursive(self, indentStr, datatypelist):
        self.bytes = self.bits/8
        indent = indentStr
        self.print(indent)
        for subItem in self.subItems:
            subItem.printRecursive(indent + "  ",datatypelist)

def parseDataType(dtnode,outputfilename):
    dt = ecDataType(outputfilename)
    dt.name = dtnode.xpathEval("Name")[0].content
    dt.bits = int(dtnode.xpathEval("BitSize")[0].content)
    counter = 0
    for subItemNode in dtnode.xpathEval("SubItem"):     
       subItem = ecDataType(outputfilename)
       subItem.subIdxNode = subItemNode.xpathEval("SubIdx")
       if len(subItem.subIdxNode)>0:
           subItem.subIdx= int(subItem.subIdxNode[0].content)
       subItem.typeNode = subItemNode.xpathEval("Type")
       if len(subItem.typeNode)>0:
           subItem.type= subItem.typeNode[0].content
       subItem.name = subItemNode.xpathEval("Name")[0].content
       subItem.bits = int(subItemNode.xpathEval("BitSize")[0].content)
       subItem.bitoffset = int(subItemNode.xpathEval("BitOffs")[0].content)
       dt.subItems.append(subItem)
       counter = counter+1
    return dt
    
def parseFile(filename, outputfile, list_devices, extraPdos):
    printedPDOHeader = False
    doc = libxml2.parseFile(filename)
    vendor = parseInt(doc.xpathEval("//Vendor/Id")[0].content)
    for device in doc.xpathEval("//Device"):
        dataTypeList={}
        try:
            devtype = device.xpathEval("Type")[0].content
            product = parseInt(device.xpathEval("Type/@ProductCode")[0].content)
            revision = parseInt(device.xpathEval("Type/@RevisionNo")[0].content)
        except:
            continue
        # key = (vendor, product, revision)
        key = (devtype, revision)
        if list_devices:
            print("%s 0x%08x (product = 0x%08x)" % (  devtype, revision, product))
            continue

        oversampling = set()
        
        if key in reqs:
            longin = []
            longout = []
            bi = []
            bo = []
            ai = []
            
            for dcmode in device.xpathEval("Dc/OpMode/Sm/Pdo[@OSFac]"):
                oversampling.add(parseInt(dcmode.content))
            emptyIndex = 0
            for txpdo in device.xpathEval("TxPdo"):
                # pdos without sync manager entries are not default
                if not txpdo.xpathEval("@Sm"):
                    if not (getPdoIndex(txpdo) in extraPdos):
                        continue

                for entry in txpdo.xpathEval("Entry"):
                    # some pdo entries are just padding with no name, ignore
                    if hasEntryName(entry):
                        datatype = entry.xpathEval("DataType")[0].content
                        if datatype == "BOOL":
                            bi.append(getPdoName(txpdo) + "." + getEntryName(entry) )
                        elif datatype == "FLOAT":
                            ai.append(getPdoName(txpdo) + "." + getEntryName(entry) )
                        else:
                            longin.append(getPdoName(txpdo) + "." + getEntryName(entry) )
                        if not printedPDOHeader:
                            printPDOHeader(outputfile)
                            printedPDOHeader = True
                        printEcmcAddEntry(vendor,product,txpdo,entry,2,1,outputfile)
                    elif verbose or True:
                        if not printedPDOHeader:
                            printPDOHeader(outputfile)
                            printedPDOHeader = True
                        print("Ignoring entry in pdo %s" % getPdoName(txpdo),file=outputfile)
                        printEcmcAddEntryEmpty(vendor,product,txpdo,entry,2,emptyIndex,outputfile)
                        emptyIndex = emptyIndex + 1
            emptyIndex = 0
            for rxpdo in device.xpathEval("RxPdo"):
                # pdos without sync manager entries are not default
                if not rxpdo.xpathEval("@Sm"):
                    if not (getPdoIndex(rxpdo) in extraPdos):
                        continue
                for entry in rxpdo.xpathEval("Entry"):
                    # some pdo entries are just padding with no name, ignore
                    if hasEntryName(entry):
                        datatype = entry.xpathEval("DataType")[0].content
                        if datatype == "BOOL":
                            bo.append(getPdoName(rxpdo) + "." + getEntryName(entry) )
                        else:
                            longout.append(getPdoName(rxpdo) + "." + getEntryName(entry) )
                        if not printedPDOHeader:
                            printPDOHeader(outputfile)
                            printedPDOHeader = True

                        printEcmcAddEntry(vendor,product,rxpdo,entry,1,1,outputfile)
                    elif verbose:
                        if not printedPDOHeader:
                            printPDOHeader(outputfile)
                            printedPDOHeader = True
                        print("Ignoring entry in pdo %s" % getPdoName(txpdo), file=outputfile)
                        printEcmcAddEntryEmpty(vendor,product,rxpdo,entry,1,emptyIndex,outputfile)
                        emptyIndex = emptyIndex + 1
            
            for dtnode in device.xpathEval("Profile/Dictionary/DataTypes/DataType"):
                dt = parseDataType(dtnode,outputfile)
                dt.print("  ")

                dataTypeList[dt.name] = dt

            printSDOHeader(outputfile)
            for sdoObject in device.xpathEval("Profile/Dictionary/Objects/Object"):
                printSDO(sdoObject,dataTypeList,outputfile)


def usage(progname):
    print("%s: Generate hardware support for ecmc " % progname)
    print("Usage:")
    print("   %s -h  Shows this usage message" % progname)
    print("   %s -b <xml-base-dir> -l  Lists the devices in the database" % progname)
    print("""
   %s -b <xml-base-dir> -d <device-type> -r <rev-no> [-p comma-separated-pdo-list] -o output-file
       Generates a ecmc hw support snippet in <output-file> for the given device and revision.
       rev-no must be input as a hex number, e.g. 0x00100000
       Use the -p argument to include additional pdos in the snippet
       """ % progname)

def parsePdoassignments(s):
    if len(s) == 0:
        return []
    assignments = list()
    for pdo_index in s.split(","):
        assignments.append(parseInt(pdo_index))
    return assignments

if __name__ == "__main__":
    import getopt
    devtype = None
    revision = None
    output = None
    list_devices = False
    pdoassignment = ""
    
    try:
        optlist, args = getopt.getopt(sys.argv[1:], 'hlb:d:r:o:vp:',
                    ['help','list','base=','device-type=','rev-no=',
                     'output=','verbose','pdoassignment='])
    except getopt.GetoptError as err:
        print(str(err))
        usage(sys.argv[0])
        sys.exit(2)
    for o,a in optlist:
        if o in ('-h', '--help'):
            usage(sys.argv[0])
            sys.exit()
        elif o in ('-l', '--list'):
            list_devices = True
        elif o in ('-b', '--base'):
            base = a
        elif o in ('-d','--device-type'):
            devtype = a
        elif o in ('-r','--rev-no'):
            revision = int(a,16)
        elif o in ('-v','--verbose'):
            verbose = True
        elif o in ('-o','--output'):
            output = a
        elif o in ('-p','--pdoassignment'):
            pdoassignment = a
        else:
            usage(sys.argv[0])
            sys.exit(1)
    if not base:
        print("No base specified")
        usage(sys.argv[0])
        sys.exit(1)
    elif verbose:
        print("base=%s" % base)
    if not list_devices:
        if not devtype :
            print("No devtype specified")
            usage(sys.argv[0])
            sys.exit(1)
        elif verbose:
            print("devtype=%s" % devtype)
        if  revision == None:
            print("No revision specified")
            usage(sys.argv[0])
            sys.exit(1)
        elif verbose:
            print("revision=%s" % revision)
        if not output:
            print("No output specified")
            usage(sys.argv[0])
            sys.exit(1)
        elif verbose:
            print("output=%s" % output)

        reqs.add((devtype, revision))
        if verbose:
            for obj in reqs:
                print("Searching device %s, revision 0x%08x" % obj)

    assert(list_devices or len(reqs) == 1)
    import os
    outputfile = open(output, "w")
    for f in os.listdir(base):
        if f.endswith("xml"):
            filename = os.path.join(base, f)
            if verbose:
                print("Parsing %s" % filename)
            parseFile(filename, outputfile, list_devices,
                      parsePdoassignments(pdoassignment))
    outputfile.close()



# loads chain description, outputs complete config file...
