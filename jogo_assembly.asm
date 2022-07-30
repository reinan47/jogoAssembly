reinan
.data
  #interface dos dados
  um : .asciiz "\n   |---|\n   |   |\n   | o |\n   |   |\n   |---|\n\n"
  dois : .asciiz "\n   |---|\n   |o  |\n   |   |\n   |  o|\n   |---|\n\n"
  tres : .asciiz "\n   |---|\n   |o  |\n   | o |\n   |  o|\n   |---|\n\n"
  quatro : .asciiz "\n   |---|\n   |o o|\n   |   |\n   |o o|\n   |---|\n\n"
  cinco : .asciiz "\n   |---|\n   |o o|\n   | o |\n   |o o|\n   |---|\n\n"
  seis : .asciiz "\n   |---|\n   |o o|\n   |o o|\n   |o o|\n   |---|\n\n"
  preencher: .byte ' '       #auxilia para preencher tabuleiro
  aux: .byte ']'
  aux1: .byte '['                               
  penalidade1: .byte'-' #rotulo de penalidade        
  penalidade2: .byte'<' #rotulo de penalidade        
  bonus : .byte'+'      #rotulo de bonus                   
  parar: .byte'='    #rotulo de parada
  
  jogador1: .byte 'B'
  jogador2: .byte 'A'
  
  jogador1aux: .asciiz "A-> "
  jogador2aux: .asciiz "B-> "
  chegou: .asciiz "->"
  
  venceu : .asciiz " venceu!!!\n"
  
  tabuleiro : .byte #tabuleiro
              .align 0 # alinha na posição correta de char
              .space 40 # reservando 23 bytes na memoria ja q defini que ia ser char
         

