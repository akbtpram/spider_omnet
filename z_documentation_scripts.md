# Documentation for `pent_best_yet.sh`

This script is a Bash shell script designed to automate the setup and execution of simulations or experiments in the context of network routing schemes. It is part of a larger project that involves OMNeT++ (a discrete event simulation environment) and focuses on evaluating various routing schemes on different network topologies. Below is a detailed documentation of the script, including its purpose, structure, variables, logic, and usage.

---

#### **Purpose**
The script automates the preparation and execution of routing scheme evaluations across multiple network topologies. It handles the following tasks:
1. **Copying necessary `.ned` files** (OMNeT++ network description files) to a specified directory.
2. **Iterating over predefined network topologies** and routing schemes.
3. **Setting up configuration parameters** for simulations, such as demand scales, routing schemes, and path selection strategies.
4. **Creating directories** for storing experiment results and intermediate files.

---

#### **File Location**
The script is located at:
```
\\wsl.localhost\Ubuntu-20.04\home\ad\omnetpp-5.6\samples\spider_omnet-Copy\exp-run-scripts\pent_best_yet.sh
```

---

#### **Script Variables**

###### **Paths**
- `PATH_NAME`: Directory where `.ned` files are copied.
  ```
  /home/ubuntu/omnetpp-5.4.1/samples/spider_omnet/benchmarks/circulations/
  ```
- `GRAPH_PATH`: Directory containing scripts for generating figures or visualizations.
  ```
  /home/ubuntu/omnetpp-5.4.1/samples/spider_omnet/scripts/figures/
  ```

###### **Network Topologies**
- `num_nodes`: Array specifying the number of nodes in each network topology.
- `prefix`: Array of prefixes representing network topology names.

###### **Routing Scheme Parameters**
- `balance`: Initial balance for nodes (default: 100).
- `routing_scheme`: Routing scheme passed as the first argument (`$1`) to the script.
- `pathChoice`: Path selection strategy passed as the second argument (`$2`). Defaults to `"shortest"` if not provided.

###### **Flags**
- `random_init_bal`: Whether to initialize node balances randomly (default: `false`).
- `random_capacity`: Whether to assign random capacities to links (default: `false`).
- `widestPathsEnabled`, `obliviousRoutingEnabled`, `kspYenEnabled`: Flags for enabling specific routing algorithms.

###### **Simulation Parameters**
- `simulationLength`: Total simulation duration (default: 8000).
- `statCollectionRate`: Rate at which statistics are collected (default: 1).
- `timeoutClearRate`: Rate at which timeouts are cleared (default: 1).
- `timeoutEnabled`, `signalsEnabled`, `loggingEnabled`: Flags for enabling/disabling specific features.
- `transStatStart`, `transStatEnd`: Time range for collecting transaction statistics.

###### **Scheme-Specific Parameters**
These parameters are specific to the routing scheme being evaluated:
- `eta`, `alpha`, `kappa`, `updateQueryTime`, `minPriceRate`, `zeta`, `rho`, `tau`, `normalizer`, `xi`, `routerQueueDrainTime`, `serviceArrivalWindow`.

###### **Miscellaneous**
- `PYTHON`: Path to the Python interpreter.
- `arraylength`: Length of the `prefix` array, used for iterating over topologies.

---

#### **Script Logic**

###### **1. Copying `.ned` Files**
The script copies several `.ned` files to the `PATH_NAME` directory. These files define the network nodes and their behavior:
```bash
cp hostNodeBase.ned ${PATH_NAME}
cp hostNodeWaterfilling.ned ${PATH_NAME}
cp hostNodeLandmarkRouting.ned ${PATH_NAME}
cp hostNodePriceScheme.ned ${PATH_NAME}
cp hostNodeLndBaseline.ned ${PATH_NAME}
cp routerNode.ned ${PATH_NAME}
```

###### **2. Iterating Over Network Topologies**
The script iterates over the `prefix` array, which contains the names of network topologies. For each topology:
- The corresponding number of nodes is retrieved from the `num_nodes` array.
- Simulations are configured based on the selected routing scheme and path choice.

###### **3. Handling Input Arguments**
- `$1` (`routing_scheme`): Specifies the routing scheme to evaluate.
- `$2` (`pathChoice`): Specifies the path selection strategy (defaults to `"shortest"` if not provided).

###### **4. Creating Directories**
A directory is created at `PATH_NAME` to store experiment results and intermediate files:
```bash
mkdir -p ${PATH_NAME}
```

###### **5. Echoing Configuration**
The script echoes the selected routing scheme and path choice for confirmation:
```bash
echo $routing_scheme
echo $pathChoice
```

---

#### **Usage**

###### **Command Syntax**
```bash
./pent_best_yet.sh <routing_scheme> <pathChoice>
```

###### **Arguments**
1. `<routing_scheme>`: The routing scheme to evaluate (e.g., `waterfilling`, `landmarkRouting`, etc.).
2. `<pathChoice>` (optional): The path selection strategy (e.g., `shortest`, `widest`, etc.). Defaults to `"shortest"` if omitted.

###### **Example**
To evaluate the `waterfilling` routing scheme with the `shortest` path choice:
```bash
./pent_best_yet.sh waterfilling shortest
```

To evaluate the `landmarkRouting` scheme with the default path choice:
```bash
./pent_best_yet.sh landmarkRouting
```

---

#### **Dependencies**
1. **OMNeT++**: The script assumes OMNeT++ is installed and properly configured.
2. **Python**: The script uses Python for certain operations (path: `/usr/bin/python`).
3. **NED Files**: The required `.ned` files must be present in the script's directory.

---

#### **Notes**
1. **Customization**: Users can modify the `prefix` and `num_nodes` arrays to include additional network topologies.
2. **Error Handling**: The script does not include robust error handling. Ensure all dependencies and input arguments are correctly provided.
3. **Logging**: Logging is disabled by default (`loggingEnabled=false`). Enable it for debugging purposes if needed.

---

#### **Conclusion**
This script serves as a powerful tool for automating the evaluation of routing schemes across diverse network topologies. By leveraging OMNeT++ and Python, it provides a flexible framework for conducting large-scale simulations and analyzing performance metrics.


Certainly! Below is a structured documentation for the provided Bash script (`run_celer_comp.sh`). This documentation includes an overview, detailed descriptions of variables and logic, and explanations of key steps in the script.

---

# **Documentation for `run_celer_comp.sh`**

### **Overview**
The script `run_celer_comp.sh` is designed to automate the execution of network simulations using OMNeT++ for different routing schemes, balance scales, and workload configurations. It generates necessary input files, runs simulations, and processes the output to generate analysis plots. The script is highly configurable, allowing users to specify routing schemes, path choices, scheduling algorithms, and other parameters.

---

### **Key Features**
1. **Parameterized Execution**:
   - Accepts command-line arguments for routing scheme, capacity type, path choice, and scheduling algorithm.
   - Allows customization of simulation parameters such as demand scale, balance scale, and timeout settings.

2. **Automated File Management**:
   - Copies `.ned` files (network description files) to the specified directory.
   - Generates `.ini` configuration files dynamically using a Python script.

3. **Simulation Execution**:
   - Runs OMNeT++ simulations in parallel for multiple configurations.
   - Supports various routing schemes, including shortest path and window-based schemes.

4. **Output Analysis**:
   - Processes simulation results (`.vec` and `.sca` files) to generate analysis plots using another Python script.

5. **Cleanup**:
   - Optionally removes intermediate files after processing to save disk space.

---

### **Script Parameters**
The script accepts the following command-line arguments:
1. **`routing_scheme`** (`$1`): Specifies the routing scheme to use (e.g., `shortestPath`, `Window`, etc.).
2. **`capacity_type`** (`$2`): Specifies the type of capacity configuration (not used directly in the script but passed as an argument).
3. **`pathChoice`** (`$3`): Specifies the path selection strategy (default: `shortest`).
4. **`schedulingAlgorithm`** (`$4`): Specifies the scheduling algorithm (default: `LIFO`).

---

### **Global Variables**
The script defines several global variables that control its behavior:

#### **Paths**
- `PATH_NAME`: Directory containing network topology and workload files.
- `GRAPH_PATH`: Directory for storing generated plots.
- `PYTHON`: Path to the Python interpreter.

#### **General Parameters**
- `simulationLength`: Total simulation time (in seconds).
- `statCollectionRate`: Rate at which statistics are collected.
- `timeoutClearRate`: Rate at which timeouts are cleared.
- `timeoutEnabled`: Enables or disables timeout functionality.
- `signalsEnabled`: Enables or disables signal generation.
- `loggingEnabled`: Enables or disables logging.

#### **Scheme-Specific Parameters**
- `eta`, `alpha`, `kappa`, `updateQueryTime`, etc.: Parameters specific to certain routing schemes (e.g., window-based schemes).

#### **DCTCP Parameters**
- `windowBeta`, `windowAlpha`, `queueThreshold`, etc.: Parameters specific to DCTCP simulations.

---

### **Script Workflow**
The script follows a structured workflow:

#### **Step 1: Copy Necessary Files**
- Copies `.ned` files (network description files) to the specified directory (`PATH_NAME`):
  ```bash
  cp hostNode${suffix}.ned ${PATH_NAME}
  cp routerNode${suffix}.ned ${PATH_NAME}
  ```

#### **Step 2: Initialize Parameters**
- Sets default values for optional parameters (`pathChoice` and `schedulingAlgorithm`) if not provided:
  ```bash
  if [ -z "$pathChoice" ]; then
      pathChoice="shortest"
  fi
  ```

#### **Step 3: Generate Topology and Workload**
- Iterates over a predefined list of balance scales and simulation runs (`num`).
- Generates topology files and workload files dynamically:
  ```bash
  topofile="${PATH_NAME}${prefix}_topo${balance}.txt"
  workloadname="${workload_prefix}_circ${num}_demand${scale}"
  ```

#### **Step 4: Create Configuration Files**
- Uses a Python script (`create_ini_file.py`) to generate `.ini` configuration files for each simulation run:
  ```bash
  python scripts/create_ini_file.py \
          --network-name ${network} \
          --topo-filename ${topofile} \
          --workload-filename ${workload}_workload.txt \
          --ini-filename $inifile \
          ...
  ```

#### **Step 5: Run Simulations**
- Executes OMNeT++ simulations in parallel for each configuration:
  ```bash
  ./spiderNet -u Cmdenv -f $inifile -c \
  ${network}_${balance}_${routing_scheme}_circ${num}_demand${scale}_${pathChoice} -n ${PATH_NAME} \
      > ${output_file}.txt &
  ```

#### **Step 6: Generate Analysis Plots**
- Processes simulation results (`.vec` and `.sca` files) to generate analysis plots:
  ```bash
  python scripts/generate_analysis_plots_for_single_run.py \
    --vec_file ${vec_file_path} \
    --sca_file ${sca_file_path} \
    --save ${graph_op_prefix}${routing_scheme}_${pathChoice} \
    ...
  ```

#### **Step 7: Cleanup**
- Optionally removes intermediate files to save disk space:
  ```bash
  rm ${PATH_NAME}${prefix}_circ*_demand${scale}.ini
  rm ${workload}_workload.txt
  rm ${workload}.json
  ```

---

### **Key Logic and Conditional Statements**
1. **Routing Scheme Handling**:
   - If the routing scheme is `shortestPath`, the script skips path choice and scheduling algorithm configurations.
   - For other routing schemes, it iterates over a fixed number of path choices (`numPathChoices`).

2. **Parallel Execution**:
   - Simulations are executed in parallel using background jobs (`&`), with process IDs stored in the `pids` array.

3. **Dynamic Plotting**:
   - The plotting logic adapts based on the routing scheme and whether path choices are relevant.

---

### **Usage Instructions**
To execute the script, run the following command:
```bash
./run_celer_comp.sh <routing_scheme> <capacity_type> <pathChoice> <schedulingAlgorithm>
```
Example:
```bash
./run_celer_comp.sh shortestPath uniform shortest LIFO
```

---

### **Dependencies**
1. **OMNeT++**: The script assumes that OMNeT++ is installed and configured correctly.
2. **Python Scripts**:
   - `create_ini_file.py`: Generates `.ini` configuration files.
   - `generate_analysis_plots_for_single_run.py`: Processes simulation results and generates plots.
