# Persian E-commerce Telegram Bot

## Overview

This project is a comprehensive Persian e-commerce Telegram bot specializing in bedding and home textile products. Its primary purpose is to provide a complete shopping experience, encompassing customer authentication, hierarchical product browsing, shopping cart management, and invoice generation. The business vision is to streamline sales and customer interaction for home textile products through an intuitive Telegram interface, tapping into the growing e-commerce market in Persia.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

The application employs a modular architecture, ensuring clear separation of concerns for maintainability and scalability.

**Core Design Principles:**
- **Bot Layer**: Manages all Telegram API interactions, handling commands, callbacks, and messages using `python-telegram-bot`.
- **Data Layer**: Stores and manages customer and product information using static Python dictionaries and JSON file-based persistence for dynamic data like shopping carts.
- **Business Logic Layer**: Encapsulates all operational processes, including cart operations, pricing calculations (with fixed category prices, discounts, and tax), invoice generation, and order management.
- **Utilities Layer**: Provides supporting functionalities such as logging, Persian language processing (number conversion, formatting), and text utilities.

**Technical Implementations:**
- **Product Catalog**: Defined with 6 main categories and fixed pricing, along with specific size restrictions per category.
- **Customer Database**: Contains registered customers with unique authentication codes.
- **Cart Management**: Supports add, remove, and clear operations, with persistence handled via JSON files.
- **Payment Processing**: Offers cash, 60-day, and 90-day installment options, including discount calculations (30% cash, 25% installment) and a 9% tax. Supports check payment workflow with photo upload and admin verification.
- **Order Management**: Features a comprehensive system for order tracking, status updates, and a unique order cancellation and remaining balance payment flow.
- **UI/UX**: Utilizes inline keyboards for navigation (main menu, category selection, alphabetical search, product selection, payment options). Implements pagination for product browsing with a consistent button layout.

## External Dependencies

- **python-telegram-bot**: The primary library for interacting with the Telegram Bot API.
- **Python Standard Library**: Utilized for core functionalities such as `json` for data persistence, `os` for file operations, `logging` for system monitoring, and `datetime` for timestamps.
- **No external database dependencies**: Product and customer data are managed in-memory via Python dictionaries, and shopping cart data is persisted using JSON files.