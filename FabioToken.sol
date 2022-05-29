pragma solidity ^0.5.0;

contract FabioToken {
    
    //Vamos inicializar as variáveis e eventos necessários para implementar o padrão de token 

    //Declaração de variáveis
    string public name = "Fabio Token"; //Detém o nome do token
    string public symbol = "FST "; //Detém o símbolo do token
    string public standard = "Fabio Token v1.0"; //Detém a versão do token
    uint256 public totalSupply; //Detém o suppy total do token

    //Este evento é sempre disparado em uma chamada bem sucedida do
    //métodos transfer e transferfrom
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    //Este evento é sempre disparado em uma chamada bem sucedida do método approve
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    //Isso cria um mapeamento com todos os saldos
    mapping(address => uint256) public balanceOf;
    //Isso cria um mapeamento de contas com concessões
    //concessão - permite que uma conta transfira tokens em nome de outra conta
    mapping(address => mapping(address => uint256)) public allowance;


    //definimos o construtor do contrato de token
    //Nós criamos uma quantidade especificada de tokens e transferimos-os para o proprietário do token.
    constructor(uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply; //Transfere todos os tokens para o proprietário
        totalSupply = _initialSupply; //Define a oferta total de tokens
    }

    /*
    Transfere uma quantidade especificada de tokens para um endereço.
    Esta função basicamente deduz uma quantidade (_value) de qualquer endereço chamador do método. 
    O valor deduzido é então adicionado ao endereço especificado no argumento (_to)
    */
    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[msg.sender] >= _value, "Não há saldo suficiente");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /*
    Permite que uma conta (_spender) saque a partir de outra conta (endereço chamador do método) várias vezes,
     até o valor especificado (_value).   Esse método é o que torna o método transferFrom possível
     porque uma conta é capaz de autorizar outra conta a fazer transferências em seu nome.  
    */
    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /*
    Transfere uma quantidade especificada de tokens de um endereço para outro.
    Este método difere do método transfer no sentido de que permite que uma conta transfira tokens em nome de outra conta.
    Para alcançar essa funcionalidade, uma concessão (allowance) é aprovada pelo destinatário (_to) de antemão. 
    Todas as chamadas para esta função então usam a concessão pré-aprovada para fazer transferências.
    */

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(
            balanceOf[_from] >= _value,
            "_from não tem tokens suficientes"
        );
        require(
            allowance[_from][msg.sender] >= _value,
            "Spender limite excedido"
        );
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
