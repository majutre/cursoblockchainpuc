pragma solidity 0.5.12;

contract Lottery {
    address public manager;
    address payable[] public players;
    
    constructor() public {
        manager = msg.sender;
    }
    modifier restricted(){
         require(msg.sender == manager);
         _;
    }
    function enter() public payable {
        require(msg.value > .01 ether);
        
        players.push(msg.sender);
    }
    //make pseudo-random number
    function random() private view returns (uint){
    return uint(keccak256(abi.encodePacked(block.difficulty,now,players)));
        
    }
    function pickWinner() public payable restricted {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }
    function getPlayers() public view returns(address payable[] memory){
        return players;
    }
    
}
