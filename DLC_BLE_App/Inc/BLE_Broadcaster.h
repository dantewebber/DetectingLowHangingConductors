#ifndef _BLE_BROADCASTER_H_
#define _BLE_BROADCASTER_H_

#include <stdlib.h>
#include "BLE_Manager_Conf.h"

#ifndef BLE_MANAGER_NO_PARSON
#include "parson.h"
#endif /* BLE_MANAGER_NO_PARSON */

#include "bluenrg_lp_aci.h"
#include "bluenrg_lp_hci_le.h"
#include "bluenrg_lp_events.h"
#include "hci_const.h"
#include "hci_tl.h"
#include "hci.h"
#include "bluenrg_utils.h"

#define ADV_DATA_LENGTH 28
#define SCAN_INTERVAL 0x0050  // Time = N * 0.625 ms
#define SCAN_WINDOW   0x0025   // Time = N * 0.625 ms
#define DUPLICATE_FILTER_DISABLED 0x00
#define SCAN_ACCEPT_ALL 0x00
#define PASSIVE_SCAN 0x00

float relativePressure; /* pressure measured from the other sensor */

extern uint8_t advStartFlag;
extern uint8_t advStopFlag;
extern uint8_t advState;
extern uint8_t adv_data[ADV_DATA_LENGTH];

extern uint8_t bleScanStartFlag;
extern uint8_t bleScanStopFlag;

void startAdvertising(void);
void stopAdvertising(void);
extern uint8_t StartBLEScan(void);
extern void hci_le_advertising_report_event(uint8_t num_reports, Advertising_Report_t advertising_report[]);
// void hci_le_advertising_report_event_process(uint8_t *payload);
extern void StopBLEScan(void);

tBleStatus InitBleBroadcaster(void);
static tBleStatus InitBleBroadcaster_BLE_Stack(void);
static tBleStatus InitBleBroadcasterServices(void);

#endif