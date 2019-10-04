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

    
        constructor( string memory nomeLocador, string memory nomeLocatario, uint256 Valordoaluguel)
public {
        locador = nomeLocador;
        locatario = nomeLocatario; 
        valor = Valordoaluguel;
}

        function Valordoaluguel() public view returns (uint256) {return valor;
}

        function simulaMulta (uint256 mesesRestantes,
                            uint256 totalMesesContrato)
        public
        view
        returns (uint256 valorMulta) {
            valorMulta = valor*NumeroMaximoLegaldeAlugueisParaMulta;
            valorMulta = valorMulta/totalMesesContrato;
            valorMulta = valorMulta*mesesRestantes;
            
        return valorMulta;
}


}
