interface IBorrowerClassification {
    function updateSocialScore(address borrower, uint256 newSocialScore) external;
    function recordBorrowing(address borrower, uint256 amount, uint256 socialScore) external;
    function recordRepayment(address borrower, uint256 amount) external;
    function getDeFiScore(address borrower) external view returns (uint256);
    function getBorrowerClassification(address borrower) external view returns (uint256);
    function getTotalRepaid(address borrower) external view returns (uint256);
}