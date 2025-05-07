 
# EtherCAT specific settings
ETHER_TYPE_ECAT = 0x88A4  # EtherType for EtherCAT protocol
DST_MAC = b'\xFF\xFF\xFF\xFF\xFF\xFF'  # Broadcast
# c6025a-06 00:01:05:a1:2e:3c
#SRC_MAC = b'\x00\x01\x05\xa1\x2e\x3c'  # Source MAC (master's NIC)
# c6025a-04 00:01:05:86:04:d7
SRC_MAC = b'\x00\x01\x05\x86\x04\xd7'  # Source MAC (master's NIC)

INTERFACE = 'enp2s0'  # Change this to the name of your NIC

import socket
import struct
import random
import time
from datetime import datetime
import os
 
# EtherCAT specific settings

#ETHER_TYPE_ECAT = 0x88A4  # EtherType for EtherCAT protocol
#
#DST_MAC = b'\xFF\xFF\xFF\xFF\xFF\xFF'  # Broadcast to all devices (since EtherCAT slaves do not have individual MACs)
#
#SRC_MAC = b'\x00\x11\x22\x33\x44\x55'  # Source MAC (master's NIC)
 
# EtherCAT frame structure (simplified)

def build_ethercat_frame(seq_num):

    eth_frame = bytearray(60)  # Make room for full Ethernet frame

    struct.pack_into('!6s6sH', eth_frame, 0, DST_MAC, SRC_MAC, ETHER_TYPE_ECAT)

    ethercat_payload = struct.pack('!I', seq_num)  # Sequence number

    eth_frame[14:14+len(ethercat_payload)] = ethercat_payload

    return bytes(eth_frame)
 
# Function to send the frame and capture the hardware timestamp

def send_ethercat_frame(sock, frame_data):

    sock.send(frame_data)

    print(f"Frame sent at {datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')}")
 
    # Capture the timestamp when the frame is sent (using SO_TIMESTAMPING)

    timestamp = None

    while timestamp is None:

        # Receive the response and timestamp

        packet, timestamp = sock.recvfrom(2048)

    return timestamp
 
# Function to set socket options for hardware timestamping

def set_socket_timestamping(sock):

    # Enable hardware timestamping for both TX (send) and RX (receive) using SO_TIMESTAMPING
    print(sock)
    
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_TIMESTAMPING, socket.TS_TX_HARDWARE | socket.TS_RX_HARDWARE)

 
# Function to calculate round-trip time using hardware timestamps

def measure_round_trip_time():

    # Specify which NIC you want to use (e.g., 'eth0')
 
    # Check if the network interface exists and is up

    if not os.path.exists(f"/sys/class/net/{interface}"):

        print(f"Error: Interface {interface} not found.")

        return
 
    # Create a raw socket

    sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(0x88A4))  # EtherType 0x88A4 for EtherCAT
 
    # Bind the socket to the specified NIC

    sock.bind((INTERFACE, 0))  # Binding to the interface
 
    # Set socket options to enable hardware timestamping for both TX and RX

    set_socket_timestamping(sock)
 
    # Create a unique sequence number for the packet

    sequence_number = random.randint(0, 10000)
 
    # Build the frame (EtherCAT frame with sequence number)

    frame = build_ethercat_frame(sequence_number)
 
    # Send the frame and measure the timestamp when it is sent

    send_timestamp = send_ethercat_frame(sock, frame)
 
    # Capture the hardware timestamp for receiving the response (RX timestamp)

    timestamp_recv = None

    while timestamp_recv is None:

        # Receive the response from the slave device

        packet, timestamp_recv = sock.recvfrom(2048)
 
    # Calculate the round-trip time (in microseconds)

    round_trip_time = time.time() - send_timestamp

    print(f"Round-trip time: {round_trip_time * 1e6:.2f} microseconds")
 
    # Print send and receive hardware timestamps (you'll need to parse the actual timestamps)

    print(f"Send hardware timestamp: {send_timestamp}")

    print(f"Receive hardware timestamp: {timestamp_recv}")
 
    # Close the socket after usage

    sock.close()
 
if __name__ == "__main__":

    measure_round_trip_time()

 