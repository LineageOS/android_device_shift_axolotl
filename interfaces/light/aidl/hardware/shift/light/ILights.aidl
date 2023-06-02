/*
 * Copyright (C) 2023 SHIFT GmbH
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package hardware.shift.light;

import hardware.shift.light.Torch;
import hardware.shift.light.TorchState;

@VintfStability
interface ILights {
    /**
     * Set torch to the provided state.
     *
     * If control over an invalid torch is requested, this method exits with
     * EX_UNSUPPORTED_OPERATION. Control over supported torches is done on a
     * device-specific best-effort basis and unsupported sub-features will not
     * be reported.
     *
     * @param torch the torch to set as returned by getTorches()
     * @param state describes what the torch should look like.
     */
    void setTorchState(in Torch torch, in TorchState state);

    /**
     * Discover what torch lights are supported by the HAL implementation.
     *
     * @return List of available torch lights
     */
    Torch[] getTorches();
}
