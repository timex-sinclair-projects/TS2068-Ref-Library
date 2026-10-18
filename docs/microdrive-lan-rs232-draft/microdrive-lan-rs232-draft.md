<!-- PDF page 1 (printed page none) -->

# DRAFT MICRODRIVE, LAN and RS232 SOFTWARE DOCUMENTATION

M.J.BRENNAN
20/4/83

> *Transcriber's note:* Typed on a dot-matrix printer whose lower-case "m" prints as a squat block glyph; it is transcribed as "m" throughout. The rows of asterisks typed under headings are underlines and are not reproduced. The tables have no column headings in the original; the blank header rows are a markdown requirement.

## MICRODRIVE

The microdrive records data on two tracks of an endless loop of video quality tape. The tape is ~~1/16[?]~~ [handwritten: .073] inch width and 200 inches long. The tape travels at a nominal speed of 30 inches per second with a variation of +/- 10%.

> *Transcriber's note:* A hand-drawn line strikes out the typed width and runs up under "two tracks of an endless" to the handwritten ".073" in the right margin.

The data is recorded on the tape at a density of 100,000 bits per second per track. This gives the capsule an unformatted capacity of 162K. The recording format is FM. There is one flux transition every bit cell (10uS) and one in the middle of the cell if the bit is a one.

Because of the splice certain regions of the tape cannot be used. There is no harware means of determining the position of the tape in the loop.

The record/replay head has a built in erase gap which erases both tracks; the erase gap leads the replay gap by 1.6mm.

The data on the two tracks is seen as one stream of bytes because the controller chip records succesive bytes on alternate tracks.

Each microdrive contains electronics to select the microdrive, provide the write and erase currents,amplify, filter and square the output from the head. The motor is turned-on only when a microdrive is selected, only one microdrive may be selected at a time.

The interface contains logic to modulate/demodulate serialize/deserialize the data from the microdrive. It also contains the microdrive, LAN, and RS232 software in an 8K ROM.

Data is recorded in sectors. Each sector contains 512 data bytes plus other file handling information. A sector has the following structure:-

| | | | |
|---|---|---|---|
| Header block | contains | 10 byte capsule name<br>sector number<br>checksum | 1.12mS |
| Gap 1 | | | 3.2mS |
| Data block | contains | 10 byte filename<br>record number<br>byte count<br>flag byte<br>checksum<br>512 bytes of data<br>data checksum | 21.2mS |
| Gap 2 | | | 6.1mS |
| | | | ------ |
| TOTAL | | | 31.62mS |

This gives a nominal content of 210 sectors with an upper limit of 230 sectors per capsule.

Not all the sectors are good for recording: the good sectors are identified during FORMATing.

The capsule has a write protect tab like a music or video cassette this is not a hardware write protect but it is detected by the software.

## FILE HANDLING SYSTEM

<!-- PDF page 2 (printed page none) -->

Microdrive files are recorded in blocks of 512 bytes called records. The records are recorded into the first encountered free sector on the tape and the sector is marked "not free" in the MAP.

The data in a record is accompanied by the record number, byte count,filename and a flag.

The byte count is usually 512 but may be less if it is the last record in a file: in which case a bit is set in the flag byte.

There are two types of file used by BASIC. One type is used by PRINT, INPUT and MOVE and would normally be readable, the other type is used by SAVE, LOAD, VERIFY and MERGE and would not normally be readable. These are distinguished by a bit in the flag byte.

When a file is opened in BASIC there is no way of specifying whether the file is opened for input or output so the tape is searched until either a record of the file is found, in which case the file is opened for input or if no record is found the file is opened for output.

The file handling system does not use a directory for two reasons:-

1) The space consumed by a directory
2) You still have to read the sectors sequentially
   to find a record.

The are a number of drawbacks with this approach:-

1) If a file is opened for writing, the entire tape
   must be searched to ensure that the file doesn't
   already exist and to make a MAP of the free sectors
