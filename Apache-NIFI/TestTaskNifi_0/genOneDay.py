import csv
import random
import datetime
import os

max_id = 0
max_sale_date = datetime.datetime.strptime("2022-12-31", '%Y-%m-%d')
max_verstamp = 0

# Чтение из файла sales.csv
if os.path.exists("sales.csv"):
    with open('sales.csv', 'r') as file:
        next(file)  # Пропускаем заголовок
        for line in file:
            data = line.split(',')
            current_id = int(data[0])
            if current_id > max_id:
                max_id = current_id
            current_sale_date = datetime.datetime.strptime(data[2], '%Y-%m-%d')
            if current_sale_date > max_sale_date:
                max_sale_date = current_sale_date
            current_verstamp = int(data[4], 0)
            if current_verstamp > max_verstamp:
                max_verstamp = current_verstamp
        file.close

# Чтение файла characters.csv и запись значений в список
with open('characters.csv', 'r') as file:
    reader = csv.reader(file)
    next(reader)  # Пропускаем заголовок
    characters = [row[0] for row in reader]
    file.close

def generate_sales_data(filename, rows, last_id, last_sale_date, last_verstamp):
    with open(filename, 'a', newline='') as csvfile:
        fieldnames = ['id', 'character_id', 'sale_date', 'amount', 'verstamp']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        if csvfile.tell() == 0:
            writer.writeheader()
        
        verstamp = last_verstamp
        sale_date = last_sale_date + datetime.timedelta(days=1) 
        for id in range(last_id + 1, last_id + rows + 1):
            character_id = random.choice(characters)
            amount = random.randint(1, 16)
            verstamp += 1
            if random.randint(0, 16) == 0:
                verstamp += random.randint(32, 2048)
            
            writer.writerow({'id': id, 'character_id': character_id, \
                'sale_date': sale_date.strftime('%Y-%m-%d'), 'amount': amount, \
                'verstamp': '0x{:08x}'.format(verstamp)})

        csvfile.close
        last_id = last_id + rows
        last_sale_date = sale_date
        last_verstamp = verstamp
        
        print(f"Сгенерировано строк: {rows}")
        print(f"На дату: {sale_date}")
        print(f"Последний verstamp: {'0x{:08x}'.format(verstamp)}")

    return [last_id, last_sale_date, last_verstamp]

for i in range(1, 2):
    gen_rows = random.randint(128, 256)
    [max_id, max_sale_date, max_verstamp] = generate_sales_data('sales.csv', gen_rows, max_id, max_sale_date, max_verstamp)