.text
  main:
         
      ############################################################
      #	 preencher o tabuleiro com espaços vazios e variedades   #
      ############################################################     
      move $t0,$zero #contador do For
      lb $t1,preencher           #passando o valor que preencherar as posições para um registrador 
      lb $s0,bonus              #jogando rotulo de bonus em $s0
      lb $s1,penalidade2	 #jogando rotulo de penalidade em $s1
      lb $s2,penalidade1 	 #jogando rotulo de penalidade em $s2
      lb $s3,parar		 #jogando rotulo de parar em $s3
      for: bge $t0,40,sairFor    #condição do for
      	   bne $t0,10,pulo   #condição para adicionar o campo de penalidade
      	       sb $s0,tabuleiro($t0)
      	       addi $t0,$t0,1
      	       j for
      	   pulo:
      	   
      	   bne $t0,20,pulo1   #condição para adicionar o campo de penalidade
      	       sb $s1,tabuleiro($t0)
      	       addi $t0,$t0,1
      	       j for
      	   pulo1:
      	   
      	   bne $t0,25,pulo2   #condicao para adicionar o campo bonus
      	       sb $s2,tabuleiro($t0)
      	       addi $t0,$t0,1
      	       j for
      	   pulo2:
      	   bne $t0,30,pulo3  #condicao para adicionar o campo pergunta
      	       sb $s3,tabuleiro($t0)
      	       addi $t0,$t0,1
      	       j for
      	   pulo3:
      	   
      	   sb $t1,tabuleiro($t0) #jogando os valores em cada uma posição do array
           addi $t0,$t0,1	 #incrementando o contador
           j for                 #repetindo o laço
      sairFor: #rotulo de saida
      
   li $v0,32#dando um brake para iniciar 
      la $a0 2000        
      syscall
  loop: 
      lb $s4,jogador1  #peça do jogador 1
      lb $s5,jogador2  #peça do jogador 2
      play1: 
      jal jogadas  #chamada da função joga dado 
      add $t3,$t3,$a0 #recebendo o incremento do dado em $t3
         
      bne $t3,10,sair  #condição avança 3 casas
          sb $s4,tabuleiro($t3) #pulando pra casa do bonus
          sb $s0,tabuleiro($t3) #atualizando novamente a casa do bonus
          addi,$t3,$t3,3 #avançando 3 casas
          sb $s4,tabuleiro($t3)  #posicionando no local correspondente ao valor do dado
      sair:
      
      bne $t3,20,sair1  #condição prar voltar ao inicio do do jogo
          sb $s4,tabuleiro($t3)#pulando pra casa da penalidade
          sb $s1,tabuleiro($t3)#atualizando novamente a casa da penalidade
      	  add $t3,$zero,$zero  #voltand ao inicio
      	  sb $s4,tabuleiro($t3)  #posicionando no local correspondente ao valor do dado
      sair1:
      
      bne $t3,25,sair2  #condição pra recuar 6 casas
          sb $s4,tabuleiro($t3) #pulando pra casa da penalidade
          sb $s2,tabuleiro($t3)#atualizando novamente a casa da penalidade
          addi $t3,$t3,-6   #recuando 6 casas
          sb $s4,tabuleiro($t3)  #posicionando no local correspondente ao valor do dado
      sair2:
      addi $t6,$zero,30#atualizando a casa da penalidade de '=', pare uma rodada
      sb $s3,tabuleiro($t6)
      addi $t6,$zero,0#condição onde o jogador 1 vai ficar uma rodada parada
      bne $t3,30,sair4
          addi $t6,$zero,1
      sair4:
      
      bne $t3,$t4,jog2Ini    #caso ele caia no mesmo lugar o oponente volta ao inicio
          add $t4,$zero,$zero
      jog2Ini: 

      sb $s4,tabuleiro($t3)  #jogada caso não atenda nenhuma condição acima
      jal exibeDado #pulando pra função exibir dado
      li $v0,4#############
      la $a0,jogador2aux###  mostrando de quem é a jogada
      syscall##############
      jal tabuleiroAtualizado   #cahamada da função arualiza tabuleir
      sb $t1,tabuleiro($t3) #colocando o valor anterior para não porluir o jogo 
      
      bne $t7,1,jogarNovamente1 #momento onde o jogador 1 joga novamente caso o jogador 2 caia nessa penalidade '='
      	  addi $t7,$zero,0
          j play1
      jogarNovamente1:

      play2:
      jal jogadas
      add $t4,$t4,$a0
      jal exibeDado #pulando pra função exibir dado

      bne $t4,10,sairr  #condição para voltar 3 casas
          sb $s5,tabuleiro($t4) #pulando pra casa do bonus
          sb $s0,tabuleiro($t4) #atualizando novamente a casa do bonus
          addi,$t4,$t4,3 #avançando 3 casas
          sb $s5,tabuleiro($t4)  #posicionando no local correspondente ao valor do dado
      sairr:
      
      bne $t4,20,sair11  #condição prar voltar ao inicio do do jogo
          sb $s5,tabuleiro($t4)#pulando pra casa da penalidade
          sb $s1,tabuleiro($t4)#atualizando novamente a casa da penalidade
      	  add $t4,$zero,$zero#voltand ao inicio
      	  sb $s5,tabuleiro($t4)  #posicionando no local correspondente ao valor do dado
      sair11:
      
      bne $t4,25,sair22  #condição pra recuar 6 casas
          sb $s5,tabuleiro($t4) #pulando pra casa da penalidade
          sb $s2,tabuleiro($t4)#atualizando novamente a casa da penalidade
          addi $t4,$t4,-6   #recuando 6 casas
          sb $s5,tabuleiro($t4)  #posicionando no local correspondente ao valor do dado
     sair22:  
      addi $t7,$zero,30 #atualizando a casa da penalidade de '=' pare uma rodada
      sb $s3,tabuleiro($t7)
      addi $t7,$zero,0
      bne $t4,30,sair44  #condição onde o jogador 2 ficará uma rodada parado
          addi $t7,$zero,1
      sair44:

	
       bne $t4,$t3,jog1Ini   #caso ele caia no mesmo lugar o oponente volta ao inicio
          add $t3,$zero,$zero
      jog1Ini:   
           
      sb $s5,tabuleiro($t4) #jogada caso não atenda nenhuma condição acima
     
      blt $t3,40,sair3  #definindo quem é o vencedor
          li $v0,11
      	  lb $a0,jogador1
      	  syscall 
          li $v0,4
      	  la $a0,venceu
      	  syscall 
       	  jal tabuleiroAtualizado
          li $v0,11
      	  lb $a0,jogador1
      	  syscall 
     	  j fim
      sair3:
      blt $t4,40,sair33  #definindo quem é o vencedor
          li $v0,11
      	  lb $a0,jogador2
      	  syscall 
          li $v0,4
      	  la $a0,venceu
      	  syscall 
      	  jal tabuleiroAtualizado
          li $v0,11
      	  lb $a0,jogador2
      	  syscall
     	  j fim
      sair33:
      
      li $v0,4  ##############
      la $a0,jogador1aux###### mostrando de quem é a jogada
      syscall#################
      jal tabuleiroAtualizado   #cahamada da função arualiza tabuleir
      sb $t1,tabuleiro($t4) #colocando o valor anterior para não porluir o jogo
      bne $t6,1,jogarNovamente2#play 2 joga novamente caso o play 1 caia na penalidade '='
      	  addi $t6,$zero,0
          j play2
      jogarNovamente2:         

      

      j loop #fazendo o loop

        

          
  fim: #rotulo de fim
  addi,$v0,$zero,10
  li $v0,10 #fim da execução
  syscall
 
  
  
  jogadas:
      #################################      
      #   função para sortear o dado  #
      #################################      
      #sorteio de 1 a 6 aleatorio com syscall 42
      addi $v0,$zero,42   #adicionando syscall em $v0
      addi $a1,$zero,7    #adicionando o intervalo de 1 a 6
      add $a0,$a0,$zero   #$a0 recebe esse valor aleatório
      syscall
      
      addi $t0,$zero,0   #valor a ser comparado na condição
      bne $a0,$t0,sairIf #garante que não saia 0 no sorteio
          addi $a0,$zero,1
      sairIf:

      jr $ra 
  
