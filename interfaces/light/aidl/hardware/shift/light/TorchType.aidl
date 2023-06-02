/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package hardware.shift.light;

@Backing(type="int") @VintfStability
enum TorchType {
    /**
     * No specific type.
     */
    NORMAL = 1 << 0,

    /**
     * The torch emits warm light.
     */
    WARM = 1 << 1,

    /**
     * The torch emits cold light.
     */
    COLD = 1 << 2,
}
