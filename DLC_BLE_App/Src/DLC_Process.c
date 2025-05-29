/* Detecting Low Hanging Conductor Process */
/* Author: Dante Webber */

#include "DLC_Process.h"
#include "BLE_Broadcaster.h"
#include "app_blesensorspnpl.h"
#include "steval_mkboxpro.h"
#include "STBOX1_config.h"
#include <math.h>

extern volatile uint32_t hci_event;
uint8_t TIM2_StartFlag;
uint8_t TIM2_StartFlag;
uint8_t pressureMeasFlag;
static float pressureAverageBuffer[MOVING_AVERAGE_WINDOW_SIZE] = {0};
static float pressureMedianBuffer[MOVING_MEDIAN_WINDOW_SIZE] = {0};
static float sortedPressureMedianBuffer[MOVING_MEDIAN_WINDOW_SIZE] = {0};
static uint8_t averageBufferIndex = 0; // Current index of the moving average buffer
static uint8_t medianBufferIndex = 0; // Current index of moving median buffer
static float runningSum = 0; // Current sum of the moving average buffer values
static float initMovingAverage = 0; // Initial moving average value
static uint8_t pressure_buffer_count = 1;
static uint8_t currentAltDetectionLed = LED_BLUE;

void insertionSort(float arr[], int n);
static void timersInit(void);

/* Initialise BLE_Broadcaster */
void DLC_Init(void) {
    advStartFlag = TRUE;
    timersInit();
    TIM2_StartFlag = TRUE;
    bleScanStartFlag = TRUE;
}

