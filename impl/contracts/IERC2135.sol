// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC2135 {

  // The main consume function
  function consume(uint256 ticketId, address consumer) external;

  // The interface to check whether an asset is consumable.
  function isConsumable(uint256 ticketId) external view returns (bool consumable);

  // The interface to check whether an asset is consumable.
  event Consume(uint256 indexed ticketId, address indexed consumer);
}

interface IERC2135Issuable {
  
  function issue(uint256 ticketId, address receiver) external; 
  
  // The interface to check whether an asset is consumable.
  event Issue(uint256 indexed ticketId, address indexed receiver);

}