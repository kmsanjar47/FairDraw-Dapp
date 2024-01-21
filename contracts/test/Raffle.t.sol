// SPDX License Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Raffle} from "../src/Raffle.sol";
import {DeployRaffle} from "../script/Raffle.s.sol";

contract RaffleTest is Test {
    enum RaffleState {
        OPEN,
        PAUSED
    }

    Raffle raffle;
    address testUser = makeAddr("USER");

    function setUp() public {
        DeployRaffle deployedRaffle = new DeployRaffle();
        raffle = deployedRaffle.run();
    }

    ////////////////////////////////
    //////// enterTheRaffle ///////
    //////////////////////////////

    function testIfMinimumBalanceIsSendToEnterTheRaffle() public {
        // Testing by sending no ether to the contract
        vm.startPrank(testUser);
        vm.expectRevert();
        raffle.enterTheRaffle();
        vm.stopPrank();
    }

    function testIfStateOfRaffleIsOpen() public {
        // Testing by fullfilling min balance condition
        vm.startPrank(testUser);
        vm.deal(testUser, 1 ether);
        raffle.enterTheRaffle{value: 0.02 ether}();
        vm.stopPrank();
    }

    function testIfPlayerIsAddedInTheArray() public {
        vm.startPrank(testUser);
        vm.deal(testUser, 1 ether);
        raffle.enterTheRaffle{value: 0.02 ether}();
        assertEq(testUser, raffle.getLatestPlayer());
        vm.stopPrank();
    }

    function testIfBalanceAdded() public {
        vm.startPrank(testUser);
        vm.deal(testUser, 1 ether);
        uint256 SENT_FUND = 0.02 ether;
        raffle.enterTheRaffle{value: SENT_FUND}();
        assertEq(SENT_FUND, raffle.getBalance());
        vm.stopPrank();
    }

    function testIfPlayerCountIncreased() public {
        vm.startPrank(testUser);
        vm.deal(testUser, 1 ether);
        uint256 SENT_FUND = 0.02 ether;
        raffle.enterTheRaffle{value: SENT_FUND}();
        assertEq(1, raffle.getPlayerCount());
        vm.stopPrank();
    }
}
