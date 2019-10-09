pragma solidity 0.5.12;

//qualquer coisa
/* seu textão
bonito
aqui */


contract Aluguel {
    string public locatario;
    string public locador;
    uint256 private valor;
    uint256 constant NumeroMaximoLegaldeAlugueisParaMulta = 3;

    
    constructor(string memory nomeLocador, string memory nomeLocatario, uint256 valorDoAluguel) public {
        locador = nomeLocador;
        locatario = nomeLocatario; 
        valor = valorDoAluguel;
    }

    function ValorAtualdoaluguel() public view returns (uint256) {
        return valor;
    }
    
    function simulaMulta (uint256 mesesRestantes, uint256 totalMesesContrato) public view returns (uint256 valorMulta) {
        valorMulta = valor*NumeroMaximoLegaldeAlugueisParaMulta;
        valorMulta = valorMulta/totalMesesContrato;
        valorMulta = valorMulta*mesesRestantes;
        return valorMulta;
    }
    function reajustaAluguel(uint256 percentualReajuste) public {
        if (percentualReajuste > 20){
            percentualReajuste = 20;
        }
        uint256 valorDoAcrescimo = 0;
        valorDoAcrescimo = ((valor*percentualReajuste)/100);
        valor = valor + valorDoAcrescimo;
    }
    function aditamentoValorAluguel(uint256 valorCerto) public {
        valor = valorCerto;
    }
    function aplicaMulta(uint256 mesesRestantes, uint256 percentual) public{
        require(mesesRestantes<30, "Período de contrato inválido");
        for (uint i=1; i<mesesRestantes; i++) {
            valor = valor+((valor*percentual)/100);
        }
    }
}

