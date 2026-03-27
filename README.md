# Neovim

## C++ CSV Reading with getline

This repository now includes a comprehensive example and guide for reading CSV files in C++ using the `getline` function.

### Quick Start

1. **Read the guide**: See [CSV_GETLINE_GUIDE.md](CSV_GETLINE_GUIDE.md) for detailed documentation
2. **Try the example**: 
   ```bash
   g++ -std=c++11 csv_reader_example.cpp -o csv_reader
   ./csv_reader
   ```

### What's Included

- **csv_reader_example.cpp**: Complete working example with:
  - Basic CSV parsing
  - Advanced parsing with quoted field support
  - Error handling
  - Self-contained test data generation

- **CSV_GETLINE_GUIDE.md**: Comprehensive documentation covering:
  - How `getline` works with delimiters
  - Step-by-step parsing approach
  - Edge case handling
  - Best practices
  - Common pitfalls

### Key Concepts

The example demonstrates how to:
- Use `std::getline(file, line)` to read lines from a file
- Use `std::getline(stream, field, ',')` to parse comma-delimited fields
- Use `std::stringstream` for efficient string parsing
- Handle empty fields, quoted fields, and special cases

