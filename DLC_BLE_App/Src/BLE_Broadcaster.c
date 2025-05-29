/* Adapted and developed from ST's BLE_Manager.c */
/* Author: Dante Webber */

#include <stdio.h>
#include <math.h>
#include "BLE_Broadcaster.h"
#include "BLE_Manager.h"

uint8_t advStartFlag;
uint8_t advStopFlag;
uint8_t advState;
uint8_t adv_data[ADV_DATA_LENGTH];

/* BLE Scanning */
uint8_t bleScanStartFlag;
uint8_t bleScanStopFlag;

uint8_t StartBLEScan(void);
// void hci_le_advertising_report_event(uint8_t num_reports, Advertising_Report_t advertising_report[]);
void StopBLEScan(void);

static uint16_t connection_handle;
static uint8_t UsedBleChars;
static uint8_t UsedStandardBleChars;
static void APP_UserEvtRx(void *pData);
static void ResetBleManagerCallbackFunctionPointer(void);

void startAdvertising(void) {
    tBleStatus ret;
    Advertising_Set_Parameters_t Advertising_Set_Parameters[1];

    adv_data[0 ] = 0x02;
    adv_data[1 ] = 0x01;
    adv_data[2 ] = 0x06;
    adv_data[3 ] = 8;
    adv_data[4 ] = 0x09;
    adv_data[5 ] = BLE_StackValue.BoardName[0]; /* Complete Name */
    adv_data[6 ] = BLE_StackValue.BoardName[1];
    adv_data[7 ] = BLE_StackValue.BoardName[2];
    adv_data[8 ] = BLE_StackValue.BoardName[3];
    adv_data[9 ] = BLE_StackValue.BoardName[4];
    adv_data[10] = BLE_StackValue.BoardName[5];
    adv_data[11] = BLE_StackValue.BoardName[6];
    adv_data[12] = 15;
    adv_data[13] = 0xFF;
    adv_data[14] = 0x30;
    adv_data[15] = 0x00; /* STM Manufacter AD */
    adv_data[16] = 0x02; /* SDK version */
    adv_data[17] = BLE_StackValue.BoardId; /* BoardType*/
    adv_data[18] = 0x00; /* Fw ID*/
    adv_data[19] = 0x00; /* Second Custom Byte -> Not Used */
    adv_data[20] = 0x00; /* Third  Custom Byte -> Not Used */
    adv_data[21] = 0x00; /* Fourth Custom Byte -> Not Used */
    adv_data[22] = BLE_StackValue.BleMacAddress[5]; /* BLE MAC start - MSB first - */
    adv_data[23] = BLE_StackValue.BleMacAddress[4];
    adv_data[24] = BLE_StackValue.BleMacAddress[3];
    adv_data[25] = BLE_StackValue.BleMacAddress[2];
    adv_data[26] = BLE_StackValue.BleMacAddress[1];
    adv_data[27] = BLE_StackValue.BleMacAddress[0]; /* BLE MAC stop */

    BLE_SetCustomAdvertiseData(adv_data);

    /* Set BLE Advertising configuration */
    ret = aci_gap_set_advertising_configuration(0, GAP_MODE_GENERAL_DISCOVERABLE,
                                              ADV_PROP_CONNECTABLE | ADV_PROP_SCANNABLE | ADV_PROP_LEGACY,
                                              ADV_INTERV_MIN,
                                              ADV_INTERV_MAX,
                                              ADV_CH_ALL,
                                              STATIC_RANDOM_ADDR, NULL,
                                              ADV_NO_WHITE_LIST_USE,
                                              0, /* 0 dBm */
                                              LE_1M_PHY, /* Primary advertising PHY */
                                              0, /* 0 skips */
                                              LE_1M_PHY, /* Secondary advertising PHY. Not used with legacy advertising. */
                                              0, /* SID */
                                              0 /* No scan request notifications */);
    if (ret != BLE_STATUS_SUCCESS)
    {
      BLE_MANAGER_PRINTF("aci_gap_set_advertising_configuration failed: 0x%02x\r\n", ret);
      goto EndLabel;
    }
    else
    {
      BLE_MANAGER_PRINTF("aci_gap_set_advertising_configuration\r\n");
    }

    /* Set advertising data */
    ret = aci_gap_set_advertising_data_nwk(0, ADV_COMPLETE_DATA, ADV_DATA_LENGTH, adv_data);
    if (ret != BLE_STATUS_SUCCESS)
    {
      BLE_MANAGER_PRINTF("aci_gap_set_advertising_data_nwk failed: 0x%02x\r\n", ret);
      goto EndLabel;
    }
    else
    {
        BLE_MANAGER_PRINTF("aci_gap_set_advertising_data_nwk\r\n");
    }

    Advertising_Set_Parameters[0].Advertising_Handle = 0;
    Advertising_Set_Parameters[0].Duration = 0;
    Advertising_Set_Parameters[0].Max_Extended_Advertising_Events = 0;

    /* enable advertising */
    ret = aci_gap_set_advertising_enable(ENABLE, 1, Advertising_Set_Parameters);
    if (ret != BLE_STATUS_SUCCESS)
    {
    BLE_MANAGER_PRINTF("aci_gap_set_advertising_enable failed: 0x%02x\r\n", ret);
    }
    else
    {
    BLE_MANAGER_PRINTF("aci_gap_set_advertising_enable\r\n");
    }

    EndLabel:
        return;
}

