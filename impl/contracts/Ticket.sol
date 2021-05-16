// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IERC2135.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

/** A reference implementation of EIP-2135
 *
 * For simplicity, this reference implementation creates a super simple `issueTicket` function without
 * restriction on who can issue new tickets and under what condition a ticket can be issued.
 */
contract Ticket is IERC2135, IERC2135Issuable, IERC721, IERC721Metadata {

  address private issuer;

  mapping(uint256 => uint256) private ticketStates; /* 0 = unissued, 1 = issued, unconsumed, 2 = consumed); */
  mapping(uint256 => address) private ticketHolders;
  mapping (address => uint256) private _balances; // TODO take care of balance

  constructor() {
    issuer = msg.sender;
  }
  
  /** IERC2135 */
  event OnConsumption(uint256 _tockenId, address _consumer);

  /** IERC2135 */
  function consume(uint256 _ticketId, address _consumer) override external {
    require (_consumer == msg.sender, "Consumer must be the sender themselves in this contract.");
    require (ticketHolders[_ticketId] == msg.sender, "Only the current ticket holder can request to consume a ticket");
    require (ticketStates[_ticketId] == 1, "The ticket needs to be issued but not consumed yet.");
    ticketStates[_ticketId] = 2;
    _balances[_consumer] --;
    emit OnConsumption(_ticketId, msg.sender);
  }

  /** IERC2135 */
  function isConsumable(uint256 _ticketId) override external view returns (bool consumable) {
    return ticketStates[_ticketId] == 1;
  }

    
  /** IERC2135Issuable */
  function issue(uint256 _ticketId, address _receiver) override external {
    require (msg.sender == issuer, "Only ticket issuer can issue ticket.");
    require (ticketStates[_ticketId] == 0, "The ticket address has been issued and not consumed yet, it cannot be issued again."); // ticket needs to be not issued yet;
    ticketStates[_ticketId] = 1;
    ticketHolders[_ticketId] = _receiver;
    _balances[_receiver] ++;
    emit Issue(_ticketId, _receiver);
  }

  function _transferFrom(address _from, address _to, uint256 _ticketId) internal virtual {
    require(_from == msg.sender, "The sender must be the source of transfer.");
    require(_from == ticketHolders[_ticketId], "The sender must hold the ticket.");
    require(1 == ticketStates[_ticketId], "The ticket must be issued but not consumed.");
    ticketHolders[_ticketId] = _to;
    _balances[_to] ++;
    _balances[_from] --;
    emit Transfer(_from, _to, _ticketId);
    return;
  }


  function transferFrom(address _from, address _to, uint256 _ticketId) public override {
    _transferFrom(_from, _to, _ticketId);
  }

  /**
    * @dev Returns the number of tokens in ``owner``'s account.
    */
  function balanceOf(address owner) override external view returns (uint256 balance) {
    return _balances[owner];
  }

  /**
    * @dev Returns the owner of the `tokenId` token.
    *
    * Requirements:
    *
    * - `tokenId` must exist.
    */
  function ownerOf(uint256 tokenId) override external view returns (address owner) {
    return ticketHolders[tokenId];
  }

  /**
    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
    *
    * Requirements:
    *
    * - `from` cannot be the zero address.
    * - `to` cannot be the zero address.
    * - `tokenId` token must exist and be owned by `from`.
    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    *
    * Emits a {Transfer} event.
    */
  function safeTransferFrom(address from, address to, uint256 tokenId) override external {
      // In our simplified implementation, we just call transferFrom;
      _transferFrom(from, to, tokenId);
}

  /**
    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
    * The approval is cleared when the token is transferred.
    *
    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
    *
    * Requirements:
    *
    * - The caller must own the token or be an approved operator.
    * - `tokenId` must exist.
    *
    * Emits an {Approval} event.
    */
  function approve(address to, uint256 tokenId) override external {
    require(false, "Our contract doesn't support approval");
  }

  /**
    * @dev Returns the account approved for `tokenId` token.
    *
    * Requirements:
    *
    * - `tokenId` must exist.
    */
  function getApproved(uint256 tokenId) override external view returns (address operator) {
    require(false, "Our contract doesn't support approval");
  }

  /**
    * @dev Approve or remove `operator` as an operator for the caller.
    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
    *
    * Requirements:
    *
    * - The `operator` cannot be the caller.
    *
    * Emits an {ApprovalForAll} event.
    */
  function setApprovalForAll(address operator, bool _approved) override external pure {
    require(false, "Our contract doesn't support approval");
  }

  /**
    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
    *
    * See {setApprovalForAll}
    */
  function isApprovedForAll(address owner, address operator) override external pure returns (bool) {
    require(false, "Our contract doesn't support approval");
  }

  /**
    * @dev Safely transfers `tokenId` token from `from` to `to`.
    *
    * Requirements:
    *
    * - `from` cannot be the zero address.
    * - `to` cannot be the zero address.
    * - `tokenId` token must exist and be owned by `from`.
    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    *
    * Emits a {Transfer} event.
    */
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) override  external {
    // In our simplified implementation, we just call transferFrom;
    _transferFrom(from, to, tokenId);
  }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId;
    }

        /**
    * @dev Returns the token collection name.
    */
  function name() override external view returns (string memory) {
    return "Boomo Token x Test";
  }

  /**
    * @dev Returns the token collection symbol.
    */
  function symbol() override external view returns (string memory) {
    return "BMTxTest";
  }

  /**
    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
    */
  function tokenURI(uint256 tokenId) override external view returns (string memory) {
    return string(abi.encodePacked("https://icotar.com/avatar/", uint2str(tokenId)));
  }

function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}