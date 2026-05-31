# -*- coding: utf-8 -*-
"""
Created on Sun May 31 12:29:16 2026

@author: alice
"""

import mysql.connector
from datetime import date

# CONEXÃO COM O BANCO
conexao = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="techbridge"
)

cursor = conexao.cursor()

while True:

    print("\n--- SISTEMA DE DIAGNÓSTICO DIGITAL ---")
    print("1 - Fazer diagnóstico")
    print("2 - Sair")

    opcao = input("Escolha uma opção: ")

    if opcao == "1":

        print("\n=== CADASTRO DA EMPRESA ===")

        nome = str(input("Nome da empresa: "))
        cnpj = str(input("CNPJ: "))
        email = str(input("Email: "))
        cep = str(input("CEP: "))
        rua = str(input("Rua: "))
        numero = str(input("Número: "))
        complemento = str(input("Complemento: "))
        bairro = str(input("Bairro: "))
        cidade = str(input("Cidade: "))
        estado = str(input("Estado (UF): "))
        pais = str(input("País: "))
        contato = str(input("Contato: "))
        tipo_empresa = str(input("Tipo da empresa: "))
        

        # INSERT EMPRESA
        sql_empresa = 'INSERT INTO tb_empresa (emp_nome, emp_cnpj, emp_email, emp_cep, emp_rua, emp_numero,emp_complemento, emp_bairro, emp_cidade, emp_estado, emp_pais, emp_contato, emp_tipo_empresa) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'
    
        valores_empresa = (nome, cnpj, email, cep, rua, numero, complemento, bairro, cidade, estado, pais, contato, tipo_empresa)
           
        cursor.execute(sql_empresa, valores_empresa)
        conexao.commit()

        # PEGAR ID DA EMPRESA
        emp_id = cursor.lastrowid

        print("\n=== QUESTIONÁRIO DE GESTÃO ===")

        organizacao = input("A empresa possui boa organização de tarefas? (sim/nao): ")
        comunicacao = input("A equipe possui boa comunicação interna? (sim/nao): ")
        planejamento = input("A empresa realiza planejamento das atividades? (sim/nao): ")
        tecnologia = input("A empresa utiliza ferramentas digitais de gestão? (sim/nao): ")

        respostas_nao = 0

        if organizacao == "nao":
            respostas_nao += 1

        if comunicacao == "nao":
            respostas_nao += 1

        if planejamento == "nao":
            respostas_nao += 1

        if tecnologia == "nao":
            respostas_nao += 1

        # DEFINIÇÃO DO IMPACTO
        if respostas_nao >= 3:
            impacto = "ALTO"

        elif respostas_nao >= 1:
            impacto = "MÉDIO"

        else:
            impacto = "BAIXO"

        # OBSERVAÇÕES
        observacoes = "Diagnóstico realizado automaticamente pelo sistema."

        # INSERT DIAGNÓSTICO
        sql_diagnostico = "INSERT INTO tb_diagnostico(emp_id, diag_data, diag_nivel_geral, diag_observacoes) VALUES (%s,%s,%s,%s)"

        valores_diagnostico = (emp_id, date.today(), impacto, observacoes)

        cursor.execute(sql_diagnostico, valores_diagnostico)
        conexao.commit()

        diag_id = cursor.lastrowid

        # RECOMENDAÇÕES
        if impacto == "ALTO":

            metodologia = "Scrum"

            vulnerabilidade = "Falta de organização de processos"

            solucao = "Implementar Scrum com: Sprints, Daily meetings e Organização das tarefas"

            prioridade = "ALTA"

        elif impacto == "MÉDIO":

            metodologia = "Kanban"

            vulnerabilidade = "Fluxo de tarefas desorganizado"

            solucao = "Implementar quadro Kanban para controle visual e melhor fluxo de trabalho"

            prioridade = "MÉDIA"

        else:

            metodologia = "Swot"

            vulnerabilidade = "Baixa necessidade de intervenção"

            solucao = "Manter melhoria contínua e otimização dos processos."

            prioridade = "BAIXA"

        # INSERT AVALIAÇÃO
        sql_avaliacao = "INSERT INTO tb_avaliacao(diag_id, avl_nome_area, avl_nome_vulnerabilidade, avl_descricao, avl_nivel_risco, avl_solucao, avl_prioridade) VALUES (%s,%s,%s,%s,%s,%s,%s)"
        
        valores_avaliacao = (diag_id, "Gestão Empresarial", vulnerabilidade, "Diagnóstico realizado pelo sistema", impacto, solucao, prioridade)

        cursor.execute(sql_avaliacao, valores_avaliacao)
        conexao.commit()

        avl_id = cursor.lastrowid

        # INSERT RESULTADO
        sql_resultado = "INSERT INTO tb_resultado_diagnostico(diag_id, avl_id, resu_nivel_impacto, resu_status, resu_data_inicio) VALUES (%s,%s,%s,%s,%s)"

        valores_resultado = (diag_id, avl_id, impacto, "PENDENTE", date.today())

        cursor.execute(sql_resultado, valores_resultado)
        conexao.commit()

        # RESULTADO FINAL
        print("\n=== RESULTADO DO DIAGNÓSTICO ===")

        print("Empresa:", nome)
        print("Impacto:", impacto)
        print("Metodologia recomendada:", metodologia)
        print("Solução recomendada:",solucao)

        print("Diagnóstico salvo com sucesso no banco de dados!")

    elif opcao == "2":

        print("Encerrando sistema...")

        break

    else:

        print("Opção inválida!")

# FECHAR CONEXÃO
cursor.close()
conexao.close()