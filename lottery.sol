// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
  address public manager;
  address[] public players;
  uint public ticketPrice;

  constructor(uint _ticketPrice) {
    manager = msg.sender;
    ticketPrice = _ticketPrice;
  }

  function enter() public payable {
    require(msg.value >= ticketPrice, "Not enough Ether sent");
    players.push(msg.sender);
  }

  function pickWinner() public onlyManager {
    uint winnerIndex = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players))) % players.length;
    address winner = players[winnerIndex];

    payable(winner).transfer(address(this).balance);

    players = new address[](0);
  }
  modifier onlyManager() {
    require(msg.sender == manager, "Only manager can call this function");
    _;
  }
}