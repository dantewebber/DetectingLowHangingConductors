#ifndef __APP_BLESENSORSPNPL_H__
#define __APP_BLESENSORSPNPL_H__

#include "stm32u5xx_hal.h"
#include "steval_mkboxpro.h"
#include "SensorTileBoxPro_conf.h"

#define PERIODIC_ADV 0
#define ENABLE_SCAN 1
#define ENABLE_PRESSURE_MEASUREMENT 1
#define PRESSURE_SAMPLE_RATE 10 /* Sample rate Options: 1, 10, 20 [Hz]*/
#define MOVING_AVERAGE_WINDOW_SIZE 50
#define MOVING_MEDIAN_WINDOW_SIZE 10

#define STBOX1_ERROR_INIT_BLE 1
#define STBOX1_ERROR_FLASH 2
#define STBOX1_ERROR_SENSOR 3
#define STBOX1_ERROR_HW_INIT 4
#define STBOX1_ERROR_BLE 5
#define STBOX1_ERROR_TIMER 6

extern float relativePressure; /* pressure measured from the other sensor */

void DLC_Init(void);
void DLC_mainProcess(void);
void STBOX1_Error_Handler(int32_t ErrorCode,char *File,int32_t Line);

#endif