import csv
from platform import java_ver
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
    'slug':'luna-rush',
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
        preco = data["data"]['16197']['quote']['BRL']['price']
    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(e)


with open('recompensas.csv', 'r') as file:
    reader = csv.reader(file)
    qntMult = {}
    lus = {}
    janelas = {}
    for row in reader:
        if row[1] not in janelas:
            janelas[row[1]] = {row[0][row[0].index(" ")+1:]: float(re.sub("[^-0-9.]", "", "0" if not row[2].rstrip('.') else row[2].rstrip('.')))}
        else:
            if row[0][row[0].index(" ")+1:] not in janelas[row[1]]:
                janelas[row[1]][row[0][row[0].index(" ")+1:]] = float(re.sub("[^-0-9.]", "", "0" if not row[2].rstrip('.') else row[2].rstrip('.')))
            else:
                janelas[row[1]][row[0][row[0].index(" ")+1:]] += float(re.sub("[^-0-9.]", "", "0" if not row[2].rstrip('.') else row[2].rstrip('.')))
        if row[1] not in lus:
            lus[row[1]] = float(re.sub("[^-0-9.]", "", "0" if not row[2].rstrip('.') else row[2].rstrip('.')))
        else:
            lus[row[1]] += float(re.sub("[^-0-9.]", "", "0" if not row[2].rstrip('.') else row[2].rstrip('.')))
    msg = ""
    for jan in janelas:
        msg = msg + f"Para a conta {jan}:{os.linesep}"
        for l in sorted(janelas[jan]):
            msg = msg + f"No dia {l} foi farmado {janelas[jan][l]:.3f} LUS, na cotação atual R${(janelas[jan][l]*preco):.3f}{os.linesep}"
        msg = msg + f"----- Total farmado na conta {jan}: {lus[jan]:.2f} LUS, na cotação atual R${(lus[jan]*preco):.3f}. -----{os.linesep}{os.linesep}"
    msg = msg + f"Cotação atual da SPE: {preco}.{os.linesep}{os.linesep}"
    print(msg)
os.system("pause")
