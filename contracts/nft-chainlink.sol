// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@chainlink/contracts/src/v0.8/AutomationCompatibleInterface.sol";

contract MyNFT is ERC721, VRFConsumerBase {
    // Variables for Chainlink VRF
    bytes32 internal keyHash;
    uint256 internal fee;

    // Traits
    struct Traits {
        uint256 energy;
        uint256 speed;
        // Add more traits as needed
    }

    // Mapping to store NFT traits
    mapping(uint256 => Traits) public tokenIdToTraits;

    // Event to log when an NFT is minted
    event Minted(uint256 tokenId, address owner);

    constructor() VRFConsumerBase(
        // Replace with actual Chainlink VRF contract address on Goerli
        0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D,
        // Replace with actual Chainlink VRF Key Hash
        bytes32("0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15")
    ) {
        keyHash = bytes32("0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15");
        fee = 0.1 * 10**18; // 0.1 LINK (Chainlink's native token)
    }

    // Mint function open to anyone
    function mintNFT() external {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK in contract");
        uint256 tokenId = totalSupply() + 1;
        // Request a random number from Chainlink VRF
        requestRandomness(keyHash, fee, tokenId);
    }

    // Callback function for Chainlink VRF
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 energy = randomness % 101; // Random energy value between 0 and 100
        uint256 speed = (randomness % 101 + 50) % 101; // Random speed value between 0 and 100

        Traits memory traits = Traits(energy, speed);
        tokenIdToTraits[requestId] = traits;

        _mint(msg.sender, requestId);
        emit Minted(requestId, msg.sender);
    }
}
