pragma solidity ^0.8.0;

import "./VestingContract.sol";

contract Proxy {
    address public owner;
    address public implementation;

    constructor(address _owner, address _implementation) {
        owner = _owner;
        implementation = _implementation;
    }

    function upgradeImplementation(address newImplementation) external {
        require(msg.sender == owner, "Only owner can upgrade");
        implementation = newImplementation;
    }

    fallback() external payable {
        address _impl = implementation;
        require(_impl != address(0), "Implementation contract not set");

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}

contract GANJESStaking is Proxy {
    constructor(
        address _owner,
        address _implementation,
        address _token,
        address _teamAndAdvisors,
        address _earlyBackers
    ) Proxy(_owner, _implementation) {
        // +GANJESVesting(implementation).initialize(_token, _teamAndAdvisors, _earlyBackers);
    }
}
