import random
from faker import Faker
from datetime import date, timedelta

fake = Faker()

employee_ids = [1, 2, 3]
product_prices = {1: 18.5, 2: 14.0, 3: 9.0, 2000: 10.0}
payment_method_ids = [1, 2, 3]

print("-- ============================================== --")
print("-- MOCK DATA GENERATION SCRIPT                    --")
print("-- Save this output as sql/3_insert_mock_data.sql --")
print("-- ============================================== --\n")

print("-- 1. NEW CUSTOMERS --")
customer_ids = list(range(1001, 1051))

for customer_id in customer_ids:
    first_name = fake.first_name()
    # Escaping apostrophes for SQL (e.g., O'Connor)
    last_name = fake.last_name().replace("'", "''") 
    email = fake.email()
    # Trigger requirement: exactly 9 digits
    phone = fake.numerify('#########') 
    points = random.randint(0, 100)
    
    print(f"INSERT INTO Klient (ID, Imie, Nazwisko, Email, Telefon, Punkty) VALUES ({customer_id}, '{first_name}', '{last_name}', '{email}', '{phone}', {points});")

print("\n-- 2. NEW ORDERS, ORDER ITEMS, AND PAYMENTS --")
order_id = 3002
payment_id = 4001

# Dates from 2025-01-01 to bypass the DB trigger block
start_date = date(2025, 1, 1)
end_date = date(2025, 5, 28)
days_between = (end_date - start_date).days

for _ in range(100):
    customer_id = random.choice(customer_ids)
    employee_id = random.choice(employee_ids)
    random_number_of_days = random.randrange(days_between)
    order_date = start_date + timedelta(days=random_number_of_days)
    
    order_date_str = f"TO_DATE('{order_date.strftime('%Y-%m-%d')}', 'YYYY-MM-DD')"
    print(f"INSERT INTO Zamowienie (ID, OrderDate, Klient_ID, Pracownik_ID) VALUES ({order_id}, {order_date_str}, {customer_id}, {employee_id});")
    
    num_of_items = random.randint(1, 3)
    selected_products = random.sample(list(product_prices.keys()), num_of_items)
    order_total = 0
    
    for product_id in selected_products:
        quantity = random.randint(1, 4)
        unit_price = product_prices[product_id]
        order_total += (quantity * unit_price)
        
        print(f"INSERT INTO Pozycja_Zamowienia (Zamowienie_ID, Produkt_ID, Ilosc, Cena_Jedn) VALUES ({order_id}, {product_id}, {quantity}, {unit_price});")
    
    method_id = random.choice(payment_method_ids)
    print(f"INSERT INTO Platnosc (ID, Zamowienie_ID, Kwota, MetodaPlatnosci_ID) VALUES ({payment_id}, {order_id}, {order_total}, {method_id});\n")
    
    order_id += 1
    payment_id += 1

print("COMMIT;")