#########################################################################
    ################################
    #   função para exibir dado    #
    ################################
    exibeDado:  #rotulo pra exibir o dado
  
      #interface dos dados de acordo com o numero do dado sorteado
      li $v0,4
      bne $a0,1 sairIf1 #condicao pra exibir o dado 1
          la $a0, um
          syscall
          jr $ra  #retornando pra proxima linha depois da chamada da função
      sairIf1:

      bne $a0,2 sairIf2 #condicao pra exibir o dado 2
          la $a0, dois
      	  syscall
      	  jr $ra  #retornando pra proxima linha depois da chamada da função
     sairIf2: 
  
     bne $a0,3 sairIf3 #condicao pra exibir o dado 3
         la $a0, tres
         syscall
         jr $ra  #retornando pra proxima linha depois da chamada da função
     sairIf3:
  
     bne $a0,4 sairIf4 #condicao pra exibir o dado 4
         la $a0, quatro
         syscall
         jr $ra  #retornando pra proxima linha depois da chamada da função
    sairIf4:
   
    bne $a0,5 sairIf5 #condicao pra exibir o dado 5
        la $a0, cinco
        syscall
        jr $ra  #retornando pra proxima linha depois da chamada da função
    sairIf5:
    
    bne $a0,6 sairIf6 #condicao pra exibir o dado 6
        la $a0, seis
        syscall
        jr $ra  #retornando pra proxima linha depois da chamada da função
    sairIf6:
###########################################################################


      
      ##################################################
      #	 função para imprimir tabuleiro atualizado     #
      ################################################## 
      tabuleiroAtualizado:   #rotulo da função
         move $t0,$zero #contador do For
         li $v0,11
     
         lb $a0,aux1
      	 syscall
         Imprime: bge $t0,40,sairFor1   #condição do for
      	      li $v0,11
      	      sb $s4,tabuleiro($t3)#imprimindo peça do jogador 1
      	      sb $s5,tabuleiro($t4)#imprimindo peça do jogador 2
              lb $a0,tabuleiro($t0) #jogando os valores em $a0 para imprimir
              syscall
              sb $t1,tabuleiro($t4)#setando o valor original do tabuleiro na posição anterior do jogador 1 
              sb $t1,tabuleiro($t3)#setando o valor original do tabuleiro na posição anterior do jogador 2
              lb $a0,aux		 #carregando dado em $a0 para imprimir
              syscall
              lb $a0,aux1		 #carregando dado em $a0 para imprimir
              syscall
              addi $t0,$t0,1	 #incrementando o contador
              j Imprime                #repetindo o laço
         sairFor1: #rotulo de saida
         li $v0,4
         la $a0,chegou
      	 syscall
         li $v0,32
         la $a0 2000        
         syscall
         jr $ra #retorno da proxima linha depois da chamada da função

  



