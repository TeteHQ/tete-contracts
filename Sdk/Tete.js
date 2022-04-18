const address = "0x7d77C97d0746bc96C07bf43B312EB2803bb4bba3";
const abi = [
  "function ListOfPools(uint256) view returns (address poolAddress, address owner)"
];

async function ListOfPools() {
	const contract = new ethers.Contract(address, abi, signer);   
	const result = await contract.functions.ListOfPools(0);

	console.log("result", result);
}

ListOfPools();
const address = "0x1B40C05f898460E28E7295e99a37C501ff0e3960";
const abi = [
  "function CreateBettingPool()"
];

async function CreateBettingPool() {
	const contract = new ethers.Contract(address, abi, signer);   
	const tx = await contract.functions.CreateBettingPool();

	const receipt = await tx.wait();
	console.log("receipt", receipt);
}

CreateBettingPool();





















const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function ListOfsubevent(uint256) view returns (string name, bytes32 Description, bool Win, bool Loose, bool Draw, bool ended)"
];

async function ListOfsubevent() {
	const contract = new ethers.Contract(address, abi, signer);   
	const result = await contract.functions.ListOfsubevent(null);

	console.log("result", result);
}

ListOfsubevent();


const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function ListOfStakers(address) view returns (uint256 amount, uint256 subeventId, address staker)"
];

async function ListOfStakers() {
	const contract = new ethers.Contract(address, abi, signer);   
	const result = await contract.functions.ListOfStakers(null);

	console.log("result", result);
}

ListOfStakers();

const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function IdToAddress(uint256) view returns (address)"
];

async function IdToAddress() {
	const contract = new ethers.Contract(address, abi, signer);   
	const result = await contract.functions.IdToAddress(null);

	console.log("result", result);
}

IdToAddress();

const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function Unstake(uint256 id)"
];

async function Unstake() {
	const contract = new ethers.Contract(address, abi, signer);   
	const tx = await contract.functions.Unstake(null);

	const receipt = await tx.wait();
	console.log("receipt", receipt);
}

Unstake();



const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function endEvent(uint256 _id)"
];

async function endEvent() {
	const contract = new ethers.Contract(address, abi, signer);   
	const tx = await contract.functions.endEvent(null);

	const receipt = await tx.wait();
	console.log("receipt", receipt);
}

endEvent();




const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function createSubEvents(string name, bytes32 description, bool win, bool Loose, bool Draw, bool _ended)"
];

async function createSubEvents() {
	const contract = new ethers.Contract(address, abi, signer);   
	const tx = await contract.functions.createSubEvents(null,null,null,null,null,null);

	const receipt = await tx.wait();
	console.log("receipt", receipt);
}

createSubEvents();


const address = "0x5bc74Bb8452dE47B5fA0A89152727Eb662Cf9D88";
const abi = [
  "function createSubEvents(string name, bytes32 description, bool win, bool Loose, bool Draw, bool _ended)"
];

async function createSubEvents() {
	const contract = new ethers.Contract(address, abi, signer);   
	const tx = await contract.functions.createSubEvents(null,null,null,null,null,null);

	const receipt = await tx.wait();
	console.log("receipt", receipt);
}

createSubEvents();