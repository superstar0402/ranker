// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BorrowerClassification.sol";
import "forge-std/console.sol";

contract Deploy is Script {
    function run() external {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying BorrowerClassification contract...");
        BorrowerClassification borrowerClassification = new BorrowerClassification();

        address borrower = address(0x123); 
        uint256 initialSocialScore = 75;
        uint256 borrowAmount = 1 ether;
        uint256 repaymentAmount = 0.5 ether;

        console.log("Setting initial conditions for the borrower...");
        // Update borrower's social score - Assume this is done via a separate process or oracle
        borrowerClassification.updateSocialScore(borrower, initialSocialScore);

        console.log("Recording a borrowing event...");
        // Record a borrowing event
        borrowerClassification.recordBorrowing(borrower, borrowAmount, initialSocialScore);

        console.log("Recording a repayment event...");
        // Record a repayment event
        borrowerClassification.recordRepayment(borrower, repaymentAmount);

        // Fetch and log the borrower's DeFi score and classification after interactions
        uint256 defiScore = borrowerClassification.getDeFiScore(borrower);
        uint256 classification = borrowerClassification.getDeFiBorrowerClassification(borrower);
        
        console.log("Borrower's DeFi Score:", defiScore);
        console.log("Borrower's Classification:", classificationToString(classification));
        vm.stopBroadcast();

    }

    function classificationToString(uint256 classification) internal pure returns (string memory) {
        if (classification == 1) {
            return "Small";
        } else if (classification == 2) {
            return "Medium";
        } else if (classification == 3) {
            return "Large";
        } else {
            return "Unknown";
        }
    }
}
