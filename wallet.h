#ifndef WALLET_H
#define WALLET_H

#include <omnetpp.h>
#include <unordered_map>


using namespace omnetpp;

class wallet : public cSimpleModule {
    private:
        double currentBalance; // Tracks the current balance in the wallet
        double totalStakedAmount; // Tracks the total amount staked on all channels
        bool enableLogging; // Enables or disables logging for debugging

        // Shared book with the node (e.g., channel-specific balances)
        std::unordered_map<int, double> sharedBook;

    protected:
        virtual void initialize() override; // Initialization logic
        virtual void handleMessage(cMessage *msg) override; // Message handling logic
        virtual void finish() override; // Cleanup logic

        // Helper functions
        bool validateTransaction(double transactionAmount); // Validates transaction amount
        void updateSharedBook(int channelId, double newBalance); // Updates the shared book
        void log(const std::string& message); // Logs messages if logging is enabled

    public :
        double getCurrentBalance() const { return currentBalance;} // Returns the current balance
        void setCurrentBalance(double balance) { currentBalance = balance; }

    public:
        wallet(); // Constructor
        virtual ~wallet(); // Destructor
};

#endif // WALLET_H