/* Handles DLC pressure measurements and BLE communication */
void DLC_mainProcess(void) {
    hci_event=0;
    hci_user_evt_proc();

    #if PERIODIC_ADV
    if (advStartFlag) {
        if (TIM2_StartFlag) {
            uint32_t uhCapture = __HAL_TIM_GET_COUNTER(&TIM_CC_HANDLE);
            /* Start the TIM Base generation in interrupt mode */
            if(HAL_TIM_OC_Start_IT(&TIM_CC_HANDLE, TIM_CHANNEL_1) != HAL_OK){
                /* Starting Error */
                STBOX1_Error_Handler(STBOX1_ERROR_TIMER,__FILE__,__LINE__);
            }
            /* Set the Capture Compare Register value */
            __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_1, (uhCapture + 10000));
            TIM2_StartFlag = FALSE;
        }

        startAdvertising();
        advStartFlag = FALSE;
        advState = TRUE;
        BSP_LED_On(LED_GREEN);
    }

    if (advStopFlag) {
        stopAdvertising();
        advStopFlag = FALSE;
        advState = FALSE;
        BSP_LED_Off(LED_GREEN);
    }
    #endif

    #if ENABLE_SCAN
    if (bleScanStartFlag) {
        uint8_t scanStartSuccess;
        scanStartSuccess = StartBLEScan();
        if (scanStartSuccess) {
            bleScanStartFlag = FALSE;
        } else {
            HAL_Delay(1000);
        }
    }
    #endif

    #if ENABLE_PRESSURE_MEASUREMENT
    if (pressureMeasFlag) {
        if (TIM2_Start_Flag){
            TIM2_StartFlag = FALSE;
            uint32_t uhCapture = __HAL_TIM_GET_COUNTER(&TIM_CC_HANDLE);
            /* Start the TIM Base generation in interrupt mode */
            if(HAL_TIM_OC_Start_IT(&TIM_CC_HANDLE, TIM_CHANNEL_2) != HAL_OK){
                /* Starting Error */
                STBOX1_Error_Handler(STBOX1_ERROR_TIMER,__FILE__,__LINE__);
            }
            /* Set the Capture Compare Register value */
            switch(PRESSURE_SAMPLE_RATE) {
            case 1:
                __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_2, (uhCapture + 10000));
                break;
            case 10:
                __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_2, (uhCapture + 1000));
                break;
            case 20:
                __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_2, (uhCapture + 500));
                break;
            }
        }

        pressureMeasFlag = FALSE;

        /* Call Functions to take pressure and temperature measurement */
        float Temp,Pressure;
        BSP_ENV_SENSOR_GetValue(STTS22H_0, ENV_TEMPERATURE, &Temp);
        BSP_ENV_SENSOR_GetValue(LPS22DF_0, ENV_PRESSURE, &Pressure);

        int32_t pressureValue = (int32_t)(Pressure * 100) - 1000*100;
        STBOX1_PRINTF("Pressure = %i\n", pressureValue);

        Place the pressure value into bytes [18:21] of manuf_data
        manuf_data[18] = 0xFF;
        manuf_data[19] = 0xFF;
        manuf_data[20] = (uint8_t)((pressureValue >> 8) & 0xFF);
        manuf_data[21] = (uint8_t)(pressureValue & 0xFF);         // Least significant byte

        updateAdvData();

        if (pressure_buffer_count == 9) {
            manuf_data[18 + pressure_buffer_count - 1] = (uint8_t)((pressureValue >> 8) & 0xFF);
            manuf_data[18 + pressure_buffer_count] = (uint8_t)(pressureValue & 0xFF);         // Least significant byte
            updateAdvData();
            pressure_buffer_count = 1;
        } else {
            manuf_data[18 + pressure_buffer_count - 1] = (uint8_t)((pressureValue >> 8) & 0xFF);
            manuf_data[18 + pressure_buffer_count] = (uint8_t)(pressureValue & 0xFF);         // Least significant byte
            pressure_buffer_count = pressure_buffer_count + 2;
        }

        /* RUNNING SUM CALCULATION */
        if (pressureAverageBuffer[averageBufferIndex] == 0) {
            runningSum += Pressure;
            initMovingAverage = 0;
        } else {
            runningSum -= pressureAverageBuffer[averageBufferIndex]; // Subtract the oldest value from the sum
            runningSum += Pressure; // Add the new value to the sum
        }

        float movingAverage = runningSum / MOVING_AVERAGE_WINDOW_SIZE; // Calculate the moving average

        /* Store the new value in the buffers */
        pressureAverageBuffer[averageBufferIndex] = Pressure;
        pressureMedianBuffer[medianBufferIndex] = movingAverage;
        /* Update the indices in a circular manner */
        averageBufferIndex = (averageBufferIndex + 1) % MOVING_AVERAGE_WINDOW_SIZE;
        medianBufferIndex = (medianBufferIndex + 1) % MOVING_MEDIAN_WINDOW_SIZE;
        
        for (int i = 0; i<MOVING_MEDIAN_WINDOW_SIZE; i++) {
            sortedPressureMedianBuffer[i] = pressureMedianBuffer[i];
        }

        insertionSort(sortedPressureMedianBuffer);
        float filteredPressureVal = ( sortedPressureMedianBuffer[MOVING_MEDIAN_WINDOW_SIZE/2 - 1] + sortedPressureMedianBuffer[MOVING_MEDIAN_WINDOW_SIZE/2] ) / 2 ;
        
        /* Hypsometric formula */
        float sensorVertDisplacement = ( 287.05*(273.15 + Temp)/9.81 ) * log(filteredPressureVal/relativePressure);
        // STBOX1_PRINTF("Current moving average:  \r\n");
        // STBOX1_PRINTF("%.2f\r\n", movingAverage);
        // manuf_data[BLE_MANAGER_CUSTOM_FIELD3]=0xFF;

        if (sensorVertDisplacement > 0.5) {
            // Fault has occurred
            manuf_data[BLE_MANAGER_CUSTOM_FIELD4]=0x00;
            STBOX1_PRINTF("Fault detected: Vertical displacement exceeds threshold\r\n");
            currentAltDetectionLed = LED_RED; // Set the current alt detection led to LED_RED
        } else if (sensorVertDisplacement < -0.5) {
            // Fault has occurred (In real application, this condition should not be here, because it would mean the sensor has moved up)
            manuf_data[BLE_MANAGER_CUSTOM_FIELD4]=0x00;
            STBOX1_PRINTF("Fault detected: Vertical displacement exceeds threshold\r\n");
            currentAltDetectionLed = LED_RED; // Set the current alt detection led to LED_RED
        } else {
            // No fault detected
            manuf_data[BLE_MANAGER_CUSTOM_FIELD4]=0x00;
            currentAltDetectionLed = LED_BLUE; // Set the current alt detection led to LED_BLUE
        }
        
        // if (initMovingAverage == 0) {
        //     initMovingAverage = filteredPressureVal; // Store the initial moving average value
        //     // STBOX1_PRINTF("Initial moving average:  \r\n");
        //     // STBOX1_PRINTF("%.2f\r\n", initMovingAverage);
        // } else {
        // // STBOX1_PRINTF("Initial moving average:  \r\n");
        // // STBOX1_PRINTF("%.2f\r\n", initMovingAverage);
        // // Compare the current moving average with the initial value
        //     if (filteredPressureVal > (initMovingAverage + 0.05)) {
        //         // Fault has occurred
        //         manuf_data[BLE_MANAGER_CUSTOM_FIELD4]=0x00;
        //         STBOX1_PRINTF("Fault detected: moving average is too high\r\n");
        //         currentAltDetectionLed = LED_RED; // Set the current alt detection led to LED_RED
        //     } else if (filteredPressureVal < (initMovingAverage - 0.05)) {
        //         // Fault has occurred (In real application, this condition should not be here, because it would mean the sensor has moved up)
        //         manuf_data[BLE_MANAGER_CUSTOM_FIELD4]=0x00;
        //         STBOX1_PRINTF("Fault detected: moving average is too low\r\n");
        //         currentAltDetectionLed = LED_RED; // Set the current alt detection led to LED_RED
        //     } else {
        //         // No fault detected
        //         manuf_data[BLE_MANAGER_CUSTOM_FIELD4]=0x00;
        //         currentAltDetectionLed = LED_BLUE; // Set the current alt detection led to LED_BLUE
        //     }
        // }

        /* Broadcast filtered pressure value */
        manuf_data[18] = (uint8_t)((filteredPressureVal >> 8) & 0xFF);
        manuf_data[19] = (uint8_t)(filteredPressureVal & 0xFF);         // Least significant byte
        updateAdvData();
    }
    #endif

}

