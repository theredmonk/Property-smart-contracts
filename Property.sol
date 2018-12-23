pragma solidity ^0.4.24;

//author Susmit and Aditi


import "./ownable.sol";
import "./erc721.sol";
import "./safemath.sol";

contract Property is ERC721,Ownable {

    using SafeMath for uint256;
    event PropertyRegistered(string _name, string _location, uint _price);

    struct PropertyStruct {
        string nameId;
        string lctn;      //location of Tajmahal
        uint price;       // price of Tajmahal in ether
    }

    uint private count = 0;

    PropertyStruct[] public property;

    mapping (uint => address) public propertyToOwner;
    mapping (address => uint) ownerPropertyCount;



    //only one tajmahal can be created ever
    function mintToken(string _name,string _location,uint _price) public onlyOwner{
        require(count < 5);
        uint id = property.push(PropertyStruct(_name, _location, _price)) - 1;
        propertyToOwner[id] = msg.sender;
        ownerPropertyCount[msg.sender]++;
        emit PropertyRegistered( _name,_location,_price);
        count = count.add(1);
    }


    //function to sell tajmahal
    function buyProperty(uint _id) public payable {
        require(msg.value == property[_id].price * 10**18);
        address ownerP =  propertyToOwner[_id];
        ownerPropertyCount[ownerP] = ownerPropertyCount[ownerP].sub(1);
        ownerPropertyCount[msg.sender] = ownerPropertyCount[msg.sender].add(1);
        propertyToOwner[_id] = msg.sender;
    }

    function bidPropertyPrice(uint _prc,uint _id) public {
        require(msg.sender == propertyToOwner[_id]);
        property[_id].price = _prc;
    }

    function withdraw() external onlyOwner {
    owner.transfer(address(this).balance);
  }

  function balanceOf(address _owner) public view returns (uint256 _balance){
      return ownerPropertyCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner){
      return propertyToOwner[_tokenId];
  }

  function transfer(address _to, uint256 _tokenId) public{
      require( msg.sender == propertyToOwner[_tokenId] );
      ownerPropertyCount[_to] = ownerPropertyCount[_to].add(1);
      ownerPropertyCount[msg.sender] = ownerPropertyCount[msg.sender].sub(1);
      propertyToOwner[_tokenId] = _to;
      emit Transfer(msg.sender,_to,_tokenId);
  }


  //no implementation added
  function approve(address _to, uint256 _tokenId) public{
  }

  //no implementation added
  function takeOwnership(uint256 _tokenId) public {
  }



}

