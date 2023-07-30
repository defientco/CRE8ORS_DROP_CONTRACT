// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IAllowlistMinter {
    error NoMoreMintsLeft();

    error TooEarlyForMinting();
}
