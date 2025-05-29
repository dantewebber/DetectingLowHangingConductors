## <b>BLESensorsPnPL Application Description</b>

This firmware package includes Components Device Drivers, Board Support Package and example application for the following STMicroelectronics elements:

  - STEVAL-MKBOXPRO (SensorTile.box-Pro)  evaluation board that contains the following components:
      - MEMS sensor devices: STTS22H, LPS22DF, LSM6DSV16X, LIS2DU12, LIS2MDL
	  - Dynamic NFC tag: ST25DV04K (board rev. A) - ST25DV64KC (board rev .B)
	  - On-board Bluetooth® Low Energy 5.2: BlueNRG-LP
      - Digital Microphone: MP23db01HP
 
The Example application provides one example on how send the board sensors values to the ST BLE sensor application using Bluetooth customizing the Demos using PnP-L message.
The application provided also firwmare over the air update allowing also to change the Firwmare running on the board

### <b>Keywords</b>

NFC, SPI, I2C, UART, MEMS, BLE, BLE_Manager, BlueNRGLP

### <b>Hardware and Software environment</b>

- This example runs on STEVAL-MKBOXPRO (SensorTile.box-Pro) evaluation board and it can be easily tailored to any other supported device and development board.
- This example must be used with the related ST BLE Sensor Android/iOS application (Version 5.0.0 or higher) available on the Google Play or Apple App Store, in order to read the sent information by Bluetooth Low Energy protocol

ADDITIONAL_COMP : STTS22H https://www.st.com/en/mems-and-sensors/stts22h.html

ADDITIONAL_COMP : LPS22DF https://www.st.com/en/mems-and-sensors/lps22df.html

ADDITIONAL_COMP : LSM6DSV16X https://www.st.com/en/mems-and-sensors/lsm6dsv16x.html

ADDITIONAL_COMP : LIS2DU12 https://www.st.com/en/mems-and-sensors/lis2du12.html

ADDITIONAL_COMP : LIS2MDL https://www.st.com/content/st_com/en/products/mems-and-sensors/e-compasses/lis2mdl.html

ADDITIONAL_COMP : MP23DB01HP https://www.st.com/en/mems-and-sensors/mp23db01hp.html

ADDITIONAL_COMP : ST25DV04K https://www.st.com/en/nfc/st25dv04k.html

ADDITIONAL_COMP : ST25DV64KC https://www.st.com/en/nfc/st25dv64kc.html

ADDITIONAL_COMP : BlueNRG-LP https://www.st.com/en/wireless-connectivity/bluenrg-lp.html

### <b>Dependencies</b>

STM32Cube packages:

  - STM32U5xx drivers from STM32CubeU5 V1.5.0
  
X-CUBE packages:

  - X-CUBE-BLEMGR V3.1.0
  - X-CUBE-MEMS1 V10.0.0
  - X-CUBE-NFC4 V3.0.0
  - X-CUBE-NFC7 V1.0.1
  
STEVAL-MKSBOX1V1:

  - STEVAL-MKBOXPRO V1.2.0
	
### <b>How to use it?</b>

This package contains projects for 3 IDEs viz- IAR, Keil µVision 5 and Integrated Development Environment for STM32.
In order to make the  program work, you must do the following:

 - WARNING: before opening the project with any toolchain be sure your folder
   installation path is not too in-depth since the toolchain may report errors
   after building.

For IAR:

 - Open IAR toolchain (this firmware has been successfully tested with Embedded Workbench V9.20.1).
 - Open the IAR project file on EWARM directory
 - Rebuild all files and Flash the binary on STEVAL-MKBOXPRO

For Keil µVision 5:

 - Open Keil µVision 5 toolchain (this firmware has been successfully tested with MDK-ARM Professional Version: 5.38.0).
 - Open the µVision project file on MDK-ARM directory
 - Rebuild all files and Flash the binary on STEVAL-MKBOXPRO
		
For Integrated Development Environment for STM32:

 - Open STM32CubeIDE (this firmware has been successfully tested with Version 1.15.1)
 - Set the default workspace proposed by the IDE (please be sure that there are not spaces in the workspace path).
 - Press "File" -> "Import" -> "Existing Projects into Workspace"; press "Browse" in the "Select root directory" and choose the path where the STM32CubeIDE project is located (it should be STM32CubeIDE\).
 - Rebuild all files and and Flash the binary on STEVAL-MKBOXPRO
   
### <b>Author</b>

SRA Application Team

### <b>License</b>

Copyright (c) 2024 STMicroelectronics.
All rights reserved.

This software is licensed under terms that can be found in the LICENSE file
in the root directory of this software component.
If no LICENSE file comes with this software, it is provided AS-IS.
