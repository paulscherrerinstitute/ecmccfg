from lxml import etree
import json
import argparse
import fnmatch  # Ensure fnmatch is imported

entryDict={
  "Status"          : "Stat",
  "Control"         : "Ctrl",
  "Feedback"        : "Fb",
  "Digital Input"   : "BI",
  "digital Input"   : "BI",
  "Digital Output"  : "BO",
  "digital Output"  : "BO",
  "Outputs Output"  : "BO",
  "Inputs"          : "Inp",
  "Input"           : "Inp",
  "Outputs"         : "Outp",
  "Output"          : "Outp",
  "Event"           : "Evt",
  "Cycle"           : "Cycl",
  "Counter"         : "Cntr",
  "Buffer"          : "Buff",
  "Short"           : "Shrt",
  "Circuit"         : "Circ",
  "Overflow"        : "Ovrflw",
  "Underflow"       : "Undrflw",
  "Order"           : "Ordr",
  "State"           : "State",
  "Manual"          : "Man",
  "Extern"          : "Ext",
  "Latch"           : "Ltch",
  "Error"           : "Err",
  "Value"           : "Val",
  "Toggle"          : "Tgl",
  "Timestamp"       : "Tme",
  "Time"            : "Tme",
  "Warning"         : "Wrn",
  "Moving"          : "Mov",
  "Positive"        : "Pos",
  "Negative"        : "Neg",
  "Torque"          : "Trq",
  "Reduced"         : "Red",
  "Reduce"          : "Red",
  "Done"            : "Dne",
  "Of"              : "",
  "Ready"           : "Rdy",
  "Enable"          : "Ena",
  "Extrapolation"   : "Ext",
  "Stall"           : "Stl",
  "InfoData"        : "InfDta",
  "Edge"            : "Edg",
  "Reset"           : "Rst",
  "Position"        : "Pos",
  "Setpoint"        : "Set",
  "Actual"          : "Act",
  "Valid"           : "Vld",
  "Inp"             : "BI",
  "Busy"            : "Bsy",
  "Channel"         : "Ch",
  "Overtemperature" : "OvrTmp",
  "Overcurrent"     : "OvrCurr",
  "Open"            : "Opn",
  "Load"            : "Ld",
  "Force"           : "Frce",
}

pdoOutDict={
  "DIG"             : "BO",
  "ENC"             : "Enc",
  "MTI"             : "BI",
  "MTO"             : "BO",
  "POS"             : "Pos",
  "STM"             : "Drv",
  "Latch"           : "Ltch",
  "Channel"         : "BO",
}

pdoInpDict={
  "DIG"             : "BI",
  "ENC"             : "Enc",
  "MTI"             : "BI",
  "MTO"             : "BO",
  "POS"             : "Pos",
  "STM"             : "Drv",
  "Latch"           : "Ltch",
  "Channel"         : "BI",
}

devsNeedIndex={
  "ENC"             : "Enc",
  "MTI"             : "BI",
  "MTO"             : "BO",
  "POS"             : "Pos",
  "STM"             : "Drv",
}

removeDictLast={
  "Outp-Outp"       : "",
  "Inp-Inp"        : "",
}

def removeTrailingHyphen(s: str) -> str:
    if s.endswith('-'):
        return s[:-1]
    return s

def checkPDODeviceAndChannel(name,input):
    words = name.split()
    devType=words[0]
    devStr=devType
    channelNumber = -1
    if input:        
        devType = checkPDODictInp(devType)
    else:
        devType = checkPDODictOut(devStr)
    # Find the word "Channel" and get the next word as the number
    for i in range(len(words) - 1):
        if words[i] == "Channel" and words[i + 1].isdigit():
            channelNumber = int(words[i + 1])
            break
    devStr = devType
    # check if device should have a default "01" index
    if channelNumber<0:
        if words[0] in devsNeedIndex:
           channelNumber = 1

    if channelNumber>=0:
        devStr = devStr + str(channelNumber).zfill(2)
    print ("Dev: " + devStr)
    return devType, devStr

def ifDigitLastMakeIt2Wide(s):
    i = len(s) - 1
    # Leta baklänges efter där siffrorna tar slut
    while i >= 0 and s[i].isdigit():
        i -= 1

    # Om det fanns siffror i slutet
    if i < len(s) - 1:
        prefix = s[:i+1]
        number = s[i+1:]
        return f"{prefix}{int(number):02d}"
    else:
        # Inga siffror i slutet, returnera originalsträngen
        return s

