// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

function ensure(bool condition, bytes memory data) pure {
  if (!condition) {
    // solhint-disable-next-line no-inline-assembly
    assembly {
      revert(add(data, 60), sub(mload(data), 28))
    }
  }
}
