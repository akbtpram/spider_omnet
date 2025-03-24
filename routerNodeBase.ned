simple routerNodeBase
{
    parameters:
        bool isHost = default(false); // Indicates whether the node is a host
        string topologyFile = default("sample-topology.txt"); // Path to topology file
        string workloadFile = default("sample-workload.txt"); // Path to workload file
        bool timeoutEnabled = default(true); // Enable or disable timeouts
        bool waterfillingEnabled = default(true); // Enable or disable water-filling

        @display("i=block/routing"); // Icon for the node module

        // Signals for tracking various metrics
        @signal[completionTime](type="long");
        @statistic[completionTime](title="Completion Time"; source="completionTime"; record=vector,stats; interpolationmode=none);

        @signal[numInQueuePerChannel*](type="unsigned long");
        @statisticTemplate[numInQueuePerChannelTemplate](record=vector,stats);

        @signal[numProcessedPerChannel*](type="long");
        @statisticTemplate[numProcessedPerChannelTemplate](record=vector, stats);

        @signal[numSentPerChannel*](type="long");
        @statisticTemplate[numSentPerChannelTemplate](record=vector, stats);

        @signal[balancePerChannel*](type="double");
        @statisticTemplate[balancePerChannelTemplate](record=vector, stats);

        @signal[capacityPerChannel*](type="double");
        @statisticTemplate[capacityPerChannelTemplate](record=vector, stats);

        @signal[timeInFlightPerChannel*](type="double");
        @statisticTemplate[timeInFlightPerChannelTemplate](record=vector, stats);

        // Price scheme payment channel-specific signals
        @signal[nValuePerChannel*](type="double");
        @statisticTemplate[nValuePerChannelTemplate](record=vector, stats);

        @signal[fakeRebalanceQPerChannel*](type="double");
        @statisticTemplate[fakeRebalanceQPerChannelTemplate](record=vector, stats);

        @signal[queueDelayEWMAPerChannel*](type="double");
        @statisticTemplate[queueDelayEWMAPerChannelTemplate](record=vector, stats);

        @signal[serviceRatePerChannel*](type="double");
        @statisticTemplate[serviceRatePerChannelTemplate](record=vector, stats);

        @signal[arrivalRatePerChannel*](type="double");
        @statisticTemplate[arrivalRatePerChannelTemplate](record=vector, stats);

        @signal[inflightOutgoingPerChannel*](type="long");
        @statisticTemplate[inflightOutgoingPerChannelTemplate](record=vector, stats);

        @signal[inflightIncomingPerChannel*](type="long");
        @statisticTemplate[inflightIncomingPerChannelTemplate](record=vector, stats);

        @signal[xLocalPerChannel*](type="double");
        @statisticTemplate[xLocalPerChannelTemplate](record=vector, stats);

        @signal[lambdaPerChannel*](type="double");
        @statisticTemplate[lambdaPerChannelTemplate](record=vector, stats);

        @signal[muLocalPerChannel*](type="double");
        @statisticTemplate[muLocalPerChannelTemplate](record=vector, stats);

        @signal[muRemotePerChannel*](type="double");
        @statisticTemplate[muRemotePerChannelTemplate](record=vector, stats);

        @signal[numInflightPerChannel*](type="unsigned long");
        @statisticTemplate[numInflightPerChannelTemplate](record=vector, stats);

        @signal[implicitRebalancingAmtPerChannel*](type="double");
        @statisticTemplate[implicitRebalancingAmtPerChannelTemplate](record=vector, stats);

        @signal[explicitRebalancingAmtPerChannel*](type="double");
        @statisticTemplate[explicitRebalancingAmtPerChannelTemplate](record=vector, stats);

    gates:
        input in[]; // Input gates for receiving messages
        output out[]; // Output gates for sending messages

    submodules:
        wallet: wallet {
            parameters:
                initialBalance = 1000; // Example initial balance (can be parameterized)
                enableLogging = true; // Enable logging for debugging
        }

    connections:
        // Connect the wallet's input gate to the node's output gate
        wallet.fromNode --> in[];

        // Connect the wallet's output gate to the node's input gate
        wallet.toNode <-- out[];
}