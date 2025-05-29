// BLE_Periodic_Beacon.h
#ifndef BLE_PERIODIC_BEACON_H
#define BLE_PERIODIC_BEACON_H

#include <stdint.h>
#include "bluenrg_lp_stack.h" // For StatusBytes etc.
// #include "BLE_Manager.h" // Include if BLE_StackTypeDef is not in a common header

/* Exported variables */
// extern BLE_StackTypeDef BLE_StackValue; // If modified globally

/* Exported functions */
tBleStatus BLE_Periodic_Beacon_Setup(void);
void BLE_Periodic_Beacon_Process(void);
void Minimal_Sensor_Init(void); // Declaration for sensor init

#endif // BLE_PERIODIC_BEACON_H