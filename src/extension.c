/* SPDX-License-Identifier: CC0-1.0
 *
 * SPDX-FileCopyrightText: 2024 Tristan Partin <tristan@partin.io>
 */

#include <postgres.h>

#include <fmgr.h>

#if PG_MAJORVERSION_NUM <= 15
void _PG_init(void);
#endif

void _PG_init(void)
{
}
