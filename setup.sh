#!/bin/bash
#
# Nome:                 setup.sh
# Versão:               1.0
# Data da criação:      25/01/2019
# Funcionalidade:       Automatizar o processo de pós instalação do Ubuntu 64bits.
# Descrição:            Este script irá criar as variáveis "LINKS" e "PACOTES" para armazenarem o conteúdo dos arquivos 
#                       "links.txt" e "pacotes.txt", respecitivamente, os quais contém os links e os nomes dos pacotes,
#                       posteriormente é atualizado os repositórios e os pacotes já instalados, em seguida o script
#                       irá verificar se existe o arquivo "links.txt", se existir o script irá percorrer todo o conteúdo
#                       do arquivo e executar o comando para baixar os pacotes, após baixar os pacotes também será verificada
#                       a existência do arquivo "pacotes.txt", caso exista, será executado o comando para instalar os pacotes.
# Autor:                Fábio A. Monteiro
# E-mail:               xfabiomonteirox@gmail.com
# Licença:              MIT.
# GitHub:               https://github.com/xfabiomonteirox/setup-ubuntu64bits
#

# cria as variáveis "LINK" e "PACOTE" para armazenarem o conteúdo dos arquivos "links.txt" e "pacotes.txt"
LINK=links.txt
PACOTE=pacotes.txt

# inicia o script apenas como "ROOT"
if [ "$USER" = "root" ] ; then
	echo "";
else
	echo "Você precisa ser logar como root.";
	exit 0;
fi

##################################################################################
#                                                                                #
# atualiza os repositórios e os pacotes já instalados,                           # 
# caso não seja possível atualizar os pacotes e ou os repositórios,              #
# será retornado uma mensagem de erro e será abortada a execução do script       #
#                                                                                #
##################################################################################
echo "Atualizando os repositórios.."
if ! apt update
then
    echo "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list"
    exit 1
fi
echo "Atualização realizada com sucesso."

echo "Atualizando os pacotes."
if ! apt dist-upgrade -y
then
    echo "Não foi possível atualizar os pacotes."
    exit 1
fi
echo "Atualização de pacotes realizada com sucesso."

##################################################################################
#                                                                                #
# verifica se existe o arquivo "link.txt", caso não exista o arquivo             # 
# será retornada uma mensagem de erro e abortada a execução do script            #
# se existir o arquivo, será percorrido o conteúdo do mesmo e, em seguida        #
# baixado os pacotes, se não for possível baixar algum pacote                    #
# será retornada uma mensagem de erro e abortada a execução do script            #
#                                                                                #
##################################################################################
if [ ! -f "$LINK" ]; 
then
    echo "Não foi possível localizar a lista de download."
    exit 1
else
    if ! wget -i "$LINK"; 
    then
        echo "Não foi possível baixar o pacote $i"
        exit 1
    else
        echo "Pacotes baixados com sucesso.."
    fi    
fi

##################################################################################
#                                                                                #
# verifica se existe o arquivo "pacotes.txt", caso não exista o arquivo          # 
# será retornada uma mensagem de erro e abortada a execução do script            #
# se existir o arquivo, será percorrido o conteúdo do mesmo e, em seguida        #
# instalado os pacotes, se não for possível instalar algum pacote                #
# será retornada uma mensagem de erro e abortada a execução do script            #
#                                                                                #
##################################################################################
if [ ! -f "$PACOTE" ]; 
then
    echo "Não foi possível localizar a lista de pacotes"
    exit 1
else
for i in `cat "$PACOTE"`; do 
    if ! dpkg -i $i; 
    then
        echo "Não foi possível instalar o pacote $i"
        exit 1
    else
        echo "A instalação foi concluída com sucesso.."
    fi    
done
fi
 


