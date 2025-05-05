//get funds from users
// withdraw funds
//set a minimum value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; //version

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./priceConverter.sol";

//use errors naming with the name of the contract at first and then two underscore and then the name of the error
error FundMe__NotOwner();

contract FundMe {
    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    using PriceConverter for uint256;
    //constant, immutable

    uint256 public constant MINIMUM_USDT = 5e18;

    address[] private s_funders;

    address private immutable i_owner;

    AggregatorV3Interface private immutable s_priceFeed;

    mapping(address funder => uint256 amountFunded) private s_addressToAmountFunded;

    function fund() public payable {
        //allow users to send money
        //have a min money sent
        require(msg.value.getConversionRate(s_priceFeed) > MINIMUM_USDT, "didnt send enough eth"); //1e18 = 1 ETH // force to send money
        //revert undo any actions that have been done and undo the remaining gas back
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value;
        // s_addressToAmountFunded[msg.sender] += msg.value;  same as this
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner,"not owner!!");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        //same as this: require(revert FundMe__NotOwner()) in future
        _;
    }

    function withdraw() public onlyOwner {
        //for loop
        //(starting index, ending index, steps)
        // require(msg.sender == owner,"not owner!!");   use modifier instead
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        //withdraw funds

        //transfer
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"sendet fuck shod");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "callet fuck shod");
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        //withdraw funds

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "callet fuck shod");
    }

    //receive()
    // when someone send a transaction to contract without calling any function and sending any data

    receive() external payable {
        fund();
    }

    //fallback
    //when someone send a transaction to contract and sending data with it

    fallback() external payable {
        fund();
    }

    //if a contract doesnt have receive and just have fallback and someone send a transaction without data it calls fallback
    //if a contract doesnt have fallback and just have receive and someone send a transaction with data it throw errors

    //The receive function is specifically designed to handle Ether transfers without data and is automatically invoked when Ether.
    // The fallback function is used for handling calls with data or when the receive function is not defined. The fallback function can also handle Ether transfers with data.

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunderAddress(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
// storage
//immutable and constant dont take slot and just are in the byte code of contract

//arrays has a slot and their slot are the arrays length and also they have another slot with the
//address (keccak(slot) and the data of array)

//mappings slot is blank indicating that is mapping

//forge inspect FundMe storageLayout

//cast storage contractAddress 2(storageSlot)
