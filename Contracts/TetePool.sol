pragma solidity 0.8.13;

contract TetePool{
    uint256 noOfPools;
    //categories
    //outcome type
    //event name
    //minimum amount
    //Owner
    constructor(){
    }
    struct stakeProp{
        address staker;
        bytes32 prediction;
        uint256 amount;
    }

    struct  Pool{
        bytes32 eventNameURI;
        uint256 minimumStakingAmount;
        address owner;
        bytes32 eventOutcome;
        bool isEventOn;
        uint256 noOfStakers;
        uint256 TotalOfYesStakedAmount;
        uint256 TotalOfNoStakedAmount;
        uint256 VariableTotalOfYesStakedAmount;
        uint256 VaribleTotalOfNoStakedAmount;
       //mapping (address=>uint256) noStakers;
       //mapping (address=>uint256) yesStakers;
    }
            Pool[] ListOfPools;
            mapping(uint256 => mapping(uint256=>stakeProp)) public ListOfStaker;
           // Pool[] public PoolsArray;

        //Create Pool
        function CreatePool(uint256 _minimumStakingAmount,bytes32  _eventNameURI )public payable {
            require(msg.value>=0.03 ether,"0.03 ether is needed for Creating Pool");
            noOfPools++;
            ListOfPools.push(Pool({
                eventNameURI:_eventNameURI,
                minimumStakingAmount: _minimumStakingAmount,
                owner: msg.sender,
                eventOutcome: "",
                isEventOn: true,
                noOfStakers:0,
                TotalOfYesStakedAmount:0,
                TotalOfNoStakedAmount:0,
                VariableTotalOfYesStakedAmount:0,
                VaribleTotalOfNoStakedAmount:0

            }));
            //noOfPools++;
        }
          
        function stake(bytes32 _prediction, uint256 _amount,uint256 _poolId)public payable {
            require(msg.value==ListOfPools[_poolId].minimumStakingAmount,"Below Minimum Staking Amount");
             require(ListOfPools[_poolId].isEventOn==false,"Event is Still Ongoing");
            require(ListOfPools[_poolId].isEventOn==true,"Event has ended");
            uint256 stakerCounter=ListOfPools[_poolId].noOfStakers++;
            if(_prediction=="yes"){
                ListOfStaker[_poolId][stakerCounter]=stakeProp({
               staker:msg.sender,
               prediction:_prediction,
               amount:_amount
           });  
           ListOfPools[_poolId].TotalOfYesStakedAmount=ListOfPools[_poolId].TotalOfYesStakedAmount+_amount;
           // VariableTotalOfYesStakedAmount
           ListOfPools[_poolId].VariableTotalOfYesStakedAmount=ListOfPools[_poolId].VariableTotalOfYesStakedAmount+_amount;
            }
             if(_prediction=="no"){
                ListOfStaker[_poolId][stakerCounter]=stakeProp({
               staker:msg.sender,
               prediction:_prediction,
               amount:_amount
           });  
           ListOfPools[_poolId].TotalOfNoStakedAmount=ListOfPools[_poolId].TotalOfNoStakedAmount+_amount;
            ListOfPools[_poolId].VaribleTotalOfNoStakedAmount=ListOfPools[_poolId].VaribleTotalOfNoStakedAmount+_amount;
            }
           
        }
        // setOutCome
        function setEventOut(uint256 _poolId,bytes32 _eventOutCome)public{
            //must be owner
            require(msg.sender==ListOfPools[_poolId].owner,"Only Pool Creator can call this function");
            //must not be ended
            require(ListOfPools[_poolId].isEventOn==false,"Event is Still Ongoing");
            //must not be already set
            require(ListOfPools[_poolId].eventOutcome=="","Event Outcome has been set Already");
            // set Outcome
            ListOfPools[_poolId].eventOutcome=_eventOutCome;

        }
//        claim win Staker
        function claimStake(uint256 _poolId)public payable{
            //confirm if outcome has happened
            stakeProp[] memory winnersArray;
            stakeProp memory UserData;
            uint256 AmountofWinner;
            uint256 TotalAmountOfWinnerStake;
            uint256 TotalAmountStaked=ListOfPools[_poolId].TotalOfYesStakedAmount+ListOfPools[_poolId].TotalOfNoStakedAmount;
            bool ClaimerIsAwinner=false;
            require(ListOfPools[_poolId].eventOutcome!="","Event Outcome is not set Yet");
            //get Winners
           for(uint256 i=1;i<=ListOfPools[_poolId].noOfStakers;i++){
                //get winners by pool Id
               if(ListOfStaker[_poolId][i].prediction==ListOfPools[_poolId].eventOutcome){
                   uint l = winnersArray.length;
                 winnersArray[l] = (ListOfStaker[_poolId][i]);
                 AmountofWinner++;
                 TotalAmountOfWinnerStake=ListOfStaker[_poolId][i].amount+TotalAmountOfWinnerStake;
               }
           }
            for(uint256 i=1;i<=ListOfPools[_poolId].noOfStakers;i++){
                //get winners by pool Id
               if(ListOfStaker[_poolId][i].prediction==ListOfPools[_poolId].eventOutcome){
                 //ListOfStaker[_poolId][i]
                 if(ListOfStaker[_poolId][i].staker==msg.sender){
                   ClaimerIsAwinner=true;
                   UserData=ListOfStaker[_poolId][i];
                 }
               
               }
           }
           require(ClaimerIsAwinner==true,"Your Prediction was wrong");
              //get Total of Winner staked Amount and get percentage
              uint256 ClaimerStakingPercentage=UserData.amount/TotalAmountOfWinnerStake*100;
              //get Losers Total staked amount
              uint256 LoooserTotalAmount=TotalAmountStaked-TotalAmountOfWinnerStake;
             uint256 ClaimerRecievedAmount=ClaimerStakingPercentage/100*LoooserTotalAmount;
             
              //remove 2% for streetwallet
              //remove 2% for Tete
              // remove 2% for creator


            //pay winners
        }
        //get All STakers By Prediction
        function getStakers(uint256 _poolId,bytes32 _predictionType)public view  returns(stakeProp[] memory) {
          stakeProp[] memory  StakerArray;
          for(uint256 i=1;i<=ListOfPools[_poolId].noOfStakers;i++){
              //stakeProp memory newStakerArray;
              //newStakerArray=pool.Staker[i];
             if(ListOfStaker[_poolId][i].prediction==_predictionType){
                 uint l = StakerArray.length;
                 StakerArray[l] = (ListOfStaker[_poolId][i]);
             }
          }
          return StakerArray;
        }
        //get Stakers By Address
        function getStakesByAddress(address _staker)public view  returns(stakeProp[] memory) {
            stakeProp[] memory  StakeArray;
          for(uint256 i=1;i<=noOfPools;i++){
              for(uint256 j=1;j<=ListOfPools[i].noOfStakers;j++){
                  if(ListOfStaker[i][j].staker==_staker){
                 uint l = StakeArray.length;
                 StakeArray[l] = (ListOfStaker[i][j]);
             }
               }
                 }
          return StakeArray;
        }
        function getUserCreatedPools(address _poolCreator)public view  returns(Pool[] memory){
            Pool[] memory PoolsArray;
            for(uint256 i=1;i<=noOfPools;i++){
                if(ListOfPools[i].owner==_poolCreator){
                    uint index=PoolsArray.length;
                    PoolsArray[index]=(ListOfPools[i]);
                }
            }
            return PoolsArray;
        }
        function getAmountStaked(uint256 _poolId,bytes32 _predictionType)public view  returns(uint256) {
           
             //create Increment Variable
             uint256 TotalStaked;
            //loop through staker Array
            for(uint256 i=0;i<ListOfPools[_poolId].noOfStakers;i++){
               // pool.Staker[i] memory stakersType;
                if(ListOfStaker[_poolId][i].prediction==_predictionType){
                    TotalStaked=ListOfStaker[_poolId][i].amount+TotalStaked;
                }
            }
            //return array of staker
            return TotalStaked;
        }
    //     //claim fund Pool Creator
    //     //claim Charges TeteAdmin


      

    // //end Pool
    function endStake(uint256 _poolId)public{
        require(msg.sender==ListOfPools[_poolId].owner,"Only Pool Owner can call ");
        //Event should have ended
        require(ListOfPools[_poolId].eventOutcome!="","Event Outcome is not set Yet");
        ListOfPools[_poolId].isEventOn=false;
    }
   

}