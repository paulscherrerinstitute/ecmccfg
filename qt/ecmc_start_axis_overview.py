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
      <string notr="true">%s</string>
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

PANEL_CONFIGS = {
    'default': {
        'filename': 'ecmcAxisFrame.ui',
        'width': 330,
        'height': 500,
    },
    'mini': {
        'filename': 'ecmcAxisMiniFrame.ui',
        'width': 125,
        'height': 112,
    },
}

class axisModule(object):
    def __init__(self, index, name, dev):
        self.index = index
        self.name = name
        self.dev = dev



def get_axes_from_ioc(ioc: str, grp_id, grp_name, grp_ax_id,grp_ax_name, sm_id_mst, sm_id_slv) -> List[NamedTuple]:
    """ Get axes from a running IOC """
    from ecmc_ca_compat import ca, epicsPV
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

    # group defined by axis id
    if grp_ax_id>=0:
        dev = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-Pfx' % (ioc, grp_ax_id)).getw()
        # remove :
        dev = dev[:-1] if dev.endswith(':') else dev
        name = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-Nam' % (ioc, grp_ax_id)).getw()
        addAxis=1
        # Overwrite group id
        grp_id = epicsPV.epicsPV('%s:%s-GrpId' % (dev, name)).getw()
    
    # Get group from master/slave statemachine
    if sm_id_mst>=0:
        #c6025a-08:SM00-SlvGrpNam
        #c6025a-08:SM00-MstGrpNam
        grp_name = epicsPV.epicsPV('%s:SM%02d-MstGrpNam' % (ioc, sm_id_mst)).getw()

    # Get group from master/slave statemachine
    if sm_id_slv>=0:
        #c6025a-08:SM00-SlvGrpNam
        #c6025a-08:SM00-MstGrpNam
        grp_name = epicsPV.epicsPV('%s:SM%02d-SlvGrpNam' % (ioc, sm_id_slv)).getw()

    # group defined by axis name
    if len(grp_ax_name)>0:
        grp_id = epicsPV.epicsPV('%s-GrpId' % (grp_ax_name)).getw()

    # get the first slave id
    n = epicsPV.epicsPV('%s:MCU-Cfg-AX-FrstObjId' % ioc).getw()
    while n != -1:     
        axis = {}
        dev = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-Pfx' % (ioc, n)).getw()
        # remove :
        dev = dev[:-1] if dev.endswith(':') else dev
        name = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-Nam' % (ioc, n)).getw()
        addAxis=1
        if grp_id>=0:
          this_grp_id = epicsPV.epicsPV('%s:%s-GrpId' % (dev, name)).getw()
          if this_grp_id !=grp_id:
            addAxis=0
        if len(grp_name)>0:
          this_grp_name = epicsPV.epicsPV('%s:%s-GrpNam' % (dev, name)).getw()
          if this_grp_name !=grp_name:
            addAxis=0

        if addAxis:
          axis['id'] = n
          axis['dev'] = dev
          axis['name'] = name
          axes.append(axis)
        n = epicsPV.epicsPV('%s:MCU-Cfg-AX%d-NxtObjId' % (ioc, n)).getw()                
    print(axes)
    return axes, grp_id

def create_ui_file(fname: str, ioc: str, axes, rows: int, panel_type: str):
    """ Create UI file from axes """
    # Qt UI files are of UTF-8 encoded XML format.
    panel = PANEL_CONFIGS[panel_type]
    sub_panel_width = panel['width']
    sub_panel_height = panel['height']
    panel_filename = bytes(panel['filename'], 'utf8')
    
    old_umask = os.umask(0)
    try:
        mode = 'rb+' if os.path.exists(fname) else 'wb'
        f = open(fname, mode)
    finally:
        os.umask(old_umask)

    with f:
        f.truncate(0)
        
        # number of columns in the grid layout
        cols = math.ceil(len(axes) / rows)
        
        f.write(header % (
            min(1000, sub_panel_width * cols),
            rows * sub_panel_height + 20,
            bytes(ioc, 'utf8'),
            sub_panel_width * cols,
            rows * sub_panel_height,
        ))

        i=0
        for axis in axes:
            #<string>IOC=%s,DEV=%s,AX_ID=%d,Axis=%s</string>            
            f.write(widget % (
                i // cols,
                i % cols,
                bytes(ioc, 'utf8'),
                bytes(axis['dev'], 'utf8'),
                axis['id'],
                bytes(axis['name'], 'utf8'),
                panel_filename,
            ))
            i+=1

        f.write(footer)

    # permission to read/write by all
    os.chmod(fname, stat.S_IRUSR | stat.S_IWUSR | stat.S_IRGRP | stat.S_IWGRP | stat.S_IROTH | stat.S_IWOTH)


def main():
    parser = argparse.ArgumentParser(description='Create an overview panel of axes for an IOC')
    parser.add_argument('ioc', help='IOC name')
    parser.add_argument('--psi-label', help='psi label of the axis overview')
    # optional args
    parser.add_argument('--rows', type=int, default=1, help='Layout modules in rows')
    # only show axes related to groups:
    parser.add_argument('--grp_id', type=int, default=-1, help='Only add axes belonging to group')
    parser.add_argument('--grp_name', type=str, default='', help='Only add axes belonging to group')
    parser.add_argument('--grp_ax_id', type=int, default=-1, help='Only add axes belonging to same group as ax_id')
    parser.add_argument('--grp_ax_name', type=str, default='', help='Only add axes belonging to same group as ax_name')
    parser.add_argument('--sm_id_mst', type=int, default=-1, help='Only add axes belonging to master group of master/slave state-machine defined by id')
    parser.add_argument('--sm_id_slv', type=int, default=-1, help='Only add axes belonging to slave group of master/slave state-machine defined by id')
    parser.add_argument(
        '--panel-type',
        choices=sorted(PANEL_CONFIGS.keys()),
        default='default',
        help='Axis overview panel type to include',
    )

    args = parser.parse_args()

    # If master is not given, get master id from ioc startup script

    # Retrive the module list from inventory if the EtherCAT coupler label is given
    axes, grp_id_fname= get_axes_from_ioc(args.ioc, args.grp_id, args.grp_name, args.grp_ax_id, args.grp_ax_name, args.sm_id_mst, args.sm_id_slv)

    # Use a fixed pattern for output file
    if args.panel_type == 'default':
        fname = os.path.join(tempfile.gettempdir(), '%s_grp%d_axes_overview.ui' % (args.ioc, int(grp_id_fname)))
    else:
        fname = os.path.join(tempfile.gettempdir(), '%s_grp%d_axes_overview_%s.ui' % (args.ioc, int(grp_id_fname), args.panel_type))

    # Create the output file
    create_ui_file(fname, args.ioc, axes, args.rows, args.panel_type)

    # Launch caqtdm
    os.system('caqtdm -x -noMsg %s' % fname)

if __name__ == '__main__':
    main()
