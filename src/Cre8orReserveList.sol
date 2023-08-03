// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IReserveList} from "./interfaces/IReserveList.sol";

/**
 ██████╗██████╗ ███████╗ █████╗  ██████╗ ██████╗ ███████╗
██╔════╝██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔════╝
██║     ██████╔╝█████╗  ╚█████╔╝██║   ██║██████╔╝███████╗
██║     ██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══██╗╚════██║
╚██████╗██║  ██║███████╗╚█████╔╝╚██████╔╝██║  ██║███████║
 ╚═════╝╚═╝  ╚═╝╚══════╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝                                                       
 */
contract Cre8orReserveList is Ownable, IReserveList {
    uint256 public reservationFee;
    address[] public reserveList;

    mapping(address => uint256) public reservations;

    event Reserved(address indexed user, uint256 amount);
    event Refunded(address indexed user, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    constructor(uint256 _reservationFee) {
        reservationFee = _reservationFee;
    }

    function getReserveList() external view returns (address[] memory) {
        return reserveList;
    }

    function reserve() external payable {
        require(reservations[msg.sender] == 0, "Already reserved");
        require(msg.value == reservationFee, "Incorrect reservation fee");

        reservations[msg.sender] = msg.value;
        reserveList.push(msg.sender);

        emit Reserved(msg.sender, msg.value);
    }

    function refund(address user) external onlyOwner {
        uint256 refundAmount = reservations[user];
        require(refundAmount > 0, "No reservation found");

        (bool success, ) = user.call{value: refundAmount}("");
        require(success, "Refund failed");

        reservations[user] = 0;

        for (uint256 i = 0; i < reserveList.length - 1; i++) {
            if (reserveList[i] == user) {
                reserveList[i] = reserveList[reserveList.length - 1];
                break;
            }
        }
        reserveList.pop();

        emit Refunded(user, refundAmount);
    }

    function withdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds available to withdraw");

        (bool success, ) = owner().call{value: contractBalance}("");
        require(success, "Withdrawal failed");

        emit Withdrawn(owner(), contractBalance);
    }
}
