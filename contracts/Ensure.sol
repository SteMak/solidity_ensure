// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contract Sample {
//   error CustomError(bytes20 param);

//   function buildCustomError(bytes20 param) internal pure returns (bytes memory) {
//     return abi.encode(uint32(CustomError.selector), param);
//   }

//   function usageCustomError() external pure {
//     ensure(false, buildCustomError(bytes20(0x1FffffffFffFfFfFFFfffFFFfffFFFffFFfffff1)));
//   }
// }

function ensure(bool condition, bytes memory data) pure {
  if (!condition) {
    // solhint-disable-next-line no-inline-assembly
    assembly {
      revert(add(data, 60), sub(mload(data), 28))
    }
  }
}
