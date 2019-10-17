mapping(<tipo de dado que é o id do elemento na coleção> => <tipo do dado a ser armazenado>) public/pvt <nome da variável>;
        ^ex.: string, uint , address etc.

==> adicionar um item no mapping:

<nome da variável do tipo mapping>[<dado que será a chave(índice)>] = <valor que será armazenado no mapping>;
ex.: listaOfertantes[endereço] = ofertanteX;
-//-

Exclamação é tipo uma negação. Ex.:
(condição) == true é a mesma coisa que (!condicao) == false.

-//-

<nome da struct>("<atributos da sequencia em que for definido na struct>")
^sintaxe de como criar uma variável cujo tipo seja uma struct e preencher os seus atributos.

-//-
        
        pode ter mais de um mapping?
        como funciona struct na prática?pragma solidity ^0.5.12;

contract Leilao {

    struct Ofertante {
        string nome;
        address payable enderecoCarteira;
        uint oferta;
        bool jaFoiReembolsado;
    }
    
    address payable public contaGovernamental;
    uint public prazoFinalLeilao;

    address public maiorOfertante;
    uint public maiorLance;

    mapping(address => Ofertante) public listaOfertantes;
    Ofertante[] public ofertantes;
    //podemos usar ou mapping ou array, mas tb podemos usar os dois.

    bool public encerrado;

    event novoMaiorLance(address ofertante, uint valor);
    event fimDoLeilao(address arrematante, uint valor);

    modifier somenteGoverno {
        require(msg.sender == contaGovernamental, "Somente Governo pode realizar essa operacao");
        _;
    }

    constructor(
        uint _duracaoLeilao,
        address payable _contaGovernamental
    ) public {
        contaGovernamental = _contaGovernamental;
        prazoFinalLeilao = now + _duracaoLeilao;
    }


    function lance(string memory nomeOfertante, address payable enderecoCarteiraOfertante) public payable {
        require(now <= prazoFinalLeilao, "Leilao encerrado.");
        require(msg.value > maiorLance, "Ja foram apresentados lances maiores.");
        
        maiorOfertante = msg.sender;
        maiorLance = msg.value;
        
        //Realizo estorno das ofertas aos perdedores
        /*
        For é composto por 3 parametros (separados por ponto virgula)
            1o  é o inicializador do indice
            2o  é a condição que será checada para saber se o continua 
                o loop ou não 
            3o  é o incrementador (ou decrementador) do indice
        */
        for (uint i=0; i<ofertantes.length; i++) {
            Ofertante memory ofertantePerdedor = ofertantes[i];
            if (!ofertantePerdedor.jaFoiReembolsado) {
                ofertantePerdedor.enderecoCarteira.transfer(ofertantePerdedor.oferta);
                ofertantePerdedor.jaFoiReembolsado = true;
            }
        }
        
        //Crio o ofertante
        Ofertante memory concorrenteVencedorTemporario = Ofertante(nomeOfertante, enderecoCarteiraOfertante, msg.value, false);
        
        //Adiciono o novo concorrente vencedor temporario no array de ofertantes
        ofertantes.push(concorrenteVencedorTemporario);
        
        //Adiciono o novo concorrente vencedor temporario na lista (mapa) de ofertantes
        listaOfertantes[concorrenteVencedorTemporario.enderecoCarteira] = concorrenteVencedorTemporario;
    
        emit novoMaiorLance (msg.sender, msg.value);
    }

   
    function finalizaLeilao() public somenteGoverno {
       
        require(now >= prazoFinalLeilao, "Leilao ainda nao encerrado.");
        require(!encerrado, "Leilao encerrado.");

        encerrado = true;
        emit fimDoLeilao(maiorOfertante, maiorLance);

        contaGovernamental.transfer(address(this).balance);
    }
}
