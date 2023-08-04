// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ICre8ing} from "./ICre8ing.sol";

interface ITransfers {
    function cre8ing() external view returns (ICre8ing);
}
