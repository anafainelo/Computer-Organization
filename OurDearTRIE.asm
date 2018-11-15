# INTEGRANTES DO GRUPO COM NUMERO USP E OQUE FEZ NO TRABALHO:
#
#	Carolina Arenas Okawa - 10258876 ___________________ MAIN
#	Bruno Del Monde - 10262818__________________________ IMPRESSAO
#	Ana Carolina Fainelo de Oliveira - 10284542_________ REMOCAO
#	Lui Franco Rocha - 10295558_________________________ INSERCAO/BUSCA
#
# OBS:  Utilizamos o Mars para fazer o trabalho
# OBS2: Na impressao, em vez de printar 'null' para ponteiro nulo, printamos '0'



#segmento de texto
	.text
	
BEGIN: j main

########################################################################## IMPRESSAO ########################################################################################
	#Argumentos usados:
#a1: Raiz da bitwase trie

	#Algorítimo:
#Usar uma fila dinamicamente alocada com um pivo que marca a mudança de linha.
#Imprimir a raiz, adicionando ela a fila e criar um pivo.
#loop:
	#Caso o nó seja um pivo:
		#Terminar o loop caso não haja nós no próximo nível.
		#Iniciar nova linha e passar pivo para o final da fila.
	#Imprimir os dados do nó, se houver filhos, adicionar-los a fila e passar para o próximo nó.
#Desempilhar e retornar

	#Estrutura da fila:
#0..3: Ponteiro para próximo nó. --Se NULL acabou a árvore (logicamente, só pode acontecer em um pivô descrito na linha de baixo)
#4..7: Ponteiro para o nó da árvore --Se NULL acabou a linha e o nó é um pivo
#8: Dígito

	#Registradores usados nessa função
#s0: Começo da fila
#s1: Final da fila
#s2: Nó atual da arvore
#s3: Contador de linhas
#t0: Usado como intermediário/temporário

imprime: #impr
	#Salvando na stack registradores $s usados
	addi $sp, $sp, -16
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	#Printa começo do nó raiz da árvore
	li $v0, 4
	la $a0, str_impr_raiz #">> N0 (raiz, "
	syscall
	
	#Cria nó para raiz
	li $v0, 9
	li $a0, 9
	syscall
	move $s0, $v0 #Começo da fila = raiz
	
	#Cria nó pivo
	li $v0, 9
	li $a0, 9
	syscall	#Cria pivo
	move $s1, $v0 #Fim da fila =  pivo
	sw $zero, 4($s1) #Marca como pivo
	
	sw $s1, ($s0) #Setando ponteiro de próximo de raiz para o pivo
	move $s2, $a1 #Setando nó atual para raiz
	li $s3, 0 #Linha = 0
	j impr_entrada_do_loop #Mover execução para o meio do loop
	
#Loop de execução da função imprime
impr_loop:
	lw $s2, 4($s0) #Nó atual da árvore carregado
	bnez $s2, impr_nao_pivo #Verifica se é pivo ou nó padrão
	
#Tratando pivo
	li $v0, 11
	li $a0, '\n'
	syscall #Pula linha
	
	beq $s0, $s1, and_impr_loop #Se só o pivo está na fila, encerra o loop
	
	#Passa pivo do começo para o final da fila
	sw $s0, ($s1) #Ponteiro de próximo do último elemento da fila aponta para o pivo
	move $s1, $s0 #Ponteiro de último elemento aponta para o pivo
	lw $s0, ($s0) #Passa para o próximo da fila
	
	#Printa início de novo nível
	addi $s3, $s3, 1 #Contador incrementado
	li $v0, 4
	la $a0, str_impr_nivel #">> N"
	syscall
	li $v0, 1
	move $a0, $s3 #Contador
	syscall
	
	lw $s2, 4($s0) #Nó atual da árvore carregado
impr_nao_pivo:
	#Impressão do dígito
	li $v0, 4
	la $a0, str_impr_abre #" ("
	syscall
	li $v0, 1
	lb $a0, 8($s0) #dígito
	syscall
	li $v0, 4
	la $a0, str_impr_separa #", "
	syscall

impr_entrada_do_loop: #Usado somente para entrar no loop
	#Impressão da terminalidade
	lb $t0, 8($s2)
	bnez $t0, impr_terminal
	li $v0, 11
	li $a0, 'N'
	syscall
impr_terminal:
	li $v0, 11
	li $a0, 'T'
	syscall
	
	#Imnpressão do filho zero
	li $v0, 4
	la $a0, str_impr_separa #", "
	syscall
	li $v0, 1
	lw $a0, ($s2) #&esq
	syscall
	beqz $a0, impr_nao_insere_filho_0
	
	#Insere filho 0
	move $t0, $a0
	li $v0, 9
	li $a0, 9
	syscall	#Cria novo nó
	sw $v0, ($s1) #Seta o ponteiro de próximo do último elemento da fila
	move $s1, $v0 #Atualiza o ponteiro do final da fila
	sw $t0, 4($s1) #Aponta novo nó para seu nó da árvore
	sb $zero, 8($s1) #Adiciona o dígito do novo nó
