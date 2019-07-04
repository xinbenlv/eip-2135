const Ticket721 = artifacts.require("Ticket721");
const truffleAssert = require('truffle-assertions');

contract("Ticket721", accounts => {
  const [ownerAccount, account1, account2, account3] = accounts;
  let ticket721;

  beforeEach(async () => {
    ticket721 = await Ticket721.new();
    await ticket721.issueTicket(account1, 1001/*ticketId*/, {from: ownerAccount});
    await ticket721.issueTicket(account1, 1002/*ticketId*/, {from: ownerAccount});
    await ticket721.issueTicket(account1, 1003/*ticketId*/, {from: ownerAccount});
  });

  it("should set an minter", async () => {
    assert.equal(await ticket721.isMinter.call(ownerAccount), true);
    assert.equal(await ticket721.isMinter.call(account1), false);
  });

  it("should allow minter to issue a ticket", async () => {
    assert.equal(await ticket721.isConsumable(2001), false);
    await ticket721.issueTicket(account1, 2001/*ticketId*/, {from: ownerAccount});
    assert.equal(await ticket721.isConsumable(2001), true);
  });

  it("should NOT allow a non-minter to issue a ticket", async () => {
    assert.equal(await ticket721.isConsumable(2001), false);
    await truffleAssert.fails(
        ticket721.issueTicket(account1, 2001/*ticketId*/, {from: account1}),
        truffleAssert.ErrorType.REVERT,
        "Only minter can issue ticket.",
        "This method should revert"
    );
  });

  it("should allow ticket holder to transfer a ticket.", async () => {
    assert.equal(await ticket721.isConsumable(1001), true);
    await ticket721.transferFrom(account1, account2, 1001, {from: account1});
    assert.equal(await ticket721.isConsumable(1001), true);
    await ticket721.transferFrom(account2, account1, 1001, {from: account2});
  });

  it("should allow ticket holder consume a ticket.", async () => {
    assert.equal(await ticket721.isConsumable(1002), true);
    let result = await ticket721.consume(1002, {from: account1});
    assert.equal(await ticket721.isConsumable(1002), false);
    truffleAssert.eventEmitted(result, "OnConsumption",  (ev) => {
      return ev[0].toNumber() === 1002;
    });
  });

  it("should NOT allow non holder of a ticket to consume a ticket.", async () => {
    assert.equal(await ticket721.isConsumable(1002), true);
    await truffleAssert.fails(
        ticket721.consume(1002, {from: account2}),
        truffleAssert.ErrorType.REVERT,
        "Ticket should be held by tx sender to be consumed.",
        "This method should revert"
    );
  });

  it("should disallow a ticket not issued to be consumed.", async () => {
    assert.equal(await ticket721.isConsumable(3001), false);
    await truffleAssert.fails(
        ticket721.consume(3001, {from: account2}),
        truffleAssert.ErrorType.REVERT,
        "Ticket needs to be consumable.",
        "This method should revert"
    );
  });

  it("should allow ticket holder to transfer the ticket to anothor new holder and consume by that new holder.", async () => {
    let ticketId = 1003;
    assert.equal(await ticket721.isConsumable(ticketId), true, "Step 1. Ticket is still consumable.");
    await ticket721.transferFrom(account1, account2, ticketId, {from: account1});
    assert.equal(await ticket721.isConsumable(ticketId), true, "Step 2. Ticket is still consumable.");
    await truffleAssert.fails(
        ticket721.consume(ticketId, {from: account1}), // account1 now no longer held ticketId=1003
        truffleAssert.ErrorType.REVERT,
        "Ticket should be held by tx sender to be consumed.",
        "This method should revert"
    );
    assert.equal(await ticket721.isConsumable(ticketId), true, "Step 3. Ticket is still consumable.");

    let result = await ticket721.consume(ticketId, {from: account2});
    truffleAssert.eventEmitted(result, "OnConsumption",  (ev) => {
      return ev[0].toNumber() === ticketId;
    });

    assert.equal(await ticket721.isConsumable(ticketId), false, "Step 4. Now ticket is consumed, should no longer be consumable.");
  });

});