void stopAdvertising(void) {
    tBleStatus ret;
    Advertising_Set_Parameters_t Advertising_Set_Parameters[1];
    Advertising_Set_Parameters[0].Advertising_Handle = 0;
    Advertising_Set_Parameters[0].Duration = 0;
    Advertising_Set_Parameters[0].Max_Extended_Advertising_Events = 0;

    /* Disable advertising */
    ret = aci_gap_set_advertising_enable(DISABLE, 1, Advertising_Set_Parameters);
    if (ret != BLE_STATUS_SUCCESS)
    {
    BLE_MANAGER_PRINTF("aci_gap_set_advertising_enable failed: 0x%02x\r\n", ret);
    }
    else
    {
    BLE_MANAGER_PRINTF("aci_gap_set_advertising_enable: Advertising Disabled\r\n");
    }
}

uint8_t StartBLEScan(void)
{
    tBleStatus status;
    BLE_MANAGER_PRINTF("Attempting to start BLE scan...\r\n");
    BLE_MANAGER_DELAY(100);

    /* Configure Scannning Parameters */
    // status = aci_gap_set_scan_configuration(
    //     DUPLICATE_FILTER_DISABLED, 
    //     SCAN_ACCEPT_ALL, 
    //     LE_1M_PHY_BIT, 
    //     PASSIVE_SCAN, 
    //     SCAN_INTERVAL, 
    //     SCAN_WINDOW);

    // if (status != BLE_STATUS_SUCCESS) {
    //     BLE_MANAGER_PRINTF("Scan configuration failed. Status: 0x%02X\r\n", status);
    //     return 0;
    // }

    status = hci_le_set_scan_parameters(PASSIVE_SCAN, SCAN_INTERVAL, SCAN_WINDOW, PUBLIC_ADDR, SCAN_ACCEPT_ALL);
    if (status != BLE_STATUS_SUCCESS) {
        BLE_MANAGER_PRINTF("Scan configuration failed. Status: 0x%02X\r\n", status);
        return 0;
    }
    BLE_MANAGER_DELAY(50);

    // Start scanning for BLE devices
    // status = aci_gap_start_procedure(GAP_OBSERVATION_PROC, LE_1M_PHY_BIT, 0x01, 0x01);
    status = hci_le_set_scan_enable(ENABLE, 0x00);
    // status = aci_gap_start_general_discovery_proc(0x10, 0x10, PUBLIC_ADDR, 0x00);
    if (status == BLE_STATUS_SUCCESS)
    {
        BLE_MANAGER_PRINTF("BLE scanning started...\r\n");
    }
    else
    {
        BLE_MANAGER_PRINTF("Failed to start BLE scanning. Status: 0x%02X\r\n", status);
        return 0;
    }
    return 1;
}

