pragma solidity ^0.8.4;

contract TetePool{
    uint EventCounter;
    uint stakersCounter;

    struct subevent{
        string name;
        bytes32 Description;
        bool Win;
        bool Loose;
        bool Draw;
        bool ended;
    }

    struct stake{
        uint amount;
        uint subeventId;
        address staker;
    }
    mapping (uint256=>subevent) public ListOfsubevent;
    mapping (address=>stake)public ListOfStakers;
    mapping(uint=>address)public IdToAddress;
  

    function createSubEvents(string memory name,bytes32  description,bool win,bool Loose,bool Draw,bool _ended) public {
            EventCounter++;
           ListOfsubevent[EventCounter]=subevent(name,description,win,Loose,Draw,_ended);
    }
    function CreateStake(uint amount,uint _subeventId)public{
        stakersCounter++;
        ListOfStakers[msg.sender]=stake(amount,_subeventId,msg.sender);
        IdToAddress[stakersCounter]=msg.sender;
    }
    function Unstake(uint id)public {
         delete ListOfStakers[msg.sender];
          delete IdToAddress[id];
         stakersCounter--;
    }
    function endEvent(uint _id)public {
        subevent  storage Subevent = ListOfsubevent[_id];
            Subevent.ended=true;

    }

    
   

}