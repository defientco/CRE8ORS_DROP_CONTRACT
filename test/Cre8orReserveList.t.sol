// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@forge-std/src/Test.sol";
import {Cre8orReserveList} from "../src/Cre8orReserveList.sol";

contract Cre8orReserveListTest is Test {
    Cre8orReserveList public cre8orsReserveList;
    address public constant DEFAULT_OWNER_ADDRESS = address(999);
    address public constant DEFAULT_PREPAY_ADDRESS = address(111);
    address public constant DEFAULT_PREPAY_ADDRESS_2 = address(222);
    address public constant DEFAULT_PREPAY_ADDRESS_3 = address(333);
    uint256 public reservationFee = 0.05 ether;

    function setUp() public {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsReserveList = new Cre8orReserveList(reservationFee);
    }

    function test_constructor() public {
        assertEq(DEFAULT_OWNER_ADDRESS, cre8orsReserveList.owner());
        assertEq(reservationFee, cre8orsReserveList.reservationFee());
        assertEq(0, cre8orsReserveList.reservations(DEFAULT_OWNER_ADDRESS));
        assertEq(0, cre8orsReserveList.getReserveList().length);
    }

    function test_reserve_revertIncorrectFee() public {
        vm.startPrank(DEFAULT_PREPAY_ADDRESS);
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee + 1);
        // Missing Fee
        vm.expectRevert("Incorrect reservation fee");
        cre8orsReserveList.reserve();
        // Too High
        vm.expectRevert("Incorrect reservation fee");
        cre8orsReserveList.reserve{value: reservationFee + 1}();
        // Too Low
        vm.expectRevert("Incorrect reservation fee");
        cre8orsReserveList.reserve{value: reservationFee - 1}();
        // Verify no reservations
        assertEq(0, cre8orsReserveList.reservations(DEFAULT_PREPAY_ADDRESS));
    }

    function test_reserve() public {
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee);
        vm.prank(DEFAULT_PREPAY_ADDRESS);
        cre8orsReserveList.reserve{value: reservationFee}();
        assertEq(
            reservationFee,
            cre8orsReserveList.reservations(DEFAULT_PREPAY_ADDRESS)
        );
        assertEq(1, cre8orsReserveList.getReserveList().length);
    }

    function test_reserve_revertAlreadyReserved() public {
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee * 2);
        // First reservation
        vm.startPrank(DEFAULT_PREPAY_ADDRESS);
        cre8orsReserveList.reserve{value: reservationFee}();
        // Second reservation
        vm.expectRevert("Already reserved");
        cre8orsReserveList.reserve{value: reservationFee}();
        assertEq(
            reservationFee,
            cre8orsReserveList.reservations(DEFAULT_PREPAY_ADDRESS)
        );
        assertEq(1, cre8orsReserveList.getReserveList().length);
    }

    function test_reserveMultiple() public {
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee);
        vm.deal(DEFAULT_PREPAY_ADDRESS_2, reservationFee);
        vm.deal(DEFAULT_PREPAY_ADDRESS_3, reservationFee);
        // First reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS);
        cre8orsReserveList.reserve{value: reservationFee}();
        // Second reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS_2);
        cre8orsReserveList.reserve{value: reservationFee}();
        // Third reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS_3);
        cre8orsReserveList.reserve{value: reservationFee}();
        assertEq(
            reservationFee,
            cre8orsReserveList.reservations(DEFAULT_PREPAY_ADDRESS)
        );
        assertEq(
            reservationFee,
            cre8orsReserveList.reservations(DEFAULT_PREPAY_ADDRESS_2)
        );
        assertEq(
            reservationFee,
            cre8orsReserveList.reservations(DEFAULT_PREPAY_ADDRESS_3)
        );
        assertEq(3, cre8orsReserveList.getReserveList().length);
    }

    function test_refund_revertNoReservation() public {
        vm.prank(DEFAULT_OWNER_ADDRESS);
        vm.expectRevert("No reservation found");
        cre8orsReserveList.refund(DEFAULT_PREPAY_ADDRESS);
    }

    function test_refund_reverNonOwner() public {
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee);
        // First reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS);
        cre8orsReserveList.reserve{value: reservationFee}();
        // Refund
        vm.expectRevert("Ownable: caller is not the owner");
        cre8orsReserveList.refund(DEFAULT_PREPAY_ADDRESS);
        assertEq(1, cre8orsReserveList.getReserveList().length);
    }

    function test_refund() public {
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee);
        // First reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS);
        cre8orsReserveList.reserve{value: reservationFee}();
        assertEq(1, cre8orsReserveList.getReserveList().length);
        assertEq(0, DEFAULT_PREPAY_ADDRESS.balance);
        // Refund
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsReserveList.refund(DEFAULT_PREPAY_ADDRESS);
        assertEq(0, cre8orsReserveList.getReserveList().length);
        assertEq(reservationFee, DEFAULT_PREPAY_ADDRESS.balance);
    }

    function test_withdraw() public {
        vm.deal(DEFAULT_PREPAY_ADDRESS, reservationFee);
        vm.deal(DEFAULT_PREPAY_ADDRESS_2, reservationFee);
        vm.deal(DEFAULT_PREPAY_ADDRESS_3, reservationFee);
        // First reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS);
        cre8orsReserveList.reserve{value: reservationFee}();
        // Second reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS_2);
        cre8orsReserveList.reserve{value: reservationFee}();
        // Third reservation
        vm.prank(DEFAULT_PREPAY_ADDRESS_3);
        cre8orsReserveList.reserve{value: reservationFee}();

        // Withdraw
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsReserveList.withdraw();
        assertEq(0, DEFAULT_PREPAY_ADDRESS.balance);
        assertEq(0, DEFAULT_PREPAY_ADDRESS_2.balance);
        assertEq(0, DEFAULT_PREPAY_ADDRESS_3.balance);
        assertEq(reservationFee * 3, DEFAULT_OWNER_ADDRESS.balance);
    }

    function test_withdraw_revertNonOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        cre8orsReserveList.withdraw();
    }
}