void hci_le_advertising_report_event(uint8_t num_reports,
                                     Advertising_Report_t advertising_report[])
{
    BLE_MANAGER_PRINTF("Advertising Report Event Called...");
    for (uint8_t i = 0; i < num_reports; i++)
    {
        // Extract advertising data
        uint8_t *adv_data = advertising_report[i].Data;
        uint8_t adv_data_len = advertising_report[i].Data_Length;
        int8_t rssi = advertising_report[i].RSSI;

        // Print advertising data
        BLE_MANAGER_PRINTF("Device found:\r\n");
        BLE_MANAGER_PRINTF("  RSSI: %d dBm\r\n", rssi);
        BLE_MANAGER_PRINTF("  Advertising Data: ");
        for (uint8_t j = 0; j < adv_data_len; j++)
        {
            BLE_MANAGER_PRINTF("%02X ", adv_data[j]);
        }
        BLE_MANAGER_PRINTF("\r\n");

        // Extract pressure value if data length is sufficient
        if (adv_data_len >= 20) {
            // Reconstruct pressure value from bytes 18-19
            uint16_t pressureRaw = (adv_data[18] << 8) | adv_data[19];
            relativePressure = (float)pressureRaw;
            
            BLE_MANAGER_PRINTF("  Received Pressure Value: %.2f\r\n", relativePressure);
        }
    }
}

// void hci_le_advertising_report_event_process(uint8_t *payload)
// {
//     hci_le_advertising_report_event_rp0 *report = (void*)payload;
    
//     for (uint8_t i = 0; i < report->Num_Reports; i++)
//     {
//         uint8_t evt_type = report->Advertising_Report[i].Event_Type;
//         uint8_t data_len = report->Advertising_Report[i].Data_Length;
//         uint8_t *adv_data = report->Advertising_Report[i].Data;
//         int8_t rssi = report->Advertising_Report[i].RSSI;
//         uint8_t addr_type = report->Advertising_Report[i].Address_Type;
//         uint8_t *bdaddr = report->Advertising_Report[i].Address;

//         BLE_MANAGER_PRINTF("Device found:\r\n");
//         BLE_MANAGER_PRINTF("  Address: %02X:%02X:%02X:%02X:%02X:%02X\r\n",
//                           bdaddr[5], bdaddr[4], bdaddr[3], 
//                           bdaddr[2], bdaddr[1], bdaddr[0]);
//         BLE_MANAGER_PRINTF("  Address Type: %d\r\n", addr_type);
//         BLE_MANAGER_PRINTF("  Event Type: %d\r\n", evt_type);
//         BLE_MANAGER_PRINTF("  RSSI: %d dBm\r\n", rssi);
//         BLE_MANAGER_PRINTF("  Data Length: %d\r\n", data_len);
//         BLE_MANAGER_PRINTF("  Data: ");
        
//         for (uint8_t j = 0; j < data_len; j++)
//         {
//             BLE_MANAGER_PRINTF("%02X ", adv_data[j]);
//         }
//         BLE_MANAGER_PRINTF("\r\n\n");
//     }
// }

void StopBLEScan(void)
{
    tBleStatus status;

    // Stop scanning
    status = aci_gap_terminate_proc(GAP_GENERAL_DISCOVERY_PROC);
    // status = aci_gap_terminate_gap_proc(GAP_GENERAL_DISCOVERY_PROC);
    if (status == BLE_STATUS_SUCCESS)
    {
        BLE_MANAGER_PRINTF("BLE scanning stopped.\r\n");
    }
    else
    {
        BLE_MANAGER_PRINTF("Failed to stop BLE scanning. Status: 0x%02X\r\n", status);
    }
}

