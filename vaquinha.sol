pragma solidity 0.5.12;

contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }


  function owner() public view returns(address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }


  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
  
}

contract Vaquinha is Ownable {
    
    struct Request {
        string descricao;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public valorMinimo;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function Campanha(uint minimo, address creator) public {
        manager = creator;
        valorMinimo = minimo;
    }

    function Contribuir() public payable {
        require(msg.value > valorMinimo);

        approvers[msg.sender] = true;
        approversCount++;
    }

    function CriaCampanha(string memory description, uint value, address payable recipient) public restricted {
        Request memory newRequest = Request({
           descricao: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });

        requests.push(newRequest);
    }

    function aprovaCampanha(uint index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizaCampanha(uint index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function retornaResumo() public view returns (
      uint, uint, uint, uint, address
      ) {
        return (
          valorMinimo,
          address(this).balance,
          requests.length,
          approversCount,
          manager
        );
    }

    function retornaCampanhas() public view returns (uint) {
        return requests.length;
    }
}
