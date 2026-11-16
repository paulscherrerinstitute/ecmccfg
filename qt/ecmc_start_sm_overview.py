#!/usr/bin/env python3
"""
Create a master/slave overview panel for an IOC.
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
   <string>%s ECMC master/slave overview</string>
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
      <string notr="true">ecmcSMxx.ui</string>
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

sub_panel_width = 247
sub_panel_height = 457


def get_state_machines_from_ioc(ioc: str):
    from ecmc_ca_compat import ca, epicsPV

    sms = []
    sm_id = epicsPV.epicsPV('%s:MCU-Cfg-SM-FrstObjId' % ioc).getw()
    if sm_id < 0:
        print('No master/slave state machines defined\n')
        return sms

    while sm_id != -1:
        sms.append({'id': sm_id})
        sm_id = epicsPV.epicsPV('%s:MCU-Cfg-SM%d-NxtObjId' % (ioc, sm_id)).getw()

    print('Master/slave count: ' + str(len(sms)))

    return sms


def create_ui_file(fname: str, ioc: str, sms, rows: int):
    old_umask = os.umask(0)
    try:
        mode = 'rb+' if os.path.exists(fname) else 'wb'
        f = open(fname, mode)
    finally:
        os.umask(old_umask)

    with f:
        f.truncate(0)
        cols = max(1, math.ceil(len(sms) / rows))

        f.write(header % (
            min(1200, sub_panel_width * cols),
            rows * sub_panel_height + 20,
            bytes(ioc, 'utf8'),
            sub_panel_width * cols,
            rows * sub_panel_height,
        ))

        for idx, sm in enumerate(sms):
            f.write(widget % (
                idx // cols,
                idx % cols,
                bytes(ioc, 'utf8'),
                bytes(ioc, 'utf8'),
                sm['id'],
                sm['id'],
            ))

        f.write(footer)

    os.chmod(
        fname,
        stat.S_IRUSR | stat.S_IWUSR |
        stat.S_IRGRP | stat.S_IWGRP |
        stat.S_IROTH | stat.S_IWOTH,
    )


def main():
    parser = argparse.ArgumentParser(description='Create an overview panel of master/slave objects for an IOC')
    parser.add_argument('ioc', help='IOC name')
    parser.add_argument('--rows', type=int, default=1, help='Layout modules in rows')
    args = parser.parse_args()

    sms = get_state_machines_from_ioc(args.ioc)
    fname = os.path.join(tempfile.gettempdir(), '%s_sm_overview.ui' % args.ioc)
    create_ui_file(fname, args.ioc, sms, args.rows)
    os.system('caqtdm -x -noMsg %s' % fname)


if __name__ == '__main__':
    main()