2) When doing a catalogue of a capsules contents
   or opening a file it is possible that a file isn't
   read properly first time. If this is the only record
   in a given file then it will be ommitted from the
   catalogue or worse it will be opened for write rather
   than read. This situation is increasingly unlikely
   if the file consists of more than one record.

This file handling system is adequate for the sequential nature of the existing BASIC INPUT/PRINT commands and for the sequential nature of the medium. It is likely to prove inadequate for applications requiring random access.

It is intended that these applications (assumed to be machine code) will use procedures from the ROM to overcome the drawbacks of the software as viewed from BASIC. Any higher level file handling would still be compatible with the BASIC system.

The following data items are used by the microdrive software:-

## MICRODRIVE BUFFER

Every time a file is opened an area called a CHANNEL is created in the area designated CHANS in the BASIC reference manual. This area is usually addressed by the IX register in the software. The channel has a length of 595 bytes.

The contents of the CHANNEL are as follows:-

| | | |
|---|---|---|
| 0 | | address 8 |
| 2 | | address 8 |
| 4 | | 'M' |
| 5 | | address of output subroutine in ROM |
| 7 | | address of input routine in ROM |

<!-- PDF page 3 (printed page none) -->

| | | |
|---|---|---|
| 9 | | address 595 |
| 11 | CHBYTE | current byte counter indicates the next byte<br>to be added or removed from the data area<br>in the range 0-512 inclusive. |
| 13 | CHREC | record number. indicates the position of the<br>record in a file range 0-255 |
| 14 | CHNAME | 10 byte filename with trailing spaces |
| 24 | CHFLAG | flag byte bit 0 set...open for write<br>clear.open for read<br>bits 1-7....unused |
| 25 | CHDRIV | drive number 1-8 |
| 26 | CHMAP | address of the MAP for this microdrive |
| 28 | | 12 bytes of header preamble....marks the<br>start of the header workspace |
| 40 | HDFLAG | flag byte bit 0 set<br>bits 1-7....unused |
| 41 | HDNUMB | sector number in range 0-255 |
| 42 | | unused |
| 44 | HDNAME | capsule name and trailing spaces |
| 54 | HDCHK | header checksum |
| 55 | | 12 bytes of data block preamble...marks<br>the start of the data workspace |
| 67 | RECFLG | flag byte bit 0=0<br>bit 1=last record in file<br>bit 2=not a PRINT file<br>bits 3-7 unused |
| 68 | RECNUM | number of this record in the range 0-255 |
| 69 | RECLEN | number of bytes of data in this record 0-512 |
| 71 | RECNAM | filename with trailing spaces |
| 81 | DESCHK | checksum of the preceding 14 bytes |
| 82 | CHDATA | 512 bytes of data |
| 594 | DCHK | checksum of the preceding 512 bytes |

When a record is written to the tape the area from RECFLG to DCHK is recorded in a data block. This data is retrieved when the record is read.

## MAP

For every microdrive containing an opened file there is an area called a MAP created in the area called "microdrive maps" in the BASIC reference manual. This area now starts at address 23791. A MAP contains 32 bytes. Each bit corresponds to a sector on the corresponding microdrive. If that sector contains data or if it is unuseable then the bit is set. The bits are numbered as follows: bit 0 byte 0 = sector 0, bit 1 byte 0 = sector 1, bit 0 byte 1 = sector 8 and so on.

## THE NETWORK

The network allows for the linking of 2-64 SPECTRUM computers. The linkage between computers is a two wire system..signal wire and ground wire.

Each SPECTRUM constitutes a station and by using the FORMAT "n";x command it is possible to assign the required station number (x) to a given computer. The range of station numbers is 1-64

Data is transmitted and received on the network in packets. The transmit process is as follows:-

1) Wait for the network to be free for between 2-3mS ?????

<!-- PDF page 4 (printed page none) -->

2) Try to claim the network by sending a "scout" signal.
   Check that there is no contention. Repeat from 1) if
   there is a collision.

3) Send out a "header" comprising 8 bytes of data (a copy of
   bytes 11-18 in the network channel area).

4) Wait for an acknowlegement. Repeat from 1) if nothing found
   within 1mS ??????

