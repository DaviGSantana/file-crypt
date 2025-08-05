#!/bin/bash

encrypt() {
    read -p "Digite o caminho do arquivo que deseja criptografar: " arquivo_origem
    if [[ ! -f "$arquivo_origem" ]]; then
        echo "Caminho do arquivo não encontrado!"
        exit 1
    fi
    read -p "Digite o nome do arquivo de saída (exemplo: arquivo_encriptado): " arquivo_destino
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$arquivo_origem" -out "$arquivo_destino"
    shred -u -n 3 -z "$arquivo_origem"
    if [[ $? -eq 0 ]]; then
        echo "Arquivo criptografado com sucesso: $arquivo_destino"
        echo "Arquivo deletado de forma segura: $arquivo_origem"
    else
        echo "Falha na criptografia do arquivo."
    fi
}

decrypt() {
    read -p "Digite o caminho do arquivo que deseja descriptografar: " arquivo_origem
    if [[ ! -f "$arquivo_origem" ]]; then
        echo "Arquivo não encontrado!"
        exit 1
    fi
    read -p "Digite o nome do arquivo de saída (exemplo: arquivo_descriptografado.txt): " arquivo_destino
    openssl enc -aes-256-cbc -d -salt -pbkdf2 -in "$arquivo_origem" -out "$arquivo_destino"
    if [[ $? -eq 0 ]]; then
        echo "Arquivo descriptografado com sucesso: $arquivo_destino"
    else
        echo "Falha na descriptografia do arquivo. Verifique se a senha está correta."
    fi
}

echo "Escolha:"
echo "1) Criptografar um arquivo"
echo "2) Descriptografar um arquivo"
read -p "Digite o número da opção desejada: " opcao

case $opcao in
    1)
        encrypt
        ;;
    2)
        decrypt
        ;;
    *)
        echo "Opção inválida. Saindo."
        exit 1
        ;;
esac
