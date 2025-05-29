/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file
  * @author  MCD Application Team
  * @version V2.0.0
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
#ifndef  __RTE_COMPONENTS_H__
#define  __RTE_COMPONENTS_H__

/* Defines ------------------------------------------------------------------*/
/* STMicroelectronics.FP-SNS-STBOX1.2.0.0 */
#define USE_MKBOXPRO 1
#define BLESENSORS_PNPL_MKBOXPRO
/* STMicroelectronics.X-CUBE-BLEMGR.3.1.0 */
#define USE_PARSON
#define HCI_TL
#define HCI_TL_INTERFACE
#define BLE_MANAGER_BATTERY
#define BLE_MANAGER_ENVIRONMENTAL
#define BLE_MANAGER_INERTIAL
#define BLE_MANAGER_PNP_LIKE
#define BLUENRG_LP
/* STMicroelectronics.X-CUBE-MEMS1.10.0.0 */
#define STTS22H_TEMP_I2C
#define LIS2DU12_ACC_I2C
#define LIS2MDL_MAG_I2C
#define LPS22DF_PRESSTEMP_I2C
#define LSM6DSV16X_ACCGYRQVAR_I2C
/* STMicroelectronics.X-CUBE-NFC4.3.0.0 */
#define ST25DV_NFC4_I2C
/* STMicroelectronics.X-CUBE-NFC7.1.0.1 */
#define ST25DVXXKC_NFC7_I2C

#endif /* __RTE_COMPONENTS_H__ */
