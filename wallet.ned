simple wallet
{
    parameters:
        double initialBalance = default(0); // Initial balance staked on all channels
        bool enableLogging = default(true); // Enable logging for debugging

        @display("i=block/wallet"); // Icon for wallet module

        // Signals for wallet-specific metrics
        @signal[currentBalance](type="double");
        @statistic[currentBalance](title="Current Wallet Balance"; source="currentBalance"; record=vector,stats);

        @signal[totalStakedAmount](type="double");
        @statistic[totalStakedAmount](title="Total Staked Amount"; source="totalStakedAmount"; record=vector,stats);

        @signal[transactionSuccess](type="bool");
        @statistic[transactionSuccess](title="Transaction Success Rate"; source="transactionSuccess"; record=count);

        @signal[transactionFailure](type="bool");
        @statistic[transactionFailure](title="Transaction Failure Rate"; source="transactionFailure"; record=count);

        @signal[bookUpdate](type="string");
        @statistic[bookUpdate](title="Shared Book Updates"; source="bookUpdate"; record=vector,stats);

    gates:
        input fromNode; // Input gate for communication from the node
        output toNode;  // Output gate for communication to the node
}