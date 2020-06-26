bits    16

; Read the specified number of sectors from a partition.
;
; Parameters:
;       EBX:EAX First sector index.
;       CX      Number of sectors to read.
;       DS:DI   Pointer to the target buffer.
;       DL      Drive number to read from.
;       DH      Partition number to read from.
;
; Returns:
;       CF      Clear on success; set on error.
read_sectors_from_partition:
        push    eax
        push    ebp

        ; Find the partition start sector index.
        mov     ebp, eax
        push    ebx
        push    edx

        movzx   eax, dh
        mov     ebx, partition_entry_size
        mul     ebx
        add     eax, partition_table_offset + 8 ; Points to 'lba_first_sector' field.

        pop     edx
        pop     ebx
        call    read_dword_from_disk

        ; Partition start sector index + first sector on that partition to be loaded.
        add     eax, ebp

        call    read_sectors_from_disk

        pop     ebp
        pop     eax
        ret


partition_table_offset  equ     446
partition_entry_size    equ     16