def convertName(dev, prefix, str):
    str = charsAfterSpaceToUpper(str)
    str = checkEntryDict(str)
    str = twoUnderScoresToDash(str)
    str = str.replace(" ", "")
    # Remove devices in entry name (already included in prefix)
    str = str.replace(dev, "")
    str = prefix + "-" + str
    str = str.replace("--", "-")
    str = ifDigitLastMakeIt2Wide(str)
    str = removeTrailingHyphen(str)
    str = checkRemoveDict(str,removeDictLast)
    return str

def charsAfterSpaceToUpper(str):
    result = ""
    lastchar=""
    for char in str:
        if lastchar == ' ':
          char = char.upper()
        result+=char
        lastchar = char
    return result

def twoUnderScoresToDash(str):
    return str.replace("__", "-")

def checkEntryDict(str):
    for key, value in entryDict.items():   
      str=str.replace(key,value )
    return str

def checkRemoveDict(str, dict):
    for key, value in dict.items():   
      str=str.replace(key,value )
    return str

def checkPDODictInp(str):
    for key, value in pdoInpDict.items():   
      str=str.replace(key,value )
    return str

def checkPDODictOut(str):
    for key, value in pdoOutDict.items():   
      str=str.replace(key,value )
    return str

def removeVowles(str):
    vowels = ['a', 'e', 'i', 'o', 'u']
    result = ""
    for char in str:
        if char not in vowels:
            result+=char
    return result

def parse_revision_number(revision_text):
    # Convert hex revision number (e.g. #x00100000) to an integer
    if revision_text and revision_text.startswith("#x"):
        return int(revision_text[2:], 16)  # Convert from hex to integer
    return None

def to_hex(value):
    """Function to convert values to hex format (with '0x' prefix)"""
    if value is None:
        return ""
    try:
        return hex(int(value))
    except ValueError:
        return value  # Return the original value if it's not a number

