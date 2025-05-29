/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    BLESensorsPnPL\Inc\STBOX1_config.h
  * @author  System Research & Applications Team - Agrate/Catania Lab.
  * @brief   FP-SNS-STBOX1 configuration
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
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STBOX1_CONFIG_H
#define __STBOX1_CONFIG_H

/* Exported define ------------------------------------------------------------*/

/* For enabling the printf */
#define STBOX1_ENABLE_PRINTF

/* Update/Blink Battery/LED Every second */
#define STBOX1_UPDATE_LED_BATTERY 10000

#define STTS22H_ODR 1.0f /* ODR = 1.0Hz */
#define LSM6DSV16X_ACC_ODR 120.0f /* ODR = 120Hz */
#define LSM6DSV16X_ACC_FS 4 /* FS = 4g */
#define LSM6DSV16X_GYRO_ODR 120.0f /* ODR = 120Hz */
#define LSM6DSV16X_GYRO_FS 2000 /* FS = 2000dps */
#define LIS2DU12_ACC_ODR 100.0f /* ODR = 100Hz */
#define LIS2DU12_ACC_FS 4 /* FS = 4g */
#define LPS22DF_ODR 25.0f /* ODR = 25.0Hz */
#define LIS2MDL_MAG_ODR 100.0f /* ODR = 100Hz */
#define LIS2MDL_MAG_FS 50 /* FS = 50gauss */

#include "stm32u5xx_hal.h"
/* Exported defines for TIMER -------------------------------------------------*/
extern TIM_HandleTypeDef htim1;
#define TIM_CC_HANDLE    htim1
#define TIM_CC_INSTANCE  TIM1

/**************************************
 *  Lab/Experimental section defines  *
***************************************/

/**************************************
 * Don't Change the following defines *
***************************************/

/* Package Version only numbers 0->9 */
#define STBOX1_VERSION_MAJOR '2'
#define STBOX1_VERSION_MINOR '0'
#define STBOX1_VERSION_PATCH '0'

/* Package Name */
#define STBOX1_PACKAGENAME "BLESensorsPnPL"

/* USER CODE BEGIN 1 */

/* Firmware IDs */
#define STBOX1A_BLUEST_SDK_FW_ID 0x32
#define STBOX1B_BLUEST_SDK_FW_ID 0x12

/* USER CODE END 1 */

#undef DEFAULT_MAX_PNPL_NOTIFICATION_CHAR_LEN
/* Define the Max Dimension of the Bluetooth characteristics for PnPL (only for Notification) */
#define DEFAULT_MAX_PNPL_NOTIFICATION_CHAR_LEN 244

#undef ACC_BLUENRG_CONGESTION

#ifdef STBOX1_ENABLE_PRINTF
#define STBOX1_PRINTF(...) printf(__VA_ARGS__)
#else /* STBOX1_ENABLE_PRINTF */
#define STBOX1_PRINTF(...)
#endif /* STBOX1_ENABLE_PRINTF */

#endif /* __STBOX1_CONFIG_H */

