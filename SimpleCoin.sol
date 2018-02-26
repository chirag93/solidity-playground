pragma solidity ^0.4.0;
import './Ownable.sol';

contract SimpleCoin is Ownable{
    
    uint256 public totalSupply;
    uint balance;
    address owner;
    string public constant name = "Simple Token";
    string public constant symbol = "STT";
    
    struct Balance{
        uint balance;
    }



    modifier onlyAllowed(address _owner){
        if(contains(_owner)){
            _;
        }
    }
    mapping (address => bool) public Wallets;

    function setWallet(address _wallet)  public{
        Wallets[_wallet]=true;
    }

    function contains(address _wallet) view  public returns (bool){
        return Wallets[_wallet];
    }
    
    
    mapping(address => Balance) records;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
   


function SimpleCoin(uint256 _totalSupply) public{
    owner = msg.sender;
    totalSupply = _totalSupply;
    records[ msg.sender].balance = _totalSupply;

}
    
    
function totalSupply() constant public returns (uint256 ){
    return totalSupply;
}

function balanceOf(address _owner) constant public onlyAllowed(_owner) returns (uint256 )  {
    
    return records[_owner].balance;
}



 function transfer(address _to, uint256 _value) public returns (bool){
     if(_value < totalSupply){
     records[_to].balance = records[_to].balance + _value;
     address sender = msg.sender;
     records[sender].balance = records[sender].balance - balance;
     Transfer(sender,_to,_value);
     return true;
     }else{
         return false;
     }
     
 }
 



}
