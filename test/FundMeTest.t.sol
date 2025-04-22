// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    function setUp() public {
        fundMe = new FundMe();
    }

    function testMinimumUSD() public view {
        assertEq(fundMe.MINIMUM_USDT(), 5e18);
    }
    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), address(this));
    }
    function testGetVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}

//forge test --match-test testGetVersion --fork-url $SEPOLIA_RPC_URL -vvvvv
// --match-test = -m