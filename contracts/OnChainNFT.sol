// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./Base64.sol";

contract OnChainNFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  uint256 public cost = 0;
  uint256 public maxSupply = 10;
  uint256 public maxMintAmount = 1;

  constructor() ERC721("Web3Labs founder pass", "WLFP") {}

  // public
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    uint256 ballance = balanceOf(msg.sender);
    require(_mintAmount > 0);
    require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);
    require(ballance <= 0, "Already minted.");

    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function walletOfOwner(address _owner) public view returns (uint256[] memory) {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function buildImage() public pure returns(string memory) {
   return Base64.encode(bytes(abi.encodePacked(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 94.3 102.4">',
    '<text transform="translate(3 80)" style="font-size:91px;fill:#231815;font-family:AB_ootori-83pv-RKSJ-H,AB_ootori">',
    unicode'絆',
    '</text>',
    '<text ransform="translate(37 99)" style="font-size:11px;fill:none;stroke:#fff;font-family:AB-digicomb-83pv-RKSJ-H,AB-digicomb">',
    'Web3Labs',
    '</text>,'
    '<text transform="translate(37 99)" style="font-size:11px;fill:#231815;font-family:AB-digicomb-83pv-RKSJ-H,AB-digicomb">',
    'Web3Lab',
    '<tspan x="50.4" y="0" style="fill:#c30d23">',
    's',
    '</tspan>',
    '</text>',
    '<path d="M34 68h-9v-4h-4v-4h-4v-4h4v4h4v4h9v4Zm41-1h-8v-3h8v-4h4v-4h4v4h-4v4h-4ZM25 32h8v4h-8v4h-4v4h-4v-4h4v-4h4Zm33-4H42v-4h16v4ZM42 72h16v3H42v-3Zm23-26h3v8h-3v6h-3v3h-3v2h-3v-3h3v-2h3v-6h3v-8Zm-31 0v8h3v6h4v2h3v3h-3v-2h-4v-3h-3v-6h-3v-8h3ZM17 56h-4v-4H9v-4h3v-4h4v4h-3v4h4Zm48-10h-3v-6h-3v-2h-3v-3h4v2h2v3h3v6Zm-31 0v-6h3v-3h2v-2h5v2h-3v3h-4v6h-3Zm9-11v-3h13v3Zm1 30h12v3H44v-3Zm30-29h5v4h4v4h-4v-4h-5v-4Zm-8-4h-8v-3a2 2 0 0 1 0-1h8v4Zm8 4h-8v-4a4 4 0 0 0 1 0h7v4ZM42 72h-8v-4h8v4Zm16 0v-4h8v3h-7a3 3 0 0 0-1 1ZM42 29v3h-9v-3h8a3 3 0 0 1 1 0Zm41 15h4v4h-4Zm4 8v-4h5v4h-5Zm0 0v4h-4v-4h4Z" transform="translate(-5 1)" style="fill:#f39800"/>',
    '</svg>'
   )));
   }

   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    return string(abi.encodePacked(
      'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
        '{"name": "Web3Labs FounderPass',
        '", "description": "Test on-chain voting ticket'
        '", "image": "data:image/svg+xml;base64,',
        buildImage(),
        '"}'
        )))));
  }

  //only owner
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
 
  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}