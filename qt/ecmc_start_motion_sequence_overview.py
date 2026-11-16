#!/usr/bin/env python3
"""Create an overview containing only configured ecmc motion sequences."""

import argparse
import html
import os
import stat
import subprocess
import tempfile


HEADER = """<?xml version="1.0" encoding="UTF-8"?>
<ui version="4.0">
 <class>Form</class>
 <widget class="QWidget" name="Form">
  <property name="geometry"><rect><x>0</x><y>0</y><width>920</width><height>{height}</height></rect></property>
  <property name="windowTitle"><string>{ioc} ECMC motion sequence overview</string></property>
  <layout class="QVBoxLayout" name="verticalLayout">
   <property name="margin"><number>4</number></property>
   <item>
    <widget class="QWidget" name="headers">
     <property name="minimumSize"><size><width>900</width><height>22</height></size></property>
     <property name="maximumSize"><size><width>16777215</width><height>22</height></size></property>
     <widget class="caLabel" name="headerOpen">
      <property name="geometry"><rect><x>0</x><y>2</y><width>46</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>Open</string></property>
     </widget>
     <widget class="caLabel" name="headerId">
      <property name="geometry"><rect><x>64</x><y>2</y><width>34</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>ID</string></property>
     </widget>
     <widget class="caLabel" name="headerState">
      <property name="geometry"><rect><x>106</x><y>2</y><width>110</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>State</string></property>
     </widget>
     <widget class="caLabel" name="headerRunning">
      <property name="geometry"><rect><x>226</x><y>2</y><width>90</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>Running</string></property>
     </widget>
     <widget class="caLabel" name="headerStep">
      <property name="geometry"><rect><x>326</x><y>2</y><width>70</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>Step</string></property>
     </widget>
     <widget class="caLabel" name="headerCount">
      <property name="geometry"><rect><x>406</x><y>2</y><width>70</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>Count</string></property>
     </widget>
     <widget class="caLabel" name="headerError">
      <property name="geometry"><rect><x>486</x><y>2</y><width>70</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>Error</string></property>
     </widget>
     <widget class="caLabel" name="headerStepName">
      <property name="geometry"><rect><x>566</x><y>2</y><width>324</width><height>18</height></rect></property>
      <property name="alignment"><set>Qt::AlignCenter</set></property>
      <property name="text"><string>Step name</string></property>
     </widget>
    </widget>
   </item>
   <item>
    <widget class="QScrollArea" name="scrollArea">
     <property name="frameShape"><enum>QFrame::NoFrame</enum></property>
     <property name="widgetResizable"><bool>true</bool></property>
     <widget class="QWidget" name="scrollAreaWidgetContents">
      <property name="geometry"><rect><x>0</x><y>0</y><width>900</width><height>{content_height}</height></rect></property>
      <layout class="QVBoxLayout" name="sequenceLayout">
       <property name="margin"><number>0</number></property>
"""

ROW = """
       <item>
        <widget class="caInclude" name="sequence{seq_id}">
         <property name="minimumSize"><size><width>900</width><height>30</height></size></property>
         <property name="maximumSize"><size><width>16777215</width><height>30</height></size></property>
         <property name="macro"><string>IOC={ioc},SEQ_ID={seq_id},SEQ_PFX={pv_prefix}</string></property>
         <property name="filename" stdset="0"><string notr="true">ecmcMotionSequenceRow.ui</string></property>
        </widget>
       </item>
"""

EMPTY_ROW = """
       <item>
        <widget class="caLabel" name="emptyMessage">
         <property name="minimumSize"><size><width>900</width><height>30</height></size></property>
         <property name="text"><string>No configured motion sequences found. Restart the IOC after loading the sequence registry records.</string></property>
        </widget>
       </item>
"""

FOOTER = """
       <item><spacer name="verticalSpacer"><property name="orientation"><enum>Qt::Vertical</enum></property><property name="sizeHint" stdset="0"><size><width>20</width><height>40</height></size></property></spacer></item>
      </layout>
     </widget>
    </widget>
   </item>
  </layout>
 </widget>
 <customwidgets>
  <customwidget><class>caLabel</class><extends>QLabel</extends><header>caLabel</header></customwidget>
  <customwidget><class>caInclude</class><extends>QWidget</extends><header>caInclude</header></customwidget>
 </customwidgets>
 <resources/>
 <connections/>
</ui>
"""


def get_sequences(ioc):
    from ecmc_ca_compat import ca, epicsPV

    def read(pv_name):
        return epicsPV.epicsPV(pv_name).getw()

    sequences = []
    seen = set()
    try:
        seq_id = int(read(f"{ioc}:MCU-Cfg-SEQ-FrstObjId"))
    except Exception:
        seq_id = -1

    while seq_id >= 0:
        if seq_id in seen:
            raise RuntimeError(f"Cycle in motion sequence configuration at ID {seq_id}")
        seen.add(seq_id)

        pv_prefix = read(f"{ioc}:MCU-Cfg-SEQ{seq_id}-Pfx")
        sequences.append({"id": seq_id, "pv_prefix": str(pv_prefix)})

        seq_id = int(read(f"{ioc}:MCU-Cfg-SEQ{seq_id}-NxtObjId"))

    if sequences:
        return sequences

    # Recover from an uninitialized first pointer by probing the bounded
    # sequencer ID range. Only IDs with configuration prefix PVs are included.
    try:
        count = int(read(f"{ioc}:MCU-Cfg-SEQ-Cnt"))
    except Exception:
        count = 0
    if count <= 0:
        return sequences

    for candidate in range(16):
        try:
            pv_prefix = read(f"{ioc}:MCU-Cfg-SEQ{candidate}-Pfx")
        except Exception:
            continue
        if pv_prefix:
            sequences.append({
                "id": candidate,
                "pv_prefix": str(pv_prefix),
            })
            if len(sequences) >= count:
                break

    return sequences


def create_ui_file(filename, ioc, sequences):
    row_count = max(1, len(sequences))
    content_height = row_count * 34
    height = min(620, max(150, 62 + content_height))
    old_umask = os.umask(0)
    try:
        mode = "r+" if os.path.exists(filename) else "w"
        output = open(filename, mode, encoding="utf-8")
    finally:
        os.umask(old_umask)

    with output:
        output.truncate(0)
        output.write(HEADER.format(
            height=height,
            content_height=content_height,
            ioc=html.escape(ioc),
        ))
        for sequence in sequences:
            output.write(ROW.format(
                ioc=html.escape(ioc),
                seq_id=sequence["id"],
                pv_prefix=html.escape(sequence["pv_prefix"]),
            ))
        if not sequences:
            output.write(EMPTY_ROW)
        output.write(FOOTER)

    os.chmod(
        filename,
        stat.S_IRUSR | stat.S_IWUSR |
        stat.S_IRGRP | stat.S_IWGRP |
        stat.S_IROTH | stat.S_IWOTH,
    )


def main():
    parser = argparse.ArgumentParser(
        description="Create an overview of configured ecmc motion sequences"
    )
    parser.add_argument("ioc", help="IOC prefix without trailing colon")
    args = parser.parse_args()

    sequences = get_sequences(args.ioc)
    if not sequences:
        print("No motion sequences configured")

    filename = os.path.join(
        tempfile.gettempdir(), f"{args.ioc}_motion_sequence_overview.ui"
    )
    create_ui_file(filename, args.ioc, sequences)
    subprocess.run(["caqtdm", "-x", "-noMsg", filename], check=False)


if __name__ == "__main__":
    main()