def parse_esi(esi_file, name_wildcard, rev_wildcard):
    tree = etree.parse(esi_file)  # Use lxml's etree for parsing
    root = tree.getroot()

    slaves = []

    for device in root.xpath('//Device'):  # Use XPath to find all <Device> elements
        device_name = device.xpath("Name/text()")[0] if device.xpath("Name/text()") else ''

        # Use XPath to extract revision number and product code
        devtype = device.xpath("Type")[0].text if device.xpath("Type") else None
        product_code = device.xpath("Type/@ProductCode")[0] if device.xpath("Type/@ProductCode") else None
        revision_raw = device.xpath("Type/@RevisionNo")[0] if device.xpath("Type/@RevisionNo") else None

        print(f"Checking device: {device_name}, raw revision: {revision_raw}")  # Debugging print

        revision = parse_revision_number(revision_raw)
        revision_hex = to_hex(revision) if revision is not None else 'None'
        print(f"Parsed revision for device {device_name}: {revision_hex}")  # Debugging parsed revision

        # If the device matches the wildcard patterns
        if fnmatch.fnmatch(device_name, name_wildcard) and (rev_wildcard == "*" or fnmatch.fnmatch(str(revision_hex), rev_wildcard)):
            slave = {
                'name': device_name,
                'product_id': to_hex(parse_revision_number(product_code)),
                'revision': revision_hex,
                'PDOmaps': [],
                'TxPDO': [],
                'RxPDO': [],
            }
            #<AlternativeSmMapping Default="1">
		    #	<Name>Velocity control compact</Name>
		    #	<Sm No="2">
		    #	    <Pdo>#x1600</Pdo>
		    #   	<Pdo>#x1602</Pdo>
		    #		<Pdo>#x1604</Pdo>
		    #	</Sm>
		    #	<Sm No="3">
		    #	    <Pdo>#x1a00</Pdo>
		    #		<Pdo>#x1a03</Pdo>
		    #	</Sm>
		    #</AlternativeSmMapping>
            for mapping in device.xpath('.//AlternativeSmMapping'):  # Adjusted XPath to select TxPdo elements
                default = mapping.xpath('@Default')[0] if mapping.xpath('@Default') else None
                name = mapping.xpath('Name/text()')[0] if mapping.xpath('Name/text()') else None
                sms = []
                for sm in mapping.xpath('.//Sm'):  # Adjusted XPath to select TxPdo elements
                    smindex = sm.xpath('@No')[0] if sm.xpath('@No') else None
                    pdos = []
                    
                    for pdo in sm.xpath('.//Pdo'):
                        pdoIndex = to_hex(parse_revision_number(pdo.xpath('text()')[0])) if pdo.xpath('text()') else None
                        pdos.append(pdoIndex)
                    
                    sm = {
                        'index': smindex,
                        'pdos': pdos,
                    }
                    sms.append(sm)

                map = {
                    'name': name,
                    'default': default,
                    'sm' : sms,
                }
                slave['PDOmaps'].append(map)

            # Debugging: Print out all TxPDO entries for the current device
            print(f"Searching for TxPDO for device {device_name}")
            for txpdo in device.xpath('.//TxPdo'):  # Adjusted XPath to select TxPdo elements
                sm = txpdo.xpath('@Sm')[0] if txpdo.xpath('@Sm') else None  # Get Sm attribute, if present
                index = to_hex(parse_revision_number(txpdo.xpath('Index/text()')[0])) if txpdo.xpath('Index/text()') else ''
                name = txpdo.xpath('Name/text()')[0] if txpdo.xpath('Name/text()') else ''
                dev, prefix = checkPDODeviceAndChannel(name,0)
                exclude = to_hex(parse_revision_number(txpdo.xpath('Exclude/text()')[0])) if txpdo.xpath('Exclude/text()') else None

                # For each Entry inside TxPdo
                entries = []
                for entry in txpdo.xpath('.//Entry'):
                    print('index= ' + str(parse_revision_number(entry.xpath('Index/text()')[0])))
                    print('subindex= ' + str((entry.xpath('SubIndex/text()'))))

                    entry_data = {
                        'index': to_hex(parse_revision_number(entry.xpath('Index/text()')[0])) if parse_revision_number(entry.xpath('Index/text()')[0]) is not None else "",
                        'subindex': to_hex(parse_revision_number(entry.xpath('SubIndex/text()')[0])) if len(entry.xpath('SubIndex/text()')) > 0 else '',
                        'bitlen': entry.xpath('BitLen/text()')[0] if entry.xpath('BitLen/text()') else '',
                        'name': convertName(dev, prefix, entry.xpath('Name/text()')[0]) if entry.xpath('Name/text()') else '',
                        'desc' : entry.xpath('Name/text()')[0] if entry.xpath('Name/text()') else '',
                        'data_type': entry.xpath('DataType/text()')[0] if entry.xpath('DataType/text()') else ''
                    }
                    entries.append(entry_data)

                # Add the extracted TxPDO data
                txpdo_entry = {
                    'sm': sm,
                    'index': (index),
                    'name': name,
                    'exclude': (exclude),
                    'entries': entries
                }

                slave['TxPDO'].append(txpdo_entry)

            # Debugging: Print out all RxPDO entries for the current device
            print(f"Searching for RxPDO for device {device_name}")
            for rxpdo in device.xpath('.//RxPdo'):  # Adjusted XPath to select RxPdo elements
                sm = rxpdo.xpath('@Sm')[0] if rxpdo.xpath('@Sm') else None  # Get Sm attribute, if present
                index = to_hex(parse_revision_number(rxpdo.xpath('Index/text()')[0])) if rxpdo.xpath('Index/text()') else ''
                name = rxpdo.xpath('Name/text()')[0] if rxpdo.xpath('Name/text()') else ''
                dev, prefix = checkPDODeviceAndChannel(name,1)                
                exclude = to_hex(parse_revision_number(rxpdo.xpath('Exclude/text()')[0])) if rxpdo.xpath('Exclude/text()') else None
                # For each Entry inside RxPdo
                entries = []
                for entry in rxpdo.xpath('.//Entry'):
                    entry_data = {
                        'index': to_hex(parse_revision_number(entry.xpath('Index/text()')[0])) if parse_revision_number(entry.xpath('Index/text()')[0]) is not None else "",
                        'subindex': to_hex(parse_revision_number(entry.xpath('SubIndex/text()')[0])) if len(entry.xpath('SubIndex/text()')) > 0 else '',
                        'bitlen': entry.xpath('BitLen/text()')[0] if entry.xpath('BitLen/text()') else '',
                        'name': convertName(dev, prefix, entry.xpath('Name/text()')[0]) if entry.xpath('Name/text()') else '',
                        'desc' : entry.xpath('Name/text()')[0] if entry.xpath('Name/text()') else '',
                        'data_type': entry.xpath('DataType/text()')[0] if entry.xpath('DataType/text()') else ''
                    }
                    entries.append(entry_data)

                # Add the extracted RxPDO data
                rxpdo_entry = {
                    'sm': sm,
                    'index': (index),
                    'name': name,
                    'exclude': (exclude),
                    'entries': entries
                }

                slave['RxPDO'].append(rxpdo_entry)

            # Get SyncManager info (with XPath)
            print(f"Searching for SyncManagers for device {device_name}")
            for sync_mgr in device.xpath('.//SyncManager'):
                sync_mgr_info = {
                    'number': sync_mgr.xpath('Number/text()')[0] if sync_mgr.xpath('Number/text()') else '',
                    'type': sync_mgr.xpath('Type/text()')[0] if sync_mgr.xpath('Type/text()') else '',
                    'DCMode': sync_mgr.xpath('DCMode/text()')[0] if sync_mgr.xpath('DCMode/text()') else 'None'
                }
                slave['SyncManagers'].append(sync_mgr_info)

            # Add the device to the slaves list
            slaves.append(slave)      
    return slaves

