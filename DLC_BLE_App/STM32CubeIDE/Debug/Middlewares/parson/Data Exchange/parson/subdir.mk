################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/Third_Party/parson/parson.c 

OBJS += \
./Middlewares/parson/Data\ Exchange/parson/parson.o 

C_DEPS += \
./Middlewares/parson/Data\ Exchange/parson/parson.d 


# Each subdirectory must supply rules for building sources it contributes
Middlewares/parson/Data\ Exchange/parson/parson.o: C:/Users/dante/OneDrive/Documents/UCT/EEE4022F/ST\ Sensor/examples/Middlewares/Third_Party/parson/parson.c Middlewares/parson/Data\ Exchange/parson/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../../Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc -I../../../../../../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../../../../../../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../../../../../../Drivers/CMSIS/Include -I../../../../../../Drivers/BSP/Components/Common -I../../../../../../Drivers/BSP/SensorTileBoxPro -I../../../../../../Drivers/BSP/Components/stc3115 -I../../../../../../Middlewares/ST/PnPLCompManager/Inc -I../../../../../../Middlewares/ST/STM32_BLE_Manager/Inc -I../../../../../../Middlewares/Third_Party/parson -I../../../../../../Middlewares/ST/BlueNRG-LP/hci/hci_tl_patterns/Basic -I../../../../../../Middlewares/ST/BlueNRG-LP/includes -I../../../../../../Middlewares/ST/BlueNRG-LP/utils -I../../../../../../Drivers/BSP/Components/lis2mdl -I../../../../../../Drivers/BSP/Components/lps22df -I../../../../../../Drivers/BSP/Components/lis2du12 -I../../../../../../Drivers/BSP/Components/stts22h -I../../../../../../Drivers/BSP/Components/lsm6dsv16x -I../../../../../../Drivers/BSP/Components/st25dvxxkc -I../../../../../../Drivers/BSP/Components/ST25DV -O0 -ffunction-sections -fdata-sections -Wall -Wno-format -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"Middlewares/parson/Data Exchange/parson/parson.d" -MT"$@" --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=softfp -mthumb -o "$@"

clean: clean-Middlewares-2f-parson-2f-Data-20-Exchange-2f-parson

clean-Middlewares-2f-parson-2f-Data-20-Exchange-2f-parson:
	-$(RM) ./Middlewares/parson/Data\ Exchange/parson/parson.cyclo ./Middlewares/parson/Data\ Exchange/parson/parson.d ./Middlewares/parson/Data\ Exchange/parson/parson.o ./Middlewares/parson/Data\ Exchange/parson/parson.su

.PHONY: clean-Middlewares-2f-parson-2f-Data-20-Exchange-2f-parson

