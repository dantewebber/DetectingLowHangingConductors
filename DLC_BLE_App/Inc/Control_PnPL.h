/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    Control_PnPL.h
  * @author  System Research & Applications Team - Agrate/Catania Lab.
  * @brief   Control PnPL Component Manager
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file in
  * the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/**
  ******************************************************************************
  * This file has been auto generated from the following DTDL Component:
  * dtmi:appconfig:steval_mkboxpro:FP_SNS_STBOX1_BLESensorPnPL:other:control:control;1
  *
  * Created by: DTDL2PnPL_cGen version 1.1.0
  *
  * WARNING! All changes made to this file will be lost if this is regenerated
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef _PNPL_CONTROL_H_
#define _PNPL_CONTROL_H_

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "parson.h"
#include "IPnPLComponent.h"
#include "IPnPLComponent_vtbl.h"
#include "IControl.h"
#include "IControl_vtbl.h"

/**
  * Create a type name for _Control_PnPL.
 */
typedef struct _Control_PnPL Control_PnPL;

/* Public API declaration ----------------------------------------------------*/

IPnPLComponent_t *Control_PnPLAlloc(void);

/**
  * Initialize the default parameters.
  *
 */
uint8_t Control_PnPLInit(IPnPLComponent_t *_this,  IControl_t *inf);

/**
  * Get the IPnPLComponent interface for the component.
  * @param _this [IN] specifies a pointer to a PnPL component.
  * @return a pointer to the generic object ::IPnPLComponent if success,
  * or NULL if out of memory error occurs.
 */
IPnPLComponent_t *Control_PnPLGetComponentIF(Control_PnPL *_this);

#ifdef __cplusplus
}
#endif

#endif /* _PNPL_CONTROL_H_ */
