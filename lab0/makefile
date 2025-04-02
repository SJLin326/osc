# AArch64 交叉編譯工具鏈設定
CC := aarch64-linux-gnu-gcc
LD := aarch64-linux-gnu-ld
OBJCOPY := aarch64-linux-gnu-objcopy

# 編譯參數
# -Wall：啟用所有警告訊息
# -nostdlib：不連結標準 C 函式庫
CFLAGS = -Wall -nostdlib

# 自動尋找目前目錄下所有的組合語言（.S）檔案
SOURCES := $(wildcard *.S)
OBJECTS := $(SOURCES:.S=.o)

# 輸出檔案名稱
TARGET_ELF := kernel8.elf
TARGET := kernel8.img

# 預設建構目標
all: $(TARGET)

# 宣告虛擬目標（這些目標名稱不對應實際檔案）
.PHONY: all clean run debug

# 組譯規則：將組合語言檔案轉為目標檔案（.o）
# $< ：第一個相依檔（來源檔案）
# $@ ：目標檔案（輸出結果）
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# 連結所有目標檔案成為 ELF 可執行檔，使用自訂 linker script
# $^ ：所有相依檔（目標檔案清單）
# $@ ：目標檔案（ELF 可執行檔）
$(TARGET_ELF): $(OBJECTS)
	$(LD) -T linker.ld $^ -o $@

# 將 ELF 可執行檔轉換為適用於 Raspberry Pi bootloader 的純 binary 映像檔
# $< ：輸入檔案（ELF）
# $@ ：輸出檔案（binary 映像檔）
$(TARGET): $(TARGET_ELF)
	$(OBJCOPY) -O binary $< $@

# 使用 QEMU 無視覺介面模式執行，並顯示反組譯指令
run:
	qemu-system-aarch64 -M raspi3b -kernel $(TARGET) -display none -d in_asm

# 啟動 QEMU，並等待 GDB 在 1234 埠口進行遠端除錯
debug:
	qemu-system-aarch64 -M raspi3b -kernel $(TARGET) -display none -S -s

# 清除所有由編譯過程所產生的檔案
clean:
	$(RM) $(TARGET) $(TARGET_ELF) $(OBJECTS)