impr_nao_insere_filho_0:	

	#Imnpressão do filho um
	li $v0, 4
	la $a0, str_impr_separa #", "
	syscall
	li $v0, 1
	lw $a0, 4($s2) #&dir
	syscall
	beqz $a0, impr_nao_insere_filho_1
	
	#Insere filho 1
	move $t0, $a0
	li $v0, 9
	li $a0, 9
	syscall	#Cria novo nó
	sw $v0, ($s1) #Seta o ponteiro de próximo do último elemento da fila
	move $s1, $v0 #Atualiza o ponteiro do final da fila
	sw $t0, 4($s1) #Aponta novo nó para seu nó da árvore
	li $t0, 1
	sb $t0, 8($s1) #Adiciona o dígito do novo nó
	
impr_nao_insere_filho_1:
	#Termina impressão do nó
	li $v0, 11
	li $a0, ')'
	syscall
	
	lw $s0, ($s0) #Passa para o próximo da fila
	j impr_loop #Volta para o começo do loop
and_impr_loop:
		#Fim da função imprime
	#Desempilhando valores salvos
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra

########################################################################## BUSCA ########################################################################################


# O registrador $v0 contem o valor de retorno:
# -1: o valor foi encontrado
# -2: a string nao esta no formato binario
# N: o valor nao foi encontrado, 'N' nos foram percorridos ate o final da execucao do algoritimo

# Registradores de argumentos:
# $a1 inicio da arvore
# $a2 inicio da string

# os registradores usados, sao os t`s (nao sao salvos) e os a`s (sao salvos)
TRIE_SEARCH:
	move $t0, $a1 # passa o ponterio pro no
	move $t3, $a2 # ponteiro para a string
	
	# validar string e ponteiro incial

	li $t5, -1
SEARCH_LOOP:
	beq $t0, $zero, SEARCH_OUT_LOOP # checa se o ponteiro pro no atual eh nulo
	addi $t5, $t5, 1
	lb $t4, 0($t3) # carrega o proximo char da memoria
	beq $t4, $zero, SEARCH_OUT_LOOP # checa se esta no final da string
	beq $t4, '1', LOOP_1 # checa se o char atual e '1'
	bne $t4, '0', SEARCH_ERROR # se o char nao e '1', e nao e '1', retorna erro
	lw $t0, 0($t0)
	j SEARCH_ATTRIBUTION
LOOP_1:
	lw $t0, 4($t0)
SEARCH_ATTRIBUTION:
	addi $t3, $t3, 1
	j SEARCH_LOOP
	

	
SEARCH_OUT_LOOP:
	lb $t4, 0($t3) # carrega o atual char da memoria
	bne $t4, $zero ,SEARCH_CHECK_STRING # checa se a string foi ate o final
	beq $t0, $zero ,SEARCH_END_ELSE # checa se o ponteiro final e nulo
	lb $t1, 8($t0)
	bne $t1, 1 ,SEARCH_END_ELSE # checa a flag END, se for == 1, esse no e o final de um valor
	li $v0 , -1
	jr $ra	

SEARCH_CHECK_STRING: # aqui e quado a string nao acabou, portanto a chave existe e sera checado erros na string (formatacao nao binaria)
	beq $t4, '0', SEARCH_STRING_ADD # se o char atual for 0, passar pro proximo char
	bne $t4, '1', SEARCH_ERROR # aqui, ja foi checado '\0' e '0', se for diferente de '1', a string tem erro de formatacao
SEARCH_STRING_ADD:
	addi $t3, $t3, 1 # avanca na string
	lb $t4, 0($t3) # carrega o proximo char
	beq $t4, $zero, SEARCH_END_ELSE # se chegou no final da string, retorna que nao encontrou o valor, mas n deu erro
	j SEARCH_CHECK_STRING
SEARCH_END_ELSE:
		
	move $v0 , $t5
	jr $ra

SEARCH_ERROR:
	li $v0, -2
	jr $ra
	

############################################################## INSERCAO ###########################################################################################
	
# O registrador $v0 contem o valor de retorno:
# 0: o valor foi inserido
# 1: o valor ja existe
# -1; string mal formatada

# Registradores de argumentos:
# $a1 inicio da arvore
# $a2 inicio da string

