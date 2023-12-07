#- ecmcForLoop file for PSI ILK anybus slave data items
#- Note: Need to be called last so that thh final result of the memory area are seen
#-  Loop macro:
#-    IDX  : Loop variable 1..OVERSAMPLING_FACTOR
#-
#-  Static macros (same for entire for loop):
#-    CH_ID          : Channel id

#- Convert to hex value with zero padding

#- Always input since only to see the resulting buffers
${SCRIPTEXEC} ${ecmccfg_DIR}addEcDataItem.cmd "STRT_ENTRY_NAME=${KEY}${IDX},OFFSET_BYTE=0,OFFSET_BITS=0,RW=2,DT=U8,NAME=${KEY}${IDX}_Ptr"