tBleStatus InitBleBroadcaster(void) {
    tBleStatus ret = BLE_STATUS_SUCCESS;

    if (BLE_StackValue.BoardId == 0U)
    {
    BLE_MANAGER_PRINTF("Error BLE_StackValue.BoardId Not Defined\r\n");
    return BLE_ERROR_UNSPECIFIED;
    }

    BLE_Conf_Service = BLE_SERV_NOT_ENABLE;
    BLE_StdTerm_Service = BLE_SERV_NOT_ENABLE;
    BLE_StdErr_Service = BLE_SERV_NOT_ENABLE;
    BLE_ExtConf_Service = BLE_SERV_NOT_ENABLE;

    UsedBleChars = 0;
    UsedStandardBleChars = 0;
    connection_handle = 0;
    MaxBleCharStdOutLen = DEFAULT_MAX_STDOUT_CHAR_LEN;
    MaxBleCharStdErrLen = DEFAULT_MAX_STDERR_CHAR_LEN;

    ret = InitBleBroadcaster_BLE_Stack();

    ResetBleManagerCallbackFunctionPointer();

    #ifndef BLE_MANAGER_NO_PARSON
    ClearCustomCommandsList();
    #endif /* BLE_MANAGER_NO_PARSON */

    if (ret == (tBleStatus)BLE_STATUS_SUCCESS)
    {
    /* Ble Manager services initialization */
    ret = InitBleBroadcasterServices();
    }

    return ret;
}