# os registradores usados, sao os t`s (nao sao salvos) e os a`s (sao salvos)
TRIE_INSERTION:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal TRIE_SEARCH # chama a funcao de busca
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	beq $v0, -2, STRING_ERROR # checa o retorno da funcao de busca
	beq $v0, -1, INSERT_EXISTS
	
	move $t0 , $a1 # inicio da arvore
	move $t3 , $a2 # inicio da string

INSERT_DESCENDO: # loop para descer na parte nao nula da arvore
	lb $t4, 0($t3) # carrega um char da string
	beq $t4, $zero, INSERT_END # ve se o char  e '\0'
	beq $t4, '0', INSERT_ESQ # ve se o char e '0', se nao, ele eh '1', pois a funcao de busca ja checou por erros
	lw $t1, 4($t0) # ponteiro da arvore recebe o no filho da direita
	j STRING_ADD
INSERT_ESQ:   
	lw $t1, 0($t0) # ponteiro da arvore recebe o no filho da esquerda
STRING_ADD:
	beq $t1, $zero, INSERT_INSERINDO # checa se o ponteiro e nulo, se for ir para parte de inserir
	move $t0, $t1
	addi $t3, $t3, 1 # avanca uma posicao na string
  
	j INSERT_DESCENDO


INSERT_INSERINDO:
        lb $t4, 0($t3)
        beq $t4, $zero INSERT_END
        li $v0, 9
        li $a0, 12
        syscall
        beq $t4, '0', ESQ_INSERT
        sw $v0, 4($t0)
        j STRING_ADD2
ESQ_INSERT:
        sw $v0, 0($t0)
STRING_ADD2:
	sw $zero, 0($v0)
        sw $zero, 4($v0)
        sb $zero, 8($v0)
        move $t0, $v0
        addi $t3, $t3, 1
        j INSERT_INSERINDO


INSERT_END:
        li $t1, 1
        sb $t1, 8($t0)
        li $v0, 0
        jr $ra

INSERT_EXISTS:
        li $v0, 1
        jr $ra

STRING_ERROR:
        li $v0, -1
        jr $ra


############################################################## REMOCAO ##############################################################################################

removendo:

	#SALVO VALORES UTEIS NA PILHA
	addi $sp, $sp, -8
	sw $a1, 4($sp) # salvo o ponteiro do node atual
	sw $ra, 0($sp)# salvo o endereco de retorno
	
	
	# se ainda nao cheguei no utimo node, vejo se vou para o node da esquerda ou direita
	blt $t5, $a3, selecionar_lado #if(contador < strlen(entrada)) verificar lado!!!
	
	#CASO TENHA CHEGADO NO ULTIMO NODE .....
	
	#verifico se o node possui filhos (se nao possuir, posso remove-lo)
	lw $t0, 0($a1)
	bne $t0, $zero, nao_remover_node_final #se o ponteiro para esquerda ja nao for NULL
	lw $t0, 4($a1)
	bne $t0, $zero, nao_remover_node_final #se o ponteiro para direita nao for NULL
	
	#se o node nao possuir filhos:
	li $v0, 0 # seto o valor de retorno (0 - POSSO REMOVER ESTE NODE)
	j retornar_de_removendo
	
nao_remover_node_final:
	#marco a falg no numero atual como 0, ou seja, este node nao marca mais o fim de um numero
	sb $zero, 8($a1)
	#retorno 1 em $v0, oque indica que nao preciso remover nenhum node
	li $v0, 1
	j retornar_de_removendo
	
selecionar_lado:
	#CARREGO A LETRA ATUAL SENDO ANALISADA NA STRING
	lb $t0, 0($a2)   # $t0 = posicao atual na string
	addi $a2, $a2, 1 # incremento o ponteiro para string para este ir para proxima letra (proximo byte)

	beq $t0, '0', ir_para_esquerda
	# caso contrario, $t0 == 1 vou para direita:

ir_para_direita: 	
	lw $a1, 4($a1)   # O 'NODE ATUAL' PASSA A SER O DA DIREITA
	addi $t5, $t5, 1 # incremento o contador
	jal removendo    # RECURSAO ------------------------------

	lw $a1, 4($sp) # restauro o ponteiro do pai (que havia sido substituido pelo filho da direita)

	#VERIFICO O VALOR DE RETORNO DA RECURSAO ($v0)
	beq $v0, 0, remover_filho_direita # se $v0 == 0, posso remover o filho
	j retornar_de_removendo           # se $v0 == 1, nao posso remover o filho OU se $v0 == 2, o numero nao foi encontrado

