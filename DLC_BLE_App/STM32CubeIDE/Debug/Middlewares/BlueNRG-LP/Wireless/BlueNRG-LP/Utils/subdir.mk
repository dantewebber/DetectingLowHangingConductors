################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/ST/BlueNRG-LP/utils/ble_list.c 

OBJS += \
./Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.o 

C_DEPS += \
./Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.o: C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/ST/BlueNRG-LP/utils/ble_list.c Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../../../../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../../../../../Drivers/CMSIS/Include -I../../../../../../Drivers/BSP/Components/Common -I../../../../../../Drivers/BSP/SensorTileBoxPro -I../../../../../../Drivers/BSP/Components/stc3115 -I../../../../../../Middlewares/ST/PnPLCompManager/Inc -I../../../../../../Middlewares/ST/STM32_BLE_Manager/Inc -I../../../../../../Middlewares/Third_Party/parson -I../../../../../../Middlewares/ST/BlueNRG-LP/hci/hci_tl_patterns/Basic -I../../../../../../Middlewares/ST/BlueNRG-LP/includes -I../../../../../../Middlewares/ST/BlueNRG-LP/utils -I../../../../../../Drivers/BSP/Components/lis2mdl -I../../../../../../Drivers/BSP/Components/lps22df -I../../../../../../Drivers/BSP/Components/lis2du12 -I../../../../../../Drivers/BSP/Components/stts22h -I../../../../../../Drivers/BSP/Components/lsm6dsv16x -I../../../../../../Drivers/BSP/Components/st25dvxxkc -I../../../../../../Drivers/BSP/Components/ST25DV -O0 -ffunction-sections -fdata-sections -Wall -Wno-format -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -mthumb -o "$@"

clean: clean-Middlewares-2f-BlueNRG-2d-LP-2f-Wireless-2f-BlueNRG-2d-LP-2f-Utils

clean-Middlewares-2f-BlueNRG-2d-LP-2f-Wireless-2f-BlueNRG-2d-LP-2f-Utils:
	-$(RM) ./Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.cyclo ./Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.d ./Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.o ./Middlewares/BlueNRG-LP/Wireless/BlueNRG-LP/Utils/ble_list.su

.PHONY: clean-Middlewares-2f-BlueNRG-2d-LP-2f-Wireless-2f-BlueNRG-2d-LP-2f-Utils

