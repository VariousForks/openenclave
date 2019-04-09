// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#include <assert.h>
#include <elf.h>
#include <link.h>
#include <stdio.h>
#include <string.h>
#include <user_ta_header.h>

/* Used by libunwind to iterate program ELF phdrs */

int dl_iterate_phdr(
    int (*callback)(struct dl_phdr_info* info, size_t size, void* data),
    void* data)
{
    const Elf64_Ehdr* ehdr =
        (Elf64_Ehdr*)(tahead_get_rva() + sizeof(struct ta_head));

    const uint8_t ident[] = {0x7f, 'E', 'L', 'F'};

    if (memcmp(ehdr->e_ident, ident, sizeof(ident)) != 0)
    {
        assert("dl_iterate_phdr(): bad identifier" == NULL);
        return -1;
    }

    struct dl_phdr_info info;
    memset(&info, 0, sizeof(info));
    info.dlpi_addr = (Elf64_Addr)(tahead_get_rva());
    info.dlpi_name = "";
    info.dlpi_phdr = (Elf64_Phdr*)((uint8_t*)ehdr + ehdr->e_phoff);
    info.dlpi_phnum = ehdr->e_phnum;

    return callback(&info, sizeof(info), data);
}
