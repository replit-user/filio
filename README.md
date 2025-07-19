# filio

A lightweight C++ file I/O utility library with convenient functions for reading, writing, appending, and checking file properties using modern C++17 `std::filesystem`.

---

## Features

- Check if files exist, are readable, or writable.
- Get absolute paths safely.
- Read and write text files easily.
- Append text to existing files.
- Read and write binary data.
- Append binary data to files.
- Custom exception handling for file errors.

---

## Installation

To use `filio` easily with `#include <filio.hpp>`, run the provided platform-specific install script:

- On **Linux**, the script installs headers to `/usr/local/include/` and libraries to `/usr/local/lib/` by default, updating the linker cache.
- On **Windows**, the script installs files to `C:\Program Files\filio\` (or a custom path you provide) and adds that path to your user environment `PATH`.

This setup allows your compiler and linker to find the headers and DLL/shared libraries automatically.

---

## Usage

After installation, include the header in your source code:

```cpp
#include <filio.hpp>
```

Example usage:

```cpp
#include <filio.hpp>
#include <iostream>
#include <vector>
#include <filesystem>

int main() {
    namespace fs = std::filesystem;

    try {
        fs::path file = "example.txt";

        // Write text to a file
        filio::write(file, "Hello, filio!");

        // Append more text
        filio::append(file, "\nAppended line.");

        // Read text
        std::string content = filio::read(file);
        std::cout << content << std::endl;

        // Write binary data
        std::vector<char> data = {'a', 'b', 'c'};
        filio::bin_write("binary.dat", data);

        // Append binary data
        filio::bin_append("binary.dat", {'d', 'e'});

        // Read binary data
        std::vector<char> binContent = filio::bin_read("binary.dat");
        std::cout << "Binary data size: " << binContent.size() << std::endl;

        // Check file properties
        if (filio::extra::file_exists(file)) {
            std::cout << file << " exists." << std::endl;
        }
        if (filio::extra::is_readable(file)) {
            std::cout << file << " is readable." << std::endl;
        }
        if (filio::extra::is_writable(file)) {
            std::cout << file << " is writable." << std::endl;
        }

        // Get absolute path
        auto absPath = filio::extra::absolute_path(file.string());
        std::cout << "Absolute path: " << absPath << std::endl;

    } catch (const filio::extra::FileError& e) {
        std::cerr << "File error: " << e.what() << std::endl;
    }

    return 0;
}
```

---

## Exception Handling

All file operation errors throw a `filio::extra::FileError` exception with a descriptive message.

---

## Requirements

-   C++17 or later (for `std::filesystem` support)
    
-   Standard C++ library
    

---

## License

\[Your license here\]

---

## Contribution

Feel free to open issues or submit pull requests.

---

## Contact

\[Your contact information\]