3. **Input Files**:
   - `.ned` files for network topology.
   - Workload files (`.txt` or `.json`).

---

### **Notes**
1. **Error Handling**:
   - The script does not include explicit error handling. Ensure all dependencies and input files are correctly set up before execution.
2. **Scalability**:
   - The script is designed to handle multiple configurations in parallel. Ensure sufficient system resources (CPU cores, memory) are available.

---

This documentation provides a comprehensive understanding of the script's purpose, structure, and usage. Let me know if you need further clarification or additional details!


Certainly! Below is a comprehensive documentation for the provided Bash scripts (`run_circulations.sh` and `run_dag_Temp.sh`). This documentation includes an overview, detailed descriptions of variables and logic, explanations of key steps, and usage instructions.

---

# **Documentation for `run_circulations.sh` and `run_dag_Temp.sh`**

## **Overview**
The scripts `run_circulations.sh` and `run_dag_Temp.sh` are designed to automate the execution of network simulations using OMNeT++ for different routing schemes, balance scales, and workload configurations. These scripts generate necessary input files, run simulations, and process the output to generate analysis plots. The scripts are highly configurable, allowing users to specify routing schemes, path choices, scheduling algorithms, and other parameters.

---

## **Key Features**
1. **Parameterized Execution**:
   - Accepts command-line arguments for routing scheme, capacity type, path choice, and scheduling algorithm.
   - Allows customization of simulation parameters such as demand scale, balance scale, and timeout settings.

2. **Automated File Management**:
   - Copies `.ned` files (network description files) to the specified directory.
   - Generates `.ini` configuration files dynamically using a Python script.

3. **Simulation Execution**:
   - Runs OMNeT++ simulations in parallel for multiple configurations.
   - Supports various routing schemes, including shortest path and window-based schemes.

4. **Output Analysis**:
   - Processes simulation results (`.vec` and `.sca` files) to generate analysis plots using another Python script.

5. **Cleanup**:
   - Optionally removes intermediate files after processing to save disk space.

---

## **Script Parameters**
### **`run_circulations.sh`**
- **`routing_scheme`**: Specifies the routing scheme to use (e.g., `shortestPath`, `priceSchemeWindow`).
- **`scale`**: Specifies the demand scale factor.

### **`run_dag_Temp.sh`**
- **`routing_scheme`**: Specifies the routing scheme to use.
- **`pathChoice`**: Specifies the path selection strategy (default: `shortest`).

---

## **Global Variables**
The scripts define several global variables that control their behavior:

### **Paths**
- `PATH_NAME`: Directory containing network topology and workload files.
- `GRAPH_PATH`: Directory for storing generated plots.
- `PYTHON`: Path to the Python interpreter.

### **General Parameters**
- `simulationLength`: Total simulation time (in seconds).
- `statCollectionRate`: Rate at which statistics are collected.
- `timeoutClearRate`: Rate at which timeouts are cleared.
- `timeoutEnabled`: Enables or disables timeout functionality.
- `signalsEnabled`: Enables or disables signal generation.
- `loggingEnabled`: Enables or disables logging.

### **Scheme-Specific Parameters**
- `eta`, `alpha`, `kappa`, `updateQueryTime`, etc.: Parameters specific to certain routing schemes (e.g., window-based schemes).

### **DCTCP Parameters**
- `windowBeta`, `windowAlpha`, `queueThreshold`, etc.: Parameters specific to DCTCP simulations.

---

## **Script Workflow**
Both scripts follow a similar structured workflow:

### **Step 1: Copy Necessary Files**
- Copies `.ned` files (network description files) to the specified directory (`PATH_NAME`):
  ```bash
  cp hostNode${suffix}.ned ${PATH_NAME}
  cp routerNode${suffix}.ned ${PATH_NAME}
  ```

### **Step 2: Initialize Parameters**
- Sets default values for optional parameters (`pathChoice` and `schedulingAlgorithm`) if not provided:
  ```bash
  if [ -z "$pathChoice" ]; then
      pathChoice="shortest"
  fi
  ```

### **Step 3: Generate Topology and Workload**
- Iterates over a predefined list of balance scales and simulation runs (`num`).
- Generates topology files and workload files dynamically:
  ```bash
  topofile="${PATH_NAME}${prefix}_topo${balance}.txt"
  workloadname="${workload_prefix}_circ${num}_demand${scale}"
  ```

### **Step 4: Create Configuration Files**
- Uses a Python script (`create_ini_file.py`) to generate `.ini` configuration files for each simulation run:
  ```bash
  python scripts/create_ini_file.py \
          --network-name ${network} \
          --topo-filename ${topofile} \
          --workload-filename ${workload}_workload.txt \
          --ini-filename $inifile \
          ...
  ```

### **Step 5: Run Simulations**
- Executes OMNeT++ simulations in parallel for each configuration:
  ```bash
  ./spiderNet -u Cmdenv -f $inifile -c \
  ${network}_${balance}_${routing_scheme}_circ${num}_demand${scale}_${pathChoice} -n ${PATH_NAME} \
      > ${output_file}.txt &
  ```

### **Step 6: Generate Analysis Plots**
- Processes simulation results (`.vec` and `.sca` files) to generate analysis plots:
  ```bash
  python scripts/generate_analysis_plots_for_single_run.py \
    --vec_file ${vec_file_path} \
    --sca_file ${sca_file_path} \
    --save ${graph_op_prefix}${routing_scheme}_${pathChoice} \
    ...
  ```

### **Step 7: Cleanup**
- Optionally removes intermediate files to save disk space:
  ```bash
  rm ${PATH_NAME}${prefix}_circ*_demand${scale}.ini
  rm ${workload}_workload.txt
  rm ${workload}.json
  ```

---

## **Key Logic and Conditional Statements**
1. **Routing Scheme Handling**:
   - If the routing scheme is `shortestPath`, the script skips path choice and scheduling algorithm configurations.
   - For other routing schemes, it iterates over a fixed number of path choices (`numPathChoices`).

2. **Parallel Execution**:
   - Simulations are executed in parallel using background jobs (`&`), with process IDs stored in the `pids` array.

3. **Dynamic Plotting**:
   - The plotting logic adapts based on the routing scheme and whether path choices are relevant.

---

## **Usage Instructions**
### **`run_circulations.sh`**
To execute the script, run the following command:
```bash
./run_circulations.sh
```

### **`run_dag_Temp.sh`**
To execute the script, run the following command:
```bash
./run_dag_Temp.sh <routing_scheme> <pathChoice>
```
Example:
```bash
./run_dag_Temp.sh shortestPath shortest
```

---

## **Dependencies**
1. **OMNeT++**: The script assumes that OMNeT++ is installed and configured correctly.
2. **Python Scripts**:
   - `create_ini_file.py`: Generates `.ini` configuration files.
   - `generate_analysis_plots_for_single_run.py`: Processes simulation results and generates plots.
3. **Input Files**:
   - `.ned` files for network topology.
   - Workload files (`.txt` or `.json`).

---

## **Notes**
1. **Error Handling**:
   - The scripts do not include explicit error handling. Ensure all dependencies and input files are correctly set up before execution.
2. **Scalability**:
   - The scripts are designed to handle multiple configurations in parallel. Ensure sufficient system resources (CPU cores, memory) are available.

---

This documentation provides a comprehensive understanding of the scripts' purpose, structure, and usage. Let me know if you need further clarification or additional details!



# Experiment Run Scripts Documentation

This document provides a comprehensive description of two Bash scripts (`run_dag.sh` and `run_exp.sh`) used for running experiments in the OMNeT++ simulation environment. These scripts are designed to automate the process of setting up, running, and analyzing simulations for network topologies while varying parameters such as routing schemes, demand scales, and balance levels.

---

# **Documentation for `run_dag.sh`**

### **Purpose**
The scripts aim to:
- Automate the generation of topology files, workload configurations, and INI files.
- Execute OMNeT++ simulations with varying parameters.
- Collect simulation results and generate plots for analysis.

### **Key Features**
- Supports multiple routing schemes (e.g., `shortestPath`, `DCTCPQ`, etc.).
- Handles different graph types (e.g., small-world, scale-free, tree, etc.).
- Allows customization of demand scales, balance levels, and path choices.
- Generates detailed plots for performance metrics like queue delays, inflight transactions, and timeouts.

---

## **Documentation for `run_exp.sh` **

### **2.1 `run_dag.sh`**

#### **Purpose**
This script is tailored for running Directed Acyclic Graph (DAG) experiments. It focuses on generating DAG-based topologies, workloads, and running simulations for various demand levels and routing schemes.

#### **Parameters**
- `$1`: Routing scheme (e.g., `shortestPath`, `DCTCPQ`).
- `$2`: Path choice strategy (default: `shortest`).
- `$3`: Prefix for naming output files.
- `$4`: Workload prefix.

#### **Key Variables**
- **Paths**:
  - `PATH_PREFIX`: Directory for storing benchmark outputs.
  - `GRAPH_PATH`: Directory for storing generated plots.
- **General Parameters**:
  - `simulationLength`: Duration of the simulation.
  - `statCollectionRate`: Rate at which statistics are collected.
  - `timeoutClearRate`: Rate at which timeouts are cleared.
  - `signalsEnabled`: Enables/disables signal collection.
  - `loggingEnabled`: Enables/disables logging.
- **Scheme-Specific Parameters**:
  - `eta`, `alpha`, `kappa`, etc.: Parameters specific to routing schemes.
  - `windowBeta`, `windowAlpha`, etc.: Parameters for DCTCP-based schemes.

#### **Workflow**
1. **Initialization**:
   - Creates directories for storing outputs and copies necessary `.ned` files.
2. **Iterates Over Configurations**:
   - Loops through DAG percentages (`dag_percent` array), balance levels, and demand scales.
   - Generates topology files using Python scripts.
3. **Simulation Execution**:
   - Creates INI files for each configuration.
   - Runs OMNeT++ simulations in the background.
4. **Plotting**:
   - Uses Python scripts to generate plots from simulation results.
5. **Cleanup**:
   - Removes temporary files (optional).

---

### **2.2 `run_exp.sh`**

#### **Purpose**
This script is designed for running experiments on a variety of network topologies, including small-world, scale-free, and random graphs. It supports both DAG and circulation-based experiments.

#### **Parameters**
- `$1`: Routing scheme (e.g., `shortestPath`, `DCTCPQ`).
- `$2`: Path choice strategy (default: `shortest`).
- `$3`: Scheduling algorithm (default: `LIFO`).

#### **Key Variables**
- **Paths**:
  - `PATH_NAME`: Directory for storing benchmark outputs.
  - `GRAPH_PATH`: Directory for storing generated plots.
- **Topology Information**:
  - `prefix`: Array of topology names.
  - `num_nodes`: Array of node counts for each topology.
- **Demand Scales**:
  - `demand_scale`: Array of demand levels (e.g., `10`, `60`, `90`).
- **General Parameters**:
  - Similar to `run_dag.sh`.

#### **Workflow**
1. **Initialization**:
   - Copies `.ned` files for different routing schemes.
   - Creates directories for outputs.
2. **Iterates Over Topologies**:
   - Loops through predefined topologies (`prefix` array), balance levels, and demand scales.
   - Identifies graph type (e.g., small-world, scale-free) based on topology name.
3. **Topology Generation**:
   - Uses Python scripts to generate `.ned` files and topology files.
4. **Workload Creation**:
   - Generates transaction workloads using Python scripts.
5. **Simulation Execution**:
   - Creates INI files for each configuration.
   - Runs OMNeT++ simulations in the background.
6. **Plotting**:
   - Generates plots for performance metrics.
7. **Cleanup**:
   - Removes temporary files (optional).

---

## **3. Common Components**

### **3.1 Python Scripts**
Both scripts rely on Python scripts for:
- **Topology Generation**: `create_topo_ned_file.py`.
- **Workload Creation**: `create_workload.py`.
- **INI File Generation**: `create_ini_file.py`.
- **Plotting**: `generate_analysis_plots_for_single_run.py`.

### **3.2 OMNeT++ Simulation**
- The `spiderNet` executable is used to run simulations.
- Simulations are executed with specific configurations (`-c`) and network paths (`-n`).

### **3.3 Output Files**
- **Simulation Outputs**: Stored in the `outputs` directory.
- **Plots**: Stored in the `GRAPH_PATH` directory.
- **Temporary Files**: Removed after processing (optional).

