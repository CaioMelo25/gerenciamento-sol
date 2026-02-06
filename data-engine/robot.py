import os
import imaplib
import email
from dotenv import load_dotenv
from parser import extrair_dados_do_html, salvar_no_banco
from email.utils import parsedate_to_datetime

load_dotenv()

CONTAS = [
    {"user": os.getenv("EMAIL_1"), "pass": os.getenv("PASS_1")},
    {"user": os.getenv("EMAIL_2"), "pass": os.getenv("PASS_2")},
    {"user": os.getenv("EMAIL_3"), "pass": os.getenv("PASS_3")},
]

def rodar_automacao():
    for conta in CONTAS:
        if not conta["user"] or not conta["pass"]:
            continue
            
        print(f"--- Acessando conta: {conta['user']} ---")
        try:
            mail = imaplib.IMAP4_SSL("imap.gmail.com")
            mail.login(conta["user"], conta["pass"])
            mail.select("inbox")

            status, mensagens = mail.search(None, '(FROM "email@cf.natura.com" SUBJECT "Seu pedido foi aprovado!")')
            
            ids = mensagens[0].split()
            print(f"Encontrados {len(ids)} pedidos para processar.")

            for e_id in ids:
                _, data = mail.fetch(e_id, "(RFC822)")
                msg = email.message_from_bytes(data[0][1])

                msg_id = msg.get("Message-ID")

                date_str = msg.get("Date")
                dt = parsedate_to_datetime(date_str)
                data_do_email = dt.strftime('%Y-%m-%d %H:%M:%S')
                
                corpo_html = ""
                if msg.is_multipart():
                    for part in msg.walk():
                        if part.get_content_type() == "text/html":
                            corpo_html = part.get_payload(decode=True).decode()
                else:
                    corpo_html = msg.get_payload(decode=True).decode()

                dados_limpos = extrair_dados_do_html(corpo_html)
                salvar_no_banco(dados_limpos, conta["user"], data_do_email)
                
            mail.close()
            mail.logout()
            print(f"Conta {conta['user']} finalizada com sucesso.\n")

        except Exception as e:
            print(f"Erro ao acessar a conta {conta['user']}: {e}")

if __name__ == "__main__":
    rodar_automacao()