# This file declares functions to install the kernel headers for linux
# Copyright 2007 Yann E. MORIN
# Licensed under the GPL v2. See COPYING in the root of this package

CT_DoKernelTupleValues()
{
    :
}

# Download the kernel
do_kernel_get()
{
    CT_Fetch FOREIGN_LINUX
}

# Extract kernel
do_kernel_extract()
{
    CT_ExtractPatch FOREIGN_LINUX
}

# Install kernel headers using headers_install from kernel sources.
do_kernel_headers()
{
    CT_DoStep INFO "Copy foreign linux sysyroot"
    
    rm -rf ${CT_SYSROOT_DIR}
    mkdir -p ${CT_SYSROOT_DIR}
    cp ${CT_SRC_DIR}/foreign-linux ${CT_SYSROOT_DIR}

    CT_EndStep
}
