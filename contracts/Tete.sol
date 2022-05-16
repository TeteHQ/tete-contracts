// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title TetePool
 * @dev TetePool is a smart contract that allows users
 *  to create betting pools and stake on them.
 *  The smart contract will allow users to stake
 *  on the pools and the smart contract will use the outcome by the pool creator.
 */
contract Tete is ReentrancyGuard {
    // use SafeMath for calculations
    using SafeMath for uint256;

    /// Contracts Constants
    uint256 private constant MAX_POOLS = 10;
    uint256 private constant MAX_STAKERS_PER_POOLS = 10;
    uint256 private constant POOL_FEE = 0.03 ether;

    struct Stake {
        address staker;
        uint256 amount;
        uint256 prediction;
    }

    struct Pool {
        string evcid;
        uint256 minimumStake;
        uint256 totalStake;
        uint256 outcome;
        uint256[] predictions;
        bool isActive;
    }

    /// Contract Stats
    uint256 public poolCount;
    uint256 public activePools;
    mapping(uint256 => Pool) public pools;

    /// Contract state mappings
    mapping(uint256 => address) private creator;
    mapping(uint256 => Stake[]) private stakes;

    /// Contract Events
    event NewPool(string evcid, uint256 minimumStake, address owner);
    event NewStake(
        address staker,
        uint256 amount,
        uint256 prediction,
        uint256 poolId
    );
    event NewOutcome(uint256 poolId, uint256 prediction);

    /**
     * @dev Creates a new pool
     * @param _evcid The event id
     * @param _minimumStake The minimum stake amount
     */
    function createPool(string memory _evcid, uint256 _minimumStake)
        external
        payable
    {
        require(
            msg.value >= POOL_FEE,
            "Pool fee is needed for creating a pool"
        );

        uint256 _poolId = poolCount; // this does nothing but prevent limiting predictions

        pools[_poolId].evcid = _evcid;
        pools[_poolId].minimumStake = _minimumStake;
        pools[_poolId].isActive = true;
        poolCount++;
        activePools++;

        creator[_poolId] = msg.sender;
        emit NewPool(_evcid, _minimumStake, msg.sender);
    }

    /**
     * @dev Stakes on a pool
     * @param _poolId The pool id
     * @param _prediction The prediction
     * @return The stake id
     */
    function stake(uint256 _poolId, uint256 _prediction)
        external
        payable
        returns (uint256)
    {
        require(pools[_poolId].isActive, "Pool is not yet active, please wait");
        require(
            msg.value >= pools[_poolId].minimumStake,
            "Staked amount is too small for this pool"
        );

        stakes[_poolId].push(
            Stake({
                staker: msg.sender,
                amount: msg.value,
                prediction: _prediction
            })
        );

        pools[_poolId].totalStake += msg.value;
        pools[_poolId].predictions[_prediction] += msg.value;

        emit NewStake(msg.sender, msg.value, _prediction, _poolId);

        return stakes[_poolId].length - 1;
    }

    /**
     * @dev Sets the outcome of a pool
     * @param _poolId The pool id
     * @param _outcome The prediction outcome
     */
    function setOutcome(uint256 _poolId, uint256 _outcome) external payable {
        require(pools[_poolId].isActive, "Pool is not yet active, please wait");
        require(
            creator[_poolId] == msg.sender,
            "Only the pool creator can set the outcome"
        );
        require(
            pools[_poolId].outcome == 0,
            "Pool outcome has already been set"
        );
        require(
            pools[_poolId].outcome == 0,
            "Pool outcome has already been set"
        );

        pools[_poolId].outcome = _outcome;
        pools[_poolId].isActive = false;
        activePools--;

        emit NewOutcome(_poolId, _outcome);
    }

    /**
     * @dev pays out the stake of a pool if it matches outcome
     * @param _poolId The pool id
     * @param _stakeId The stake id
     */
    function claimStake(uint256 _poolId, uint256 _stakeId)
        external
        nonReentrant
    {
        require(!pools[_poolId].isActive, "Pool is still active, please wait");
        require(
            pools[_poolId].outcome == 0,
            "Pool outcome has not been set yet"
        );

        Stake memory _stake = stakes[_poolId][_stakeId];

        require(
            _stake.staker == msg.sender,
            "You don't have an active stake in this pool"
        );

        require(
            _stake.prediction == pools[_poolId].outcome,
            "You have not won the stake"
        );

        (bool paidOut, ) = payable(msg.sender).call{
            value: (
                _stake.amount.div(pools[_poolId].predictions[_stake.prediction])
            ).mul(pools[_poolId].totalStake)
        }("");
        require(paidOut, "Error occurred while paying out stake");
    }

    /**
     * @dev returns a list of msg.sender stakes
     */
    function getStakes(uint256 _poolId) external view returns (Stake[] memory) {
        return stakes[_poolId];
    }

    /**
     * @dev gets the stake info on a pool
     * @param _poolId The pool id
     * @param _stakeId The stake id
     */
    function getStake(uint256 _poolId, uint256 _stakeId)
        external
        view
        returns (Stake memory)
    {
        return stakes[_poolId][_stakeId];
    }

    /**
     * @dev gets the prediction of a stake
     * @param _poolId The pool id
     * @param _stakeId The stake id
     */
    function getPrediction(uint256 _poolId, uint256 _stakeId)
        external
        view
        returns (uint256)
    {
        return stakes[_poolId][_stakeId].prediction;
    }
}
