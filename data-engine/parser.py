import os
import re
import datetime
from dotenv import load_dotenv
from supabase import create_client
from bs4 import BeautifulSoup

load_dotenv()
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")
supabase = create_client(url, key)

def mapear_categoria(nome_produto):
    n = nome_produto.lower()
    if any(k in n for k in ['sabonete']): return 4
    if any(k in n for k in ['creme', 'tododia', 'mãos', 'corpo', 'hidratante']): return 1
    if any(k in n for k in ['perfume', 'ília', 'colônia', 'essencial']): return 2
    if any(k in n for k in ['maquiagem', 'batom', 'una', 'faces']): return 3
    if any(k in n for k in ['mamãe', 'bebê', 'infantil']): return 5
    return 6 

def limpar_valor(texto):
    if not texto: return 0.0
    match = re.search(r"([\d,.]+)", texto)
    if match:
        valor_str = match.group(1)
        valor_str = valor_str.strip('.,')
        
        if ',' in valor_str:
            valor_str = valor_str.replace('.', '').replace(',', '.')
        
        try:
            return float(valor_str)
        except ValueError:
            return 0.0
    return 0.0

def extrair_dados_do_html(html_content):
    """Extrai apenas dados financeiros e itens. A data agora vem do Robot."""
    html_content = html_content.replace('&nbsp;', ' ').replace('\xa0', ' ')
    soup = BeautifulSoup(html_content, 'html.parser')
    
    financeiro = {"subtotal": 0.0, "consultoria": 0.0, "desconto": 0.0, "frete": 0.0, "total": 0.0}
    
    termos_busca = {
        "subtotal": ["SUBTOTAL (R$)", "Subtotal"],
        "consultoria": ["CONSULTORIA", "Ganho", "Margem"],
        "desconto": ["DESCONTO", "Cupom"],
        "frete": ["FRETE (R$)", "Valor do Frete"],
        "total": ["TOTAL: R$"]
    }

    linhas = soup.find_all('tr')
    for i, linha in enumerate(linhas):
        texto_linha = linha.get_text(separator=" ").strip()
        
        if any(x in texto_linha for x in ["Endereço", "Qd 13", "Casa", "Setor"]):
            continue

        for chave, variantes in termos_busca.items():
            if any(v.lower() in texto_linha.lower() for v in variantes):
                valor = limpar_valor(texto_linha)
                if valor == 0 and i + 1 < len(linhas):
                    texto_abaixo = linhas[i+1].get_text(strip=True)
                    if len(texto_abaixo) < 15:
                        valor = limpar_valor(texto_abaixo)
                
                if valor >= 0:
                    financeiro[chave] = valor
                    if valor > 0: break

    if financeiro["frete"] == financeiro["subtotal"] and financeiro["subtotal"] > 0:
        financeiro["frete"] = 0.0

    itens = []
    for linha in soup.find_all('tr'):
        texto_item = linha.get_text(separator=" ").strip()
        if "R$" in texto_item:
            proibidos = ["total", "subtotal", "consultoria", "cupom", "frete (r$)"]
            if not any(p in texto_item.lower() for p in proibidos):
                colunas = linha.find_all('td')
                if len(colunas) >= 2:
                    nome = colunas[0].get_text(strip=True)
                    preco = limpar_valor(texto_item)
                    if preco > 0 and len(nome) > 10:
                        itens.append({"nome": nome, "preco": preco, "qtd": 1})

    return {"financeiro": financeiro, "itens": itens}

def salvar_no_banco(dados, email_origem, data_venda, msg_id):
    f = dados["financeiro"]
    
    try:
        res_pedido = supabase.table("pedidos").insert({
            "message_id": msg_id,
            "data_pedido": data_venda,
            "subtotal": f["subtotal"],
            "valor_consultoria": f["consultoria"],
            "valor_desconto": f["desconto"],
            "valor_frete": f["frete"],
            "valor_total": f["total"],
            "email_origem": email_origem
        }).execute()
        
        id_pedido = res_pedido.data[0]['id']

        for item in dados["itens"]:
            cat_id = mapear_categoria(item["nome"])
            
            res_prod = supabase.table("produtos_catalogo").upsert({
                "nome_natura": item["nome"],
                "id_categoria": cat_id
            }, on_conflict="nome_natura").execute()
            
            id_prod = res_prod.data[0]['id']
            
            supabase.table("itens_pedido").insert({
                "pedido_id": id_pedido,
                "produto_catalogo_id": id_prod,
                "quantidade": item["qtd"],
                "valor_unitario_pago": item["preco"]
            }).execute()

        print(f"SUCESSO: Pedido de {data_venda} salvo com sucesso!")

    except Exception as e:
        if "duplicate key value" in str(e):
            print(f"AVISO: Pedido {msg_id} já existe no banco. Pulando...")
        else:
            print(f"ERRO inesperado ao salvar: {e}")