ir_para_esquerda:	
	lw $a1, 0($a1)   # O 'NODE ATUAL' PASSA A SER O DA ESQUERDA
	addi $t5, $t5, 1 # incremento o contador
	jal removendo    # RECURSAO -------------------------------

	lw $a1, 4($sp) # restauro o ponteiro do pai (que havia sido substituido pelo filho da esquerda)

	#VERIFICO O VALOR DE RETORNO DA RECURSAO ($v0)
	beq $v0, 0, remover_filho_esquerda # se $v0 == 0, posso remover o filho
	j retornar_de_removendo            # se $v0 == 1, nao posso remover o filho OU se $v0 == 2, o numero nao foi encontrado

nao_remover_node:
	#retorno 1 em $v0, oque indica que nao preciso remover nenhum node
	li $v0, 1
	j retornar_de_removendo

verifica_se_posso_remover:
	#primeiro verifico se este node possui uma marcacao de final, se sim, nao posso remove-lo
	lb $t0, 8($a1)
	beq $t0, 1, nao_remover_node
	
	#verifico se o node possui filhos (se nao possuir, posso remove-lo)
	lw $t0, 0($a1)
	bne $t0, $zero, nao_remover_node # se o ponteiro para esquerda ja nao for NULL
	lw $t0, 4($a1)
	bne $t0, $zero, nao_remover_node # se o ponteiro para direita nao for NULL

	jr $ra # caso possua filhos, volto para a linha seguinte da linha que chamou essa funcao

remover_filho_direita:
	sw $zero, 4($a1) # atualizo o ponteiro para direita como nulo
	jal verifica_se_posso_remover #VERIFICO SE O NODE ATUAL PRECISA SER REMOVIDO

	#se voltar para essa linha, o node nao possui filhos e posso remove-lo
	li $v0, 0
	j retornar_de_removendo

remover_filho_esquerda:
	sw $zero, 0($a1) # atualizo o ponteiro para esquerda como nulo
	jal verifica_se_posso_remover #VERIFICO SE O NODE ATUAL PRECISA SER REMOVIDO

	#se voltar para essa linha, o node nao possui filhos e posso remove-lo
	li $v0, 0
	j retornar_de_removendo

retornar_de_removendo:
	lw $ra, 0($sp)
	addi, $sp, $sp, 8
	jr $ra

#----------------------------------------------------------------------------------------------------------------------------------------------
strlen:
	# FUNCAO RETORNA (EM $v0) O NUMERO DE CHARS DA STRING CASO NAO ENCONTRE ERRO, CASO ALGUM
	# DOS CARACTERES NAO SEJA '1' OU '0' RETORNA -1

	move $t4, $a1 # o registrador $t4 recebe a string
	li $v0, 0     # inicializo o valor de retorno como 0
	lb $t5, 0($t4) # o registrados $t5 recebe a 'letra' atual na string (inicialmente na posicao 0
	
verificando:
	beq $t5, $zero, fim_da_palavra
	addi, $t4, $t4, 1 # vou para a proxima posicao na string
	lb $t5, 0($t4)    # atualizo t5
	addi $v0, $v0, 1  # incremento a contagem dos caracteres
	j verificando

fim_da_palavra:
	jr $ra #volto para 'remover_numero' se cheguei no fim da palavra sem erros


#----------------------------------------------------------------------------------------------------------------------------------------------
remover_numero:
	# RETORNOS DA FUNCAO (EM $v0):
	# -1 - remocao efetuda com sucesso        -------> MUDAR RETORNOSS
	# -2 - palavra com chars invalidos
	# N : numero de bits do numero que deveria ser removido que foram encontrados na arvore

	# SALVO NA PLHA O ENDERECO DE RETORNO
	addi $sp, $sp, -12
	sw $ra, 0($sp)  
	sw $a1, 4($sp) # gurado na pilha o ponteiro pra raiz da arvore
	sw $a2, 8($sp) # e tambem o ponteiro para o espaco mallocado para armazenar a string
	
	#VERIFICO SE O NUMERO EXISTE NA ARVORE COM A BUSCA: (os argumentos a1 e a2 ja estao setados)
	jal TRIE_SEARCH
	
	#analisando os retornos de TRIE_SEARCH
	beq $v0, -2, chars_invalidos   ## erro 1 ficou como '-dois' para bater com a funcao de search e vice-versa
	bne $v0, -1, numero_nao_existe

	#CHAMO O LABEL 'strlen' QUE RETORNA O TAMANHO DA STRING
	move $a1, $a2 # o unico argumento para 'verifica_string' e a string
	jal strlen
	#CASO NAO HAJA ERRO NA STRING, PERCORRO A ARVORE
	lw $a1, 4($sp) # o primeiro argumento e o ponteiro para raiz da arvore
	lw $a2, 8($sp) # o segundo argumeto e o ponteiro para a string
	move $a3, $v0 # o terceiro argumento e o tamanho da palavra
	li $t5, 0     # o quarto argumento e o valor inicial de um contador
	jal removendo 
	
