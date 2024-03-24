// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BorrowerClassification {
    // Borrower details expanded to include repayment rate and social score
    struct BorrowerDetails {
        uint256 totalBorrowed;
        uint256 totalRepaid;
        uint256 socialScore; // Score provided by Karma3Labs, scaled to 0-100
        uint256 defiScore; // Calculated DeFi score
    }

    // Define borrower tiers based on borrowed amount thresholds for simplicity
    uint256 constant SMALL_BORROWER_THRESHOLD = 1 ether;
    uint256 constant MEDIUM_BORROWER_THRESHOLD = 10 ether;
    // Amounts greater than MEDIUM_BORROWER_THRESHOLD classify as Large Borrowers

    // Mapping from borrower address to their details
    mapping(address => BorrowerDetails) public borrowers;

    // Events for logging borrower classification changes and DeFi score updates
    event BorrowerClassified(address borrower, uint256 classification);
    event DeFiScoreUpdated(address borrower, uint256 defiScore);

    // Function to record a borrowing event and classify the borrower based on external ranking
    function recordBorrowing(address borrower, uint256 amount, uint256 socialScore) external {
        BorrowerDetails storage details = borrowers[borrower];
        details.totalBorrowed += amount;
        details.socialScore = socialScore; // Assuming the score is updated with each borrowing for simplicity

        updateDeFiScore(borrower); // Update DeFi score based on new social score and repayment rate

        // Emit event indicating classification, though in this version, classification may depend on external data
        emit BorrowerClassified(borrower, getDeFiBorrowerClassification(borrower));
    }

    // Function to simulate a repayment
    function recordRepayment(address borrower, uint256 amount) external {
        BorrowerDetails storage details = borrowers[borrower];
        details.totalRepaid += amount;

        updateDeFiScore(borrower); // Recalculate DeFi score upon repayment
    }

    // Function to calculate and update the DeFi score
    function updateDeFiScore(address borrower) internal {
        BorrowerDetails storage details = borrowers[borrower];

        uint256 repaymentScore = (details.totalRepaid * 100) / details.totalBorrowed;
        // Weighted score: 40% social score (from Karma3Labs) + 60% repayment score
        details.defiScore = ((details.socialScore * 2) + (repaymentScore * 3)) / 5;

        emit DeFiScoreUpdated(borrower, details.defiScore);
    }

    // Function to retrieve a borrower's classification based on their DeFi score
    function getDeFiBorrowerClassification(address borrower) public view returns (uint256) {
        uint256 defiScore = borrowers[borrower].defiScore;
        if (defiScore < 40) {
            return 1; // Small
        } else if (defiScore < 70) {
            return 2; // Medium
        } else {
            return 3; // Large
        }
    }

     // Function to update the social score separately from borrowing activity
     function updateSocialScore(address borrower, uint256 newSocialScore) public {
        require(newSocialScore <= 100, "Social score must be between 0 and 100");
        BorrowerDetails storage details = borrowers[borrower];
        details.socialScore = newSocialScore;
        
        updateDeFiScore(borrower); // Update DeFi score based on the new social score
        emit DeFiScoreUpdated(borrower, details.defiScore); // Log the update
    }

    // Function to get the total amount repaid by a borrower
    function getTotalRepaid(address borrower) public view returns (uint256) {
        return borrowers[borrower].totalRepaid;
    }

    // Function to check the DeFi score of a borrower
    function getDeFiScore(address borrower) public view returns (uint256) {
        return borrowers[borrower].defiScore;
    }

    // Optional: Function to manually adjust the classification of a borrower (Admin only)
    function adjustClassification(address borrower, uint256 newClassification) public {
        // This could be restricted to the contract owner or a specific admin role
        require(newClassification >= 1 && newClassification <= 3, "Invalid classification");
        emit BorrowerClassified(borrower, newClassification); // Log the classification change
    }

    // Optional: Function to allow borrowers to request loans based on their classification
    // This function is a conceptual placeholder and would need integration with a lending mechanism
    function requestLoan(address borrower, uint256 amount) public view returns (bool canBorrow, uint256 maxAmount) {
        uint256 classification = getDeFiBorrowerClassification(borrower);
        uint256 borrowerMaxAmount;
        
        // Example logic to determine max loan amount based on classification
        if (classification == 1) { // Small
            borrowerMaxAmount = SMALL_BORROWER_THRESHOLD;
        } else if (classification == 2) { // Medium
            borrowerMaxAmount = MEDIUM_BORROWER_THRESHOLD;
        } else { // Large
            borrowerMaxAmount = MEDIUM_BORROWER_THRESHOLD + 10 ether; // Just as an example
        }

        // Check if the requested amount is within the allowable range for the borrower's classification
        canBorrow = amount <= borrowerMaxAmount;
        maxAmount = borrowerMaxAmount;
        
        // This function currently only returns whether a loan is possible and the max allowable amount;
        // Actual loan granting would involve additional logic and integration with a lending contract or platform.
        return (canBorrow, maxAmount);
    }

    
}
