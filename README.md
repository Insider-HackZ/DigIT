# **DigIT** 🚀



**DigIT** is a powerful tool designed to automate subdomain enumeration and historical data retrieval. It integrates various subdomain enumeration tools like `subfinder`, `assetfinder`, and `amass`, along with historical data collection from `crt.sh` and the Wayback Machine. The tool is designed to be easy to use, versatile, and efficient, making it a valuable resource for security researchers and penetration testers.

## **Features**

- **Subdomain Enumeration:** Uses multiple tools (`subfinder`, `assetfinder`, and `amass`) to gather a comprehensive list of subdomains.
- **Historical Data Retrieval:** Collects and organizes historical data from `crt.sh` and the Wayback Machine.
- **Data Aggregation and Sorting:** Aggregates results from all tools, sorts the data, and saves it in organized files for easy analysis.
- **Customizable Execution:** Supports single domain processing and batch processing using a list of domains.
- **Help Manual:** Provides a help manual to guide users on how to use the tool.

## **Installation**

### **1. Clone the Repository**

```
git clone https://github.com/Byte-BloggerBase/DigIT.git
```

### **2. Make the Script Executable**

```
cd DigIT
chmod +x Digit.sh
```

### **3. Install Dependencies**

Ensure you have the following tools installed:

- `subfinder`
- `assetfinder`
- `amass`
- `jq`
- `curl`

On Debian-based systems, you can install them using:

```
sudo apt update
sudo apt install subfinder assetfinder amass jq curl
```

## **Usage**

### **1. Single Domain**

To process a single domain, use the `-d` flag:

```
./Digit.sh -d example.com
```

### **2. List of Domains**

To process a list of domains, use the `-L` flag and provide a file containing the domains:

```
./Digit.sh -L domain_list.txt
```

### **3. Help Manual**

To view the help manual, use the `-h` flag:

```
./Digit.sh -h
```

## **Flags**

- **`-d`** : Specify a single domain to process.
- **`-L`** : Provide a file containing a list of domains to process.
- **`-h`** : Show the help manual.

## **Example Usage**

**Single Domain:**

```
./Digit.sh -d example.com
```

**Multiple Domains:**

```
./Digit.sh -L domains.txt
```

## **Output**

The tool organizes the output into directories:

- **`[domain]-output/`**: Contains sorted subdomains and historical data files.
- **`[domain]-output/wayback_data/`**: Contains Wayback Machine data for each subdomain.

## **Credits**

Developed by: [harshj054](https://www.linkedin.com/in/harsh-jain-7648382b7/)

> If anyone would like to contribute to the development of Byte-BloggerBase/DigIT, please send an email to official@bytebloggerbase.com.