---

## **4. Usage Instructions**

### **4.1 Running `run_dag.sh`**
```bash
./run_dag.sh <routing_scheme> [pathChoice] [prefix] [workload_prefix]
```
Example:
```bash
./run_dag.sh shortestPath shortest my_prefix my_workload
```

### **4.2 Running `run_exp.sh`**
```bash
./run_exp.sh <routing_scheme> [pathChoice] [schedulingAlgorithm]
```
Example:
```bash
./run_exp.sh DCTCPQ shortest LIFO
```

---

## **5. Notes and Recommendations**

### **5.1 Resource Management**
- Running simulations in parallel may consume significant CPU and memory resources. Adjust the number of parallel processes (`numPathChoices`) as needed.

### **5.2 Cleanup**
- Uncomment cleanup commands (`rm`) in the scripts to remove temporary files after processing.

### **5.3 Debugging**
- Enable `loggingEnabled` and inspect logs for troubleshooting.

### **5.4 Customization**
- Modify arrays like `prefix`, `demand_scale`, and `dag_percent` to suit specific experimental needs.

---

## **6. Conclusion**
These scripts provide a robust framework for automating network simulation experiments in OMNeT++. By leveraging Python scripts for file generation and OMNeT++ for simulation execution, they streamline the process of testing various routing schemes and configurations. Proper customization and resource management ensure efficient and insightful experimentation.


# Documentation for `collect_lnd_ping_times.py` and `config.py`

### Overview

The provided Python scripts are designed to collect and analyze ping times to nodes in the Lightning Network Daemon (LND) network. The primary script, `collect_lnd_ping_times.py`, handles the collection of Round-Trip Time (RTT) data by pinging LND nodes, storing the results, and visualizing them. The secondary script, `config.py`, contains constants, graph definitions, and other configurations used across the project.

---

### **File: `collect_lnd_ping_times.py`**

#### Purpose
This script collects RTT data by pinging IP addresses associated with LND nodes, aggregates statistics, and generates a visualization of the collected data.

---

#### Key Functions

1. **`parse_json_data()`**
   - **Purpose**: Extracts IP addresses from a JSON file containing LND node information.
   - **Input**: None (reads from `LND_FILE_PATH + 'lnd_july15_2019.json'`).
   - **Output**: A list of IP addresses derived from the `addresses` field of each node in the JSON file. Excludes `.onion` addresses.
   - **Details**:
     - Reads the JSON file specified by `LND_FILE_PATH`.
     - Iterates through the `nodes` array and extracts valid IP addresses from the `addresses` field.

2. **`ping_node(ip_addr)`**
   - **Purpose**: Pings a specific IP address and returns ping statistics.
   - **Input**: `ip_addr` (string) – The IP address to ping.
   - **Output**: A dictionary containing ping statistics (e.g., `rtt_avg`, `rtt_min`, etc.) or `None` if the ping fails.
   - **Details**:
     - Uses the `pingparsing` library to execute 10 ICMP echo requests.
     - Parses the output and returns it as a dictionary.

3. **`ping_nodes(addr_list)`**
   - **Purpose**: Pings all IP addresses in a given list and aggregates RTT statistics.
   - **Input**: `addr_list` (list of strings) – List of IP addresses to ping.
   - **Output**: A list of RTT averages (in milliseconds) for successfully pinged nodes.
   - **Details**:
     - Iterates through the list of IP addresses, pinging each one using `ping_node()`.
     - Writes the RTT averages to a file (`ping_times_data`) and prints summary statistics (mean, median, variance).

4. **`parse_rtts_from_file()`**
   - **Purpose**: Reads RTT values from a file generated by `ping_nodes()`.
   - **Input**: None (reads from `LND_FILE_PATH + "ping_times_data"`).
   - **Output**: A list of RTT values (floats).
   - **Details**:
     - Filters out invalid entries (e.g., lines containing `"None"` or spaces).

5. **`visualize_rtts(rtts)`**
   - **Purpose**: Generates a histogram of RTT values and saves it as a PDF file.
   - **Input**: `rtts` (list of floats) – RTT values to visualize.
   - **Output**: A cumulative step histogram saved as `lnd_ping_rtt_spread.pdf`.
   - **Details**:
     - Uses `matplotlib` to create a histogram with 100 bins.
     - Prints summary statistics (mean, median, variance, min, max).

---

#### Command-Line Arguments

- `--rerun-ping`: If specified, the script will re-run the ping process instead of reading RTT values from the pre-existing file.

---

#### Workflow

1. Parse the JSON file to extract IP addresses.
2. Optionally re-run the ping process or read RTT values from a file.
3. Visualize the RTT data using a histogram.

---

### **File: `config.py`**

#### Purpose
This script defines constants, graph structures, and configuration parameters used throughout the project.

---

#### Key Components

1. **Graph Definitions**
   - Several graph structures are defined using the `networkx` library. These include:
     - `simple_line_graph`
     - `hotnets_topo_graph`
     - `simple_deadlock_graph`
     - `two_node_graph`, `three_node_graph`, `four_node_graph`, etc.
     - `toy_dctcp_graph`
   - These graphs represent various network topologies used for simulations or testing.

2. **File Paths and Constants**
   - **Kaggle Data Paths**:
     - `KAGGLE_PATH`: Base directory for Kaggle-related data files.
     - Specific file paths for amount distributions, time distributions, etc.
   - **OMNET-Specific Constants**:
     - `MAX_K`: Maximum number of paths to consider.
     - `RECOGNIZED_OMNET_SIGNALS`: List of signals recognized by OMNET simulations.
     - `INTERESTING_SIGNALS`: Dictionary mapping signal types to their respective fields.
   - **Other Constants**:
     - `SEED`, `SEED_LIST`: Random seed values for reproducibility.
     - `SCALE_AMOUNT`, `MEAN_RATE`: Parameters for transaction rates.
     - `LARGE_BALANCE`, `REASONABLE_BALANCE`: Balance thresholds for nodes.

3. **Scheme Codes**
   - `SCHEME_CODE`: Mapping of routing schemes to their abbreviated codes (e.g., `"priceSchemeWindow": "PS"`).

4. **Percent Mapping**
   - `PERCENT_MAPPING`: Maps percentage values to specific DAG percentages.

---

#### Usage

- The constants and graph definitions in this file are imported and utilized by other scripts in the project.
- For example, the `LND_FILE_PATH` constant is used in `collect_lnd_ping_times.py` to locate the JSON file containing LND node data.

---

### **Dependencies**

1. **Python Libraries**:
   - `json`: For parsing JSON data.
   - `subprocess`: For executing shell commands.
   - `pingparsing`: For parsing ping results.
   - `statistics`: For calculating statistical metrics (mean, median, variance).
   - `matplotlib`: For generating visualizations.
   - `argparse`: For handling command-line arguments.
   - `networkx`: For defining and manipulating graph structures.

2. **Environment Variables**:
   - `HOME`: Home directory path.
   - `OMNET`: Path to the OMNET simulation directory.

---

### **Usage Instructions**

1. **Collecting Ping Data**:
   - Run the script with the `--rerun-ping` flag to collect fresh RTT data:
     ```bash
     python collect_lnd_ping_times.py --rerun-ping
     ```

2. **Visualizing Pre-Existing Data**:
   - Run the script without the `--rerun-ping` flag to visualize data from the existing file:
     ```bash
     python collect_lnd_ping_times.py
     ```

3. **Customizing Configurations**:
   - Modify constants in `config.py` (e.g., `LND_FILE_PATH`, `KAGGLE_PATH`) to match your environment.

---

### **Outputs**

1. **Ping Times File**:
   - `ping_times_data`: Contains RTT averages for each successfully pinged node.

2. **Visualization**:
   - `lnd_ping_rtt_spread.pdf`: A histogram of RTT values with summary statistics printed to the console.

---

### **Notes**

- Ensure that the required libraries (`pingparsing`, `matplotlib`, `networkx`) are installed in your Python environment.
- The script assumes that the JSON file (`lnd_july15_2019.json`) and other data files are located in the specified directories.
- Adjust file paths and environment variables in `config.py` as needed to match your system configuration.


Based on the provided Python scripts, I'll create documentation for both scripts. These scripts are part of a larger system for generating and processing network topologies for simulations in OMNeT++. Here's the structured documentation:

---

# Documentation for `convert_pkl_paths_to_format.py`

## Overview

This script is designed to convert path data stored in `.pkl` (pickle) files into formatted text files. It processes multiple topology files and path types, writing the results to separate output files.

## File Details

- **File Path**: `\\wsl.localhost\Ubuntu-20.04\home\ad\omnetpp-5.6\samples\spider_omnet-Copy\scripts\convert_pkl_paths_to_format.py`

## Key Variables

- `OP_FILE_PATH`: Directory where output files will be stored.
- `topo_filelist`: List of topology file prefixes.
- `file_prefix`: Corresponding output file prefixes.
- `path_type_list`: Types of paths to process.
- `op_suffix_list`: Suffixes for the output filenames based on path type.

## Script Workflow

1. **Iterate Over Topologies and Path Types**:
   - Loop through each combination of topology and path type.
   
2. **Load Pickle Files**:
   - Open and load paths from `.pkl` files using `pickle.load`.

3. **Write Paths to Output Files**:
   - For each sender-receiver pair, write the number of paths and the actual paths to an output file.
   - Format: Each line starts with "pair" followed by sender and receiver IDs, then lists each path.

4. **Count Paths**:
   - Use `collections.Counter` to count the frequency of different path lengths and print the result.

## Example Output Filename

For a topology file `sw_50_routers_lndCap_topo4000_ksp_yen`, the output filename would be:
```
../benchmarks/circulations/sw_50_routers_lndCap_topo4000.txt_kspYenPaths
```

---

# Documentation for `create_topo_ned_file.py`

## Overview

This script generates network topology files in NED format for OMNeT++ simulations. It supports various graph types and routing algorithms, allowing flexible creation of complex network topologies.

## File Details

- **File Path**: `\\wsl.localhost\Ubuntu-20.04\home\ad\omnetpp-5.6\samples\spider_omnet-Copy\scripts\create_topo_ned_file.py`

## Key Functions

### `parse_node_name(node_name, max_router, max_host)`

- **Purpose**: Parses node names to determine if they are routers or hosts and updates the maximum counts.
- **Returns**: Tuple containing the parsed node name and updated max values.

### `write_ned_file(topo_filename, output_filename, network_name, routing_alg)`

- **Purpose**: Converts a topology text file into a NED file format.
- **Details**:
  - Reads topology details such as neighboring nodes, delays, and balances.
  - Writes router and host definitions, link delays, and connections to the output NED file.
  - Supports various routing algorithms which influence node types.

### `generate_graph(size, graph_type)`

- **Purpose**: Generates different types of graphs (e.g., small-world, scale-free).
- **Details**:
  - Uses NetworkX to generate graphs based on the specified type and size.
  - Removes self-loops and parallel edges.

### `print_topology_in_format(G, balance_per_channel, delay_per_channel, output_filename, ...)`

- **Purpose**: Prints the graph in a specific format suitable for `write_ned_file`.
- **Details**:
  - Identifies landmarks based on node degrees.
  - Writes edge details including delays and capacities.
  - Optionally adds separate end-host nodes.

## Argument Parsing

The script uses `argparse` to handle command-line arguments:

- `--num-nodes`: Number of nodes in the graph.
- `--delay-per-channel`: Delay between nodes in milliseconds.
- `graph_type`: Type of graph to generate.
- Additional options include balance per channel, separate end hosts, random initial balance, etc.

## Supported Routing Algorithms

- `shortestPath`
- `priceScheme`
- `waterfilling`
- `landmarkRouting`
- `lndBaseline`
- Various DCTCP and TCP variants

## Execution Workflow

1. **Argument Parsing**: Parse user inputs to configure graph generation and output settings.
2. **Graph Generation**: Generate the graph based on the specified type and parameters.
3. **Topology Formatting**: Format the generated graph into the required topology text file.
4. **NED File Creation**: For each routing algorithm, create a corresponding NED file.

## Example Usage

```bash
python create_topo_ned_file.py --num-nodes 50 --delay-per-channel 30 small_world --balance-per-channel 100 --topo-filename topo.txt --network-name myNetwork
```

