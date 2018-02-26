pragma solidity ^0.4.0;
contract Score{
    uint myscrore;
    address owner;
    string description;
    
    event ScoreSet(uint);
    
    modifier onlyOwner(){
        if(msg.sender==owner){
            _;
        }
    }
    
    function Score() public{ 
        owner = msg.sender;
    }
    
    function getScore() public view returns (uint) {
        
        return myscrore;
        
    }
    
    function setScore(uint _score) external { //convention to add  _  for the arguements
        myscrore = _score;
        ScoreSet(_score);
    }
    
    function setDescription(string _description) public onlyOwner{
        description = _description;
    }
    
    
}
