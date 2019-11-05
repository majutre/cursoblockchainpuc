pragma solidity 0.5.12;

contract AmigoSecreto{

    address payable dono;
    string[] private dadosParticipantes;
    address[] public addressParticipantes;
    bool public emAberto = true;

    event novoParticipante(address participante, string data);
    event ASDefinido(address amigoS, address para, string data);

    constructor() public{
        dono = msg.sender;
    }

  
    function Participar(string memory _data) public{
        require(emAberto);

        dadosParticipantes.push(_data);
        addressParticipantes.push(msg.sender);

        emit novoParticipante(msg.sender, _data);
    }

    
    function announce() public {
        require(msg.sender == dono);
        require(addressParticipantes.length >= 1);
        require(emAberto);
        emAberto = false;

        uint size = addressParticipantes.length;

       
        emit ASDefinido(addressParticipantes[0], addressParticipantes[size - 1], dadosParticipantes[size - 1]);

      
        for(uint i = 1; i < size; i++){
            
            emit ASDefinido(addressParticipantes[i], addressParticipantes[i - 1], dadosParticipantes[i - 1]);
        }

        
        dono.transfer(address(this).balance);
    }


    
    function reabrir() public{
        require(msg.sender == dono);
        emAberto = true;
    }