def filterOnIndex(objs,filterString):
    # filterString = "1,2,3,5"
    # filterString = "all"
    listAll = False
    if len(filterString) > 0:
        if filterString=='all':
            listAll = True
        else:
            filterList= list(map(int, filterString.split(',')))
            filterListLength = len(filterList)
    else:
        filterListLength = -1
    listThis = False
    objindex = 1
    filterindex = 0
    objsOutput = []
    for obj in objs:
        listThis = False
        if listAll:
            listThis = True
        elif filterListLength > filterindex:
            if filterList[filterindex] == objindex:
                filterindex += 1
                listThis = True
        if listThis:
            objsOutput.append(obj)
        objindex += 1
    return objsOutput

def filtPdoMaps(slaves, filterString):
    newSlaves = []
    for slave in slaves:
        newSlave=slave.copy()
        newSlave['PDOmaps'] = []
        newSlave['PDOmaps'] = filterOnIndex(slave['PDOmaps'], filterString)
        print('PDOMaps length: ' + str(len(newSlave['PDOmaps'])))
        newSlaves.append(newSlave)
    slaves = newSlaves
    return slaves

def printPdoMaps(slaves):
    slaveindex = 1
    for slave in slaves:
        print(str(slaveindex) + ': ' + 'Name : ' + slave['name'] + ', revision: ' + slave['revision'])
        pdomapindex = 1
        for pdoMap in slave['PDOmaps']:
            print ('   '+ str(pdomapindex) + ': ' + pdoMap['name'])
            pdomapindex += 1
        slaveindex += 1

def printPdo(slaves,pdo):
    print('ee')


def main():
    parser = argparse.ArgumentParser(description='Parse EtherCAT ESI XML and extract TxPDO, RxPDO, SyncManager, and DC modes.')
    parser.add_argument('--file',        required=True, help='Path to the ESI XML file')
    parser.add_argument('--name',        required=True, help='Slave name pattern (wildcard)')
    parser.add_argument('--rev',         required=True, help='Revision pattern (wildcard)')
    parser.add_argument('--filtSlaves',  required=False, help='Slaves filter (\'all\' for all or slave id integer comma separated list, \'1,2,5\' )')
    parser.add_argument('--filtPdoMaps', required=False, help='PDO map filter (\'all\' for all or PDO map id integer comma separated list, \'1,2,5\' )')
    parser.add_argument('--outputJSON',  required=False, help='Filename of output JSON file')
    parser.add_argument('--outputECMC',  required=False, help='Filename-base of output ecmc hw support files')
    
    args = parser.parse_args()

    slaves = parse_esi(args.file, args.name, args.rev)

    # Filter slaves on "index"
    #   args.filtSlaves = "1,5" or "all"
    if args.filtSlaves:
        slaves=filterOnIndex(slaves, args.filtSlaves)

    # Filter pdoMaps on "index"
    #   args.filtPdoMaps = "1,5" or "all"
    if args.filtPdoMaps:
        slaves=filtPdoMaps(slaves, args.filtPdoMaps)

    if args.outputJSON is not None:
        with open(args.outputJSON, 'w') as f:
            json.dump(slaves, f, indent=4)
    
    printPdoMaps(slaves)

if __name__ == "__main__":
    main()