static tBleStatus InitBleBroadcaster_BLE_Stack(void) {
    uint16_t service_handle;
    uint16_t dev_name_char_handle;
    uint16_t appearance_char_handle;
    tBleStatus ret;
    uint8_t data_len_out;
    uint8_t random_number[8];
    uint8_t  hwVersion;
    uint16_t fwVersion;

    /* Initialize the BlueNRG HCI */
    hci_init(APP_UserEvtRx, NULL);

    InitBLEIntForBlueNRGLP();

    /* Sw reset of the device */
    hci_reset();

    BLE_MANAGER_DELAY(2000);

    /* get the BlueNRG HW and FW versions */
    getBlueNRGVersion(&hwVersion, &fwVersion);

    /* we will let the BLE chip to use its Random MAC address */
// #define CONFIG_DATA_RANDOM_ADDRESS          (0x80) /**< Stored static random address. Read-only. */
//     ret = aci_hal_read_config_data(CONFIG_DATA_RANDOM_ADDRESS, &data_len_out, BLE_StackValue.BleMacAddress);

//     if (ret != BLE_STATUS_SUCCESS)
//     {
//         BLE_MANAGER_PRINTF("\r\nReading  Random BD_ADDR failed\r\n");
//         goto fail;
//     }

//     /* Check Random MAC */
//     if ((BLE_StackValue.BleMacAddress[5] & 0xC0U) != 0xC0U)
//     {
//         BLE_MANAGER_PRINTF("\tStatic Random address not well formed\r\n");
//         goto fail;
//     }

    // ret = aci_hal_write_config_data(BLE_StackValue.ConfigValueOffsets,
    //                                 BLE_StackValue.ConfigValuelength,
    //                                 BLE_StackValue.BleMacAddress);
    // if (ret != BLE_STATUS_SUCCESS)
    // {
    // BLE_MANAGER_PRINTF("\r\nSetting Public BD_ADDR failed\r\n");
    // goto fail;
    // }

    ret = aci_gatt_srv_init();
    if (ret != BLE_STATUS_SUCCESS)
    {
    BLE_MANAGER_PRINTF("\r\nGATT_Init failed\r\n");
    goto fail;
    }

    ret = aci_gap_init(BLE_StackValue.GAP_Roles,
                        0x00,
                        (uint8_t) strlen(BLE_StackValue.BoardName),
                        PUBLIC_ADDR,
                        &service_handle,
                        &dev_name_char_handle,
                        &appearance_char_handle);

    if (ret != BLE_STATUS_SUCCESS)
    {
    BLE_MANAGER_PRINTF("\r\nGAP_Init failed\r\n");
    goto fail;
    }

    ret = aci_gatt_srv_write_handle_value_nwk(dev_name_char_handle + 1,
                                            0,
                                            (uint8_t) strlen(BLE_StackValue.BoardName),
                                            (uint8_t *) BLE_StackValue.BoardName);
    if (ret != BLE_STATUS_SUCCESS)
    {
    BLE_MANAGER_PRINTF("\taci_gatt_srv_write_handle_value_nwk failed: 0x%02x\r\n", ret);
    goto fail;
    }
    else
    {
    BLE_MANAGER_PRINTF("\taci_gatt_srv_write_handle_value_nwk\r\n");
    }

    // ret = aci_gap_set_authentication_requirement(0x00,
    //                                              0x00,
    //                                              0x00,
    //                                              0x00,
    //                                              7,
    //                                              16,
    //                                              0x00,
    //                                              0);
    
    // if (ret != BLE_STATUS_SUCCESS)
    // {
    // BLE_MANAGER_PRINTF("\r\nGAP setting Authentication failed\r\n");
    // goto fail;
    // }

    BLE_MANAGER_PRINTF("\r\nSERVER: BLE Stack Initialized \r\n"
                    "\t\tBoardName= %s\r\n"
                    "\t\tBoardMAC = %x:%x:%x:%x:%x:%x\r\n",
                    BLE_StackValue.BoardName,
                    BLE_StackValue.BleMacAddress[5],
                    BLE_StackValue.BleMacAddress[4],
                    BLE_StackValue.BleMacAddress[3],
                    BLE_StackValue.BleMacAddress[2],
                    BLE_StackValue.BleMacAddress[1],
                    BLE_StackValue.BleMacAddress[0]);

    BLE_MANAGER_PRINTF("BlueNRG-LP HWver %d FWver %d\r\n", hwVersion, fwVersion);
    /* Set output power level */
    // aci_hal_set_tx_power_level(0x01,
    //                             0x25);
    
    // ret = hci_le_write_suggested_default_data_length(247, (247 + 14) * 8);
    // if (ret != BLE_STATUS_SUCCESS)
    // {
    // BLE_MANAGER_PRINTF("\thci_le_write_suggested_default_data_length failed: 0x%02x\r\n", ret);
    // }
    // else
    // {
    // BLE_MANAGER_PRINTF("\thci_le_write_suggested_default_data_length\r\n");
    // }

    fail:
        return ret;
}

static tBleStatus InitBleBroadcasterServices(void) {
    tBleStatus Status = BLE_ERROR_UNSPECIFIED;
    BleCharTypeDef *BleCharPointer;

    BLE_InitCustomService();
    return Status;
}

