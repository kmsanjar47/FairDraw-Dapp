// SPDX License Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Raffle} from "../src/Raffle.sol";

contract DeployRaffle is Script {
    bytes32 private constant KEY_HASH =
        0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    uint64 private constant SUBSCRIPTION_ID = 7407;
    address private constant COORDINATOR =
        address(0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625);

    function run() external returns (Raffle) {
        Raffle raffle;
        vm.startBroadcast();
        raffle = new Raffle(
            0.01 ether,
            500,
            SUBSCRIPTION_ID,
            1000,
            KEY_HASH,
            COORDINATOR
        );
        vm.stopBroadcast();

        return raffle;
    }
}
