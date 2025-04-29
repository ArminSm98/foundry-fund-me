// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; //version

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        //address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //abi
        (, int256 answer,,,) = priceFeed.latestRoundData();
        //the answer decimal 8
        //msg value decimal is 18 so we should use 1e10
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // 1 ETH?
        //2000_000000000000000000
        uint256 ethPrice = getPrice(priceFeed);
        //2000_000000000000000000 * 1_000000000000000000 / 1e18;

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