This command generates a small-world graph with 50 nodes, 30ms delay per channel, 100 balance per channel, and outputs the topology to `topo.txt`. It then creates NED files for each supported routing algorithm under the base name `myNetwork`.

---

These documents should provide a comprehensive overview of the scripts' functionalities, structures, and usage instructions.




Below is the documentation for the `create_workload.py` script based on the provided content. This documentation includes an overview of the script, its purpose, key functions, and usage instructions.

---

# Documentation for `create_workload.py`

## Overview

The `create_workload.py` script is designed to generate transaction workloads for simulating payment networks in the OMNeT++ simulator. It supports various graph topologies and workload types, allowing users to customize the generation of transaction demands, sizes, and timing distributions. The script can also generate JSON files for distributed testbeds and supports different demand types, such as circulation (cyclic) and directed acyclic graph (DAG) demands.

## Purpose

The primary purpose of this script is to:
1. Generate transaction workloads for predefined or custom graph topologies.
2. Support different transaction size distributions (e.g., uniform, Poisson, log-normal, or Kaggle-based).
3. Create JSON files for distributed testbeds, including router and end-host configurations.
4. Allow flexible configuration of transaction parameters, such as timeout values, mean rates, and scaling factors.

---

## Key Functions

### 1. `generate_workload_standard`
#### Description
Generates a standard workload for predefined graph topologies (e.g., `hotnets_topo`, `simple_line`, `dag_example`, etc.). It defines start and end nodes, transaction amounts, and demand dictionaries for circulation and DAG demands.

#### Parameters
- `filename`: Output file prefix for saving the workload.
- `payment_graph_topo`: Type of graph topology (e.g., `hotnets_topo`, `simple_line`).
- `workload_type`: Distribution type for transaction intervals (`uniform`, `poisson`, `kaggle`).
- `total_time`: Total simulation time for generating transactions.
- `log_normal`: Boolean flag to enable log-normal transaction sizes.
- `kaggle_size`: Boolean flag to use Kaggle-based transaction sizes.
- `txn_size_mean`: Mean transaction size.
- `timeout_value`: Timeout value for transactions.
- `generate_json_also`: Boolean flag to generate JSON files for distributed testbeds.
- `circ_frac`: Fraction of circulation demand in the workload.

#### Output
- Writes transaction workload to a `.txt` file.
- Optionally generates JSON files for distributed testbeds.

---

### 2. `write_txns_to_file`
#### Description
Writes transaction details to a workload file. Each transaction includes the amount, timestamp, sender, receiver, priority class, and timeout value.

#### Parameters
- `filename`: Name of the output workload file.
- `start_nodes`: List of sender nodes.
- `end_nodes`: List of receiver nodes.
- `amt_absolute`: List of absolute transaction amounts.
- `workload_type`: Distribution type for transaction intervals.
- `total_time`: Total simulation time.
- `log_normal`: Boolean flag to enable log-normal transaction sizes.
- `kaggle_size`: Boolean flag to use Kaggle-based transaction sizes.
- `txn_size_mean`: Mean transaction size.
- `timeout_value`: Timeout value for transactions.
- `mode`: File writing mode (`w` for write, `a` for append).
- `start_time`: Start time for appending transactions.

#### Output
- Writes transactions to the specified workload file.

---

### 3. `generate_json_files`
#### Description
Generates JSON files for distributed testbeds, including router and end-host configurations, Bitcoin (btcd) connections, and Lightning Network Daemon (LND) channels.

#### Parameters
- `filename`: Name of the output JSON file.
- `graph`: Whole graph structure.
- `inside_graph`: Subgraph representing the internal network.
- `start_nodes`: List of sender nodes.
- `end_nodes`: List of receiver nodes.
- `amt_absolute`: List of absolute transaction amounts.

#### Output
- Creates JSON files with configurations for nodes, connections, channels, and demands.

---

### 4. `generate_workload_for_provided_topology`
#### Description
Generates a workload for a custom topology provided in a topology file. It samples sender-receiver pairs uniformly and calculates circulation and DAG demands.

#### Parameters
- `filename`: Output file prefix for saving the workload.
- `inside_graph`: Subgraph representing the internal network.
- `whole_graph`: Whole graph structure.
- `end_host_map`: Mapping of end hosts to nodes.
- `workload_type`: Distribution type for transaction intervals.
- `total_time`: Total simulation time.
- `log_normal`: Boolean flag to enable log-normal transaction sizes.
- `kaggle_size`: Boolean flag to use Kaggle-based transaction sizes.
- `txn_size_mean`: Mean transaction size.
- `timeout_value`: Timeout value for transactions.
- `generate_json_also`: Boolean flag to generate JSON files for distributed testbeds.
- `circ_frac`: Fraction of circulation demand in the workload.

#### Output
- Writes transaction workload to a `.txt` file.
- Optionally generates JSON files for distributed testbeds.

---

### 5. `parse_topo`
#### Description
Parses a topology file to extract graph structures, including the whole graph, router graph, and end-host mappings.

#### Parameters
- `topo_filename`: Name of the topology file.

#### Output
- Returns the whole graph, router graph, and end-host mapping.

---

### 6. `circ_demand`
#### Description
Generates circulation demands for a given list of nodes, with a specified mean and standard deviation.

#### Parameters
- `node_list`: List of node IDs.
- `mean`: Average total demand per node.
- `std_dev`: Standard deviation for perturbation.

#### Output
- Returns a dictionary of circulation demands.

---

### 7. `dag_demand`
#### Description
Generates DAG demands for a given list of nodes, with a specified mean and standard deviation.

#### Parameters
- `node_list`: List of node IDs.
- `mean`: Average total demand out of a node.
- `std_dev`: Standard deviation for perturbation.
- `skew_param`: Skewness parameter for source skew.
- `gen_method`: Method for generating DAG demands (`src_skew` or `topological_sort`).

#### Output
- Returns a dictionary of DAG demands.

---

## Usage Instructions

### Command-Line Arguments
The script accepts the following command-line arguments:

| Argument                     | Description                                                                 |
|------------------------------|-----------------------------------------------------------------------------|
| `--graph-topo`               | Type of graph topology (e.g., `hotnets_topo`, `simple_line`, `custom`).     |
| `--payment-graph-dag-percentage` | Percentage of DAG demand in the workload.                                  |
| `--topo-filename`            | File containing the custom topology (required for `custom` graph-topo).    |
| `output_file_prefix`         | Prefix for the output workload file.                                       |
| `interval_distribution`      | Distribution type for transaction intervals (`uniform`, `poisson`, `kaggle`). |
| `--experiment-time`          | Total simulation time for generating transactions.                         |
| `--txn-size-mean`            | Mean transaction size.                                                     |
| `--log-normal`               | Enable log-normal transaction sizes.                                       |
| `--kaggle-size`              | Use Kaggle-based transaction sizes.                                        |
| `--generate-json-also`       | Generate JSON files for distributed testbeds.                              |
| `--balance-list`             | List of balance values for JSON generation.                                |
| `--timeout-value`            | Timeout value for transactions.                                            |
| `--scale-amount`             | Scaling factor for mean demand.                                            |
| `--run-num`                  | Run number to influence random seed.                                       |

### Example Commands
1. Generate a standard workload for a `simple_line` topology:
   ```bash
   python create_workload.py --graph-topo simple_line simple_workload uniform --experiment-time 30 --txn-size-mean 1
   ```

2. Generate a custom workload from a topology file:
   ```bash
   python create_workload.py --graph-topo custom --topo-filename topo.txt custom_workload poisson --experiment-time 60 --txn-size-mean 2 --generate-json-also
   ```

3. Generate a workload with log-normal transaction sizes:
   ```bash
   python create_workload.py --graph-topo hotnets_topo hotnets_workload kaggle --experiment-time 100 --txn-size-mean 5 --log-normal
   ```

---

## Notes
- Ensure that the required libraries (`numpy`, `networkx`, `argparse`, etc.) are installed before running the script.
- For custom topologies, provide a valid topology file in the expected format.
- Adjust the random seed (`SEED_LIST`) if reproducibility is required across runs.

---

This documentation provides a comprehensive guide to understanding and using the `create_workload.py` script effectively.



# Documentation for Spider-OMNeT++ Analysis Scripts

This documentation provides an overview of two key scripts used in the Spider-OMNeT++ project for data gathering and analysis:

1. **`gather_sw_sf_data.sh`**: A shell script for parsing and gathering simulation data.
2. **`generate_analysis_plots_for_single_run.py`**: A Python script for generating detailed analysis plots from simulation output files.

---

## 1. `gather_sw_sf_data.sh`

### Purpose
This script automates the process of parsing and summarizing simulation results for different topologies and configurations. It uses a Python script (`parse_final_summary_stats.py`) to extract and save relevant statistics.

### Key Features
- Iterates over specified topologies (`sw_50_routers`, `sf_50_routers`).
- Processes multiple credit distribution schemes (`uniform`, `gaussian`, `lnd`).
- Generates summary statistics for various parameters, including:
  - Path types (`oblivious`, `kspYen`, `widest`).
  - Number of paths (`1`, `2`, `8`).
  - Credit amounts (`400`, `800`, `1600`, `3200`, etc.).
  - Payment graph types (`circ`).
  - Schemes (`priceSchemeWindow`, `waterfilling`, `lndBaseline`, `DCTCPQ`, etc.).

### Script Workflow
1. **Iterate Over Topologies**:
   - For each topology (`sw_50_routers`, `sf_50_routers`), the script processes data with specific suffixes based on the credit distribution scheme.

2. **Process Path Data**:
   - Calls `parse_final_summary_stats.py` to generate data for:
     - Path types (`oblivious`, `kspYen`, `widest`).
     - Number of paths (`1`, `2`, `8`).

3. **Handle Credit Distributions**:
   - For each credit distribution scheme (`uniform`, `gaussian`, `lnd`):
     - Adjusts parameters like credit amounts and topology suffixes.
     - Calls `parse_final_summary_stats.py` to generate:
       - Summary statistics for credit distributions.
       - Probability and size statistics for payments.

4. **Save Results**:
   - Saves parsed data into files with meaningful names (e.g., `${topo}_${credit}_credit_data`).

---

## 2. `generate_analysis_plots_for_single_run.py`

### Purpose
This Python script generates detailed plots and summaries from simulation output files (`.vec` and `.sca`). It supports a wide range of visualization options to analyze network performance metrics.

### Key Features
- Supports multiple plot types for analyzing network behavior.
- Aggregates data per router, channel, or source-destination pair.
- Outputs plots as PDF files for easy sharing and review.

### Command-Line Arguments
The script accepts the following arguments:
- `--detail`: Whether to generate detailed plots or just summaries (default: `True`).
- `--vec_file`: Path to the `.vec` file containing time-series data.
- `--sca_file`: Path to the `.sca` file containing scalar data.
- Plot-specific flags (e.g., `--balance`, `--queue_info`, `--timeouts`):
  - Enable generation of specific plots (e.g., balance information, queue sizes, timeouts).
- `--save`: Prefix for saving generated PDF files.

### Supported Plots
The script can generate plots for various metrics, including:
- **Balance Information**:
  - Balance and inflight funds for all routers.
- **Queue Information**:
  - Queue sizes, delays, and fake rebalance queues.
- **Timeouts**:
  - Number of timeouts at senders or for source-destination pairs.
- **Throughput**:
  - Fraction of completed transactions over time.
- **Path Metrics**:
  - Path indices, probabilities, bottlenecks, and rates for sending/acknowledging transactions.
- **Price-Based Metrics**:
  - Per-channel prices, demand estimates, and capacity-related prices.
- **Rebalancing**:
  - Implicit and explicit rebalancing amounts.

### Script Workflow
1. **Parse Input Files**:
   - Reads `.vec` and `.sca` files using helper functions (`parse_vec_file`, `parse_sca_file`).

2. **Aggregate Data**:
   - Aggregates time-series data per router, channel, or source-destination pair using `aggregate_info_per_node`.

3. **Generate Plots**:
   - Calls `plot_relevant_stats` to create plots for specified metrics.
   - Saves plots as PDF pages using `PdfPages`.

4. **Output Summary Statistics**:
   - Writes summary statistics to a text file (`${save}_summary.txt`).