remocao_bem_sucedida:
	li $v0, -1 # setando em v0 o valor de retorno de 'deu tudo certo' hehehehe :)
	j voltando_para_remover

chars_invalidos: # PALAVRA COM CHARS INVALIDOS
	li $v0, -2 # setando em v0 o valor de retorno desse erro
	j voltando_para_remover

numero_nao_existe: #PALAVRA NAO EXISTE NA ARVORE
	 # o valor de retorno eh o proprio retorno de TRIE_SEARCH, valor ja em v0

voltando_para_remover:
	#RESTAURO DA PILHA O PONTEIRO PARA RETORNO DA FUNCAO
	lw $ra, 0($sp)
	addi, $sp, $sp, 12
	jr $ra

############################################################## MAIN ################################################################################################

#segmento de texto
	.text

# $s0: guarda o ponteiro do espaco alocado na heap com a string digitada pelo usuario
# $s1: guarda a opcao do menu escolhida pelo usuario
# $s2: ponteiro para a raiz arvore 
#
#

criar_node:#-----------------------------------------------------------------------------------
	# Aloco 9 bytes para um node:	
	# 4 para conter o ponteiro para o filho da direita
	# 4 para conter o ponteiro para o filho da esquera
	# 1 para conter a flag que indicara se este node eh ou nao o fim de um numero
	
	li $a0, 9      #quero alocar 9 bytes 
	li $v0, 9      # 'comando' para alocar espaco na memoria
	syscall        #SYSCALL
	#o ponteiro para o endereco alocado ja esta no registro de retorno $v0
		
	#inicializando:
	lw $zero, 0($s0)
	lw $zero, 4($s0)
	lb $zero, 8($s0)
	
	jr $ra

ler_entrada:#-----------------------------------------------------------------------------------
	move $a0, $s0   #passo para a0 o endereco no qaual a palavra lida sera armazenada
	li $a1, 15      # indico que poso ler ate 15 bytes de informacao
	li $v0, 8       #comando read_string
	syscall

	move $t1, $s0 # uma copia da string
	
substituir_barra_ene:
	addi $t1, $t1, 1 # vou para proxima posicao da string
	lb $t0, 0($t1)   # pego o numero  na posicao atual
	bne $t0, 10, substituir_barra_ene

	sb $zero , 0($t1)  # na posicao do vetor que era \n, coloco um \0
	
	
	jr $ra

inserir:#--------------------------------------------------------------------------------------- 
	#SALVO NA PILHA O ENDERECO DE RETORNO 
	addi $sp, $sp, -12
	sw $ra, 0($sp) # guardo na pilha o ponteiro de retorno
	sw $a1, 4($sp) # gurado na pilha o ponteiro pra raiz da arvore
	sw $a2, 8($sp) # e tambem o ponteiro para o espaco mallocado para armazenar a string
	
in:
	#EXIBO MENSAGEM NA TELA PEDINDO INPUT
	la $a0, digite_binario_insercao
	li $v0, 4
	syscall

	jal ler_entrada
	
	#verificando string pra ver se eh -1
verficar_menos_in:
	lb $t1, 0($s0)
	bne $t1, '-', continuar_insercao
	
verificar_um_in:
	lb $t1, 1($s0)
	bne $t1, '1', continuar_insercao
	
verificar_barra_zero:
	lb $t1, 2($s0)
	beq $t1, $zero,  voltando_para_TRIE


continuar_insercao:
	lw $a1, 4($sp)
	lw $a2, 8($sp)

	jal TRIE_INSERTION

	beq $v0, 1, in_existente
	beq $v0, -1, in_mal_formatada
	beq $v0, 0, in_sucesso

in_sucesso:
	#CASO 'inserir_numero' TENHA RETORNADO 0: SUCESSO
	la $a0, inserido_sucesso
	li $v0, 4
	syscall

	j in

in_existente:
	#CASO 'inserir_numero' TENHA RETORNADO 1: PALAVRA JA EXISTE
	la $a0, chave_repetida  # | 
	li $v0, 4               # |--> exibindo mensagem de chave repetida
	syscall                 # |
	j in # volto para pedir outro input

in_mal_formatada:
	#CASO 'inserir_numero' TENHA RETORNADO -1: CHARS INVALIDOS :(
	la $a0, chave_invalida  # | 
	li $v0, 4               # |--> exibindo mensagem de chave invalida
	syscall                 # |
	j in # volto para pedir outro input

remover: #-------------------------------------------------------------------------------------
	#SALVO NA PILHA O ENDERECO DE RETORNO
	addi, $sp, $sp, -12
	sw $ra, 0($sp) # guardo na pilha o ponteiro de retorno
	sw $a1, 4($sp) # gurado na pilha o ponteiro pra raiz da arvore
	sw $a2, 8($sp) # e tambem o ponteiro para o espaco mallocado para armazenar a string

