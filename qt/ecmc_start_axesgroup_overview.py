#!/usr/bin/env python3
"""
Create an EtherCAT modules overview panel for an IOC
"""

header = b"""<?xml version="1.0" encoding="UTF-8"?>
<ui version="4.0">
 <class>Form</class>
 <widget class="QWidget" name="Form">
  <property name="geometry">
   <rect>
    <x>0</x>
    <y>0</y>
    <width>%d</width>
    <height>%d</height>
   </rect>
  </property>
  <property name="windowTitle">
   <string>%s ECMC axes group overview</string>
  </property>
  <layout class="QHBoxLayout" name="horizontalLayout">
   <property name="margin">
    <number>0</number>
   </property>
   <item>
    <widget class="QScrollArea" name="scrollArea">
     <property name="frameShape">
      <enum>QFrame::NoFrame</enum>
     </property>
     <property name="widgetResizable">
      <bool>false</bool>
     </property>
     <widget class="QWidget" name="scrollAreaWidgetContents">
      <property name="geometry">
       <rect>
        <x>0</x>
        <y>0</y>
        <width>%d</width>
        <height>%d</height>
       </rect>
      </property>
      <layout class="QGridLayout" name="gridLayout">
       <property name="margin">
        <number>0</number>
       </property>
"""

widget = b"""
   <item row="%d" column="%d">
    <widget class="caInclude" name="cainclude">
     <property name="macro">
      <string>IOC=%s,GRP_ID=%d</string>
     </property>
     <property name="filename" stdset="0">
      <string notr="true">ecmcAxesGroupFrame.ui</string>
     </property>
    </widget>
   </item>
"""

footer = b"""
      </layout>
     </widget>
    </widget>
   </item>
  </layout>
 </widget>
 <customwidgets>
  <customwidget>
   <class>caInclude</class>
   <extends>QWidget</extends>
   <header>caInclude</header>
  </customwidget>
 </customwidgets>
 <resources/>
 <connections/>
</ui>
"""

import argparse
import glob
import itertools
import math
import os
import re
import stat
import sys
import tempfile
from typing import List, NamedTuple

import requests

subPanelWidth = 240
subPanelHeight = 150

class axisModule(object):
    def __init__(self, index, name, dev):
        self.index = index
        self.name = name
        self.dev = dev



def get_axes_groups_from_ioc(ioc: str) -> List[NamedTuple]:    
    from ecmc_ca_compat import ca, epicsPV
    groups = []    
    # These PVs are of intrest:
    # c6025a-08:MCU-Cfg-AXGRP-Cnt
    # c6025a-08:MCU-Cfg-AXGRP0-Nam
    # c6025a-08:MCU-Cfg-AXGRP0-Axes
    # c6025a-08:MCU-Cfg-AXGRP1-Nam
    # c6025a-08:MCU-Cfg-AXGRP1-Axes

    ax_grp_count = epicsPV.epicsPV('%s:MCU-Cfg-AXGRP-Cnt' % ioc).getw()
    if ax_grp_count <= 0:
      print('No groups defined\n')
      return groups
    print('Group count: ' + str( ax_grp_count))

    
    for i in range(int(ax_grp_count)):
        group = {}
        group['id'] = i
        
        groups.append(group)
        
    return groups

def create_ui_file(fname: str, ioc: str, groups, rows: int):
    """ Create UI file from axes """
    # Qt UI files are of UTF-8 encoded XML format.
    
    old_umask = os.umask(0)
    try:
        mode = 'rb+' if os.path.exists(fname) else 'wb'
        f = open(fname, mode)
    finally:
        os.umask(old_umask)

    with f:
        f.truncate(0)
        
        # number of columns in the grid layout
        cols = math.ceil(len(groups) / rows)
        print(cols, len(groups))
        
        f.write(header % (min(1000, subPanelWidth*cols), rows * subPanelHeight + 20, bytes(ioc, 'utf8'), subPanelWidth*cols, rows * subPanelHeight))

        i=0
        for group in groups:
            print('Group: ' + str(group['id']))
            # <item row="%d" column="%d">            
            # <string>IOC=%s,GRP_ID=%d</string>
            print('cols: ' + str(i%cols))
            f.write(widget % (i//cols, i%cols, bytes(ioc, 'utf8'), group['id']))
            i+=1

        f.write(footer)

    # permission to read/write by all
    os.chmod(fname, stat.S_IRUSR | stat.S_IWUSR | stat.S_IRGRP | stat.S_IWGRP | stat.S_IROTH | stat.S_IWOTH)


def main():
    parser = argparse.ArgumentParser(description='Create an overview panel of axes for an IOC')
    parser.add_argument('ioc', help='IOC name')
    parser.add_argument('--psi-label', help='psi label of the axis overview')

    parser.add_argument('--rows', type=int, default=1, help='Layout modules in rows')
    args = parser.parse_args()

    # If master is not given, get master id from ioc startup script

    # Retrive the module list from inventory if the EtherCAT coupler label is given
    groups = get_axes_groups_from_ioc(args.ioc)

    # Use a fixed pattern for output file
    fname = os.path.join(tempfile.gettempdir(), '%s_axes_group_overview.ui' % (args.ioc))

    # Create the output file
    create_ui_file(fname, args.ioc, groups, args.rows)

    # Launch caqtdm
    os.system('caqtdm -x -noMsg %s' % fname)

if __name__ == '__main__':
    main()
