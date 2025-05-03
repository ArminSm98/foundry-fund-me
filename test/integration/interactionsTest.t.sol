// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract InteractionTest is Test {
    FundMe fundMe;
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() public {
        fundMe = new DeployFundMe().run();
    }

    function testUserCanFundAndOwnerWithdraw() public {

        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundme(address(fundMe));

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundme(address(fundMe));

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;


        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingFundMeBalance + startingOwnerBalance
        );
    }
}