5. **Optional Debugging Output**:
   - Writes additional data to a `ggplot.txt` file for further analysis.

---

## Usage Examples

### Running `gather_sw_sf_data.sh`
```bash
./gather_sw_sf_data.sh
```
This will process all specified topologies and credit distributions, saving parsed data into appropriately named files.

### Running `generate_analysis_plots_for_single_run.py`
```bash
python generate_analysis_plots_for_single_run.py \
    --vec_file simulation_output.vec \
    --sca_file simulation_output.sca \
    --balance \
    --queue_info \
    --save output_plots
```
This command generates balance and queue information plots, saving them as `output_plots_per_channel_info.pdf` and `output_plots_per_src_dest_stats.pdf`.

---

## Notes
1. **Dependencies**:
   - Requires Python libraries: `matplotlib`, `numpy`, `argparse`, `collections`.
   - Ensure `parse_final_summary_stats.py`, `parse_vec_files.py`, and `parse_sca_files.py` are accessible.

2. **Customization**:
   - Modify the `gather_sw_sf_data.sh` script to include additional topologies or schemes.
   - Add new plot types to `generate_analysis_plots_for_single_run.py` by extending the argument parser and plotting logic.

3. **Visualization**:
   - Generated PDFs provide a comprehensive view of network performance, aiding in debugging and optimization.

---

This documentation should serve as a guide for understanding and using the provided scripts effectively.

Certainly! Below is the documentation for the provided code snippets, which include shell scripts and a Python script used to generate benchmark simulations, workloads, and results analysis in an OMNeT++ environment.

---

# **Documentation for Spider-OMNeT Benchmark Generation Scripts**

This document provides an overview of the shell scripts (`generate_circulation_benchmarks.sh`, `generate_dag_benchmarks.sh`, `generate_rebalancing_benchmarks.sh`) and the Python script (`generate_summary_cdf.py`) used for generating network topologies, simulating workloads, and analyzing simulation results. These scripts are part of the Spider-OMNeT project, designed to simulate payment networks and analyze their performance under various conditions.

---

## **1. Shell Scripts**

### **1.1 `generate_circulation_benchmarks.sh`**
#### **Purpose**
This script generates benchmarks for circulation-based simulations in the Spider-OMNeT framework. It creates network topologies, transaction workloads, and configuration files for different demand levels and balance scenarios.

#### **Key Variables**
- **`PATH_NAME`**: Directory where benchmark files are stored.
- **`GRAPH_PATH`**: Path to graph-related figures or data.
- **`num_nodes`**: Array specifying the number of nodes for each topology.
- **`prefix`**: Array of prefixes identifying the topology names.
- **`demand_scale`**: Scale factor for transaction demand.
- **General Parameters**:
  - `simulationLength`: Total simulation duration (default: 5100).
  - `statCollectionRate`: Rate at which statistics are collected (default: 100).
  - `timeoutClearRate`: Timeout clearing rate (default: 1).
  - Flags like `random_init_bal`, `random_capacity`, and `lnd_capacity` control initialization behaviors.

#### **Workflow**
1. **Topology Creation**:
   - Iterates over specified indices in the `prefix` array.
   - Calls `create_topo_ned_file.py` to generate `.ned` topology files based on graph type (`small_world`, `scale_free`, etc.).
   - Sets parameters such as delay, balance per channel, and randomization flags.

2. **Workload Generation**:
   - For each topology, generates multiple workload files with varying demand scales.
   - Calls `create_workload.py` to create transaction workloads in JSON format.

3. **Output Files**:
   - `.ned` files for network topologies.
   - `.txt` topology description files.
   - Workload files in JSON format.

---

### **1.2 `generate_dag_benchmarks.sh`**
#### **Purpose**
This script generates benchmarks for Directed Acyclic Graph (DAG)-based simulations. It focuses on creating topologies and workloads with specific DAG percentages.

#### **Key Variables**
- **`dag_percent`**: Array of DAG percentages to simulate.
- **`balance`**: Initial balance per channel (default: 4000).
- Other variables are similar to those in `generate_circulation_benchmarks.sh`.

#### **Workflow**
1. **Topology Creation**:
   - Similar to `generate_circulation_benchmarks.sh`, but includes DAG-specific logic.
   - Creates `.ned` files and topology descriptions.

2. **Workload Generation**:
   - Generates workloads with specified DAG percentages using `create_workload.py`.

3. **Output Files**:
   - Similar to `generate_circulation_benchmarks.sh`, but tailored for DAG-based simulations.

---

### **1.3 `generate_rebalancing_benchmarks.sh`**
#### **Purpose**
This script generates benchmarks for rebalancing simulations. It focuses on scenarios where rebalancing is enabled in the network.

#### **Key Variables**
- **`rebalancing-enabled`**: Flag to enable rebalancing in the topology.
- Other variables are similar to the previous scripts.

#### **Workflow**
1. **Topology Creation**:
   - Includes an additional flag for enabling rebalancing in the network.
   - Creates `.ned` files and topology descriptions.

2. **Workload Generation**:
   - Similar to `generate_dag_benchmarks.sh`, but with rebalancing-specific configurations.

3. **Output Files**:
   - Similar to other scripts, but includes rebalancing-specific metadata.

---

## **2. Python Script**

### **2.1 `generate_summary_cdf.py`**
#### **Purpose**
This script analyzes simulation results by computing and plotting Cumulative Distribution Functions (CDFs) for path completion rates.

#### **Key Features**
- Parses `.vec` files generated by OMNeT++ simulations.
- Computes average path completion rates across all source-destination pairs.
- Plots CDFs comparing different algorithms or configurations.

#### **Command-Line Arguments**
- **`--vec_files`**: List of `.vec` files to analyze.
- **`--labels`**: Labels for each `.vec` file (used in the plot legend).
- **`--save`**: File path to save the resulting plot.

#### **Workflow**
1. **Data Parsing**:
   - Uses `parse_vec_files.py` to extract signal data from `.vec` files.
   - Aggregates completion rates for attempted and completed transactions.

2. **CDF Computation**:
   - Computes completion fractions for each path between source-destination pairs.
   - Calculates overall success rates.

3. **Plotting**:
   - Generates a CDF plot using Matplotlib.
   - Saves the plot to the specified file.

#### **Output**
- A CDF plot saved as an image file (e.g., `.png`).

---

## **3. Common Tools and Dependencies**

### **3.1 Python Dependencies**
- **Matplotlib**: Used for plotting CDFs.
- **NumPy**: Used for numerical computations.
- **Custom Module**: `parse_vec_files.py` for parsing OMNeT++ vector files.

### **3.2 Shell Script Dependencies**
- **Python Interpreter**: Scripts rely on Python scripts (`create_topo_ned_file.py`, `create_workload.py`) for topology and workload generation.
- **OMNeT++**: The generated `.ned` and `.ini` files are intended for use with OMNeT++ simulations.

---

## **4. Usage Instructions**

### **4.1 Generating Benchmarks**
1. Modify the `array` variable in the shell scripts to specify the indices of topologies to simulate.
2. Run the desired shell script:
   ```bash
   ./generate_circulation_benchmarks.sh
   ```
3. Ensure Python dependencies are installed:
   ```bash
   pip install matplotlib numpy
   ```

### **4.2 Analyzing Results**
1. Collect `.vec` files from OMNeT++ simulations.
2. Run the Python script:
   ```bash
   python generate_summary_cdf.py --vec_files file1.vec file2.vec --labels Label1 Label2 --save output.png
   ```

---

## **5. Notes and Recommendations**
- **Customization**: Adjust parameters like `demand_scale`, `balance`, and `dag_percent` to suit specific simulation requirements.
- **Error Handling**: Add error handling in shell scripts to manage missing files or invalid inputs.
- **Performance**: Use parallel processing for large-scale simulations to improve efficiency.

---

This documentation provides a comprehensive overview of the scripts and their functionalities. For further details, refer to the inline comments in the scripts and the Spider-OMNeT project documentation.





Certainly! Below is the documentation for the provided code snippets, which include shell scripts and a Python script used to generate benchmark simulations, workloads, and results analysis in an OMNeT++ environment.

---

# **Documentation for Spider-OMNeT Benchmark Generation Scripts**

This document provides an overview of the shell scripts (`generate_circulation_benchmarks.sh`, `generate_dag_benchmarks.sh`, `generate_rebalancing_benchmarks.sh`) and the Python script (`generate_summary_cdf.py`) used for generating network topologies, simulating workloads, and analyzing simulation results. These scripts are part of the Spider-OMNeT project, designed to simulate payment networks and analyze their performance under various conditions.

---

## **1. Shell Scripts**

### **1.1 `generate_circulation_benchmarks.sh`**
#### **Purpose**
This script generates benchmarks for circulation-based simulations in the Spider-OMNeT framework. It creates network topologies, transaction workloads, and configuration files for different demand levels and balance scenarios.

#### **Key Variables**
- **`PATH_NAME`**: Directory where benchmark files are stored.
- **`GRAPH_PATH`**: Path to graph-related figures or data.
- **`num_nodes`**: Array specifying the number of nodes for each topology.
- **`prefix`**: Array of prefixes identifying the topology names.
- **`demand_scale`**: Scale factor for transaction demand.
- **General Parameters**:
  - `simulationLength`: Total simulation duration (default: 5100).
  - `statCollectionRate`: Rate at which statistics are collected (default: 100).
  - `timeoutClearRate`: Timeout clearing rate (default: 1).
  - Flags like `random_init_bal`, `random_capacity`, and `lnd_capacity` control initialization behaviors.

#### **Workflow**
1. **Topology Creation**:
   - Iterates over specified indices in the `prefix` array.
   - Calls `create_topo_ned_file.py` to generate `.ned` topology files based on graph type (`small_world`, `scale_free`, etc.).
   - Sets parameters such as delay, balance per channel, and randomization flags.

2. **Workload Generation**:
   - For each topology, generates multiple workload files with varying demand scales.
   - Calls `create_workload.py` to create transaction workloads in JSON format.

3. **Output Files**:
   - `.ned` files for network topologies.
   - `.txt` topology description files.
   - Workload files in JSON format.

---

### **1.2 `generate_dag_benchmarks.sh`**
#### **Purpose**
This script generates benchmarks for Directed Acyclic Graph (DAG)-based simulations. It focuses on creating topologies and workloads with specific DAG percentages.

#### **Key Variables**
- **`dag_percent`**: Array of DAG percentages to simulate.
- **`balance`**: Initial balance per channel (default: 4000).
- Other variables are similar to those in `generate_circulation_benchmarks.sh`.

#### **Workflow**
1. **Topology Creation**:
   - Similar to `generate_circulation_benchmarks.sh`, but includes DAG-specific logic.
   - Creates `.ned` files and topology descriptions.

2. **Workload Generation**:
   - Generates workloads with specified DAG percentages using `create_workload.py`.

3. **Output Files**:
   - Similar to `generate_circulation_benchmarks.sh`, but tailored for DAG-based simulations.

---

### **1.3 `generate_rebalancing_benchmarks.sh`**
#### **Purpose**
This script generates benchmarks for rebalancing simulations. It focuses on scenarios where rebalancing is enabled in the network.

#### **Key Variables**
- **`rebalancing-enabled`**: Flag to enable rebalancing in the topology.
- Other variables are similar to the previous scripts.

#### **Workflow**
1. **Topology Creation**:
   - Includes an additional flag for enabling rebalancing in the network.
   - Creates `.ned` files and topology descriptions.

2. **Workload Generation**:
   - Similar to `generate_dag_benchmarks.sh`, but with rebalancing-specific configurations.

3. **Output Files**:
   - Similar to other scripts, but includes rebalancing-specific metadata.

---

## **2. Python Script**

### **2.1 `generate_summary_cdf.py`**
#### **Purpose**
This script analyzes simulation results by computing and plotting Cumulative Distribution Functions (CDFs) for path completion rates.

#### **Key Features**
- Parses `.vec` files generated by OMNeT++ simulations.
- Computes average path completion rates across all source-destination pairs.
- Plots CDFs comparing different algorithms or configurations.

#### **Command-Line Arguments**
- **`--vec_files`**: List of `.vec` files to analyze.
- **`--labels`**: Labels for each `.vec` file (used in the plot legend).
- **`--save`**: File path to save the resulting plot.

