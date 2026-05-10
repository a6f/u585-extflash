#!/bin/bash

# Would like to use
#   -msingle-pic-base \
#   -mpic-data-is-text-relative \
#   -fpic \
#   -pie \
#
# but that attempts a dynamic link.
# Otherwise PIC doesn't seem to get relocated properly?
# Init_OSPI() loads &Flash by adding 0x10 to R9, which is wrong.
#
# https://stackoverflow.com/questions/75558729/position-independent-code-gcc-versus-armcc reports this too.
#
# For now, just force the load address with:
#   -Wl,--section-start PrgCode=0x20000004

arm-none-eabi-gcc \
  -ffunction-sections \
  -fdata-sections \
  -Os \
  -mcpu=cortex-m33 \
  -mfloat-abi=hard \
  -D FLASH_MEM \
  -D USE_HAL_DRIVER \
  -D STM32U5G9xx \
  -iquote OSPI \
  -I ../STM32U5G9J_DK2_HSPI/HSPI/CMSIS \
  -I ../Keil-STM32U5x9J-DK_OSPI/OSPI/Core/Include \
  OSPI/*.c \
  -r -o hal.o

arm-none-eabi-ar rcs libhal.a hal.o

arm-none-eabi-gcc \
  -ffunction-sections \
  -fdata-sections \
  -Os \
  -mcpu=cortex-m33 \
  -mfloat-abi=hard \
  -D FLASH_MEM \
  -D USE_HAL_DRIVER \
  -D STM32U5G9xx \
  -iquote OSPI \
  -I ../STM32U5G9J_DK2_HSPI/HSPI/CMSIS \
  -I ../Keil-STM32U5x9J-DK_OSPI/OSPI/Core/Include \
  FlashDev.c FlashPrg.c \
  -nostartfiles \
  -Wl,--gc-sections \
  -L . -Wl,--as-needed -l hal \
  -T flash_algo.ld \
  -Wl,--section-start PrgCode=0x20000004 \
  -o mx25lm51245g_stm32u585i_iot02a.flm
