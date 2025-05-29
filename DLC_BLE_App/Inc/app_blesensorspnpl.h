/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file   BLESensorsPnPL\Inc\app_blesensorspnpl.h
  * @author System Research & Applications Team - Agrate/Catania Lab.
  * @brief  Header for app_blesensorspnpl.c file.
  *         This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __APP_BLESENSORSPNPL_H__
#define __APP_BLESENSORSPNPL_H__

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32u5xx_hal.h"
#include "steval_mkboxpro.h"
#include "SensorTileBoxPro_conf.h"

/* Exported types ------------------------------------------------------------*/
typedef enum
{
  STBOX1_ACC_LSM6DSV16X=0,
  STBOX1_ACC_LIS2DU12=1
} STBOX1_Acc_t;
/* Exported constants --------------------------------------------------------*/

/* Exported macro ------------------------------------------------------------*/
#define MCR_HEART_BIT()   \
{                         \
  BSP_LED_On(LED_YELLOW); \
  BSP_LED_On(LED_GREEN);  \
  HAL_Delay(200);         \
  BSP_LED_Off(LED_YELLOW);\
  BSP_LED_Off(LED_GREEN); \
  HAL_Delay(400);         \
  BSP_LED_On(LED_YELLOW); \
  BSP_LED_On(LED_GREEN);  \
  HAL_Delay(200);         \
  BSP_LED_Off(LED_YELLOW);\
  BSP_LED_Off(LED_GREEN); \
  HAL_Delay(1000);        \
}

#define MCR_HEART_BIT2()  \
{                         \
  BSP_LED_On(LED_YELLOW); \
  BSP_LED_On(LED_RED);    \
  HAL_Delay(200);         \
  BSP_LED_Off(LED_YELLOW);\
  BSP_LED_Off(LED_RED);   \
  HAL_Delay(400);         \
  BSP_LED_On(LED_YELLOW); \
  BSP_LED_On(LED_RED);    \
  HAL_Delay(200);         \
  BSP_LED_Off(LED_YELLOW);\
  BSP_LED_Off(LED_RED);   \
  HAL_Delay(1000);        \
}

/* Exported Variables --------------------------------------------------------*/
extern void *HandleGGComponent;
extern int32_t CurrentActiveBank;
extern STBOX1_Acc_t CurrentAccType;
extern FinishGood_TypeDef FinishGood;

/* Exported Functions Prototypes ---------------------------------------------*/
void STBOX1_Error_Handler(int32_t ErrorCode,char *File,int32_t Line);
FinishGood_TypeDef BSP_CheckFinishGood(void);
void MX_BLESensorsPnPL_Init(void);
void MX_BLESensorsPnPL_Process(void);

/* Exported defines -----------------------------------------------------------*/
#define STBOX1_ERROR_INIT_BLE 1
#define STBOX1_ERROR_FLASH 2
#define STBOX1_ERROR_SENSOR 3
#define STBOX1_ERROR_HW_INIT 4
#define STBOX1_ERROR_BLE 5
#define STBOX1_ERROR_TIMER 6

/* STM32 Unique ID */
#define STM32_UUID ((uint32_t *)0x0BFA0700)

/* STM32 MCU_ID */
#define STM32_MCU_ID ((uint32_t *)0xE0044000)

#ifdef __cplusplus
}
#endif

#endif /*__APP_BLESENSORSPNPL_H__ */

