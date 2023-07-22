// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Ensure.sol";

/**
 * @title Example errors contract contains error-related functionality to be used in the example target contract
 *
 * @notice The errors and functions may be defined outside of any contract; however, in such case, it looks better if
 *      they are defined in a separate file and imported via `import "PATH" as Errors` pattern
 *
 * @notice The different errors are implemented to check that packing works as required
 *
 * @dev Use `build_CUSTOM_ERROR` functions to build CUSTOM_ERROR data properly
 */
abstract contract ExampleErrors {
  /// @notice Typical error when a uint value is not within the specified bounds
  error NotWithinBounds(uint256 min, uint256 max, uint256 actual);

  /**
   * @notice Builds `NotWithinBounds` error data for `ensure` function call
   *
   * @dev The function performs necessary type checks of the error parameters.
   *      Direct call to `abi.encode` does not perform any type checks.
   * @dev The function parameters should be fully consistent with error parameters.
   *
   * @param min Error parameter representing the minimum allowed value
   * @param max Error parameter representing the maximum allowed value
   * @param actual Error parameter representing the actual provided value
   *
   * @return The bytes array is returned from the function:
   *      28 empty bytes + bytes `NotWithinBounds` error representation
   */
  function buildNotWithinBounds(uint256 min, uint256 max, uint256 actual) internal pure returns (bytes memory) {
    return abi.encode(uint32(NotWithinBounds.selector), min, max, actual);
  }

  error NotSpecificAddress(address expected, address actual);

  function buildNotSpecificAddress(address expected, address actual) internal pure returns (bytes memory) {
    return abi.encode(uint32(NotSpecificAddress.selector), expected, actual);
  }

  error HeadBytesMismatch(bytes4 expected, bytes4 actual);

  function buildHeadBytesMismatch(bytes4 expected, bytes4 actual) internal pure returns (bytes memory) {
    return abi.encode(uint32(HeadBytesMismatch.selector), expected, actual);
  }
}

/**
 * @title Example target contract demonstrates `ensure` function usage
 *
 * @notice The different functions are implemented to check that packing works as required
 *
 * @dev The `if (!condition) revert CUSTOM_ERROR()` may save some Gas comparing to the implementation due to error
 *      messages not being precalculated on the `condition` check stage
 */
contract ExampleTarget is ExampleErrors {
  /**
   * @notice Example function calls `ensure` function to validate that the `value` parameter is in provided boundaries
   *
   * @param min Parameter representing the bottom boundary
   * @param max Parameter representing the top boundary
   * @param value Parameter representing the actual provided value to be validated
   */
  function checkBounds(uint256 min, uint256 max, uint256 value) external pure {
    ensure(min <= value && value <= max, buildNotWithinBounds(min, max, value));
  }

  function checkAddress(address expected, address value) external pure {
    ensure(expected == value, buildNotSpecificAddress(expected, value));
  }

  function checkBytesHead(bytes4 expected, bytes32 value) external pure {
    /// @dev `bytes4(bytes32 value)`: trims 28 bytes tail
    bytes4 head = bytes4(value);
    ensure(head == expected, buildHeadBytesMismatch(expected, head));
  }
}
