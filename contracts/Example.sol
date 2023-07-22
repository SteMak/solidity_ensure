// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Ensure.sol";

abstract contract ExampleErrors {
  error NotWithinBounds(uint256 min, uint256 max, uint256 actual);

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

contract ExampleTarget is ExampleErrors {
  function checkBounds(uint256 min, uint256 max, uint256 value) external pure {
    ensure(min <= value && value <= max, buildNotWithinBounds(min, max, value));
  }

  function checkAddress(address expected, address value) external pure {
    ensure(expected == value, buildNotSpecificAddress(expected, value));
  }

  function checkBytesHead(bytes4 expected, bytes32 value) external pure {
    ensure(bytes4(value) == expected, buildHeadBytesMismatch(expected, bytes4(value)));
  }
}