5) Send out the data block comprising 1-255 bytes of data
   (a copy of the data buffer)

6) Wait for an acknowledgement. Repeat from 1) if nothing is found
   within 1mS ??????

The receive process is as follows:-

1) Wait for the network to be free for at least 2mS.

2) Wait for the network to become active ("scout").

3) Collect the "header" block compute the checksum
   and acknowledge if it is correct. Repeat from 1) if not.
   It is correct if it has the correct source and destination
   station numbers and has the correct sequence number.

4) Collect the data block compute the checksum and acknowledge
   if correct. Repeat from 1) if not.

Messages may be BROADCAST to more than one station. The protocol is as above but no acknowledgments are required. The receiver must be expecting a broadcast.

A "scout" and "header" pair take about 1.6mS and are repeated about once every 8mS if not acknowledged.

A "scout","header" and data block containing 255 bytes take about 37mS.

Stations wait a random interval after the network has become free before transmitting packets. This scheme avoids time consuming collisions.

## NETWORK CHANNEL

When a stream is opened to the network a channel is created in the area designated CHANS in the BASIC reference manual. This area is usually addressed by the IX register in the software. The channel has a length of 276 bytes

The contents of the channel are described as follows:-

| | | |
|---|---|---|
| 0 | | address 8 |
| 2 | | address 8 |
| 4 | | "N" |
| 5 | | address of output subroutine in ROM |
| 7 | | address of input subroutine in ROM |
| 9 | | address 276 |
| 11 | NCIRIS | the destination station number |
| 12 | NCSELF | this SPECTRUMs station number |
| 13 | NCNUMB | the block number |
| 15 | NCTYPE | the packet type code...0 data, 1 EOF. |
| 16 | NCOBL | number of bytes in the data block |

<!-- PDF page 5 (printed page none) -->

| | | |
|---|---|---|
| 17 | NCDCS | the data checksum |
| 18 | NCHCS | the header checksum |
| 19 | NCBL | the position of the last character taken from the buffer |
| 20 | NCB | the number of bytes in the input buffer |
| 21 | | a 255 byte data buffer. |

Temporary network channels are created and deleted afterwards during SAVE,LOAD,VERIFY and MERGE commands. They may also be created from machine code.

## SYSTEM VARIABLES

The microdrive, LAN and RS232 software uses more system variables; these are described as follows:-

| | | |
|---|---|---|
| 23734 | FLAGS3 | Flags |
| 23735 | VECTOR | Address used to extend the BASIC interpreter |
| 23737 | SBRT | ROM paging subroutine |
| 23747 | BAUD | Two byte number determining the baud rate<br>calculated as follows:-<br>BAUD=(3500000/(26\*baud rate))-2 |
| 23749 | NTSTAT | Own network station number 1-64 |
| 23750 | IOBORD | Border colour used during I/O |
| 23751 | SER_FL | 2 byte workspace used by RS232 |
| 23753 | SECTOR | 2 byte workspace used by microdrive |
| 23755 | CHADD_ | Temporary store for CH_ADD |
| 23757 | NTRESP | Store for network response code |
| 23758 | NTDEST | Beginning of network buffer<br>contains destination station number 0-64 |
| 23759 | NTSRCE | source station number 1-64 |
| 23760 | NTHUMB | network block number 0-65535 |
| 23762 | NTTYPE | header type code |
| 23763 | NTLEN | data block length 0-255 |
| 23764 | NTDCS | data block checksum |
| 23765 | NTHCS | header block checksum |
| 23766 | D_STR1 | start of 8 byte file specifier<br>2 byte drive number 1-8 |
| 23768 | S_STR1 | stream number 1-15 |
| 23769 | L_STR1 | device type... "M","N","T" or "B" |
| 23770 | N_STR1 | length of filename |
| 23772 | | start of filename |
| 23774 | D_STR2 | second 8 byte file specifier<br>used by MOVE and LOAD commands |
| 23782 | HD_00 | start of workspace for SAVE,LOAD,VERIFY<br>and MERGE.<br>data type code |
| 23783 | HD_0B | length of data 0-65535 |
| 23785 | HD_0D | start of data 0-65535 |
| 23787 | HD_0F | program length 0-65535 |
| 23789 | HD_11 | line number |
| 23791 | COPIES | number of copies of program to be saved by SAVE command |
| 23792 | | Start of microdrive MAPs or CHANS |

