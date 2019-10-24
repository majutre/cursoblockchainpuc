pragma solidity 0.5.11;

// Token é tipo uma rifa, uma representação de um valor.
// O código abaixo é um padrão. Todos os contratos que seguem esse padrão são chamados de ERC20.
//Interface: funções e campos que devem necessariamente ser aplicadas no contrato.

/* LER:
https://eips.ethereum.org/EIPS/eip-20
https://guiadobitcoin.com.br/o-que-sao-tokens-erc-20/

*/

contract ERC20Interface {
    function totalSupply() public view returns(uint amount);
    function balanceOf(address tokenOwner) public view returns(uint balance);
    function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining);
    // ^retorna o valor que o spender tem direito a gastar (os X tokens).
    function transfer(address to, uint tokens) public returns(bool status);
    function approve(address spender, uint limit) public returns(bool status);
  //  ^ o approve é a autorização dada ao spender para que ele possa transferir em meu nome X tokens.
    function transferFrom(address from, address to, uint amount) public returns(bool status);
 //   ^ delega a venda de X Tokens a alguém. to=para quem vai; from=seria o dono do contrato.
    function name() public view returns(string memory tokenName);
    function symbol() public view returns(string memory tokenSymbol);

    event Transfer(address from, address to, uint amount);
    //^emitido quando há uma transferência. Quem mandou para aonde e quanto.
    event Approval(address tokenOwner, address spender, uint amount);
    //^o sender aprova ao spender X tokens.
}

contract Owned {
    address payable contractOwner;

    constructor() public { 
        contractOwner = msg.sender; 
    }
    
    function whoIsTheOwner() public view returns(address) {
        return contractOwner;
    }
}


contract Mortal is Owned  {
    function kill() public {
        if (msg.sender == contractOwner) {
            selfdestruct(contractOwner);
        }
    }
}

contract TicketERC20 is ERC20Interface, Mortal {
    string private myName;
    string private mySymbol;
    uint private myTotalSupply;
    uint8 public decimals;

    mapping (address=>uint) balances;
    mapping (address=>mapping (address=>uint)) ownerAllowances;

    constructor() public {
        myName = "Maju";
        mySymbol = "TokenMaju";
        myTotalSupply = 1000000;
        decimals = 0;
        balances[msg.sender] = myTotalSupply;
        //^quem publicou o contrato tem o supply de X tokens.
    }

    function name() public view returns(string memory tokenName) {
        return myName;
    }

    function symbol() public view returns(string memory tokenSymbol) {
        return mySymbol;
    }

    function totalSupply() public view returns(uint amount) {
        return myTotalSupply;
    }

    function balanceOf(address tokenOwner) public view returns(uint balance) {
        require(tokenOwner != address(0));
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns(uint balanceRemaining) {
        return ownerAllowances[tokenOwner][spender];
    }

    function transfer(address to, uint amount) public hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool status) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint limit) public returns(bool status) {
        ownerAllowances[msg.sender][spender] = limit;
        emit Approval(msg.sender, spender, limit);
        return true;
    }

    function transferFrom(address from, address to, uint amount) public 
    hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)
    returns(bool status) {
        balances[from] -= amount;
        balances[to] += amount;
        ownerAllowances[from][msg.sender] = amount;
        emit Transfer(from, to, amount);
        return true;
    }

    modifier hasEnoughBalance(address owner, uint amount) {
        uint balance;
        //^variável para saldo
        balance = balances[owner];
        //^"arquivo" chamado balance. A conta a ser mostrada o saldo é do owner.
        require (balance >= amount); 
        _;
    }
// ^deve ter balance suficiente
    modifier isAllowed(address spender, address tokenOwner, uint amount) {
        require (amount <= ownerAllowances[tokenOwner][spender]);
    //^verifica se o token owner (endereço) ou spender (endereço) tem fundos para realizar a operação.
        _;
    }
// ^deve ter permissão
    modifier tokenAmountValid(uint amount) {
        require(amount > 0);
        _;
    }

}
// ^o valor deve ser válido
    }
}
