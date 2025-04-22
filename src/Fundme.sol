//get funds from users 
// withdraw funds
//set a minimum value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; //version

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./priceConverter.sol";

//use errors naming with the name of the contract at first and then two underscore and then the name of the error
error FundMe__NotOwner();

contract FundMe{
    constructor(){
        i_owner = msg.sender;
    }

    using PriceConverter for uint256;
    //constant, immutable
    uint256 public constant MINIMUM_USDT = 5e18 ;
    
    address[] public funders;

    address public immutable i_owner;

    mapping(address funder=> uint256 amountFunded) public addressToAmountFunded;
    function fund() public payable {
        //allow users to send money
        //have a min money sent
    require(msg.value.getConversionRate() > MINIMUM_USDT, "didnt send enough eth"); //1e18 = 1 ETH // force to send money
    //revert undo any actions that have been done and undo the remaining gas back
    funders.push(msg.sender);
    addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    // addressToAmountFunded[msg.sender] += msg.value;  same as this



    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
        
    function withdraw( ) public onlyOwner{
        //for loop
        //(starting index, ending index, steps)
        // require(msg.sender == owner,"not owner!!");   use modifier instead
        for (uint256 funderIndex = 0; funderIndex< funders.length ; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        //withdraw funds

        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"sendet fuck shod");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"callet fuck shod");

    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner,"not owner!!");
        if(msg.sender == i_owner){
            revert FundMe__NotOwner();
        }
        //same as this: require(revert FundMe__NotOwner()) in future
        _;
    }

    //receive()
    // when someone send a transaction to contract without calling any function and sending any data
    receive() external payable{
        fund();
    }
    //fallback
    //when someone send a transaction to contract and sending data with it
    fallback() external payable{
        fund();
    }

    //if a contract doesnt have receive and just have fallback and someone send a transaction without data it calls fallback
    //if a contract doesnt have fallback and just have receive and someone send a transaction with data it throw errors

    //The receive function is specifically designed to handle Ether transfers without data and is automatically invoked when Ether.
    // The fallback function is used for handling calls with data or when the receive function is not defined. The fallback function can also handle Ether transfers with data.


}