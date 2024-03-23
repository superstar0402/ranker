// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


///@notice This is an Evaluation tracker for undercollateralized loans

contract UndercollateralizedTracker {

    address[] public borrowers; 
    mapping(address => Stats) public stats;
    mapping(address => Score) public score;


    // Payments can be done in chunks, so we need to keep track of the partial payments in an array
    struct Stats {
        uint48 amount;
        uint48[] partialPaid;
        bool repaid; 
    }

    struct Score {
        uint8 score;
        uint8 weight; 
    }

    function retrieveStats() public view returns (Stats memory _stats) {
        return stats[msg.sender];
    }

    function calculateScore() internal {
    } 






    
}
