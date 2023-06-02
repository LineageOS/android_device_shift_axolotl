/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package hardware.shift.light;

@VintfStability
parcelable TorchState {
    /**
     * The brightness of the torch.
     */
    int brightness;
}
