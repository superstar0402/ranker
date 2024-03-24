// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BorrowerClassification.sol";

contract BorrowerClassificationTest is Test {
    BorrowerClassification public borrowerClassification;
    address constant alice = address(1);
    address constant bob = address(2);

    function setUp() public {
        borrowerClassification = new BorrowerClassification();
    }

    function testInitialClassification() public {
        // Initially, borrowers should not have any classification
        assertEq(borrowerClassification.getDeFiBorrowerClassification(alice), 0);
    }

    function testBorrowingAndClassification() public {
        // Simulate borrowing and social score update
        borrowerClassification.recordBorrowing(alice, 1 ether, 80);
        uint256 aliceClassification = borrowerClassification.getDeFiBorrowerClassification(alice);
        assertTrue(aliceClassification > 0, "Alice should have a classification");

        // Check if DeFi score updates correctly
        uint256 aliceDeFiScore = borrowerClassification.getDeFiScore(alice);
        assertTrue(aliceDeFiScore > 0, "Alice should have a DeFi score");
    }

    function testRepaymentUpdate() public {
        // Set up borrowing first
        borrowerClassification.recordBorrowing(alice, 1 ether, 80);
        // Repay
        borrowerClassification.recordRepayment(alice, 1 ether);

        uint256 totalRepaid = borrowerClassification.getTotalRepaid(alice);
        assertEq(totalRepaid, 1 ether, "Total repaid should match the repaid amount");
    }

    function testDeFiScoreAfterRepayment() public {
        // Simulate borrowing and repayment
        borrowerClassification.recordBorrowing(alice, 1 ether, 80);
        borrowerClassification.recordRepayment(alice, 0.5 ether); // Partial repayment

        uint256 aliceDeFiScoreAfterRepayment = borrowerClassification.getDeFiScore(alice);
        assertTrue(aliceDeFiScoreAfterRepayment > 0, "Alice's DeFi score should update after repayment");
    }
}
