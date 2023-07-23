# Solidity Ensure

## Disclaimer
The usage of the `ensure(condition, build_CUSTOM_ERROR(CUSTOM_ERROR parameters))` function is considered to be gas inefficient compared to `require(condition, "Error message")` and `if (!condition) revert CUSTOM_ERROR(CUSTOM_ERROR parameters)`.

## Abstract
Starting from `solidity 0.8.4`, Custom Errors are available, providing the ability to efficiently return dynamic data packed in an efficient format.

However, the previously used validation pattern with the `require` function does not have support for Custom Errors. In this way, the validation style changed significantly, and the declarativeness of the `require` pattern was missed.

In smart contracts, it is often more valuable to check if values are within certain bounds rather than out of bounds. The `require` pattern allowed for this perfectly, while the `revert` pattern made the code look more branchy, decreasing readability.

This project aims to develop an `ensure` function that allows the usage of Custom Errors within a declarative `require` pattern.

## Fake Custom Errors
Custom errors are ABI encoded as follows:
- 4 bytes Custom Error selector
- 32 bytes for each Custom Error parameter

It was decided to use `abi.encode` to pack Custom Error parameters into 32 bytes memory slots. After evaluating efficiency, `abi.encode(uint32(selector), parameters)` was found to be more optimal than `abi.encodePacked(selector, abi.encode(parameters))`, hence the prior was chosen.

To throw the error message, the `assembly revert` instruction is used, allowing for starting the error message from any memory pointer and directly providing the message length.

It is worth mentioning that `abi.encode` accepts parameters of any type, which led to the proposal of building builder functions for each error. These builder functions accept corresponding parameters and perform auto typechecks.

## Result
The `ensure` function was developed and should be used within the `ensure(condition, build_CUSTOM_ERROR(CUSTOM_ERROR parameters))` pattern. It preserves the declarative `require` pattern and allows for the usage of Custom Errors.

However, there are some flaws:
- The need to declare a builder function for each error leads to code overload and increased gas consumption during deployment.
- Custom Error data is not lazy-built, and the error message is calculated before the function call, causing ordinary checks to incur gas costs based on the error parameter types.
