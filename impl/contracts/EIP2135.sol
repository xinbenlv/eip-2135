pragma solidity ^0.5.8;

contract EIP2135 {
  function consume(uint256 assetId) public returns(bool success);
  function isConsumable(uint256 assetId) public view returns (bool consumable);
  event OnConsumption(uint256 assetId);
}
