pragma solidity ^0.5.16;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false
    
    uint private MINIMUM_AIRLINES_FOR_CONSENSUS = 4;
    uint public INSURANCE_PAID = 1;
    uint public INSURANCE_CLOSED = 2;
    uint public INSURANCE_UNKNOWN = 0;
    uint public INSURANCE_BOUGHT = 1;

    mapping(address => Airline) private address_airline;
    uint256 private countOfAirlines = 0;
    /********************************************************************************************/
    /*                                       Constructs                                         */
    /********************************************************************************************/
    struct Airline{
        bool approvalRequired;
        bool isFunded;
        uint256 airlineNum;
        Voters voters;
        uint256 minimumVotesRequired;
        bool added;
    }
    struct Voters{
        uint count;
        mapping(address => bool) voterAddress_infavour;
    }
    struct PassengerInsurance{
        bool isInsured;
        uint256 paidAmount;
        uint256 insuranceAmount;
        uint status;
        address passengerAddress;
    }
    struct Passenger{
        uint256 walletBalance;
        address payable passengerAddress;
    }
    struct Flight {
        PassengerInsurance[] passengerList;
        uint8 statusCode;
        uint256 updatedTimestamp;        
        address airline;
    }
    mapping(bytes32 => Flight) private flights;
    mapping(address => Passenger) private passengers;
    mapping (address=>bool) private authorizedCallers;
    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                ) 
                                public 
    {
        contractOwner = msg.sender;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }
    
    /**
     * @dev Modifier that requires caller is airline
     */
    modifier requireAirline() {
        require(address_airline[msg.sender].added, "Caller is not an airline");
        _;
    }

    /**
     * @dev Modifier that requires caller Airline is voted approved
     */
    modifier requireApprovedAirline() {
        // Instaniate struct of Airline
        Airline memory airline = address_airline[msg.sender];
        // Check if votes >= minVotes and airline doesn't require approval
        require((airline.approvalRequired == false) || (airline.voters.count >= airline.minimumVotesRequired), "Caller Airline is not approved");
        _;
    }

    /**
     * @dev Modifier that requires a funded airline
     */
    modifier requireFundedAirline() {
        Airline memory airline = address_airline[msg.sender];
        require(airline.isFunded != true, "Caller airline is not funded");
        _;
    }

    /**
     * @dev Modifier that requires a 10 ether as fund by airline
     */
    modifier requireMinimumFund() {
        require(msg.value == 10 ether, "Caller airline has not funded 10 ether");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get currently count of airlines
    *
    * @return A uint256 that is the current count of airlines
    */      
    function getCountOfAirlines() public view returns(uint256) 
    {
        return countOfAirlines;
    }
    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }


    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    /**
     * @dev Check the Airline Exists or not
     */
    function isAirline(address airlineAddress) public view requireIsOperational returns (bool) {
        return address_airline[airlineAddress].added;
    }

    /**
     * @dev Check the Authorized Caller should be ContractOwner & should be Operational
     */
    function authorizeCaller(address contractAddress) external requireContractOwner requireIsOperational {
        authorizedCallers[contractAddress] = true;
    }

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function registerAirline
                            (   address airlineAddress
                            )
                            external
                            requireIsOperational
                            
    {
        address_airline[airlineAddress] = Airline({
            approvalRequired : countOfAirlines >= MINIMUM_AIRLINES_FOR_CONSENSUS, //Approval is only required when currently registered airlines are greater than or equal to mimimum consensus airlines i.e. 4 for current scenario
            isFunded : false,
            airlineNum : countOfAirlines,
            voters: Voters({count:0}),//set default votes to zero
            minimumVotesRequired: countOfAirlines.add(1).div(2), //Minimum votes required are equal to 50%
            added : true
        });
        countOfAirlines = countOfAirlines.add(1);
    }

    /**
     * @dev Vote to nonapproved airline
     *
     */
    function voteAirline(address airlineAddress) 
                                        external 
                                        requireIsOperational
                                        requireAirline
                                        requireApprovedAirline
                                        requireFundedAirline
                                        returns (bool){

        require(airlineAddress != msg.sender, "You can not vote for yourself");
        require(address_airline[airlineAddress].voters.voterAddress_infavour[msg.sender] == false, "You have already voted by this airline");
        address_airline[airlineAddress].voters.count = address_airline[airlineAddress].voters.count.add(1);
        address_airline[airlineAddress].voters.voterAddress_infavour[msg.sender] = true;
        address_airline[airlineAddress].approvalRequired = address_airline[airlineAddress].voters.count < address_airline[airlineAddress].minimumVotesRequired;
        return address_airline[airlineAddress].approvalRequired;
    }

   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy
                            (   bytes32 flightKey                          
                            )
                            external
                            payable
                            requireIsOperational
    {
        for(uint i=0;i<flights[flightKey].passengerList.length;i++){
            if(flights[flightKey].passengerList[i].passengerAddress == msg.sender){
                flights[flightKey].passengerList[i].isInsured = true;
                flights[flightKey].passengerList[i].paidAmount =  msg.value;
                flights[flightKey].passengerList[i].insuranceAmount =  msg.value.mul(15).div(10);
                flights[flightKey].passengerList[i].status = INSURANCE_BOUGHT;
                flights[flightKey].passengerList[i].passengerAddress = msg.sender;
            }
        }
    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (bytes32 flightKey
                                )
                                external
                                requireIsOperational
    {
        for(uint i=0;i<flights[flightKey].passengerList.length;i++){
            flights[flightKey].passengerList[i].status = INSURANCE_PAID;
            passengers[flights[flightKey].passengerList[i].passengerAddress].walletBalance =
                passengers[flights[flightKey].passengerList[i].passengerAddress].walletBalance +
                flights[flightKey].passengerList[i].insuranceAmount;
        }
    }
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                            )
                            external
                            requireIsOperational
    {
        require(address(this).balance > passengers[msg.sender].walletBalance,
                         'Contract does not have enough balance');
        passengers[msg.sender].passengerAddress.transfer(passengers[msg.sender].walletBalance);
        passengers[msg.sender].walletBalance = 0;
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund
                            (   
                            )
                            public
                            payable
                            requireIsOperational
                            requireAirline
                            requireApprovedAirline
                            requireMinimumFund
    {
        address_airline[msg.sender].isFunded = true;
    }

    function getFlightKey
                        (
                            address airline,
                            string memory flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract only to be used by contract owner.
    *
    */
    function fallbackFundingToContract() 
                            external 
                            payable 
                            requireContractOwner
    {
        
    }


}

