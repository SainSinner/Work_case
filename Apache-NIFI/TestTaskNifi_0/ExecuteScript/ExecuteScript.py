flowFile = session.get()
if flowFile != None:
    import os
    import csv
    # Указываем путь к файлу из которого будем извлекать наибольший verstamp последней выгрузки
    file_path = "C:/Users/gsvya/Downloads/ASGTestTaskNifi/key_verstamp/key_verstamp.csv"

    if os.path.exists(file_path):
        with open(file_path, mode='r') as file:
            reader = csv.reader(file)
            next(reader)  # Пропускаем заголовок
            for lines in reader:
                # Создаем переменную которой будем ссылаться на извлеченное значение наибольшего verstamp последней выгрузки
                key_verstamp_value = str(lines[-1])
        	# Создание просто атрибута куда помещаем значение verstamp последней выгрузки
            flowFile = session.putAttribute(flowFile, "key_verstamp", key_verstamp_value)
session.transfer(flowFile, REL_SUCCESS)