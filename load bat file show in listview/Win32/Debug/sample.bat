set fastboot_path="%PROGRAMFILES%\Intel\Phone Flash Tool\fastboot.exe"
%fastboot_path% oem start_partitioning
%fastboot_path% flash /tmp/partition.tbl %cd%\partition.tbl
%fastboot_path% oem partition /tmp/partition.tbl
%fastboot_path% oem backup_config
%fastboot_path% erase system
%fastboot_path% erase cache
%fastboot_path% erase spare
rem %fastboot_path% erase data
%fastboot_path% erase APD
%fastboot_path% oem stop_partitioning
%fastboot_path% flash recovery %cd%\recovery_sign.bin
%fastboot_path% flash fastboot %cd%\droidboot_sign.bin
%fastboot_path% flash splashscreen %cd%\splash_sign.bin
%fastboot_path% flash APD %cd%\APD.img
