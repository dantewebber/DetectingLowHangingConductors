################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/ST/PnPLCompManager/Src/IPnPLComponent.c \
C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/ST/PnPLCompManager/Src/PnPLCompManager.c 

OBJS += \
./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.o \
./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.o 

C_DEPS += \
./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.d \
./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.o: C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/ST/PnPLCompManager/Src/IPnPLComponent.c Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../../../../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../../../../../Drivers/CMSIS/Include -I../../../../../../Drivers/BSP/Components/Common -I../../../../../../Drivers/BSP/SensorTileBoxPro -I../../../../../../Drivers/BSP/Components/stc3115 -I../../../../../../Middlewares/ST/PnPLCompManager/Inc -I../../../../../../Middlewares/ST/STM32_BLE_Manager/Inc -I../../../../../../Middlewares/Third_Party/parson -I../../../../../../Middlewares/ST/BlueNRG-LP/hci/hci_tl_patterns/Basic -I../../../../../../Middlewares/ST/BlueNRG-LP/includes -I../../../../../../Middlewares/ST/BlueNRG-LP/utils -I../../../../../../Drivers/BSP/Components/lis2mdl -I../../../../../../Drivers/BSP/Components/lps22df -I../../../../../../Drivers/BSP/Components/lis2du12 -I../../../../../../Drivers/BSP/Components/stts22h -I../../../../../../Drivers/BSP/Components/lsm6dsv16x -I../../../../../../Drivers/BSP/Components/st25dvxxkc -I../../../../../../Drivers/BSP/Components/ST25DV -O0 -ffunction-sections -fdata-sections -Wall -Wno-format -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -mthumb -o "$@"
Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.o: C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/ST/PnPLCompManager/Src/PnPLCompManager.c Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../../../../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../../../../../Drivers/CMSIS/Include -I../../../../../../Drivers/BSP/Components/Common -I../../../../../../Drivers/BSP/SensorTileBoxPro -I../../../../../../Drivers/BSP/Components/stc3115 -I../../../../../../Middlewares/ST/PnPLCompManager/Inc -I../../../../../../Middlewares/ST/STM32_BLE_Manager/Inc -I../../../../../../Middlewares/Third_Party/parson -I../../../../../../Middlewares/ST/BlueNRG-LP/hci/hci_tl_patterns/Basic -I../../../../../../Middlewares/ST/BlueNRG-LP/includes -I../../../../../../Middlewares/ST/BlueNRG-LP/utils -I../../../../../../Drivers/BSP/Components/lis2mdl -I../../../../../../Drivers/BSP/Components/lps22df -I../../../../../../Drivers/BSP/Components/lis2du12 -I../../../../../../Drivers/BSP/Components/stts22h -I../../../../../../Drivers/BSP/Components/lsm6dsv16x -I../../../../../../Drivers/BSP/Components/st25dvxxkc -I../../../../../../Drivers/BSP/Components/ST25DV -O0 -ffunction-sections -fdata-sections -Wall -Wno-format -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -mthumb -o "$@"

clean: clean-Middlewares-2f-PnPLCompManager-2f-Middlewares-2f-PnPLCompManager

clean-Middlewares-2f-PnPLCompManager-2f-Middlewares-2f-PnPLCompManager:
	-$(RM) ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.cyclo ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.d ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.o ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/IPnPLComponent.su ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.cyclo ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.d ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.o ./Middlewares/PnPLCompManager/Middlewares/PnPLCompManager/PnPLCompManager.su

.PHONY: clean-Middlewares-2f-PnPLCompManager-2f-Middlewares-2f-PnPLCompManager

