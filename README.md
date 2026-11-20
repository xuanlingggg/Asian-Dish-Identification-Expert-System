# Asian Dish Identification Expert System

A simple rule-based Prolog expert system (`asian_dish.pl`) that identifies Asian dishes by asking questions about their main base, cooking method, and key ingredients.

## How to Run

1. Open SWI-Prolog in this folder and load the file:
   ```prolog
   ?- [asian_dish].
   ```
   Or from the terminal:
   ```bash
   swipl asian_dish.pl
   ```
2. Start the identification session:
   ```prolog
   ?- identify.
   ```
3. Enter the number for your choice followed by a period (e.g. `1.`).

## Supported Dishes

- Nasi Lemak
- Nasi Goreng
- Congee
- Sushi
- Char Kway Teow
- Asam Laksa
- Ramen
- Steamed Dumplings
- Satay
