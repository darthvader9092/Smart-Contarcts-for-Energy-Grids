// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract EnergyMarket {
    address public owner;

    enum UserType { Consumer, Producer, Prosumer }

    struct User {
        uint weiBalance;
        uint energyBalance;
        bool registered;
        UserType userType;
    }

    struct Order {
        address user;
        uint energyUnits;
        uint energyPricePerUnit; // Price per unit of energy
        bool active;
        bool isBuyOrder;
    }

    mapping(address => User) public users;
    Order[] public orders;

    // Constructor with visibility specifier
    constructor() public {
        owner = msg.sender;
    }

    // Events
    event UserRegistered(address indexed user, UserType userType);
    event OrderPlaced(uint indexed orderId, address indexed user, bool isBuyOrder);
    event TransactionExecuted(uint indexed orderId, address indexed buyer, address indexed seller, uint weiAmount, uint energyAmount);

    // Modifier to restrict function access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    // Register a user with userType
    function register(uint _weiBalance, uint _energyBalance, UserType _userType) external {
        require(!users[msg.sender].registered, "User already registered.");

        users[msg.sender] = User(_weiBalance, _energyBalance, true, _userType);
        emit UserRegistered(msg.sender, _userType);
    }

    // Create an order with price per unit of energy
    function placeOrder(uint _energyUnits, uint _energyPricePerUnit, bool _isBuyOrder) external {
        require(users[msg.sender].registered, "User not registered.");

        // Check user type restrictions
        if (users[msg.sender].userType == UserType.Consumer) {
            require(_isBuyOrder, "Consumers can only place buy orders.");
        } else if (users[msg.sender].userType == UserType.Producer) {
            require(!_isBuyOrder, "Producers can only place sell orders.");
        }

        orders.push(Order(msg.sender, _energyUnits, _energyPricePerUnit, true, _isBuyOrder));
        emit OrderPlaced(orders.length - 1, msg.sender, _isBuyOrder);
    }

    // Owner executes all transactions at once
    function executeTransactions() external onlyOwner {
        // Sort orders by price per unit of energy for buyers and sellers separately
        sortOrders();

        // Example matching algorithm: match orders based on price per unit and quantity
        for (uint i = 0; i < orders.length; i++) {
            if (orders[i].active && orders[i].isBuyOrder) {
                uint remainingUnits = orders[i].energyUnits;

                // Iterate through all sell orders to find matches
                for (uint j = 0; j < orders.length; j++) {
                    if (orders[j].active && !orders[j].isBuyOrder &&
                        orders[j].energyPricePerUnit <= orders[i].energyPricePerUnit) {

                        uint unitsAvailable = orders[j].energyUnits;

                        // Determine the amount to execute
                        uint amountToExecute = remainingUnits < unitsAvailable ? remainingUnits : unitsAvailable;

                        // Execute the transaction
                        executeOrder(i, j, amountToExecute);

                        // Reduce the remaining amount for the buy order
                        remainingUnits -= amountToExecute;

                        // Mark the sell order as inactive after execution
                        orders[j].energyUnits -= amountToExecute;
                        if (orders[j].energyUnits == 0) {
                            orders[j].active = false;
                        }

                        // Stop if the buy order is fully fulfilled
                        if (remainingUnits == 0) {
                            orders[i].active = false;
                            break;
                        }
                    }
                }
            }
        }
    }

    // Execute an individual order with a specified amount
    function executeOrder(uint buyerIndex, uint sellerIndex, uint unitsToExecute) private {
        uint weiAmount = unitsToExecute * orders[sellerIndex].energyPricePerUnit;

        // Transfer wei and energy balances
        users[orders[buyerIndex].user].weiBalance -= weiAmount;
        users[orders[sellerIndex].user].weiBalance += weiAmount;

        users[orders[buyerIndex].user].energyBalance += unitsToExecute;
        users[orders[sellerIndex].user].energyBalance -= unitsToExecute;

        emit TransactionExecuted(sellerIndex, orders[buyerIndex].user, orders[sellerIndex].user, weiAmount, unitsToExecute);
    }

    // Sort orders to prioritize buyer's lowest price and seller's lowest price
    function sortOrders() private {
        for (uint i = 0; i < orders.length - 1; i++) {
            for (uint j = i + 1; j < orders.length; j++) {
                if (orders[i].isBuyOrder && orders[j].isBuyOrder &&
                    orders[i].energyPricePerUnit > orders[j].energyPricePerUnit) {
                    // Swap orders for buyers based on lower energy price
                    Order memory temp = orders[i];
                    orders[i] = orders[j];
                    orders[j] = temp;
                } else if (!orders[i].isBuyOrder && !orders[j].isBuyOrder &&
                           orders[i].energyPricePerUnit < orders[j].energyPricePerUnit) {
                    // Swap orders for sellers based on higher energy price
                    Order memory temp = orders[i];
                    orders[i] = orders[j];
                    orders[j] = temp;
                }
            }
        }
    }

    // Function to retrieve total number of orders
    function getOrderCount() external view returns (uint) {
        return orders.length;
    }
}

