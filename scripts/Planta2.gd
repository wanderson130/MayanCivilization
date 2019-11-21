extends Node2D

onready var TIMER = $Timer
onready var PROGRESS_BAR = $ProgressBar
onready var ANIM_SPRITE = $AnimatedSprite
onready var nomes_das_animacoes = ANIM_SPRITE.get_sprite_frames().get_animation_names()
onready var quant_de_animacoes = ANIM_SPRITE.get_sprite_frames().get_animation_names().size()
var tempo_decorrido
var numero_de_frames
var inicio_da_animacao = 0
var fim_da_animacao = 0
var tempo_entre_frames = 0
var tmp = 0
var inicio_do_frame = 0
var marcador_atual
var animacao_atual = 0
var tempo_entre_animacoes = 0
var frame_atual = 0
var desenvolvida = false

#função para arredondar números "por casas decimais"
func round_to_dec(num, digit):
    return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _ready():
	tempo_entre_animacoes = TIMER.wait_time/quant_de_animacoes
	fim_da_animacao = tempo_entre_animacoes
	marcador_atual = fim_da_animacao
	
#responsável pelo gerenciamento de animações e intervalos entre seus frames
func animar_sprites(animatedSprite):
	if(tmp == 0):
		numero_de_frames = animatedSprite.get_sprite_frames().get_frame_count(animatedSprite.get_animation())
		tempo_entre_frames = (fim_da_animacao - inicio_da_animacao)/numero_de_frames
		inicio_do_frame = tempo_entre_frames
	
	#responsável por mudar as animações
	#se a animação que está executando terminar e estiver antes da última
	if(round_to_dec(tempo_decorrido, 1) == round_to_dec(fim_da_animacao, 1) and animacao_atual < quant_de_animacoes-1):
		#incrementa o índice da animação
		animacao_atual += 1
		#executa a nova animação a partir do seu índice no array de nomes
		animatedSprite.animation = nomes_das_animacoes[animacao_atual]
		#o inicio da nova animação é o fim da anterior
		inicio_da_animacao = fim_da_animacao
		#o fim da nova é o fim da anterior mais o tempo entre animações
		fim_da_animacao += tempo_entre_animacoes
		
		#recebe o números de frames da animação atual
		numero_de_frames = animatedSprite.get_sprite_frames().get_frame_count(animatedSprite.get_animation())
		#pega o intervalo em que a animação será executada e divide pelo seu número de frames
		#para calcular o tempo entre frames
		tempo_entre_frames = (fim_da_animacao - inicio_da_animacao)/numero_de_frames
		#seta o inicio do proximo frame da animacao
		inicio_do_frame += tempo_entre_frames
		#zera o valor do frame atual da proxima animacao, para ser ela ser executada do início
		frame_atual = 0
	
	#responsável por mudar os frames
	#se o tempo decorrido for igual ao tempo que o frame aparece e o frame não for o último
	if(round_to_dec(tempo_decorrido, 1) == round_to_dec(inicio_do_frame, 1) and frame_atual < numero_de_frames-1):
		frame_atual += 1
		#seta o próximo frame
		animatedSprite.set_frame(frame_atual)
		#para não executar o bloco do frame inicial novamente
		tmp +=1
		#o inicio do próximo frame será o início do frame atual mais o intervalo entre os frames
		inicio_do_frame += tempo_entre_frames
		
func _physics_process(delta):
	#tempo desde que a planta começou brotar
	tempo_decorrido = TIMER.wait_time - TIMER.time_left
	#preenche a barra de progresso baseado no tempo_decorrido
	PROGRESS_BAR.value = (tempo_decorrido*100)/TIMER.wait_time
	animar_sprites(ANIM_SPRITE)
	
func _on_Timer_timeout():
	PROGRESS_BAR.visible = false
	desenvolvida = true

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.get_button_index() == 2:
		queue_free()