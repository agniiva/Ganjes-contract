
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "./GanjesStakingV1.sol";

contract GANJESStakingProxy is TransparentUpgradeableProxy {
        uint256 public minAPR;
        uint256 public maxAPR;
        address public admin;
    
   constructor(address _logic, address _adminAddress, GANJESToken _token, uint256 _minAPRValue, uint256 _maxAPRValue) TransparentUpgradeableProxy(_logic, _adminAddress, abi.encodeWithSignature("initialize(address,uint256,uint256)", _token, _minAPRValue, _maxAPRValue)) {
        admin = _adminAddress;
        minAPR = _minAPRValue;
        maxAPR = _maxAPRValue;
   }
    
        function setAPRRange(uint256 _minAPR, uint256 _maxAPR) external {
            require(msg.sender == admin, "Only admin can set APR range");
            minAPR = _minAPR;
            maxAPR = _maxAPR;
        }
}