rm:
	#EXIBO MENSAGEM NA TELA PEDINDO INPUT
	la $a0, digite_binario_remocao
	li $v0, 4
	syscall
	
	jal ler_entrada     #leio a entrada
	
verficar_menos_rm:
	lb $t1, 0($s0)
	bne $t1, '-', continuar_remocao
	
verificar_um_rm:
	lb $t1, 1($s0)
	bne $t1, '1', continuar_remocao
	
	j verificar_barra_zero
	
continuar_remocao:
	lw $a1, 4($sp)      #restauro a1 que foi usado em ler entrada
	lw $a2, 8($sp)
	
	jal remover_numero  #chamo a funcao de remocao
	
	beq $v0, -2, rm_mal_formatado
	bne $v0, -1, rm_existente
	#beq $v0, -1, rm_sucesso (proxima funcao):

rm_sucesso:
	#CASO 'remover_numero' TENHA RETORNADO -1: SUCESSO!!!
	la $a0, chave_encontrada
	li $v0, 4
	syscall
	
	move $a0, $s0 #imprimo o numero encontrado (palavra) NAO SEI SE TA CERTOOOOOOOOOO
	li $v0, 4
	syscall
	
	la $a0, barra_ene
	li $v0, 4
	syscall
	
	la $a0, caminho_percorrido
	li $v0, 4
	syscall
	
	jal imprimir_caminho_percorrido
	
	la $a0, barra_ene
	li $v0, 4
	syscall
	
	la $a0, remocao_sucesso # |
	li $v0, 4               # |--> exibindo mensagem de sucesso
	syscall                 # |
	
	j rm

rm_mal_formatado:
	#CASO 'remover_numero' TENHA RETORNADO -2: CHARS INVALIDOS :(
	la $a0, chave_invalida  # | 
	li $v0, 4               # |--> exibindo mensagem de chave invalida
	syscall                 # |
	j rm # volto para pedir outro input
	
rm_existente:
	#CASO 'remove_numero' TENHA RETORNADO -3: PALAVRA NA EXISTE
	la $a0, chave_nao_encontrada  # | 
	li $v0, 4                     # |--> exibindo mensagem de chave invalida
	syscall                       # |
	j rm # volto para pedir outro input
	
voltando_para_TRIE:
	#RECUPERO O ENDERECO DE RETORNO E OS ARGUMENTOS INICIAIS DA PILHA
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra

buscar: #-----------------------------------------------------------------------------------------------
	#SALVO NA PILHA O ENDERECO DE RETORNO
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp) # guardo na pilha o ponteiro pra raiz da arvore
	sw $a2, 8($sp) # e tambem o ponteiro para o espaco mallocado para armazenar a string	

bus:
	#EXIBO MENSAGEM NA TELA PEDINDO INPUT
	la $a0, digite_binario_busca
	li $v0, 4
	syscall
	
	jal ler_entrada     #leio a entrada

verficar_menos_bus:
	lb $t1, 0($s0)
	bne $t1, '-', continuar_busca
	
verificar_um_bus:
	lb $t1, 1($s0)
	bne $t1, '1', continuar_busca
	
	j verificar_barra_zero

continuar_busca:	
	lw $a1, 4($sp)      #restauro a1 que foi usado em ler entrada
	lw $a2, 8($sp)
	
	jal TRIE_SEARCH  #chamo a funcao de busca
	
	move $t4, $v0		#salva o valor de N
	beq $v0, -2, bus_invalido
	beq $v0, -1, bus_encontrado

bus_nao_encontrado:
	#CASO 'busca_numero' TENHA RETORNADO N: NUMERO NAO ENCONTRADO
	
	la $a0, chave_nao_encontrada
	li $v0, 4
	syscall

	la $a0, barra_ene
	li $v0, 4
	syscall

	la $a0, caminho_percorrido
	li $v0, 4
	syscall

	jal imprimir_caminho_percorrido
	
	la $a0, barra_ene
	li $v0, 4
	syscall

	j voltando_para_TRIE

bus_encontrado:
	#CASO 'busca_numero' TENHA RETORNADO -1: SUCESSO!!!
	la $a0, chave_encontrada
	li $v0, 4
	syscall
	
	move $a0, $s0 #imprimo o numero encontrado (palavra) 
	li $v0, 4
	syscall
	
	la $a0, barra_ene
	li $v0, 4
	syscall
	
	la $a0, caminho_percorrido
	li $v0, 4
	syscall
	
	jal imprimir_caminho_percorrido
	
	la $a0, barra_ene
	li $v0, 4
	syscall
	
	j bus

