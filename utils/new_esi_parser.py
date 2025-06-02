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
                    #print('1 index= ' + str(parse_revision_number(entry.xpath('Index/text()')[0])))
                    #print('1 subindex= ' + str((entry.xpath('SubIndex/text()'))))
                    #print('1: ' + str(parse_revision_number(entry.xpath('SubIndex/text()')[0])) if len(entry.xpath('SubIndex/text()')) > 0 else '',)

                    entry_data = {
                        'index': to_hex(parse_revision_number(entry.xpath('Index/text()')[0])) if parse_revision_number(entry.xpath('Index/text()')[0]) is not None else "",
                        'subindex': str(to_hex(entry.xpath('SubIndex/text()')[0]) if len(entry.xpath('SubIndex/text()')) > 0 else ''),
                        'bitlen': entry.xpath('BitLen/text()')[0] if entry.xpath('BitLen/text()') else '',
                        'name': convertName(dev, prefix, entry.xpath('Name/text()')[0]) if entry.xpath('Name/text()') else '',
                        'desc' : entry.xpath('Name/text()')[0] if entry.xpath('Name/text()') else '',
                        'data_type': entry.xpath('DataType/text()')[0] if entry.xpath('DataType/text()') else '',
                        'sub_entries': []
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
                    #print('2 index= ' + str(parse_revision_number(entry.xpath('Index/text()')[0])))
                    #print('2 subindex= ' + str(to_hex(entry.xpath('SubIndex/text()')[0]) if len(entry.xpath('SubIndex/text()')) > 0 else '',))
                    #print('2 ' + str(entry.xpath('SubIndex/text()')[0]) if len(entry.xpath('SubIndex/text()')) > 0 else '',)

                    entry_data = {
                        'index': to_hex(parse_revision_number(entry.xpath('Index/text()')[0])) if parse_revision_number(entry.xpath('Index/text()')[0]) is not None else "",
                        'subindex': str(to_hex(entry.xpath('SubIndex/text()')[0]) if len(entry.xpath('SubIndex/text()')) > 0 else ''),
                        'bitlen': entry.xpath('BitLen/text()')[0] if entry.xpath('BitLen/text()') else '',
                        'name': convertName(dev, prefix, entry.xpath('Name/text()')[0]) if entry.xpath('Name/text()') else '',
                        'desc' : entry.xpath('Name/text()')[0] if entry.xpath('Name/text()') else '',
                        'data_type': entry.xpath('DataType/text()')[0] if entry.xpath('DataType/text()') else '',
                        'sub_entries': []
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

def saveJSON(slaves,filename):
    with open(filename, 'w') as f:
            json.dump(slaves, f, indent=4)

def findPdo(slaves,pdo_index_str):
    # Look in RX
    for slave in slaves:
       for pdo in slave['RxPDO']:
           #print (str(pdo) + '\n')
           if pdo['index']==pdo_index_str:
                return pdo
    # Look in TX
    for slave in slaves:
       for pdo in slave['TxPDO']:
           #print (str(pdo) + '\n')
           if pdo['index']==pdo_index_str:
                return pdo
    
    print('Pdo: ' + pdo_index_str + ' not found')
    return None


def saveEcmcCmdFiles(slaves, filename_suffix):
    for slave in slaves:
        # Hardware cmd file
        pdoMapIndex = 1
        for pdoMap in slave['PDOmaps']:
            cmd_rows = pdosToEcAddEntryDT(slaves, pdoMap)
            slave_type =slave['name'].split()[0] + '_' + slave['revision'] + filename_suffix  # bad.. hardcoded (name="EL1259 8Ch. Dig Input 24V/8Ch. Dig. Output 24V with Multi-Time-Stamp")
            print('HEPPEPEPE 888')
            if pdoMapIndex > 1:
                print('HEPPEPEPE')
                slave_type += '_' + str(pdoMapIndex) 
            with open('ecmc' + slave_type + '.cmd', "w") as f:
                f.write(F"#-  ecmc hardware config for: { slave['name'] }\n")
                f.write(F"#- { pdoMap['name'] }\n")
                f.write('\n')
                f.write(F"epicsEnvSet(\"ECMC_EC_HWTYPE\"             \"{ slave_type }\")\n")
                f.write(F"epicsEnvSet(\"ECMC_EC_VENDOR_ID\"          \"0x2\")\n")  # bad hardcoded..
                f.write(F"epicsEnvSet(\"ECMC_EC_PRODUCT_ID\"         \"{ slave['product_id'] }\")\n")
                f.write(F"epicsEnvSet(\"ECMC_EC_REVISION\"           \"{ slave['revision'] }\")\n")
                f.write('\n')
                for row in cmd_rows:
                    f.write(row + '\n')
            pdoMapIndex += 1

def saveEcmcSubstFiles(slaves,filename_suffix):
   for slave in slaves:
        # Hardware cmd file
        pdoMapIndex = 1
        for pdoMap in slave['PDOmaps']:
            cmd_rows = pdosToEcSubst(slaves, pdoMap)
            slave_type =slave['name'].split()[0] + '_' + slave['revision'] + filename_suffix  # bad.. hardcoded (name="EL1259 8Ch. Dig Input 24V/8Ch. Dig. Output 24V with Multi-Time-Stamp")
            print('HEPPEPEPE 888')
            if pdoMapIndex > 1:
                print('HEPPEPEPE')
                slave_type += '_' + str(pdoMapIndex) 
            with open('ecmc' + slave_type + '.substitution', "w") as f:
                f.write(F"#-  ecmc database for: { slave['name'] }\n")
                f.write(F"#- { pdoMap['name'] }\n")
                f.write('\n')
                for row in cmd_rows:
                    f.write(row + '\n')
            pdoMapIndex += 1
                
def saveEcmc(slaves, filename_suffix):
    saveEcmcCmdFiles(slaves, filename_suffix)
    saveEcmcSubstFiles(slaves, filename_suffix)


def mergeEntriesBelow8bits(slaves): 
    for slave in slaves:
        for pdoMap in slave['PDOmaps']:
            for sm in pdoMap['sm']:
                sm_index=sm['index']
                for pdo in sm['pdos']:
                    pdo_data=findPdo(slaves,pdo)                    
                    pdo_index=pdo_data['index']
                    newEntries= []
                    for entry in mergeEntries(pdo_data['entries']):
                        newEntries.append(entry)
                    pdo_data['entries'] = newEntries
    return slaves

def pdosToEcAddEntryDT(slaves, pdoMap):
    cmd_rows=[]
    # first check for selected alterative mappings
    for sm in pdoMap['sm']:
        sm_index=sm['index']
        for pdo in sm['pdos']:
            pdo_data=findPdo(slaves,pdo)
            pdo_index=pdo_data['index']
            for entry in pdo_data['entries']:
                cmd_rows.append(pdoEntryToEcmcConfigOrDieStr(sm_index,pdo_index,entry))
                sub_entry_id = 1
                for subentry in entry['sub_entries']:
                    cmd_rows.append(F'#- { sub_entry_id }: ' + pdoEntryToEcmcConfigOrDieStr(sm_index,pdo_index,subentry) + ' # merged')
                    sub_entry_id +=1
    return cmd_rows

def pdosToEcSubst(slaves, pdoMap):
    ai_rows=[]
    ao_rows=[]
    bi_rows=[]
    bo_rows=[]
    mbbiDirect_rows=[]
    mbboDirect_rows=[]
    mbbiDirect_bi_rows=[]
    mbboDirect_bo_rows=[]

    # first check for selected alterative mappings
    for sm in pdoMap['sm']:
        sm_index=sm['index']
        for pdo in sm['pdos']:
            pdo_data=findPdo(slaves,pdo)
            pdo_index=pdo_data['index']
            for entry in pdo_data['entries']:
                if len(entry['sub_entries']) > 0:
                    # mbbiDirect or mbboDirect
                    mbbxName = entry['name']                    
                    sub_entry_bit_index = 0                    
                    prev_bi_name = ""
                    for sub_entry in entry['sub_entries']:
                        if len(sub_entry['name']) == 0 or int(sub_entry['bitlen']) > 1: # dummy entry or not a binary
                            sub_entry_bit_index += int(sub_entry['bitlen'])
                            print ('WARNING: Skipping entry' + sub_entry['desc'])
                            continue
                        
                        if sm_index=='0' or sm_index=='2': # Output
                            #  pattern {    REC_NAME,              DESC,                  LNK_NAME,                              FLNK                            }'
                            macros = F"{{ { sub_entry['name'] } , { sub_entry['desc'] } , { mbbxName }.B{ sub_entry_bit_index }, ${{ECMC_P}}{ mbbxName }.PROC }}"
                            mbboDirect_bo_rows.append(macros)
                        else: # Input                                                        
                            #  pattern {    REC_NAME,              DESC,                  LNK_NAME,                              FLNK                                }'                            
                            macros = F"{{ { sub_entry['name'] } , { sub_entry['desc'] } , { mbbxName }.B{ sub_entry_bit_index }, ${{ECMC_P}}{ prev_bi_name }.PROC }}"
                            mbbiDirect_bi_rows.append(macros)
                            prev_bi_name = sub_entry['name']
                        sub_entry_bit_index += int(sub_entry['bitlen'])

                    if sm_index=='0' or sm_index=='2': # Output
                        #  pattern {    REC_NAME,     DESC,         }'                        
                        macros = F"{{ { mbbxName }, { entry['desc'] } }}"
                        mbboDirect_rows.append(macros)
                    else: # Input
                        #  pattern {    REC_NAME,     DESC,              FLNK                 }'
                        macros = F"{{ { mbbxName }, { entry['desc'] }, { prev_bi_name }.PROC }}"
                        mbbiDirect_rows.append(macros)
                    continue

                # avoid dummy
                if len(entry['name']) == 0:
                    continue

                # normal data type
                #  pattern {    REC_NAME,              DESC }
                macros = F"{{ { entry['name'] } , { entry['desc'] } }}"
                if int(entry['bitlen']) > 1:
                    if sm_index=='0' or sm_index=='2':
                        # Output                        
                        ao_rows.append(macros)

                    else:
                        # Input
                        ai_rows.append(macros)
                else:
                    # bitlength = 1
                    if sm_index=='0' or sm_index=='2':
                        # Output                        
                        bo_rows.append(macros)

                    else:
                        # Input
                        bi_rows.append(macros)
    output_rows = []

    #ecmc_ESI_mbboDirect_bo
    output_rows.append('file "ecmc_ESI_mbboDirect_bo.template" {')
    output_rows.append('    pattern { REC_NAME, DESC, LNK_NAME, FLNK }')
    for item in mbboDirect_bo_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    #ecmc_ESI_mbboDirect
    output_rows.append('file "ecmc_ESI_mbboDirect.template" {')
    output_rows.append('    pattern { REC_NAME, DESC}')
    for item in mbboDirect_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' + '\n')

    #ecmc_ESI_mbbiDirect_bi
    output_rows.append('file "ecmc_ESI_mbbiDirect_bi.template" {')
    output_rows.append('    pattern { REC_NAME, DESC, LNK_NAME, FLNK }')
    for item in mbbiDirect_bi_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    #ecmc_ESI_mbbiDirect
    output_rows.append('file "ecmc_ESI_mbbiDirect.template" {')
    output_rows.append('    pattern { REC_NAME, DESC, FLNK }')
    for item in mbbiDirect_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    #ecmc_ESI_ai
    output_rows.append('file "ecmc_ESI_ai.template" {')
    output_rows.append('    pattern { REC_NAME, DESC }')
    for item in ai_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    #ecmc_ESI_ao
    output_rows.append('file "ecmc_ESI_ao.template" {')
    output_rows.append('    pattern { REC_NAME, DESC }')
    for item in ao_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    #bi_rows
    output_rows.append('file "ecmc_ESI_bi.template" {' )
    output_rows.append('    pattern { REC_NAME, DESC }')
    for item in bi_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    #bo_rows
    output_rows.append('file "ecmc_ESI_bo.template" {')
    output_rows.append('    pattern { REC_NAME, DESC }')
    for item in bo_rows:
        output_rows.append('        ' + item)
    output_rows.append('}' +  '\n')

    return output_rows

def entryToDBMacros(entry):
    # REC_NAME, DESC, 
    return F'{entry['name'], entry['name'] }'

# All in the alterative maps available after filtering
def printPdoMapData(slaves):
    slaveindex = 1
    for slave in slaves:
        #print(str(slaveindex) + ': ' + 'Name : ' + slave['name'] + ', revision: ' + slave['revision'])
        pdomapindex = 1
        # first check for selected alterative mappings
        for pdoMap in slave['PDOmaps']:
            for sm in pdoMap['sm']:
                sm_index=sm['index']
                for pdo in sm['pdos']:
                    pdo_data=findPdo(slaves,pdo)
                    #print('Pdo data: ' + str(pdo_data))
                    pdo_index=pdo_data['index']
                    for entry in mergeEntries(pdo_data['entries']):
                        print(pdoEntryToEcmcConfigOrDieStr(sm_index,pdo_index,entry))
                        sub_entry_id = 1
                        for subentry in entry['sub_entries']:
                            print(F'#- { sub_entry_id }: ' + pdoEntryToEcmcConfigOrDieStr(sm_index,pdo_index,subentry) + ' # merged')
                            sub_entry_id +=1

ecmcCfgOrDieStrPart1 ='ecmcConfigOrDie \"Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},'

def pdoEntryToEcmcConfigOrDieStr(sm_index,pdo_index,entry):
    dir = 1 # intput
    if sm_index=='0' or sm_index=='2':
        dir=2 # output
    ecmcCfgOrDieStrPart2 = F'{ dir },{ sm_index },{ pdo_index },{ entry['index'] },{ entry['subindex'] },{ getEntryDT(entry) },{ entry['name'] })\"'
    comment=''
    if len(entry['sub_entries']) > 0:
        comment = F' # { len(entry['sub_entries']) } merged entries:' 
    return ecmcCfgOrDieStrPart1 + ecmcCfgOrDieStrPart2 + comment

# Merge data types below 8 bits
def mergeEntries(entries):
    new_entries_list=[]
    bitlen_curr_merge = 0
    sub_entries = []
    new_merge_entry = [] 
    merge_in_progress = False
    total_bit_legth = 0
    entry_count = 0
    for entry in entries:
        # filter strange bit lengths and merge
        bitlen = int(entry['bitlen'])
        total_bit_legth += bitlen        
        if  bitlen != 8 and bitlen != 16 and bitlen != 32 and bitlen != 64:
            if not merge_in_progress:
                merge_in_progress = True
                sub_entries = []
                new_merge_entry=entry.copy()
                bitlen_curr_merge = 0
            sub_entries.append(entry.copy())
            bitlen_curr_merge += bitlen
  
            if merge_in_progress:
                # continue merge if NEXT entry bitlen < 8
                nextEntryBitSize = 8  # dummy just to make the merge stop if last entry in list    
                if len(entries) > entry_count:                    
                    nextEntryBitSize = int(entries[entry_count + 1]['bitlen'])
                
                if (bitlen_curr_merge == 8 or bitlen_curr_merge == 16 or bitlen_curr_merge == 32 or bitlen_curr_merge == 64) and nextEntryBitSize >= 8:
                    merge_in_progress = False
                    new_merge_entry['sub_entries'] = sub_entries.copy()

                    # If Array then remove index in end and add "Arr"
                    if checkSubEntriesIsArray(sub_entries):
                        dummy, dummy1, digitCount = numberInEnd(new_merge_entry['name'])
                        if digitCount > 0:
                            new_merge_entry['name'] = new_merge_entry['name'][:-digitCount] + 'Arr'
                    else:         
                        if checkOnlyLastPartOFNameDiffer(sub_entries):
                            newNameList=new_merge_entry['name'].split('-')[:-1]
                            newName=''
                            for s in newNameList:
                                newName+=s + '-'
                            newName = newName[:-1] + '_'
                            new_merge_entry['name'] = newName

                    new_merge_entry['data_type'] = bitLengthToUXINT(bitlen_curr_merge)
                    new_merge_entry['bitlen'] = str(bitlen_curr_merge)
                    new_entries_list.append(new_merge_entry)
        else:
            # normal entry
            new_entries_list.append(entry)
        entry_count += 1

    print(F'Processed { entry_count } entries with a total bitlegth of { total_bit_legth }' )
    return new_entries_list

def numberInEnd(s):
    i = len(s) - 1
    digitCount = 0
    # Leta baklänges efter där siffrorna tar slut
    while i >= 0 and s[i].isdigit():
        i -= 1
        digitCount += 1
    if i < len(s) - 1:
        number = s[i+1:]
        return True, int(number), digitCount
    else:
        return False , -1, 0

# For merged entries. Example, in below remove "OutpBuffRst" from the top below
#ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7011,0x1,U8,BO02-Ctrl-OutpBuffRst)" # Merged entry (4)
##- Merged    ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7011,0x1,ERROR_BOOL_1,BO02-Ctrl-OutpBuffRst)"
##- Merged    ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7011,0x2,ERROR_BOOL_1,BO02-Ctrl-ManOutpState)"
##- Merged    ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x7011,0x3,ERROR_BOOL_1,BO02-Ctrl-FrceOrdr)"
##- Merged    ecmcConfigOrDie "Cfg.EcAddEntryDT(${ECMC_EC_SLAVE_NUM},${ECMC_EC_VENDOR_ID},${ECMC_EC_PRODUCT_ID},1,2,0x1605,0x0,,ERROR__5,)"
def checkOnlyLastPartOFNameDiffer(entries):
    prefixOld=[]
    firstEntry = True
    for entry in entries:
        # filter dummy fieds without name
        if len(entry['name']) == 0:
            continue
        if firstEntry:
           firstEntry = False
           prefixOld = entry['name'].split('-')
           prefixOld = prefixOld[:-1]   # remove last
        else:
            prefix = entry['name'].split('-')
            prefix = prefix[:-1]
            if prefix != prefixOld:
                return False
            prefixOld = prefix
    return True

# check if index in end increasing with 1, only check entries with name and datatype.. Remove empty
def checkSubEntriesIsArray(entries):
    firstEntry = True
    numberOld = 0
    for entry in entries:
        # filter dummy fieds without name
        if len(entry['name']) == 0:
            continue
        numInEnd, number, charCount = numberInEnd(entry['name'])
        if not numInEnd:
            return False
        if firstEntry:
           firstEntry = False
           numberOld = numInEnd
        else:
            if number != (numberOld + 1):
                return False
            numberOld = number
    return True

def bitLengthToUXINT(bitlegth):
    match bitlegth:
        case 8:
            return 'USINT'
        case 16:
            return 'UINT'
        case 32:
            return 'UDINT'
        case 64:
            return 'UXXX64'
    return 'UXXXX'

def getEntryDT(entry):
    match entry['data_type']:
        case 'USINT':
            return 'U8'
        case 'UINT':
            return 'U16'
        case 'UDINT':
            return 'U32'
        case 'SINT':
            return 'S8'
        case 'INT':
            return 'S16'        
        case 'DINT':
            return 'S32'
    return 'B'+ entry['bitlen'] 

def main():
    parser = argparse.ArgumentParser(description='Parse EtherCAT ESI XML and extract TxPDO, RxPDO, SyncManager, and DC modes.')
    parser.add_argument('--file',        required=True, help='Path to the ESI XML file')
    parser.add_argument('--name',        required=True, help='Slave name pattern (wildcard)')
    parser.add_argument('--rev',         required=True, help='Revision pattern (wildcard)')
    parser.add_argument('--filtSlaves',  required=False, help='Slaves filter (\'all\' for all or slave id integer comma separated list, \'1,2,5\' )')
    parser.add_argument('--mergeEntries', required=False, help='Merge entries below 8 bits')
    parser.add_argument('--filtPdoMaps', required=False, help='PDO map filter (\'all\' for all or PDO map id integer comma separated list, \'1,2,5\' )')
    parser.add_argument('--outputJSON',  required=False, help='Filename of output JSON file')
    parser.add_argument('--outputECMC',  required=False, help='Filename-base of output ecmc hw support files')
    
    args = parser.parse_args()

    slaves = parse_esi(args.file, args.name, args.rev)

    # Filter slaves on "index", applied after filtered with --name and --rev
    #   args.filtSlaves = "1,5" or "all"
    if args.filtSlaves:
        slaves = filterOnIndex(slaves, args.filtSlaves)

    # Filter pdoMaps on "index"
    #   args.filtPdoMaps = "1,5" or "all"
    if args.filtPdoMaps:
        slaves = filtPdoMaps(slaves, args.filtPdoMaps)

    # Merge entrie below 8 bits
    if args.mergeEntries:
        slaves = mergeEntriesBelow8bits(slaves)

    if args.outputJSON is not None:
        saveJSON(slaves,args.outputJSON)
    
    #printPdoMaps(slaves)
    #printPdoMapData(slaves)

    if args.outputECMC is not None:
        saveEcmc(slaves,args.outputECMC)

if __name__ == "__main__":
    main()
