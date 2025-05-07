from lxml import etree
import json
import argparse
import fnmatch  # Ensure fnmatch is imported

def parse_revision_number(revision_text):
    # Convert hex revision number (e.g. #x00100000) to an integer
    if revision_text and revision_text.startswith("#x"):
        return int(revision_text[2:], 16)  # Convert from hex to integer
    return None

def to_hex(value):
    """Function to convert values to hex format (with '0x' prefix)"""
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
                exclude = to_hex(parse_revision_number(txpdo.xpath('Exclude/text()')[0])) if txpdo.xpath('Exclude/text()') else None

                # For each Entry inside TxPdo
                entries = []
                for entry in txpdo.xpath('.//Entry'):
                    entry_data = {
                        'index': to_hex(parse_revision_number(entry.xpath('Index/text()')[0])) if entry.xpath('Index/text()') else '',
                        'subindex': to_hex(entry.xpath('SubIndex/text()')[0]) if entry.xpath('SubIndex/text()') else '',
                        'bitlen': entry.xpath('BitLen/text()')[0] if entry.xpath('BitLen/text()') else '',
                        'name': entry.xpath('Name/text()')[0] if entry.xpath('Name/text()') else '',
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
                exclude = to_hex(parse_revision_number(rxpdo.xpath('Exclude/text()')[0])) if rxpdo.xpath('Exclude/text()') else None

                # For each Entry inside RxPdo
                entries = []
                for entry in rxpdo.xpath('.//Entry'):
                    entry_data = {
                        'index': to_hex(parse_revision_number(entry.xpath('Index/text()')[0])) if entry.xpath('Index/text()') else '',
                        'subindex': to_hex(entry.xpath('SubIndex/text()')[0]) if entry.xpath('SubIndex/text()') else '',
                        'bitlen': entry.xpath('BitLen/text()')[0] if entry.xpath('BitLen/text()') else '',
                        'name': entry.xpath('Name/text()')[0] if entry.xpath('Name/text()') else '',
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

def main():
    parser = argparse.ArgumentParser(description='Parse EtherCAT ESI XML and extract TxPDO, RxPDO, SyncManager, and DC modes.')
    parser.add_argument('--file', required=True, help='Path to the ESI XML file')
    parser.add_argument('--name', required=True, help='Slave name pattern (wildcard)')
    parser.add_argument('--rev', required=True, help='Revision pattern (wildcard)')
    parser.add_argument('--output', required=True, help='Output JSON file')

    args = parser.parse_args()

    slaves = parse_esi(args.file, args.name, args.rev)

    with open(args.output, 'w') as f:
        json.dump(slaves, f, indent=4)

if __name__ == "__main__":
    main()
