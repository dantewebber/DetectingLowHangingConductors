# Detecting Low Hanging Conductors (DLC)

# DLC_App
This project is designed to detect low-hanging electrical conductors by analyzing barometric pressure and temperature data from an onboard sensor node.

# DLC_Process.c

## Overview
Code for `main()` loop process implementation.
## Features

- BLE advertising of filtered pressure data.
- Timer-driven sensor polling and BLE update scheduling.
- Pressure data smoothing using moving average and median filtering.
- Fault detection based on vertical displacement thresholding using the hypsometric formula.
- Visual status indicators using onboard LEDs (e.g., blue for normal, red for fault).

## Main Components

- **`DLC_Init()`**  
  Initializes BLE advertising and system timers.

- **`DLC_mainProcess()`**  
  Periodically collects sensor data, applies filtering, calculates altitude changes, and updates BLE advertising data. Detects and flags faults if vertical displacement exceeds ±0.5 meters.

- **`timersInit()`**  
  Sets up hardware timers to trigger BLE and pressure measurement events.

- **`HAL_TIM_OC_DelayElapsedCallback()`**  
  Timer interrupt handler for managing state transitions and sampling.

- **`insertionSort()`**  
  Utility function used for median filtering of pressure values.

## BLE Data Format

Custom manufacturer data in BLE packets contains:

- Raw and filtered pressure values.
- Fault flags based on altitude deviation.

## Pressure Filtering

- Moving Average: Smooths short-term fluctuations.
- Median Filter: Reduces the influence of outliers in the averaged data.

## Fault Detection

- Uses hypsometric formula to compute vertical displacement.
- A deviation greater than ±0.5 meters from baseline indicates a fault.
- LED color changes and BLE data reflect fault status.

## Dependencies

- STMicroelectronics Sensor Expansion (BSP)
- STM32 HAL library
- BLE_Broadcaster module
- STBOX1 configuration utilities

# BLE_Broadcaster.c

## Overview

This module provides Bluetooth Low Energy (BLE) broadcasting and scanning capabilities for embedded systems based on ST's BlueNRG BLE stack. It is adapted from ST's `BLE_Manager.c` and supports device advertising, scanning, and event handling.

---

## Features

- BLE stack initialization and hardware reset
- Configurable advertising with custom data (device name, MAC, etc.)
- Passive BLE scanning and device discovery
- Event-based callback handling for HCI BLE events
- Pressure sensor data decoding from advertising packets (optional)

---

## Main Components

- `startAdvertising()` — Sets advertising parameters and starts BLE advertising.
- `stopAdvertising()` — Disables BLE advertising.
- `StartBLEScan()` — Starts BLE scanning in passive mode.
- `StopBLEScan()` — Stops scanning and terminates BLE observation procedure.
- `hci_le_advertising_report_event()` — Handles advertising report events.
- `InitBleBroadcaster()` — Initializes the BLE stack and services.
- `InitBleBroadcaster_BLE_Stack()` — Low-level stack init (GATT/GAP setup, MAC retrieval).
- `APP_UserEvtRx()` — Dispatches BLE stack events to handler tables.

---

## Dependencies

- ST BlueNRG BLE Stack
- Header Files:
  - `BLE_Manager.h`
  - `BLE_Broadcaster.h`

---


## Author

**Dante Webber**  
Adapted from STMicroelectronics' BLE Manager source.

---

## License

This project is adapted from ST's BLE_Manager.c and is subject to the licensing terms of the original codebase.

# Data_Analysis
Contains Matlab code used for data processing and data collected from tests.

