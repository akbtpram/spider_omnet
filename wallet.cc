#include "wallet.h"
#include <iostream>
#include <sstream>

Define_Module(wallet);

// Constructor
wallet::wallet() : currentBalance(0), totalStakedAmount(0), enableLogging(true) {}

// Destructor
wallet::~wallet() {}

int _nodeChannelStakes = 0;
std::map<int, double> _nodeWalletBalances;

// Initialization logic
void wallet::initialize() {
    // Initialize parameters
    currentBalance = par("initialBalance");
    totalStakedAmount = currentBalance;
    enableLogging = par("enableLogging");

    // Log initialization
    log("Wallet initialized with initial balance: " + std::to_string(currentBalance));
}

// Message handling logic
void wallet::handleMessage(cMessage *msg) {
    // Extract message type and content
    if (msg->isSelfMessage()) {
        // Handle self-messages (if any)
        log(std::string("Received self-message: ") + msg->getName());
    } else {
        // Handle incoming messages from the node
        std::string msgName = msg->getName();
        if (msgName == "TransactionValidationRequest") {
            // Parse transaction details (e.g., amount, channel ID)
            double transactionAmount = msg->par("amount");
            int channelId = msg->par("channelId");

            // Validate transaction
            if (validateTransaction(transactionAmount)) {
                // Update shared book
                updateSharedBook(channelId, transactionAmount);

                // Send success response
                cMessage *response = new cMessage("TransactionValidationResponse");
                response->addPar("success") = true;
                send(response, "toNode");
                emit(par("transactionSuccess"), true);
            } else {
                // Send failure response
                cMessage *response = new cMessage("TransactionValidationResponse");
                response->addPar("success") = false;
                send(response, "toNode");
                emit(par("transactionFailure"), true);
            }
        } else if (msgName == "BookUpdateRequest") {
            // Handle book update requests
            int channelId = msg->par("channelId");
            double newBalance = msg->par("newBalance");
            updateSharedBook(channelId, newBalance);

            // Log the update
            log("Updated shared book for channel " + std::to_string(channelId) + ": " + std::to_string(newBalance));
        }
    }

    // Delete the received message
    delete msg;
}

// Cleanup logic
void wallet::finish() {
    // Log final state
    log("Wallet finished. Final balance: " + std::to_string(currentBalance));
}

// Validates transaction amount
bool wallet::validateTransaction(double transactionAmount) {
    if (transactionAmount <= currentBalance) {
        currentBalance -= transactionAmount;
        return true;
    }
    return false;
}

// Updates the shared book
void wallet::updateSharedBook(int channelId, double newBalance) {
    sharedBook[channelId] = newBalance;
    emit(par("bookUpdate"), ("Updated shared book for channel " + std::to_string(channelId)).c_str());
}

// Logs messages if logging is enabled
void wallet::log(const std::string& message) {
    if (enableLogging) {
        EV << "[Wallet] " << message << endl;
    }
}