# FAT32 USB devices formatter

Restore your USB device to its original state while formatting it as FAT32.

## Why another USB formatter?

Yes, I know that this specific type of software that allows formatting USB devices with FAT32 format is not lacking, but the truth is that I do not intend to offer an alternative to existing programs for this task, much less.

What I intend is to speed up the process of fixing when a device begins to have problems in relation to the loss of its total capacity, i.e.: if our device had the total capacity of 16 GB of memory, our computer will show us that it has any other capacity except that one.

This mostly happens when we use tools to burn ISO files to our USB device and then later, after reintroducing our USB device to our computer, it seems that our USB device "has lost some of its capacity", and here is where the small program that I just developed comes into play, its main task could be said to be to actually clean the partition table of our device and create a new one, and in this way we would restore our device to its original state, and not just format it with FAT32 format, since 99% of the situations in which it seems that our device has lost part of its total capacity, is because our device has an incorrect or damaged partition table.

### Links

I will leave some links related to this problem.

* [Superuser - 16 GB USB flash drive capacity down to 938 MB](https://superuser.com/questions/752874/16-gb-usb-flash-drive-capacity-down-to-938-mb)
* [AskUbuntu - 16GB pen drive showing 2MB space after formatting on windows 7](http://askubuntu.com/questions/586118/16gb-pen-drive-showing-2mb-space-after-formatting-on-windows-7)
* [AskUbuntu - USB's storage capacity reduced to 2 MB from 16 GB](http://askubuntu.com/questions/289971/usbs-storage-capacity-reduced-to-2-mb-from-16-gb)
* [Superuser - How do I fix my USB drive to get its original 8GB size back?](https://superuser.com/questions/382242/how-do-i-fix-my-usb-drive-to-get-its-original-8gb-size-back)
* [Pendrivelinux - Restore Your USB Key to its original state](https://www.pendrivelinux.com/restoring-your-usb-key-partition/)


## How to Install

You can download the script through curl, add the execution bit, and open it. Just execute the following three lines (once opened it will ask for your sudo password)

```
curl https://raw.githubusercontent.com/filisko/fat32-formatter/master/fat32_formatter.sh > fat32_formatter.sh
chmod +x fat32_formatter.sh
./fat32_formatter.sh
```

## How to Use

### Step 1: Choose the USB device that you want to format.

![Step 1](https://github.com/filisko/fat32-formatter/blob/master/images/01.png)

### Step 2: Confirm.

![Step 2](https://github.com/filisko/fat32-formatter/blob/master/images/02.png)

### Step 3: Enter a new label for your USB device.

![Step 3](https://github.com/filisko/fat32-formatter/blob/master/images/03.png)

### Step 4: Wait until the process finishes.

![Step 4](https://github.com/filisko/fat32-formatter/blob/master/images/04.png)
