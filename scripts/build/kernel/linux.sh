# This file declares functions to install the kernel headers for linux
# Copyright 2007 Yann E. MORIN
# Licensed under the GPL v2. See COPYING in the root of this package

CT_DoKernelTupleValues()
{
    if [ -z "${CT_ARCH_USE_MMU}" ]; then
        # Some no-mmu linux targets requires a -uclinux tuple (like m68k/cf),
        # while others must have a -linux tuple.  Other targets
        # should be added here when someone starts to care about them.
        case "${CT_ARCH}" in
            arm*)               CT_TARGET_KERNEL="linux" ;;
            m68k|xtensa*)       CT_TARGET_KERNEL="uclinux" ;;
            *)                  CT_Abort "Unsupported no-mmu arch '${CT_ARCH}'"
        esac
    fi
}

# Download the kernel
do_kernel_get()
{
    CT_Fetch LINUX
}

# Disable building relocs application - it needs <linux/types.h>
# on the host, which may not be present on Cygwin or MacOS; it
# needs <elf.h>, which again is not present on MacOS; and most
# important, we don't need it to install the headers.
# This is not done as a patch, since it varies from Linux version
# to version - patching each particular Linux version would be
# too cumbersome.
linux_disable_build_relocs()
{
    sed -i -r 's/(\$\(MAKE\) .* relocs)$/:/' arch/*/Makefile
}

# Extract kernel
do_kernel_extract()
{
    # TBD verify linux_disable_build_relocs is run
    CT_ExtractPatch LINUX linux_disable_build_relocs
}

# Install kernel headers using headers_install from kernel sources.
do_kernel_headers()
{
    CT_DoStep INFO "Installing kernel headers"
    
    rm -rf ${CT_SYSROOT_DIR}
    mkdir -p ${CT_SYSROOT_DIR}
    tar -xhvf ${CT_SYSROOT_SOURCE} -C ${CT_SYSROOT_DIR} --strip-components=1

    CT_EndStep
}
