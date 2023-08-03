// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
 * ██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
 * ██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
 * ██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
 * ╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 *  ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝
 */
interface IReserveList {
    function getReserveList() external view returns (address[] memory);

    function reserve() external payable;

    function refund(address user) external;

    function withdraw() external;
}
