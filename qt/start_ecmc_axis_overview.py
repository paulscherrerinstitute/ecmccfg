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
   <string>%s ECMC motion overview</string>
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
      <string>IOC=%s,DEV=%s,AX_ID=%d,Axis=%s</string>
     </property>
     <property name="filename" stdset="0">
      <string notr="true">ecmcAxis.ui</string>
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

class axisModule(object):
    def __init__(self, index, name, dev):
        self.index = index
        self.name = name
        self.dev = dev



def get_axes_from_ioc(ioc: str) -> List[NamedTuple]:
    """ Get axes from a running IOC """
    import ca, epicsPV    
    axes = []
    # These PVs are of intrest:
    #  c6025a-06:MCU-Cfg-AX-FrstObjId
    #  c6025a-06:MCU-Cfg-AX4-NxtObjId
    #  c6025a-06:MCU-Cfg-AX4-PrvObjId
    #  c6025a-06:MCU-Cfg-AX2-NxtObjId
    #  c6025a-06:MCU-Cfg-AX2-PrvObjId
    #  c6025a-06:MCU-Cfg-AX-Cnt
    #  c6025a-06:MCU-Cfg-UI-AX-Id
    #  c6025a-06:MCU-Cfg-AX4-Pfx
    #  c6025a-06:MCU-Cfg-AX4-Nam
    #  c6025a-06:MCU-Cfg-AX4-PfxNam
    #  c6025a-06:MCU-Cfg-AX2-Pfx
    #  c6025a-06:MCU-Cfg-AX2-Nam
    #  c6025a-06:MCU-Cfg-AX2-PfxNam
    
    ax_count = epicsPV.epicsPV('%s:MCU-Cfg-AX-Cnt' % ioc).getw()
    if ax_count <= 0:
      print('No axes defined\n')
      return devnames,names
    print('Axes count: ' + str( ax_count))

    # get the first slave id
    n = epicsPV.epicsPV('%s:MCU-Cfg-AX-FrstObjId' % ioc).getw()
    while n != -1:     
        axis = {}
        dev = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-Pfx' % (ioc, n)).getw()
        # remove :
        dev = dev[:-1] if dev.endswith(':') else dev
        name = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-Nam' % (ioc, n)).getw()
        axis['id'] = n
        axis['dev'] = dev
        axis['name'] = name
        n = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-NxtObjId' % (ioc, n)).getw()
        
        axes.append(axis)
    print(axes)
    return axes

def create_ui_file(fname: str, ioc: str, axes, rows: int):
    """ Create UI file from axes """
    # Qt UI files are of UTF-8 encoded XML format.
    
    with open(fname, 'wb') as f:
        
        # number of columns in the grid layout
        cols = math.ceil(len(axes) / rows)
        
        f.write(header % (min(1000, 315*cols), rows * 488 + 20, bytes(ioc, 'utf8'), 315*cols, rows * 488))

        i=0
        for axis in axes:
            #<string>IOC=%s,DEV=%s,AX_ID=%d,Axis=%s</string>            
            f.write(widget % (i//cols, i%cols, bytes(ioc, 'utf8'), bytes(axis['dev'],'utf8'), axis['id'], bytes(axis['name'],'utf8')))
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
    axes = get_axes_from_ioc(args.ioc)

    # Use a fixed pattern for output file
    fname = os.path.join(tempfile.gettempdir(), '%s_axes_overview.ui' % (args.ioc))

    # Create the output file
    create_ui_file(fname, args.ioc, axes, args.rows)

    # Launch caqtdm
    os.system('caqtdm -x -noMsg %s' % fname)

if __name__ == '__main__':
    main()
