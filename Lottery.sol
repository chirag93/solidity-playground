pragma solidity ^0.4.2;
// WARNING THIS CODE IS AWFUL, NEVER DO ANYTHING LIKE THIS
contract Oracle{
	uint8 seed;
	function Oracle(uint8 _seed){
		seed = _seed;
	}

	function getRandomNumber() external returns (uint256){
		return block.number % seed;
	}

}

// WARNING THIS CODE IS AWFUL, NEVER DO ANYTHING LIKE THIS

contract Lottery{
address public owner;
Oracle private oracle;
uint256 public endTime;

mapping(address=>uint256) public balances;
mapping (address=>string) public teamNames;
address [] public teams;
string [] private passwords;


event TeamRegistered(string name);
event TeamCorrectGuess(string name);
event AddressPaid(address sender, uint256 amount);
event resetOracle(uint8 _newSeed);

modifier onlyowner(){
	if (msg.sender==owner){
	_;
	}

}


// Constructor - set the owner of the contract
function lottery(){
	owner = msg.sender;
}

// initialise the oracle and lottery end time
function initialiseLottery(uint8 seed) onlyowner {
	oracle = new Oracle(seed);
	endTime = now + 7 days;
	teams.push(0x0);
	teamNames[0x0] = "Default Team";
	balances[0x0] = 13;

}

// reset the lottery
function reset(uint8 _newSeed) onlyowner {
	endTime = now + 7 days;
    resetOracle(_newSeed);
}

// register a team
function registerTeam(address _walletAddress,string _teamName, string _password){
	teams.push(_walletAddress);
	passwords.push(_password);
	teamNames[_walletAddress] = _teamName;
	// give team a starting balance of 6
	balances[_walletAddress] = 6;
	TeamRegistered(_teamName);
}


// this would check that sufficient ether had been sent, disabled for testing
function checkThatPaid() returns (bool){
	return true;
}


// make your guess , return a success flag
function makeAGuess(address _team,uint256 _guess) external payable  returns (bool){

	if (checkThatPaid()==false){
		return false;
	}

	// get a random number
	uint256 random = oracle.getRandomNumber();
	if(random==_guess){
		// add 100 points to team score
		balances[_team]=+100;
		TeamCorrectGuess(teamNames[_team]);
        return true;
	}
	else{
	    // wrong answer  - subtract 3 points
		balances[_team]-=3;
		return false;
	}
}

// once the lottery has finished pay out the best teams
function payoutWinningTeam(uint256 _teamNumber) external onlyowner returns (bool){

 if(balances[teams[_teamNumber]]>0){
    // send every winning team some ether
    bool sent =  teams[_teamNumber].send(balances[teams[_teamNumber]]);
    // reset balance
    balances[teams[_teamNumber]] = 0;
    return sent;
 }


}

function getTeamCount() constant returns (uint256){
	return teams.length;
}

function getTeamDetails(uint256 _num) constant returns(string,address,uint256){
	address teamAddress = teams[_num];
	string name = teamNames[teamAddress];
	uint256 score = balances[teamAddress];

	return(name,teamAddress,score);
}

function ResetOracle  (uint8 _newSeed) internal {
    oracle = new Oracle(_newSeed);
}

// catch any ether sent to the contract
function() payable {
	balances[msg.sender] += msg.value;
	AddressPaid(msg.sender,msg.value);
 }


}
