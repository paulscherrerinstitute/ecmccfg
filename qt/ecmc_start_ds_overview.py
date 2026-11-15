#!/usr/bin/env python3
"""
Create a Data Storage overview panel for an IOC.
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
   <string>%s ECMC data storage overview</string>
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
      <string>SYS=%s,IOC=%s,ID_1=%d,ID_2=%02d</string>
     </property>
     <property name="filename" stdset="0">
      <string notr="true">ecmcDSxx.ui</string>
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
import math
import os
import stat
import tempfile

sub_panel_width = 683
sub_panel_height = 286


def get_ds_from_ioc(ioc: str):
    from ecmc_ca_compat import ca, epicsPV

    ds_list = []
    ds_id = epicsPV.epicsPV('%s:MCU-Cfg-DS-FrstObjId' % ioc).getw()
    if ds_id < 0:
        print('No data storages defined\n')
        return ds_list

    while ds_id != -1:
        ds_list.append({'id': ds_id})
        ds_id = epicsPV.epicsPV('%s:MCU-Cfg-DS%d-NxtObjId' % (ioc, ds_id)).getw()

    print('Data storage count: ' + str(len(ds_list)))
    return ds_list


def create_ui_file(fname: str, ioc: str, ds_list, rows: int):
    old_umask = os.umask(0)
    try:
        mode = 'rb+' if os.path.exists(fname) else 'wb'
        f = open(fname, mode)
    finally:
        os.umask(old_umask)

    with f:
        f.truncate(0)
        cols = max(1, math.ceil(len(ds_list) / rows))

        f.write(header % (
            min(1800, sub_panel_width * cols),
            rows * sub_panel_height + 20,
            bytes(ioc, 'utf8'),
            sub_panel_width * cols,
            rows * sub_panel_height,
        ))

        for idx, ds in enumerate(ds_list):
            f.write(widget % (
                idx // cols,
                idx % cols,
                bytes(ioc, 'utf8'),
                bytes(ioc, 'utf8'),
                ds['id'],
                ds['id'],
            ))

        f.write(footer)

    os.chmod(
        fname,
        stat.S_IRUSR | stat.S_IWUSR |
        stat.S_IRGRP | stat.S_IWGRP |
        stat.S_IROTH | stat.S_IWOTH,
    )


def main():
    parser = argparse.ArgumentParser(description='Create an overview panel of data storages for an IOC')
    parser.add_argument('ioc', help='IOC name')
    parser.add_argument('--rows', type=int, default=1, help='Layout modules in rows')
    args = parser.parse_args()

    ds_list = get_ds_from_ioc(args.ioc)
    fname = os.path.join(tempfile.gettempdir(), '%s_ds_overview.ui' % args.ioc)
    create_ui_file(fname, args.ioc, ds_list, args.rows)
    os.system('caqtdm -x -noMsg %s' % fname)


if __name__ == '__main__':
    main()