#### **Workflow**
1. **Data Parsing**:
   - Uses `parse_vec_files.py` to extract signal data from `.vec` files.
   - Aggregates completion rates for attempted and completed transactions.

2. **CDF Computation**:
   - Computes completion fractions for each path between source-destination pairs.
   - Calculates overall success rates.

3. **Plotting**:
   - Generates a CDF plot using Matplotlib.
   - Saves the plot to the specified file.

#### **Output**
- A CDF plot saved as an image file (e.g., `.png`).

---

## **3. Common Tools and Dependencies**

### **3.1 Python Dependencies**
- **Matplotlib**: Used for plotting CDFs.
- **NumPy**: Used for numerical computations.
- **Custom Module**: `parse_vec_files.py` for parsing OMNeT++ vector files.

### **3.2 Shell Script Dependencies**
- **Python Interpreter**: Scripts rely on Python scripts (`create_topo_ned_file.py`, `create_workload.py`) for topology and workload generation.
- **OMNeT++**: The generated `.ned` and `.ini` files are intended for use with OMNeT++ simulations.

---

## **4. Usage Instructions**

### **4.1 Generating Benchmarks**
1. Modify the `array` variable in the shell scripts to specify the indices of topologies to simulate.
2. Run the desired shell script:
   ```bash
   ./generate_circulation_benchmarks.sh
   ```
3. Ensure Python dependencies are installed:
   ```bash
   pip install matplotlib numpy
   ```

### **4.2 Analyzing Results**
1. Collect `.vec` files from OMNeT++ simulations.
2. Run the Python script:
   ```bash
   python generate_summary_cdf.py --vec_files file1.vec file2.vec --labels Label1 Label2 --save output.png
   ```

---

## **5. Notes and Recommendations**
- **Customization**: Adjust parameters like `demand_scale`, `balance`, and `dag_percent` to suit specific simulation requirements.
- **Error Handling**: Add error handling in shell scripts to manage missing files or invalid inputs.
- **Performance**: Use parallel processing for large-scale simulations to improve efficiency.

---

This documentation provides a comprehensive overview of the scripts and their functionalities. For further details, refer to the inline comments in the scripts and the Spider-OMNeT project documentation.




Certainly! Below is a structured documentation for the provided code snippets, which include two scripts: `get-queue-numbers-capacityFactor-1.sh` and `kshortestpaths.py`. The documentation provides an overview of functionality, usage, parameters, and implementation details.

---

# Documentation for `get-queue-numbers-capacityFactor-1.sh`

## 1. **Script: `get-queue-numbers-capacityFactor-1.sh`**

### Overview
This script automates the execution of a Python script (`parse_vec_files_queueLines.py`) to process queue-related data for different demand scenarios in a network simulation environment. It iterates over predefined demand values and generates output files for further analysis.

### Purpose
The script processes `.vec` files generated from OMNeT++ simulations, extracting queue-related metrics under various configurations (e.g., with/without windowing or queues). The results are saved as text files for visualization or further processing.

### Usage
Run the script in a Unix-like shell:
```bash
bash get-queue-numbers-capacityFactor-1.sh
```

### Key Parameters
- **Demand Values**: Iterates over `demand = 1, 3, 6, 9`.
- **Python Script**: Calls `parse_vec_files_queueLines.py` with specific arguments.
- **Input Files**: `.vec` files located in `/home/ubuntu/omnetpp-5.4.1/samples/spider_omnet/benchmarks/circulations/results/`.
- **Output Files**: Results are saved in `figures/timeouts/capacity-factor-1-queue-1000/`.

### Implementation Details
1. **For Demand Values 1, 3, 6**:
   - Executes the Python script with `woWin` configuration.
   - Generates output files named `queue-sw50-kaggle-demand${demand}-woWin-capacityFactor1.txt`.

2. **For Demand Value 9**:
   - Executes the Python script with `woQ` configuration.
   - Generates output file named `queue-sw50-kaggle-demand9-woQ-capacityFactor1.txt`.

3. **Commented Lines**:
   - Additional configurations (`regular`, `woQ`) are commented out but can be uncommented for extended analysis.

### Example Command
For `demand = 1`:
```bash
python parse_vec_files_queueLines.py /home/ubuntu/omnetpp-5.4.1/samples/spider_omnet/benchmarks/circulations/results/capacity-factor-1-queue-1000/sw_50_routers_circ_net_priceScheme_demand1_shortest_4-#0.vec 1 woWin 3000 5000 figures/timeouts/capacity-factor-1-queue-1000/queue-sw50-kaggle-demand1-woWin-capacityFactor1.txt
```

---

## 2. **Script: `kshortestpaths.py`**

### Overview
This Python script implements algorithms for computing multiple shortest paths between nodes in a graph. It supports various path computation methods, including Yen's algorithm, edge-disjoint shortest paths, and heuristic-based widest paths. The script also handles graph construction, credit matrix generation, and path serialization.

### Purpose
The script is designed to compute and store sets of paths for network topologies, which can be used for routing optimization, simulation, or analysis in network research.

### Usage
Run the script from the command line with required arguments:
```bash
python kshortestpaths.py --credit_type <type> --graph_type <type> --path_type <type> --max_num_paths <num>
```

### Key Parameters
- **`--credit_type`**: Specifies the type of credit matrix to use (`uniform`, `random`, `txt`, `edgelist`).
- **`--graph_type`**: Specifies the type of graph to construct (`scale_free`, `small_world`, `txt`, `lnd`, `edgelist`).
- **`--path_type`**: Specifies the path computation method (`ksp_yen`, `ksp_edge_disjoint`, `kwp_edge_disjoint`, `heuristic`).
- **`--topo_txt_file`**: Path to a topology file (required for `txt` graph type).
- **`--max_num_paths`**: Maximum number of paths to compute between each pair of nodes.

### Implementation Details
1. **Graph Construction**:
   - Supports random graph models (`scale_free`, `small_world`) and custom topologies (`txt`, `edgelist`).
   - Ensures the graph is connected before proceeding.

2. **Credit Matrix**:
   - Defines link capacities and propagation delays based on the specified `credit_type`.

3. **Path Computation**:
   - **Yen's Algorithm (`ksp_yen`)**: Computes up to `max_k` shortest paths using Yen's algorithm.
   - **Edge-Disjoint Shortest Paths (`ksp_edge_disjoint`)**: Finds edge-disjoint shortest paths.
   - **Edge-Disjoint Widest Paths (`kwp_edge_disjoint`)**: Finds edge-disjoint paths maximizing bottleneck capacity.
   - **Heuristic-Based Paths (`heuristic`)**: Selects paths based on a metric combining bottleneck capacity and total delay.

4. **Serialization**:
   - Stores computed paths in a `.pkl` file for later use.

### Functions
- **`ksp_yen(graph, node_start, node_end, max_k)`**:
  Implements Yen's algorithm for finding `max_k` shortest paths.

- **`ksp_edge_disjoint(graph, node_start, node_end, max_k)`**:
  Computes edge-disjoint shortest paths.

- **`kwp_edge_disjoint(graph, node_start, node_end, max_k, credit_mat)`**:
  Computes edge-disjoint widest paths using a modified Dijkstra's algorithm.

- **`heuristic(intermediary_paths, capacity_mat, prop_mat, max_k)`**:
  Selects the best `max_k` paths based on a heuristic metric.

- **`raeke(node_start, node_end)`**:
  Loads precomputed paths from a pickle file.

- **`main()`**:
  Parses command-line arguments, constructs the graph and credit matrix, computes paths, and saves them.

### Example Command
Compute 4 shortest paths for a small-world graph with uniform credit:
```bash
python kshortestpaths.py --credit_type uniform --graph_type small_world --path_type ksp_yen --max_num_paths 4
```

### Output
- A `.pkl` file containing all computed paths, stored in the `./paths/` directory.
- File name format: `<graph_type>_<path_type>.pkl`.

---

## Notes
1. **Dependencies**:
   - Requires Python libraries: `networkx`, `numpy`, `argparse`, `cPickle`.
   - Ensure the `../paths` and `../topology` directories exist and contain necessary files.

2. **Extensibility**:
   - Add new graph types or path computation methods by extending the respective functions.

3. **Error Handling**:
   - The script validates graph connectivity and handles missing paths gracefully.

---

This documentation provides a comprehensive overview of the scripts' functionality, usage, and implementation. It serves as a guide for users and developers working with the codebase.


### Documentation for `max_circulation.py` and `parse_completion_times.py`

---

## **1. File: `max_circulation.py`**

### **Overview**
This script computes the maximum circulation value in a given demand matrix using linear programming with the Gurobi optimization library. It defines a function `max_circulation` that takes a demand dictionary as input and returns the maximum flow value satisfying the circulation constraints.

---

### **Function: `max_circulation(demand_dict)`**

#### **Purpose**
To compute the maximum circulation value in a network represented by a demand matrix.

#### **Parameters**
- **`demand_dict`** (`dict`): A dictionary where keys are tuples `(i, j)` representing directed edges from node `i` to node `j`, and values are the maximum allowed flow on that edge.

#### **Returns**
- **`obj`** (`float`): The total flow value achieved after solving the optimization problem.

#### **Steps**
1. **Model Initialization**:
   - A Gurobi model is created.
   - Output is suppressed (`OutputFlag=0`) and a time limit (`TIME_LIMIT`) is set for the optimization process.

2. **Variable Creation**:
   - For each edge `(i, j)` in `demand_dict`, a continuous variable `xvar[i, j]` is added to the model.
   - The variable is constrained between 0 and the maximum allowed flow on the edge.

3. **Circulation Constraints**:
   - Nodes with non-zero demand are identified.
   - For each node, a constraint is added to ensure that the incoming flow equals the outgoing flow (flow conservation).

4. **Optimization**:
   - The objective is to maximize the total flow.
   - The model is solved using Gurobi's optimizer.

5. **Solution Extraction**:
   - The total flow value is computed by summing up the values of all variables in the optimal solution.

---

### **Global Variable**
- **`TIME_LIMIT`** (`int`): Maximum time (in seconds) allowed for the optimization process. Default value is `120`.

---

### **Function: `main()`**

#### **Purpose**
To demonstrate the usage of the `max_circulation` function with a sample demand dictionary.

#### **Example Demand Dictionary**
```python
demand_dict = {
    (0, 1): 1.0,
    (1, 2): 1.0,
    (2, 3): 1.0,
    (3, 0): 1.0,
    (3, 1): 1.0,
    (2, 0): 1.0
}
```

#### **Output**
The script prints the maximum circulation value for the given demand dictionary.

---

## **2. File: `parse_completion_times.py`**

### **Overview**
This script processes transaction completion time data for a payment network simulation. It aggregates statistics (e.g., average, 90th percentile, 99th percentile) for transaction sizes grouped into buckets and writes the results to a CSV file.

---

### **Function: `compute_buckets(num_buckets, dist_filename)`**

#### **Purpose**
To compute size buckets for grouping transactions based on their sizes.

#### **Parameters**
- **`num_buckets`** (`int`): Number of buckets to create.
- **`dist_filename`** (`str`): Path to the file containing the transaction size distribution.

#### **Returns**
- **`buckets`** (`list`): List of bucket boundaries.

#### **Steps**
1. Load the transaction size distribution from the file.
2. Compute the cumulative distribution function (CDF) of transaction sizes.
3. Divide the CDF into equal intervals to determine bucket boundaries.

---

### **Command-Line Arguments**
The script accepts the following arguments via `argparse`:

| Argument             | Type      | Description                                                                 |
|----------------------|-----------|-----------------------------------------------------------------------------|
| `--topo`             | `str`     | Topology type (required).                                                  |
| `--payment-graph-type` | `str`   | Payment graph type (default: `"circ"`).                                    |
| `--credit`           | `int`     | Credit value for which statistics are collected (default: `10`).           |
| `--demand`           | `int`     | Demand value for which statistics are collected (default: `30`).           |
| `--path-type`        | `str`     | Type of paths used (default: `"shortest"`).                                |
| `--path-num`         | `int`     | Number of paths used (default: `4`).                                       |
| `--scheme-list`      | `list`    | List of schemes to aggregate results for (default: `["priceSchemeWindow"]`). |
| `--save`             | `str`     | Filename to save the output data (required).                               |
| `--num-max`          | `int`     | Maximum number of runs to aggregate data over (default: `5`).              |
| `--num-buckets`      | `int`     | Number of buckets to group transaction sizes into (default: `20`).         |
| `--lnd-retry-data`   | `bool`    | Whether to parse LND retry information.                                    |