static void timersInit(void) {
    uint32_t uwPrescalerValue;

    /* Timer Output Compare Configuration Structure declaration */
    TIM_OC_InitTypeDef sConfig;

    /* Compute the prescaler value to counter clock equal to 10000 Hz */
    uwPrescalerValue = (uint32_t) ((SystemCoreClock / 10000) - 1);

    /* Set TIM1 instance */
    TIM_CC_HANDLE.Instance = TIM_CC_INSTANCE;
    TIM_CC_HANDLE.Init.Period        = 65535;
    TIM_CC_HANDLE.Init.Prescaler     = uwPrescalerValue;
    TIM_CC_HANDLE.Init.ClockDivision = 0;
    TIM_CC_HANDLE.Init.CounterMode   = TIM_COUNTERMODE_UP;

    if(HAL_TIM_OC_DeInit(&TIM_CC_HANDLE) != HAL_OK) {
    /* Initialization Error */
    STBOX1_Error_Handler(STBOX1_ERROR_HW_INIT,__FILE__,__LINE__);
    }

    if(HAL_TIM_OC_Init(&TIM_CC_HANDLE) != HAL_OK) {
    /* Initialization Error */
    STBOX1_Error_Handler(STBOX1_ERROR_HW_INIT,__FILE__,__LINE__);
    }

    /* Configure the Output Compare channels */

    /* Common configuration for all channels */
    sConfig.OCMode     = TIM_OCMODE_TOGGLE;
    sConfig.OCPolarity = TIM_OCPOLARITY_LOW;

    /* Conf TIM1 to hande communication timing */
    sConfig.Pulse = 10000;
    if(HAL_TIM_OC_ConfigChannel(&TIM_CC_HANDLE, &sConfig, TIM_CHANNEL_1) != HAL_OK) {
    /* Configuration Error */
    STBOX1_Error_Handler(STBOX1_ERROR_HW_INIT,__FILE__,__LINE__);
    }

}

void HAL_TIM_OC_DelayElapsedCallback(TIM_HandleTypeDef *htim)
{
  uint32_t uhCapture=0;
  /* TIM1_CH1 toggling*/
  if(htim->Channel == HAL_TIM_ACTIVE_CHANNEL_1) {
    uhCapture = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_1);
    /* Set the Capture Compare Register value */
    __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_1, (uhCapture + 10000));
    if (advState) {
        advStopFlag = TRUE;
    } else {
        advStartFlag = TRUE;
    }
  }

  /* TIM1_CH2 toggling */
    if(htim->Channel == HAL_TIM_ACTIVE_CHANNEL_2) {
        uhCapture = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_2);
        /* Set the Capture Compare Register value */
        switch(PRESSURE_SAMPLE_RATE) {
        case 1:
            __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_2, (uhCapture + 10000));
            break;
        case 10:
            __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_2, (uhCapture + 1000));
            break;
        case 20:
            __HAL_TIM_SET_COMPARE(&TIM_CC_HANDLE, TIM_CHANNEL_2, (uhCapture + 500));
            break;
        }
        pressureMeasFlag=1;
    }
}

/* Basic insertion sort algorithm for median calculation */
void insertionSort(float arr[], int n)
{
    for (int i = 1; i < n; ++i) {
        float key = arr[i];
        int j = i - 1;

        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}