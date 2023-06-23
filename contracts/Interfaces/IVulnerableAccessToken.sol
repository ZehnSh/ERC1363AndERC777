pragma solidity ^0.8.0;

interface IVulnerableAccessToken{
    function withdrawFromContract(uint256 amount) external;
}