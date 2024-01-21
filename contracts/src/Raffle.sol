// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX License Identifier: MIT
pragma solidity ^0.8.0;

import {VRFCoordinatorV2Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title Lottery Smart Contract
 * @author Khan MD Saifullah Anjar
 * @notice This smart contract is used to create a decentralized lottery system
 * @dev Chainlink VRF is used to generate random numbers, automation is used to
 *      automatically select winners and distribute prizes
 */

contract Raffle is VRFConsumerBaseV2 {
    //Errors

    error Raffle__minimumBalanceLimitNotReached();
    error Raffle_raffleCurrentlyNotOpen();

    //Enums

    enum RaffleState {
        OPEN,
        PAUSED
    }

    //Variables

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NO_OF_WORDS = 1;

    uint256 private immutable i_minimumBalance;
    uint256 private immutable i_interval;
    uint256 private immutable i_blockTime;
    uint32 private immutable i_callbackGasLimit;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_keyHash; //GasLane
    uint64 private immutable i_subscriptionId;

    address payable[] private s_players;
    address private s_owner;
    uint256 private s_timestamp;
    uint256 private s_playerCount = 0;
    uint256 private s_balance;

    RaffleState public raffleState = RaffleState.OPEN;

    //Events

    event PlayerEnteredTheRaffle(address indexed playerAddress, uint256 amount);
    event WinnerPicked(address winnerAddress);
    event FundSentToWinner(address indexed winnerAddress, uint256 amount);
    event RaffleReset();

    //Modifiers

    modifier minimumBalanceLimit() {
        if (msg.value < i_minimumBalance) {
            revert Raffle__minimumBalanceLimitNotReached();
        }
        _;
    }

    modifier raffleIsOpen() {
        if (raffleState != RaffleState.OPEN) {
            revert Raffle_raffleCurrentlyNotOpen();
        }
        _;
    }

    // Constructor

    constructor(
        uint256 minimumBalance_,
        uint256 interval_,
        uint64 subscriptionId_,
        uint32 callbackGasLimit_,
        bytes32 keyHash_,
        address vrfCoordinator_
    ) VRFConsumerBaseV2(vrfCoordinator_) {
        i_minimumBalance = minimumBalance_;
        i_interval = interval_;
        i_blockTime = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator_);
        i_callbackGasLimit = callbackGasLimit_;
        i_keyHash = keyHash_;
        i_subscriptionId = subscriptionId_;
    }

    function enterTheRaffle()
        external
        payable
        minimumBalanceLimit
        raffleIsOpen
    {
        // store the player

        s_players.push(payable(msg.sender));

        //store the balance

        s_balance += msg.value;
        s_playerCount++;

        emit PlayerEnteredTheRaffle(msg.sender, msg.value);
    }

    /**
     * @dev This function picks winner when the interval time passes.
     * The winner is picked with a random number and the function is automatically called after a certain time
     * to check if the interval time has passed
     */

    function pickWinner() public payable {
        if ((block.timestamp - s_timestamp) > i_interval) {
            // Will revert if subscription is not set and funded.
            raffleState = RaffleState.PAUSED;
            uint256 requestId = i_vrfCoordinator.requestRandomWords(
                i_keyHash,
                i_subscriptionId,
                REQUEST_CONFIRMATIONS,
                i_callbackGasLimit,
                NO_OF_WORDS
            );
        }
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        uint256 winnerIndex = (randomWords[0] % s_players.length);
        address payable winnerAddress = s_players[winnerIndex];
        emit WinnerPicked(winnerAddress);

        // (bool success,) = winnerAddress.call(value:{})
        winnerAddress.transfer(address(this).balance);
        emit FundSentToWinner(winnerAddress, s_balance);

        s_balance = 0;
        s_players = new address payable[](0);
        emit RaffleReset();
    }

    //Views

    function getBalance() external view returns (uint256) {
        return s_balance;
    }

    function getLatestPlayer() external view returns (address) {
        return s_players[0];
    }

    function getPlayerCount() external view returns (uint256) {
        return s_playerCount;
    }
}