> *Transcriber's note:* In the original, "Start of microdrive MAPs or CHANS" begins in the name column, not the description column. The COPIES and 23792 rows are each set off by a blank line.

## PROCEDURES

To make the job of writing application software easier procedures in the new ROM have been made available. These are called with the following two byte call:-

```
        RST     8
```

<!-- PDF page 6 (printed page none) -->

```
        DEFB    N
```

> *Transcriber's note:* The top edge of "DEFB" is clipped by the edge of the scan, but the word is still readable.

where N is the code for a particular procedure.

The procedures, their codes and parameters are described below. All registers are corrupted.

If the procedure cannot complete the request or if it is interupted (if the break key is pressed) it makes an error return. This means that it loads SP from ERR_SP and returns. This allows the caller to handle errors.

The reader should note that the new system variables should be created before they can be set up prior to calling any procedure. This is achieved by calling procedure code 49 first.

Register IY should point into the system variables at 5C3Ah when any of the procedures are called.

### CONSOLE INPUT   code 27

This procedure waits for a character to be typed in on the SPECTRUM keyboard and returns it in the A register. Nothing is printed on the screen.

### CONSOLE OUTPUT  code 28

This procedure prints the character in the A register in the upper part of the screen.

### RS232 INPUT     code 29

This procedure waits for a character received on the RS232 serial interface. The baud rate is specified by BAUD in the system variables the format is 8 data bits, 1 stop bit. No framing error is generated if the stop bit is missing. The byte is returned in register A.

### RS232 OUTPUT    code 30

This procedure outputs the byte in A onto the RS232 serial interface. The baud rate is specified by BAUD in the system variables. The transmission format is 8 data bits, 2 stop bits, no parity.

### ZX PRINTER OUTPUT       code 31

This procedure outputs the byte in A to the ZX printer

### KEYBOARD TEST   code 32

This procedure tests to see if a key has been pressed. The carry flag is set if a character is available.

### SELECT DRIVE    code 33

This procedure selects the drive specified in A, range 1-8, The motor is started in the selected drive and interupts are disabled If A=0 then all drives are de-selected, all the motors are turned off and interupts are enabled.

If no signal is found from the selected drive then all

<!-- PDF page 7 (printed page none) -->

drives are de-selected and an error return is made. This usually happens if the drive doesn't contain a formatted capsule or if the drive is not present.

### OPEN FILE       code 34

This procedure creates a channel in CHANS and a MAP (if necessary) below CHANS pushing up everything in memory up to STKEND.

The file is specified as follows:-
the drive number is stored in D_STR1
the length of the filename is stored in N_STR1
the address of the filename is stored in N_STR1

The drive is then selected and searched for the specified file. If the file exists then the first record is read into the buffer and bit 0 of CHFLAG is cleared (to indicate that it has been opened for read). If the file does not exist the MAP is marked to show the location of all free sectors and bit 0 of CHFLAG is set (to indicate that the file has been opened for write).

Open only works for PRINT/INPUT type files an error return is made if an attempt is made to open a SAVE type file.

If the file exists but the first record cannot be found an error return is made.

As many files may be opened as memory allows. MAPs are

Only one MAP is created per drive and this may shared between many opened files.

A file may be opened for read more than once but may only be opened of write once. An error return is made if an attempt is made to open a file previously opened for write.

The address of the channel is returned in IX.

### CLOSE FILE      code 35

This procedure closes the file whose channel is identified by IX. If the file was opened for read the channel and MAP (if necessary) are deleted and the rest of memory up to STKEND is dropped down.

If the file was opened for write the current record is as the end of file and it is written onto the first free sector of the microdrive. The channel and MAP are deleted as for a read file.

