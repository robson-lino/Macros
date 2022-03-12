import csv
import re
import os
import pprint
from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

preco = 0.0



if (bool(input("Quer ver precos? "))):
    url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest'

    parameters = {
    'slug':'space-crypto-spe',
    'convert':'BRL'
    }
    headers = {
    'Accepts': 'application/json',
    'X-CMC_PRO_API_KEY': '7e6ac617-ab2b-40be-8e7e-698a32c354da',
    }

    session = Session()
    session.headers.update(headers)

    try:
        response = session.get(url, params=parameters)
        data = json.loads(response.text)
        preco = data["data"]['18149']['quote']['BRL']['price']
    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(e)


with open('recompensas.csv', 'r') as file:
    reader = csv.reader(file)
    qntMult = {}
    spe = 0
    dias = {}
    for row in reader:
        if row[0][row[0].index(" ")+1:] not in dias:
            dias[row[0][row[0].index(" ")+1:]] = float(re.sub("[^-0-9.]", "", "0" if not row[3].rstrip('.') else row[3].rstrip('.')))
        else:
            dias[row[0][row[0].index(" ")+1:]] += float(re.sub("[^-0-9.]", "", "0" if not row[3].rstrip('.') else row[3].rstrip('.')))
        if row[1] not in qntMult:
            qntMult[row[1]] = 1
        else:
            qntMult[row[1]] += 1
        spe += float(re.sub("[^-0-9.]", "", "0" if not row[3].rstrip('.') else row[3].rstrip('.')))

    total = 0.0
    for mults in qntMult:
        if mults in ('1x','2x','0.5x','100x'):
            total += qntMult[mults]
    for mults in qntMult:
        if mults in ('1x','2x','0.5x','100x'):
            qntMult[mults] =  (qntMult[mults], (qntMult[mults]/total)*100)
        else:
            qntMult[mults] = (qntMult[mults], 0)
        
    msg = ""
    for l in sorted(dias):
        msg = msg + f"No dia {l} foi farmado {dias[l]:.3f} SPEs, convertido para SPE: {(dias[l]/3)*0.96:.3f} na cotação atual R${(((dias[l]/3)*0.96)*preco):.3f}{os.linesep}"
    msg = msg + f"{os.linesep}Cotação atual da SPE: {preco}.{os.linesep}{os.linesep}"
    msg = msg + f"----- Total farmado nesse arquivo: {spe:.2f} SPEs, convertido para SPE: {(spe/3)*0.96:.2f} na cotação atual R${(((spe/3)*0.96)*preco):.3f}. -----{os.linesep}{os.linesep}"
    for mult in sorted(qntMult.items(), key=lambda x: x[1][0], reverse=True):
        msg = msg + f"{qntMult[mult[0]][0]} roladas em {mult[0]}, {qntMult[mult[0]][1]:.2f}%.{os.linesep}"
    print(msg)
os.system("pause")
