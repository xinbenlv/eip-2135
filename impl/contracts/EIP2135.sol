pragma solidity ^0.5.8;

contract EIP2135 {
  // The main consume function
  function consume(uint256 assetId) public returns(bool success);

  // The interface to check whether an asset is consumable.
  function isConsumable(uint256 assetId) public view returns (bool consumable);

  // The interface to check whether an asset is consumable.
  event OnConsumption(uint256 assetId);
}
