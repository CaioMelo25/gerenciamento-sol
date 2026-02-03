import os
import pdfplumber
import re
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")

supabase = create_client(url, key)
supabase = create_client(url, key)

def mapear_categoria(nome_produto):
    n = nome_produto.lower()
    if any(k in n for k in ['sabonete']): return 4
    if any(k in n for k in ['creme', 'tododia', 'mãos', 'corpo']): return 1
    if any(k in n for k in ['perfume', 'ília', 'colônia']): return 2
    if any(k in n for k in ['maquiagem', 'batom']): return 3
    return 6 # Outros

def extrair_dados_pdf(caminho_pdf):
    return {
        "data": "2026-01-17", 
        "total": 281.28,      
        "itens": [
            {"nome": "Protetor Térmico Lumina 150 ml", "preco": 55.93, "qtd": 1}, 
            {"nome": "Álcool Gel Erva Doce 45g", "preco": 20.23, "qtd": 1}, 
            {"nome": "Sabonetes Sortidos Ekos", "preco": 37.40, "qtd": 1}, 
            {"nome": "Perfume Ilía Ser Feminino 50 ml", "preco": 139.93, "qtd": 1}  
        ]
    }

def salvar_no_banco(dados):
    pedido = supabase.table("pedidos").insert({
        "data_pedido": dados["data"],
        "valor_total": dados["total"],
        "email_origem": "white258br@gmail.com" 
    }).execute()
    
    id_pedido = pedido.data[0]['id']

    for item in dados["itens"]:
        cat_id = mapear_categoria(item["nome"])
        produto = supabase.table("produtos_catalogo").upsert({
            "nome_natura": item["nome"],
            "id_categoria": cat_id
        }, on_conflict="nome_natura").execute()
        
        id_prod = produto.data[0]['id']

        supabase.table("itens_pedido").insert({
            "pedido_id": id_pedido,
            "produto_catalogo_id": id_prod,
            "quantidade": item['qtd'],
            "valor_unitario_pago": item['preco']
        }).execute()

if __name__ == "__main__":
    print("Iniciando extração...")
    dados_extraidos = extrair_dados_pdf("pedido.pdf")
    salvar_no_banco(dados_extraidos)
    print("Sucesso! Dados salvos no Supabase.")