---

### **Function: `collect_retry_stats(succ_retry_file, fail_retry_file)`**

#### **Purpose**
To collect retry statistics for successful and failed transactions in the LND baseline scheme.

#### **Parameters**
- **`succ_retry_file`** (`str`): Filename containing successful retry data.
- **`fail_retry_file`** (`str`): Filename containing failed retry data.

#### **Behavior**
- Reads retry counts from the files and appends them to global lists `succ_retries` and `fail_retries`.

---

### **Main Processing Logic**
1. **Bucket Computation**:
   - Buckets are computed using the `compute_buckets` function.

2. **File Parsing**:
   - For each scheme and run number, relevant files are parsed to extract completion times for transactions.
   - Completion times are grouped by transaction size buckets.

3. **Statistics Calculation**:
   - For each bucket, the average, 90th percentile, and 99th percentile completion times are calculated.

4. **Output Writing**:
   - Results are written to a CSV file in the format:
     ```
     Topo,CreditType,Scheme,Credit,SizeStart,SizeEnd,Point,AvgCompTime,TailCompTime90,TailCompTime99,Demand
     ```

---

### **Global Variables**
- **`delay`** (`int`): Fixed delay value (not actively used in the current implementation).
- **`GGPLOT_DATA_DIR`**, **`RESULT_DIR`**, **`KAGGLE_AMT_DIST_FILENAME`**, **`SCHEME_CODE`**: Constants imported from `config.py`.

---

### **Usage Example**
Run the script with the following command:
```bash
python parse_completion_times.py --topo lnd_uniform --save output.csv --num-buckets 20
```

This will generate a CSV file named `output.csv` containing aggregated completion time statistics for the specified topology.

---

### **Notes**
1. Ensure that the required dependencies (`numpy`, `argparse`, `gurobipy`) are installed.
2. The script assumes the existence of specific directory structures and configuration files (`config.py`).
3. Error handling is implemented for missing or inaccessible files.

--- 

This documentation provides a comprehensive overview of the functionality, parameters, and usage of both scripts.




# Documentation for `parse_final_summary_stats.py`

## Overview
This Python script is designed to aggregate and summarize simulation results from a set of files generated by a network simulation tool. The script processes the data based on various input parameters, computes statistical metrics (e.g., mean, min, max), and writes the aggregated results to an output file in a structured format.

The script is highly configurable, allowing users to specify multiple parameters such as topology, credit values, scheduling algorithms, path types, and more. It supports both circular payment graphs (`circ`) and directed acyclic graph (DAG) payment graphs.

---

## File Details
- **File Path**:  
  `\\wsl.localhost\Ubuntu-20.04\home\ad\omnetpp-5.6\samples\spider_omnet-Copy\scripts\parse_final_summary_stats.py`
  
- **Dependencies**:
  - `sys`: For system-level operations.
  - `argparse`: For parsing command-line arguments.
  - `statistics`: For computing statistical metrics like mean, min, and max.
  - `config`: A custom module that likely contains configuration constants such as `GGPLOT_DATA_DIR`, `SUMMARY_DIR`, `SCHEME_CODE`, and `PERCENT_MAPPING`.

---

## Command-Line Arguments

The script accepts the following command-line arguments:

| Argument Name               | Type       | Required | Default Value | Description                                                                 |
|-----------------------------|------------|----------|---------------|-----------------------------------------------------------------------------|
| `--topo`                    | `str`      | Yes      | N/A           | Specifies the topology for which to generate the summary.                  |
| `--payment-graph-type`      | `str`      | No       | `"circ"`      | Specifies the type of payment graph (`circ` or `dag`).                     |
| `--credit-list`             | `list`     | Yes      | N/A           | List of credit values to collect statistics for.                           |
| `--demand`                  | `int`      | No       | `30`          | Single number denoting the demand to collect data for.                     |
| `--path-type-list`          | `list`     | No       | `["shortest"]`| Types of paths to collect data for (e.g., `shortest`, `widest`).            |
| `--scheduling-alg-list`     | `list`     | No       | `[None]`      | Scheduling algorithms to collect information for.                          |
| `--queue-threshold-list`    | `list`     | No       | `[None]`      | Queue thresholds to collect information for.                               |
| `--dag-percent-list`        | `list`     | No       | `[None]`      | DAG percentages to collect information for (used with `dag` payment graph).|
| `--path-num-list`           | `list`     | No       | `[4]`         | Number of paths to collect data for.                                       |
| `--scheme-list`             | `list`     | No       | `["priceSchemeWindow"]` | Set of schemes to aggregate results for.                           |
| `--save`                    | `str`      | Yes      | N/A           | File name to save the aggregated data in.                                  |
| `--num-max`                 | `int`      | No       | `5`           | Maximum number of runs to aggregate data over.                             |

---

## Script Workflow

1. **Argument Parsing**:
   - The script uses the `argparse` module to parse command-line arguments.
   - All required arguments are validated, and default values are assigned to optional arguments.

2. **Output File Initialization**:
   - An output file is created in the directory specified by `GGPLOT_DATA_DIR`.
   - The header of the output file is written, containing column names such as `Scheme`, `Credit`, `Topo`, `SuccRatio`, etc.

3. **Topology and Credit Type Determination**:
   - Based on the `topo` argument, the script determines the topology type (`topo_type`) and credit type (`credit_type`).

4. **Data Aggregation**:
   - The script iterates over all combinations of the provided parameters (e.g., `credit_list`, `scheme_list`, `path_type_list`, etc.).
   - For each combination, it constructs the corresponding file name and attempts to open the file.
   - If the file exists, it reads the success ratio, success volume, and average completion time from the file and appends these values to lists.

5. **Statistical Analysis**:
   - After collecting data for all runs (up to `num_max`), the script computes the mean, min, and max for success ratio, success volume, and completion time.

6. **Writing Results**:
   - The aggregated results are written to the output file in CSV format.
   - If the payment graph type is `dag`, additional rows are added to represent ideal performance metrics.

7. **Error Handling**:
   - If a file cannot be opened (e.g., due to missing data), the script prints an error message and skips that file.

8. **Finalization**:
   - The output file is closed after all data has been written.

---

## Key Variables and Constants

| Variable/Constant           | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `delay`                     | Fixed delay value used in file naming (default: `30`).                      |
| `topo_type`                 | Derived from the `topo` argument, represents the topology type.             |
| `credit_type`               | Derived from the `topo` argument, represents the credit distribution type.  |
| `succ_ratios`, `succ_vols`, `comp_times` | Lists to store success ratios, success volumes, and completion times. |
| `GGPLOT_DATA_DIR`           | Directory where the output file is saved (defined in `config.py`).         |
| `SUMMARY_DIR`               | Directory where input summary files are located (defined in `config.py`).  |
| `SCHEME_CODE`               | Mapping of scheme names to their codes (defined in `config.py`).           |
| `PERCENT_MAPPING`           | Mapping of DAG percentages to their numerical values (defined in `config.py`). |

---

## Example Usage

### Command-Line Invocation
```bash
python parse_final_summary_stats.py \
    --topo lnd_uniform \
    --credit-list 10 20 30 \
    --demand 50 \
    --path-type-list shortest widest \
    --scheduling-alg-list FIFO LIFO \
    --queue-threshold-list 10 20 \
    --dag-percent-list 0 50 \
    --path-num-list 2 4 \
    --scheme-list priceSchemeWindow waterfilling \
    --save results.csv \
    --num-max 10
```

### Explanation
- The script will process data for the `lnd_uniform` topology with credit values of `10`, `20`, and `30`.
- It will consider both `shortest` and `widest` path types, using `FIFO` and `LIFO` scheduling algorithms.
- Queue thresholds of `10` and `20` will be considered for DAG percentages of `0` and `50`.
- The results will be saved in `results.csv` after aggregating data from up to `10` runs.

---

## Output Format

The output file is a CSV file with the following columns:

| Column Name         | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `Scheme`            | Code representing the scheduling scheme.                                   |
| `Credit`            | Credit value multiplied by a scaling factor (based on topology and credit type). |
| `DAGAmt`            | Percentage of DAG transactions (only for `dag` payment graphs).            |
| `Topo`              | Topology type (e.g., `lnd`, `sw`).                                         |
| `CreditType`        | Credit distribution type (e.g., `uniform`, `lnd`).                         |
| `NumPaths`          | Number of paths used in the simulation.                                    |
| `PathType`          | Type of path (e.g., `shortest`, `widest`).                                 |
| `SchedulingAlg`     | Scheduling algorithm used (e.g., `FIFO`, `LIFO`).                          |
| `Threshold`         | Queue threshold value.                                                     |
| `SuccRatio`         | Mean success ratio across all runs.                                        |
| `SuccRatioMin`      | Minimum success ratio across all runs.                                     |
| `SuccRatioMax`      | Maximum success ratio across all runs.                                     |
| `SuccVolume`        | Mean success volume across all runs.                                       |
| `SuccVolumeMin`     | Minimum success volume across all runs.                                    |
| `SuccVolumeMax`     | Maximum success volume across all runs.                                    |
| `CompTime`          | Mean completion time across all runs.                                      |
| `CompTimeMin`       | Minimum completion time across all runs.                                   |
| `CompTimeMax`       | Maximum completion time across all runs.                                   |

---

## Error Handling
- If a file cannot be found or opened, the script prints an error message and skips that file.
- Missing or invalid arguments result in an error during argument parsing.

---

## Notes
- Ensure that the `config.py` file is correctly configured with the necessary constants (`GGPLOT_DATA_DIR`, `SUMMARY_DIR`, etc.).
- The script assumes that the input files follow a specific naming convention and contain lines starting with `Success ratio`, `Success volume`, and `Avg completion time`.
- For DAG payment graphs, the script adds additional rows to represent ideal performance metrics.

---

This documentation provides a comprehensive overview of the script's functionality, usage, and output format.


# Documentation for `parse_probability_size_stats.py` and `parse_rebalancing_stats.py`

### Overview
These scripts are designed to analyze and aggregate data from simulation runs in a network topology environment. The first script, `parse_probability_size_stats.py`, focuses on analyzing transaction sizes and probabilities, while the second script, `parse_rebalancing_stats.py`, deals with rebalancing statistics and other performance metrics.

---

## `parse_probability_size_stats.py`

### Purpose
This script processes simulation results to compute and summarize transaction size distributions and their success probabilities. It aggregates data over multiple simulation runs and outputs the results into a CSV file.

### Key Functions

#### `compute_buckets(num_buckets, dist_filename)`
- **Purpose**: Computes bucket boundaries for grouping transaction sizes based on their probability distribution.
- **Parameters**:
  - `num_buckets` (int): Number of buckets to divide the transaction sizes into.
  - `dist_filename` (str): Path to the `.npy` file containing the transaction size distribution.
- **Returns**: A list of bucket boundaries.
- **Logic**:
  - Loads the transaction size distribution from the `.npy` file.
  - Computes the cumulative distribution function (CDF) of transaction sizes.
  - Divides the CDF into equally spaced intervals (buckets) based on the number of transactions in each bucket.

---

### Command-Line Arguments

| Argument               | Type         | Required | Default           | Description                                                                 |
|------------------------|--------------|----------|-------------------|-----------------------------------------------------------------------------|
| `--topo`               | str          | Yes      | None              | Topology for which to generate size summary.                                |
| `--payment-graph-type` | str          | No       | "circ"            | Type of payment graph (e.g., circular or DAG).                              |
| `--credit`             | int          | No       | 10                | Credit value to collect stats for.                                         |
| `--demand`             | int          | No       | 30                | Demand level for which to collect data.                                    |
| `--path-type`          | str          | No       | "shortest"        | Type of paths to collect data for (e.g., shortest or widest).              |
| `--path-num`           | int          | No       | 4                 | Number of paths to consider.                                               |
| `--scheme-list`        | list of str  | No       | ["priceSchemeWindow"] | List of schemes to aggregate results for.                          |
| `--save`               | str          | Yes      | None              | File name to save the output data.                                         |
| `--num-max`            | int          | No       | 5                 | Maximum number of simulation runs to aggregate data over.                  |
| `--num-buckets`        | int          | No       | 20                | Number of buckets to group transaction sizes into.                         |

