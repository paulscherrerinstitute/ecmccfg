# Example usefull to see ECMC performance
## Electrical Connections:

1. Connect signal generator to EL3702
2. Connect oscilloscope to signal generator and EL4732 output

## Epics Configs:

1. Read data form EL3702 in 100kHz (oversample factor 100). 
2. Push data to EPICS waveform record (input)
3. Forward data to waveform output record linked to EL4732 analog output terminal

# DC clocks (EC rate = 1kHz (1ms))

## Shift0 3702 = 0, Shift0 4732 = 0

Shift of data is approx 300 values (3 cycles)

## Shift0 3702 = 0, Shift0 4732 = 500000

Shift of data is approx 250 values (2.5 cycles = 2 cycles + the shift0 for el4732)

## Shift0 3702 = 500000, Shift0 4732 = 500000

Shift of data is approx 300 values (3 cycles)

## Shift0 3702 = 500000, Shift0 4732 = 0

Shift of data is approx 350 values (3.5 cycles = 3 cycles + the shift0 for el3702)

## Shift0 3702 = -500000, Shift0 4732 = 500000

Shift of data is approx 300 values (3 cycles)

## Shift0 3702 = 500000, Shift0 4732 = -500000

Shift of data is approx 300 values (3 cycles)
