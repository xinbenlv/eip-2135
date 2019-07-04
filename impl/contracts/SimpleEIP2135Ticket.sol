pragma solidity ^0.5.8;

import "./EIP2135.sol";

/** A reference implementation of EIP-2135
 *
 * For simplicity, this reference implementation creates a super simple `issueTicket` function without
 * restriction on who can issue new tickets and under what condition a ticket can be issued.
 */
contract SimpleEIP2135Ticket is EIP2135 {

  mapping(uint256 => bool) private tickets;

  function issueTicket(uint256 ticketId) public {
    require (!tickets[ticketId]); // ticket needs to be not issued yet;
    tickets[ticketId] = true;
  }

  function consume(uint256 ticketId) public returns (bool success) {
    require (tickets[ticketId], "Ticket needs to be consumable.");
    tickets[ticketId] = false;
    emit OnConsumption(ticketId);
    return true;
  }

  function isConsumable(uint256 ticketId) public view returns (bool consumable) {
    return tickets[ticketId];
  }
}
