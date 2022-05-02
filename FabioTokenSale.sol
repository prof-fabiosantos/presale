pragma solidity ^0.5.0;

import "./FabioToken.sol";

contract FabioTokenSale {
    address payable admin; //endereço do administrador
    FabioToken public tokenContract; //referência do contrato do token
    uint256 public tokenPrice; //preço do token
    uint256 public tokensSold; //quantidade de tokens vendidos

    //Evento que é sempre disparado quando uma compra de token é realizada
    event Sell(address _buyer, uint256 _amount);

    //método construtor
    constructor(FabioToken _tokenContract, uint256 _tokenPrice) public {
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    /*
    Permite que uma conta (endereço chamador do método) compre uma determinada quantidade de tokens
    */

    function buyTokens(uint256 _numberOfTokens) public payable {
        require(
            msg.value == _numberOfTokens * tokenPrice,
            "Número de tokens não corresponde ao valor"
        );
        require(
            tokenContract.balanceOf(address(this)) >= _numberOfTokens,
            "Contrato não tem tokens suficientes"
        );
        require(
            tokenContract.transfer(msg.sender, _numberOfTokens),
            "Algum problema com a transferência de tokens"
        );
        tokensSold += _numberOfTokens;
        emit Sell(msg.sender, _numberOfTokens);
    }


    function _forwardFunds() internal {
     admin.transfer(msg.value);
    }

    /*
    Permite que uma conta (somente o admnistrador) finalize a venda de tokens e transfira tokens para a conta do admim
    */

    function endSale() public {
        require(msg.sender == admin, "Apenas o administrador pode chamar essa função");
        require(
            tokenContract.transfer(
                msg.sender,
                tokenContract.balanceOf(address(this))
            ),
            "Incapaz de transferir tokens para administrador"
        );
        // destroy contract
        selfdestruct(admin);
    }
}
