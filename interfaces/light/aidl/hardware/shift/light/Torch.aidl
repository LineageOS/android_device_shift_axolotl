/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package hardware.shift.light;

import hardware.shift.light.TorchType;

@VintfStability
parcelable Torch {
    /**
     * Integer ID of the torch.
     */
    int id;

    /**
     * The type of the torch.
     */
    TorchType type;

    /**
     * The maximum brightness as supported by the torch.
     */
    int maxBrightness;
}
