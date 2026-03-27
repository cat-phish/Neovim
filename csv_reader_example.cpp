/**
 * CSV Reader Example using getline in C++
 * 
 * This example demonstrates how to read CSV files delimited with commas
 * using std::getline and std::stringstream for parsing.
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

/**
 * Parse a CSV line into individual fields
 * @param line The CSV line to parse
 * @return A vector of strings containing each field
 */
std::vector<std::string> parseCSVLine(const std::string& line) {
    std::vector<std::string> fields;
    std::stringstream ss(line);
    std::string field;
    
    // Use getline with comma delimiter to extract each field
    while (std::getline(ss, field, ',')) {
        fields.push_back(field);
    }
    
    return fields;
}

/**
 * Read and process a CSV file
 * @param filename Path to the CSV file
 */
void readCSVFile(const std::string& filename) {
    std::ifstream file(filename);
    
    if (!file.is_open()) {
        std::cerr << "Error: Could not open file " << filename << std::endl;
        return;
    }
    
    std::string line;
    int lineNumber = 0;
    
    // Read file line by line using getline
    while (std::getline(file, line)) {
        lineNumber++;
        
        // Skip empty lines
        if (line.empty()) {
            continue;
        }
        
        // Parse the CSV line
        std::vector<std::string> fields = parseCSVLine(line);
        
        // Process the fields
        std::cout << "Line " << lineNumber << ": ";
        for (size_t i = 0; i < fields.size(); i++) {
            std::cout << "[" << fields[i] << "]";
            if (i < fields.size() - 1) {
                std::cout << " | ";
            }
        }
        std::cout << std::endl;
    }
    
    file.close();
}

/**
 * Example with advanced CSV parsing (handles quoted fields)
 * This is a more robust version that handles CSV fields with quotes
 */
std::vector<std::string> parseCSVLineAdvanced(const std::string& line) {
    std::vector<std::string> fields;
    std::string field;
    bool inQuotes = false;
    
    for (size_t i = 0; i < line.length(); i++) {
        char c = line[i];
        
        if (c == '"') {
            // Toggle quote state
            inQuotes = !inQuotes;
        } else if (c == ',' && !inQuotes) {
            // Field delimiter found (outside quotes)
            fields.push_back(field);
            field.clear();
        } else {
            // Regular character
            field += c;
        }
    }
    
    // Don't forget the last field
    fields.push_back(field);
    
    return fields;
}

int main() {
    std::cout << "=== CSV Reader Example using getline ===" << std::endl;
    std::cout << std::endl;
    
    // Example 1: Create a sample CSV file
    std::cout << "Creating sample CSV file..." << std::endl;
    std::ofstream outFile("sample.csv");
    outFile << "Name,Age,City,Country\n";
    outFile << "John Doe,30,New York,USA\n";
    outFile << "Jane Smith,25,London,UK\n";
    outFile << "Bob Johnson,35,Toronto,Canada\n";
    outFile << "Alice Brown,28,Sydney,Australia\n";
    outFile.close();
    std::cout << "Sample CSV file created." << std::endl;
    std::cout << std::endl;
    
    // Example 2: Read the CSV file
    std::cout << "Reading CSV file using getline..." << std::endl;
    std::cout << std::endl;
    readCSVFile("sample.csv");
    std::cout << std::endl;
    
    // Example 3: Demonstrate advanced parsing with quoted fields
    std::cout << "=== Advanced CSV Parsing Example ===" << std::endl;
    std::ofstream outFile2("sample_quoted.csv");
    outFile2 << "Product,Price,Description\n";
    outFile2 << "Widget,29.99,\"A useful widget, with features\"\n";
    outFile2 << "Gadget,49.99,\"Super gadget\"\n";
    outFile2 << "Tool,15.50,Simple tool\n";
    outFile2.close();
    
    std::cout << "Reading CSV with quoted fields..." << std::endl;
    std::ifstream file("sample_quoted.csv");
    std::string line;
    int lineNum = 0;
    
    while (std::getline(file, line)) {
        lineNum++;
        if (!line.empty()) {
            std::vector<std::string> fields = parseCSVLineAdvanced(line);
            std::cout << "Line " << lineNum << ": ";
            for (size_t i = 0; i < fields.size(); i++) {
                std::cout << "[" << fields[i] << "]";
                if (i < fields.size() - 1) {
                    std::cout << " | ";
                }
            }
            std::cout << std::endl;
        }
    }
    file.close();
    
    std::cout << std::endl;
    std::cout << "=== Key Points ===" << std::endl;
    std::cout << "1. Use std::getline(stream, string) to read entire lines" << std::endl;
    std::cout << "2. Use std::getline(stream, string, delimiter) with ',' to parse CSV fields" << std::endl;
    std::cout << "3. Use std::stringstream for parsing individual lines" << std::endl;
    std::cout << "4. Handle edge cases like empty lines and quoted fields" << std::endl;
    std::cout << "5. Always check if file opened successfully with is_open()" << std::endl;
    
    return 0;
}