An error return is made if there is no room on the microdrive for the last record.

### DELETE FILE     code 36

This procedure erases a file specified as in OPEN. A channel and MAP (if necessary) are temporarilly created and deleted while this is taking place.

### READ SEQUENTIAL code 37

This procedure reads the next record in the file whose channel is identified by IX. The number in CHREC is incremented.

An error return is made if an attempt is made to read past the end of file or if a record cannot be found.

If an attempt is made to read a record of an SAVE type file the channel is deleted and an error return is made.

<!-- PDF page 8 (printed page none) -->

### WRITE RECORD    code 38

This procedure writes the record in the file whose channel is identified by IX onto the next free sector on the drive.

A free sector is one containing a block which contains fewer than 512 bytes and is not marked end of file.
CHREC is not incremented. An error return is made if there is no free space on the drive.

### READ RANDOM     code 39

This procedure reads the record specified by CHREC in the channel identified by IX.

If an attempt is made to read a record of an SAVE type file the channel is deleted and an error return is made.

### READ SECTOR     code 40

This procedure reads the data block in the sector identified by CHREC into the channel identified by IX.

The carry flag is set if the data is erroneous.
The data in the buffer will be made void if it contains data belonging to a SAVE type file.

The drive should previously be selected. An error return is made if a sector is not found within one revolution.

### READ NEXT       code 41

This procedure reads the data block in the next sector found into the microdrive channel specified by IX. This can be a convenient way of finding where the tape is. The number of the header will be found in the channel at HDNUMB. The carry flag is set if the data is erroneous. The data in the buffer will be made void if it contains data belonging to a SAVE type file.

The drive should previously be selected. An error return is made if a sector cannot be found within one revolution.

### WRITE SECTOR    code 42

This procedure writes the data block in the channel specified by IX into the sector identified by CHREC.

The drive should previously be selected. An error return is made if the drive is write protected or of the sector cannot be found.

The MAP is marked to indicate that the sector is occupied.

### CREATE BUFFER   code 43

This procedure creates a microdrive channel in CHANS and a MAP (if necessary) below CHANS pushing up everything in memory up to STKEND.

The drive and filename are specified as in the OPEN procedure ,code 34. The address of the channel is returned in IX.

### DELETE BUFFER   code 44

This procedure deletes the channel identified by IX

<!-- PDF page 9 (printed page none) -->

### OPEN NETWORK CHANNEL    code 45

This procedure opens a network channel to the station whose number is stored in D_STR1, our current station number should be stored in NTSTAT.

A network area is created in CHANS; everything else in memory up to STKEND is pushed up. The address of the channel is returned in IX.

### CLOSE NETWORK CHANNEL   code 46

This procedure closes the network channel specified by IX. If the buffer contains data yet to be sent (NCOBL > 0) then this is sent in a final packet before the channel is deleted.

### GET PACKET      code 47

This procedure gets the next packet for the network channel identified by IX. NCNUMB identifies the required block number. (Both this block and the previous one will be acknowledged in case our acknowledgment to the last block was lost).

The procedure returns within 12mS if there is no packet available. If an appropriate packet arrives the procedure may take a further 37mS.

If the procedure is waiting for a broadcast (NCIRIS = 0) then it does not return until a packet is received.

The carry flag is set if no packet is available or if the received packet was erroneous in some way.

The packet "header" and data block can be found in the channel starting at NCIRIS and NCB respectively.

NCNUMB is incremented.

### SEND PACKET     code 48

This procedure sends a packet from the network channel identified by IX. The number of bytes in the data buffer is specified by NCOBL (must be > 0). The byte in A is stored in NCTYPE. NCNUMB is incremented. The procedure does not return until the packet has been sent and an acknowledgment received (no acknowledgment is necessary in the case of a BROADCAST; ie NTDEST=0).

### CREATE SYSTEM VARIABLES code 49

This procedure creates a space for and initializes the new system variables described above. This should be called before attempting to set up any any of these variables prior to calling any of the above procedures.