---

### Workflow
1. **Bucket Computation**:
   - Uses the `compute_buckets` function to determine transaction size buckets based on the provided distribution file (`KAGGLE_AMT_DIST_FILENAME`).

2. **File Parsing**:
   - Iterates over all specified simulation runs (`num_max`) and parses result files (`*.sca`) for each scheme.
   - Extracts transaction size (`size`), number of arrivals (`num_arrived`), and number of completions (`num_completed`).

3. **Aggregation**:
   - Aggregates the number of arrivals and completions for each bucket.
   - Ensures that the number of completions does not exceed the number of arrivals.

4. **Output**:
   - Writes the aggregated data into a CSV file with columns: `Topo`, `CreditType`, `Scheme`, `Credit`, `SizeStart`, `SizeEnd`, `Point`, `Prob`, `Demand`.

---

### Example Usage
```bash
python parse_probability_size_stats.py \
    --topo lnd_uniform \
    --payment-graph-type circ \
    --credit 10 \
    --demand 30 \
    --path-type shortest \
    --path-num 4 \
    --scheme-list priceSchemeWindow waterfilling \
    --save output.csv \
    --num-max 5 \
    --num-buckets 20
```

---

## `parse_rebalancing_stats.py`

### Purpose
This script analyzes rebalancing statistics and other performance metrics from simulation runs. It aggregates data across multiple runs and outputs the results into a CSV file.

---

### Command-Line Arguments

| Argument               | Type         | Required | Default           | Description                                                                 |
|------------------------|--------------|----------|-------------------|-----------------------------------------------------------------------------|
| `--topo`               | str          | Yes      | None              | Topology for which to generate summary.                                    |
| `--payment-graph-type` | str          | No       | "circ"            | Type of payment graph (e.g., circular or DAG).                              |
| `--credit-list`        | list of str  | Yes      | None              | List of credit values to collect stats for.                                |
| `--demand`             | int          | No       | 30                | Demand level for which to collect data.                                    |
| `--path-type-list`     | list of str  | No       | ["shortest"]      | Types of paths to collect data for (e.g., shortest or widest).             |
| `--scheduling-alg-list`| list of str  | No       | [None]            | Scheduling algorithms to collect info for.                                 |
| `--queue-threshold-list`| list of str | No       | [None]            | Queue thresholds to collect info for.                                      |
| `--dag-percent-list`   | list of str  | No       | [None]            | DAG percentages to collect info for.                                       |
| `--path-num-list`      | list of int  | No       | [4]               | Number of paths to collect data for.                                       |
| `--scheme-list`        | list of str  | No       | ["priceSchemeWindow"] | List of schemes to aggregate results for.                          |
| `--save`               | str          | Yes      | None              | File name to save the output data.                                         |
| `--num-max`            | int          | No       | 5                 | Maximum number of simulation runs to aggregate data over.                  |
| `--rebalancing-rate-list`| list of int| No       | [None]            | List of rebalancing frequencies.                                           |

---

### Workflow
1. **File Parsing**:
   - Iterates over all specified combinations of parameters (e.g., credit, scheme, path type, etc.).
   - Parses summary files (`*_summary.txt`) for each simulation run.

2. **Data Extraction**:
   - Extracts metrics such as success ratio, success volume, completion time, rebalanced amount, and offloading.

3. **Aggregation**:
   - Aggregates metrics across multiple runs using statistical measures (mean, min, max).

4. **Output**:
   - Writes the aggregated data into a CSV file with columns:
     - `Scheme`, `Credit`, `DAGAmt`, `Topo`, `CreditType`, `NumPaths`, `PathType`, `SchedulingAlg`, `Threshold`, `RebalancingRate`, `SuccRatio`, `SuccRatioMin`, `SuccRatioMax`, `SuccVolume`, `SuccVolumeMin`, `SuccVolumeMax`, `CompTime`, `CompTimeMin`, `CompTimeMax`, `RebalancingAmt`, `RebalancingAmtMin`, `RebalancingAmtMax`, `Offloading`, `OffloadingMin`, `OffloadingMax`.

---

### Example Usage
```bash
python parse_rebalancing_stats.py \
    --topo lnd_uniform \
    --payment-graph-type circ \
    --credit-list 10 20 30 \
    --demand 30 \
    --path-type-list shortest widest \
    --scheduling-alg-list None RR \
    --queue-threshold-list None 50 \
    --dag-percent-list 0 25 50 \
    --path-num-list 4 8 \
    --scheme-list priceSchemeWindow waterfilling \
    --save output.csv \
    --num-max 5 \
    --rebalancing-rate-list 10 20
```

---

### Notes
- Both scripts rely on external configuration files (`config.py`) and directories (`RESULT_DIR`, `SUMMARY_DIR`, `GGPLOT_DATA_DIR`) for input and output.
- Ensure that the required `.npy` files, `.sca` files, and `_summary.txt` files are available in the appropriate directories before running the scripts.
- The scripts use Python libraries such as `numpy`, `statistics`, and `argparse`. Install these dependencies if not already available.

---

### Dependencies
- Python 3.x
- Libraries: `numpy`, `statistics`, `argparse`

---

### Output Format
Both scripts generate CSV files with aggregated data. These files can be used for further analysis or visualization using tools like R, Python, or Excel.


The provided content appears to be a collection of Python scripts designed for processing, analyzing, and visualizing data from simulation outputs. Below is the structured documentation for the codebase based on the provided files.

---

# Code Documentation

## Overview
This codebase contains Python scripts used for parsing, analyzing, and visualizing simulation results generated by OMNeT++ (or similar simulators). The scripts are tailored to process scalar (`.sca`) and vector (`.vec`) files, compute performance metrics, and generate plots or summaries for further analysis. The primary focus is on analyzing network simulations, particularly those related to payment channel networks (e.g., Spider, LND).

---

# Documentation for `parse_sca_files.py` 

### 1. `parse_sca_files.py`
**Purpose**: Parses `.sca` files to extract statistics and compute performance metrics.

#### Key Functions:
- **`parse_sca_parameter_line(line)`**:
  - Parses a line in the scalar file that starts with `scalar`.
  - Extracts the scalar name and its value.
  
- **`parse_sca_stat_line(line)`**:
  - Parses a line in the scalar file that starts with `statistic`.
  - Identifies the sender, receiver, and type of statistic (`arrived`, `attempted`, `completed`, etc.).

- **`parse_sca_files(filename)`**:
  - Parses the entire `.sca` file.
  - Computes success rates (e.g., completion rate over arrivals and attempts).

- **`parse_sca_files_overall(filename)`**:
  - Aggregates statistics for different time intervals (e.g., first 3000 seconds vs. the entire simulation).
  - Computes metrics such as success ratio, volume-based success, average completion time, retries percentile, and rebalancing statistics.

#### Output:
- Metrics like success ratios, volumes, completion times, and rebalancing statistics.
- Returns aggregated lists and summary strings.

---

### 2. `parse_vec_files_for_ggplot.py`
**Purpose**: Processes `.vec` files to extract time-series data for visualization using ggplot.

#### Key Features:
- **Command-Line Arguments**:
  - Supports filtering by schemes, credit values, start/end times, attributes, and topology.
  - Generates summary data across all source-destination pairs or specific ones.

- **Key Functions**:
  - **`parse_for_timeseries(filename, start_time, end_time, node_type, src, dest, relevant_signal)`**:
    - Extracts time-series data for a specific signal (e.g., queue size, inflight packets).
  - **`aggregate_across_files(scheme_list, credit_list, topo)`**:
    - Aggregates time-series data across multiple files for comparison.

#### Output:
- Time-series data files formatted for ggplot visualization.
- Includes metrics like average inflight tokens, queue sizes, and rates.

---

### 3. `parse_vec_files.py`
**Purpose**: Provides utility functions for parsing `.vec` files.

#### Key Functions:
- **`parse_vec_declaration(line)`**:
  - Maps vector IDs to their corresponding signals and metadata.
  
- **`parse_vec_data_line(columns)`**:
  - Parses a single data line from the `.vec` file.
  
- **`parse_vec_file(filename, plot_type)`**:
  - Parses the entire `.vec` file and extracts time-series data for specified plot types.
  
- **`is_interesting(vec_id, vec_id_to_info_map, plot_type)`**:
  - Checks if a vector ID corresponds to an interesting signal for analysis.

#### Output:
- A dictionary mapping vector IDs to their time-series data.
- Metadata about each vector (e.g., owner node, destination node, signal type).

---

### 4. `plot_rebalancing_dist.py`
**Purpose**: Analyzes and visualizes the distribution of rebalancing events across nodes.

#### Key Features:
- **Command-Line Arguments**:
  - Supports filtering by topology, credit values, demand, scheduling algorithm, and path types.
  - Allows specifying the number of runs and rebalancing frequencies.

- **Key Functions**:
  - **`compute_x_y(array)`**:
    - Computes cumulative distributions for rebalancing amounts and event counts.
  - **`plot_rebalancing_dist(amt_list, num_list, alg)`**:
    - Plots the cumulative distribution of rebalancing amounts and events.

#### Output:
- Plots showing the fraction of nodes contributing to rebalancing amounts and events.

---

### 5. `README.md`
**Purpose**: Provides instructions for generating benchmarks, running simulations, and visualizing results.

#### Sections:
- **Benchmark Generation**:
  - Scripts for generating circulation and DAG benchmarks.
- **Running Benchmarks**:
  - Instructions for executing simulations using `spiderNet`.
- **Visualizing CDFs**:
  - Commands for generating cumulative distribution function (CDF) plots.
- **Analyzing Single Runs**:
  - Example commands for extracting detailed analysis from individual simulation runs.

---

### 6. `snowball.py`
**Purpose**: Implements snowball sampling to extract subgraphs from large network graphs.

#### Key Functions:
- **`sample_ngbr(graph, ngbr_set, v_set, k)`**:
  - Samples `k` neighbors for each node in the neighbor set.
  
- **`snowball_sample(graph, init_seed, max_sample_size, k)`**:
  - Performs iterative snowball sampling to extract a subgraph starting from an initial seed set.
  
- **`prune_deg_one_nodes(sampled_graph)`**:
  - Removes degree-one nodes from the sampled graph.

#### Output:
- A reduced-size subgraph with capacities preserved.
- Edge capacity data saved to a file.

---

### 7. `visualize_kaggle.py`
**Purpose**: Analyzes and visualizes the distribution of transaction amounts.

#### Key Features:
- Loads transaction amount distributions from a `.npy` file.
- Computes cumulative distribution functions (CDFs) and truncates the distribution at a specified threshold.
- Calculates mean and standard deviation of the truncated distribution.

#### Output:
- Plots of the truncated CDF.
- Mean and standard deviation of transaction amounts.

---

## Dependencies
- **Python Libraries**:
  - `numpy`
  - `matplotlib`
  - `networkx`
  - `argparse`
  - `shlex`

- **External Tools**:
  - OMNeT++ for generating `.sca` and `.vec` files.
  - ggplot for visualization (optional).

---

## Usage Instructions
1. **Generate Benchmarks**:
   - Use `generate_circulation_benchmarks.sh` or `generate_dag_benchmarks.sh` to create simulation topologies and workloads.

2. **Run Simulations**:
   - Execute `run_circulations.sh` or `run_dag.sh` to run simulations.
   - Alternatively, run `spiderNet` manually with custom configurations.

3. **Parse Results**:
   - Use `parse_sca_files.py` and `parse_vec_files.py` to extract metrics from `.sca` and `.vec` files.

4. **Visualize Results**:
   - Generate CDF plots using `generate_summary_cdf.py`.
   - Create detailed analysis plots using `generate_analysis_plots_for_single_run.py`.

5. **Analyze Rebalancing**:
   - Use `plot_rebalancing_dist.py` to visualize rebalancing distributions.

---

## Notes
- Ensure all dependencies are installed before running the scripts.
- Adjust configuration files (`config.py`) as needed to match your simulation setup.
- For large-scale simulations, consider parallelizing the parsing and plotting steps.

---

This documentation provides a comprehensive overview of the codebase and its functionality. Each script is modular and can be extended or modified to suit specific analysis needs.
