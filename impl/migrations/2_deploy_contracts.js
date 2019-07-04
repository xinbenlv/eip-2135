var SimpleEIp2135Ticket = artifacts.require("./SimpleEIp2135Ticket.sol");
var Ticket721 = artifacts.require("./Ticket721.sol");
module.exports = function(deployer) {
  deployer.deploy(SimpleEIp2135Ticket);
  deployer.deploy(Ticket721);
};