static void APP_UserEvtRx(void *pData)
{
  uint32_t i;

  hci_spi_pckt *hci_pckt = (hci_spi_pckt *)pData;

  if (hci_pckt->type == HCI_EVENT_PKT || hci_pckt->type == HCI_EVENT_EXT_PKT)
  {
    void *data;
    hci_event_pckt *event_pckt = (hci_event_pckt *)hci_pckt->data;

    if (hci_pckt->type == HCI_EVENT_PKT)
    {
      data = event_pckt->data;
    }
    else
    {
      hci_event_ext_pckt *event_pckt = (hci_event_ext_pckt *)hci_pckt->data;
      data = event_pckt->data;
    }

    if (event_pckt->evt == EVT_LE_META_EVENT)
    {
      evt_le_meta_event *evt = data;

      for (i = 0; i < (sizeof(hci_le_meta_events_table) / sizeof(hci_le_meta_events_table_type)); i++)
      {
        if (evt->subevent == hci_le_meta_events_table[i].evt_code)
        {
          hci_le_meta_events_table[i].process((void *)evt->data);
          break;
        }
      }
    }
    else if (event_pckt->evt == EVT_VENDOR)
    {
      evt_blue_aci *blue_evt = data;

      for (i = 0; i < (sizeof(hci_vendor_specific_events_table) / sizeof(hci_vendor_specific_events_table_type)); i++)
      {
        if (blue_evt->ecode == hci_vendor_specific_events_table[i].evt_code)
        {
          hci_vendor_specific_events_table[i].process((void *)blue_evt->data);
          break;
        }
      }
    }
    else
    {
      for (i = 0; i < (sizeof(hci_events_table) / sizeof(hci_events_table_type)); i++)
      {
        if (event_pckt->evt == hci_events_table[i].evt_code)
        {
          hci_events_table[i].process(data);
          break;
        }
      }
    }
  }
}

static void ResetBleManagerCallbackFunctionPointer(void)
{
  /**************** Bluetooth Communication *************************/
  CustomPairingCompleted = NULL;
  CustomMTUExchangeRespEvent = NULL;
  CustomSetConnectable = NULL;
  CustomConnectionCompleted = NULL;
  CustomDisconnectionCompleted = NULL;
  CustomAciGattTxPoolAvailableEvent = NULL;
  CustomHardwareErrorEventHandler = NULL;

  /**************** Debug Console *************************/
  CustomDebugConsoleParsingCallback = NULL;

  /******************* Config Char *************************/
  CustomAttrModConfigCallback = NULL;
  CustomWriteRequestConfigCallback = NULL;

#ifndef BLE_MANAGER_NO_PARSON
  /**************** Extended Configuration *************************/
  /* For Reboot on DFU Command */
  CustomExtConfigRebootOnDFUModeCommandCallback = NULL;
  /* For Power off Command */
  CustomExtConfigPowerOffCommandCallback = NULL;
  /* For Set board Name Command */
  CustomExtConfigSetNameCommandCallback = NULL;
  /* For Set Time Command */
  CustomExtConfigSetTimeCommandCallback = NULL;
  /* For Set Date Command */
  CustomExtConfigSetDateCommandCallback = NULL;
  /* For Set Wi-Fi Command */
  CustomExtConfigSetWiFiCommandCallback = NULL;
  /* For Change Secure PIN Command */
  CustomExtConfigChangePinCommandCallback = NULL;
  /* For Clear Secure Data Base Command */
  CustomExtConfigClearDBCommandCallback = NULL;
  /* For Reading the Flash Banks Fw Ids */
  CustomExtConfigReadBanksFwIdCommandCallback = NULL;
  /* For Swapping the Flash Banks */
  CustomExtConfigBanksSwapCommandCallback = NULL;
  /* For UID Command */
  CustomExtConfigUidCommandCallback = NULL;
  /* For Info Command */
  CustomExtConfigInfoCommandCallback = NULL;
  /* For Help Command */
  CustomExtConfigHelpCommandCallback = NULL;
  /* For PowerStatus Command */
  CustomExtConfigPowerStatusCommandCallback = NULL;
  /* For VersionFw Command */
  CustomExtConfigVersionFwCommandCallback = NULL;
  /* For Custom Command */
  CustomExtConfigReadCustomCommandsCallback = NULL;
  CustomExtConfigCustomCommandCallback = NULL;
  /* For Read Certificate Command */
  CustomExtConfigReadCertCommandCallback = NULL;
  /* For Set Certificate Command */
  CustomExtConfigSetCertCommandCallback = NULL;
#endif /* BLE_MANAGER_NO_PARSON */
}