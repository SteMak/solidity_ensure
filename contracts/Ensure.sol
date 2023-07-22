// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @notice Requires `condition` to be true; otherwise, throws CUSTOM_ERROR.
 *
 * @dev When `revert CUSTOM_ERROR()` is called, it throws a bytes error message in the format:
 * - 4 bytes: CUSTOM_ERROR selector
 * - 32 bytes * parameters.length: CUSTOM_ERROR parameters
 *
 * @param condition Expression to be validated
 * @param data Packed CUSTOM_ERROR selector and parameters
 * @dev The first 28 bytes of `data` are empty because the 4 bytes selector is converted to uint, and uints are aligned
 *      on the right in packed representation.
 * @dev The `data` could be generated via `abi.encode(uint32(CUSTOM_ERROR selector), CUSTOM_ERROR parameters)`.
 */
function ensure(bool condition, bytes memory data) pure {
  if (!condition) {
    // solhint-disable-next-line no-inline-assembly
    assembly {
      /**
       * @dev Expected `data` layout produced by
       *      `abi.encode(uint32(CUSTOM_ERROR selector), CUSTOM_ERROR parameters)`:
       * - 32 bytes: length
       * - 28 bytes: empty space
       * - 4 bytes: CUSTOM_ERROR selector
       * - 32 bytes * parameters.length: CUSTOM_ERROR parameters
       */

      // `add(data, 60) = add(data, add(32, 28))`: CUSTOM_ERROR selector start pointer
      // `sub(mload(data), 28)`: length after trimming empty space
      revert(add(data, 60), sub(mload(data), 28))
    }
  }
}
