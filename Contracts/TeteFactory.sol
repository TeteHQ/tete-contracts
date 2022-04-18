pragma solidity ^0.8.4;

import "./TetePool.sol";

contract TeteFactory{
 uint256 poolCounter;

struct bettingPool{
    address poolAddress;
    address owner;
}
  mapping(uint256=>bettingPool)public ListOfPools;

function CreateBettingPool()public {
     TetePool  collection = new TetePool();
     ListOfPools[poolCounter++]=bettingPool(address(collection),msg.sender);
}



}