#MUDAR para todas as funcoes chamarem o mesmo retorno_um	
bus_invalido:
	#CASO 'busca_numero' TENHA RETORNADO 2: CHARS INVALIDOS :(
	la $a0, chave_invalida  # | 
	li $v0, 4               # |--> exibindo mensagem de chave invalida
	syscall                 # |

	la $a0, barra_ene
	li $v0, 4
	syscall

	j bus # volto para pedir outro input
	
vizualizar: #--------------------------------------------------------------------------------------------------------------------- 

	jal imprime
	move $v0, $zero
	j voltando_para_TRIE


imprimir_caminho_percorrido: #IMPRIMIR CAMINHO PERCORRIDO ATE O \0--------------------------------------------------------------- 
	
	la $a0, raiz	#imprime raiz
	li $v0, 4
	syscall

	move $t5, $zero	#cria um contador
	move $t1, $s0	#copia string

loop_caminho:	

	lb $t2, 0($t1)	#carrega um caracter da string

	beq $t2, $zero, terminar_caminho 	#se for \0 termina
	beq $t4, $t5, terminar_caminho		#se for igual ao contador termina
	
	addi, $t5, $t5, 1			#incrementa o contador
	
	jal imprimir_virgula	#imprime virgula

	beq $t2, '0', imprimir_esq	#se for zero imprime esquerda
	j imprimir_dir			#se for um imprime direita
			
imprimir_esq:
	la $a0, esquerda
	li $v0, 4
	syscall

	addi $t1, $t1, 1	#passa para o proximo caracter
	j loop_caminho		#continua imprimindo	

imprimir_dir:
	la $a0, direita
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1	#passa para o proximo caracter
	j loop_caminho		#continua imprimindo
	
imprimir_virgula:
	
	la $a0, virgula
	li $v0, 4
	syscall
	
	jr $ra
	
terminar_caminho:		#finaliza impressao de caminho

	la $a0, barra_ene	#imprime \n
	li $v0, 4
	syscall

	move $t4, $zero		#zera o valor de N
	move $t5, $zero		#zera o contador
	

	j voltando_para_TRIE	#volta pro menu

escolher_funcao: #-----------------------------------------------------------------------------------------------------------------
	#ESTA FUNCAO RETORNARA UM VALOR EM v0, SE...
	# $v0 == 0, CONTINUO RODANDO O PROGRAMA
	# $v0 == 1, USUARIO SELECIONOU A OPCAO 5 (SAIR DO PROGRAMA)
	
	#SALCANDO NA PILHA O ENDERECO PARA RETORNO (label1: menu):
	addi $sp, $sp, -16
	sw $ra,  0($sp)
	sw $s0,  4($sp) #guardo o ponteiro na heap para string
	sw $s1,  8($sp) #guardo o valor da opcao digitada pelo usuario
	sw $s2, 12($sp) #guardo o ponteiro para o raiz da arvore
	
	
	beq $s1, 1, inserir_TRIE
	beq $s1, 2, remover_TRIE
	beq $s1, 3, buscar_TRIE
	beq $s1, 4, vizualizar_TRIE
	beq $s1, 5, exit_TRIE
	
	#CASO PADRAO (a opcao escolhida pelo usuario nao existe), IMPRIMO MENSAGEM DE ERRO E RETORNO PARA MENU:
	la $a0, opcao_nao_existe
	li $v0, 4
	syscall
	
	li $v0, 0 # o valor de retorno e definido para indicar que so vou continuar a execucao
	j voltando_para_menu
	
inserir_TRIE:
	#SETANDO ARGUMENTOS:
	move $a1, $s2 # o primeiro argumento a ser passado eh o ponteiro para a raiz da arvore
	move $a2, $s0 # o segundo eh o ponteiro pro espaco na memoria alocado para armazernar a string que sera lida
	
	jal inserir
	li $v0, 0 # setando valor de retorno
	j voltando_para_menu
	
remover_TRIE:
	#SETANDO ARGUMENTOS:
	move $a1, $s2 # o primeiro argumento eh o ponteiro para a raiz da arvore
	move $a2, $s0 # o segundo eh o ponteiro pro espaco na memoria alocado para armazernar a string que sera lida
	
	jal remover
	li $v0, 0 # setando valor de retorno
	j voltando_para_menu

buscar_TRIE:
	#SETANDO ARGUMENTOS:
	move $a1, $s2 # o primeiro argumento eh o ponteiro para a raiz da arvore
	move $a2, $s0 # o segundo eh o ponteiro pro espaco na memoria alocado para armazernar a string que sera lida
	
	jal buscar
	li $v0, 0 # setando valor de retorno
	j voltando_para_menu

vizualizar_TRIE:
	#SETANDO ARGUMENTOS:
	move $a1, $s2 # o primeiro e unico argumento eh o ponteiro para a raiz da arvore
	
	jal vizualizar
	li $v0, 0 # setando valor de retorno
	j voltando_para_menu

