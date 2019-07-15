pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleEIP2135Ticket.sol";

contract TestSimpleEIP2135Ticket {
  function testTicketIssueAndConsume() public {
    SimpleEIP2135Ticket eip2135 = SimpleEIP2135Ticket(DeployedAddresses.SimpleEIP2135Ticket());

    Assert.equal(eip2135.isConsumable(0/*ticketId*/), false, "Before ticket 0 issued, the consumable returns false");
    Assert.equal(eip2135.isConsumable(1/*ticketId*/), false, "Before ticket 0 issued, the consumable returns false");

    eip2135.issueTicket(0);
    eip2135.issueTicket(1);

    Assert.equal(eip2135.isConsumable(0/*ticketId*/), true, "After ticket 0 issued, it should be consumable");
    Assert.equal(eip2135.isConsumable(1/*ticketId*/), true, "After ticket 1 issued, it should be consumable");

    eip2135.consume(1);
    // So far we could not test the event here.

    Assert.equal(eip2135.isConsumable(1/*ticketId*/), false, "After consumption, the consumable of ticketId=1 returns false");
    Assert.equal(eip2135.isConsumable(0/*ticketId*/), true, "Without consumption ticket 0 should still be consumable");
  }

}