exit_TRIE:
	li $v0, 1 #altero o valor de retorno para 1, o que indicara o fim do programa
	

voltando_para_menu: #VOLTO PARA O LABEL 'menu'
	
	# RECARREGO NO REGISTRADOR $Ra O ENDERECO DE RETORNO DA FUNCAO (e os $s* cm seus valores)
	lw $ra, 0($sp)  # |
	lw $s0, 4($sp)  # |--> restauro o valores da pilha em seus respectivos registradores
	lw $s1, 8($sp)  # |
	lw $s2, 12($sp) # |
	jr $ra

secao_do_menu: #-------------------------------------------------------------------------------------------------------------------

	# SALVANDO NA PILHA O ENDERECO PARA RETORNO QUANDO A FUNCAO ACABAR:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
menu:
	
	# EXIBINDO O MENU DE OPCOES:
	la $a0, menu_opcoes  # carrego a string com o menu para a0
	li $v0, 4            # passo para v0 o 'comando' para imprimir uma string
	syscall
	
	# LENDO A OPCAO DO MENU QUE O USUARIO DESEJA:
	li $v0, 5      # 5: comando para ler inteiro
	syscall        #SYSCALL
	move $s1, $v0  #passo o comando o comando lido s1
	
	# FUNCAO QUE VERIFICA QUAL OPCAO FOI ESCOLHIDA E COMO PROCEDER:
	jal escolher_funcao
	
	#SE O RETORNO DE 'escolher funcao' FOR 0, VOLTO PARA MENU PARA CONTINUAR O PROGRAMA
	beq $v0, 0, menu
	
	#CASO CONTRARIO, VOLTO PARA A MAIN E FINALIZO A EXECUCAO....

voltando_para_main: #VOLTO PARA O LABEL 'main'
	
	# RECARREGO NO REGISTRADOR $ra O ENDERECO DE RETORNO DA FUNCAO (POR ISSO EMPILHEI)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
main: #--------------------------------------------------------------------------------------------------------------------------------
	#ALOCANDO DINAMICAMENTE ESPACO PARA STRING DE INPUT:
	li $a0, 16   # colocando em 10 a quantidade de bits para ser alocado
	li $v0, 9    # 9: 'comando' para alocar ($a0) espacos na heap
	syscall      # SYSCALL
	move $s0, $v0  # passando o ponteiro do espaco alocado para s0
	
	#CRIO A RAIZ DA ARVORE E PASSO O PONTEIRO PARA $s2
	jal criar_node
	move $s2, $v0
	
	
	#EXIBINDO MENU E EXECUTANDO OPCOES SENDO ESCOLOHIDAS:
	jal secao_do_menu
	
	#ENCERRANDO O PROGRAMA ... ;D ...
	li $v0, 10
	syscall

#segmento de dados:
	.data

menu_opcoes: .ascii "1 - Insercao,"
			 .ascii "\n"
			 .ascii "2 - Remocao,"
			 .ascii "\n"
			 .ascii "3 - Busca,"
			 .ascii "\n"
			 .ascii "4 - Vizualizacao,"
			 .ascii "\n"
			 .asciiz "5 - Fim\n"
			
opcao_nao_existe: .asciiz "A opcao selecionada nao existe, tente novamente: \n\n"

chave_invalida: .asciiz "Chave Invalida. Insira somente numeros binarios (ou -1 para retornar ao menu).\n"

double_barra_ene: .asciiz "Digite um binario para remocao"
barra_ene: .asciiz "\n"

#secao para remocao:
digite_binario_remocao: .asciiz "Digite um binario para remocao: "
chave_encontrada: .asciiz "Chave encontrada na arvore: "
chave_nao_encontrada: .asciiz "Chave nao encontrada na arvore: -1\n"
caminho_percorrido: .asciiz "Caminho percorrido: "
remocao_sucesso: .asciiz "Chave removida com sucesso.\n\n"

#secao para insercao:
digite_binario_insercao: .asciiz "Digite um binario para insercao: "
inserido_sucesso: .asciiz "Chave inserida com sucesso.\n\n"

#secao para busca:
digite_binario_busca: .asciiz "Digite um binario para busca: "
chave_repetida: .asciiz "Chave repetida, insercao nao permtida\n\n"

menos_um: .asciiz "-1"

virgula: .asciiz ", "
esquerda: .asciiz "esq"
direita: .asciiz "dir"
raiz: .asciiz "raiz"

#Seção para impressão
str_impr_raiz:		.asciiz ">> N0 (raiz, "
str_impr_nivel:		.asciiz ">> N"
str_impr_abre:		.asciiz " ("
str_impr_separa:	.asciiz ", "
