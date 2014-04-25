package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	[SWF(width="800",height="600",frameRate="30")]
	public class Demo_5 extends Sprite
	{
		private var _pista:f_mc_pista;
		private var _front1:f_front1;
		private var _front2:f_front2;
		private var _cielo:f_cielo;
		private var _player:mc_jugador;
		private var _impulso:mc_laser;
		private var _explo:particula_expo;
		
		private var speed:int=5;
		private var parallax:Number=1;
		private var contador:Number=0;
		
		private var _enemigo_:C_enemigo;
		private var _enemigo_sinColor:C_enemigo;
		private var _rayo:C_enemigo;
		private var _roca:C_enemigo;
		
		private var velocidad_enemigo:Number=5;
		private var _enemigo_color:int =1;
		private var _vida_color:int =2;
		
		private var _indicador:mcx_indicador_malos;
		private var _indicador_vida:mc_barra_coger;
		
		private var mainJumping:Boolean = false;
		private var jumpSpeedLimit:int=20;
		private var jumpSpeed:Number = jumpSpeedLimit;
		private var upKeyDown:Boolean = false;	
		private var rightKeyDown:Boolean = false;
		
		private var flag_correr:Boolean =false;
		private var jump_dis:Number=1;
		
		private var contador_rayo:int=0;
		private var arreglo_enemigosSColor:Array = new Array();
		private var _mensaje:mc_mensaje;
		private var _vida:int=10;
		private var myTimer:Timer;
		
		private var myText:TextField;
		private var myFormat:TextFormat;
		
		private var _score:int=100;
		private var myTextScore:TextField;
		private var myFormatScore:TextFormat;
		
		public function Demo_5()
		{
			//Movimiento de los edificios
			this.addEventListener(Event.ENTER_FRAME,MoverTodo,false,0,true);
			//Creando la ciudad
			f_CrearCiudad();
			
			
			//Creacion de Enemigos
			this.addEventListener(Event.ENTER_FRAME,CrearEnemigos,false,0,true);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown,false,0,true);
			stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp,false,0,true);
			this.addEventListener(Event.ENTER_FRAME,moveChar,false,0,true);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,MouseDown,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,MouseUp,false,0,true);
			
			
			myTimer = new Timer(1500);
			myTimer.addEventListener(TimerEvent.TIMER, LanzarObstaculos);
			
			myTimer.start();
			
		}
		
		
		protected function LanzarObstaculos(event:TimerEvent):void
		{
			trace("Timer is Triggered");
			if(ObtenerColor(1,3)!=1){
				f_CrearEnemigo();
			}
			
			
			if(event.target.currentCount%60==0){
				if(event.target.delay>=600){
				event.target.delay-=300;
				trace("Cambio rehalizado en el reloj");
				}	
			}
			if(event.target.currentCount%30==0){
				for(var i:int=0;i<ObtenerColor(1,3);i++){
					f_CrearEnemigoSinColor();	
				}				
			}
			if(event.target.currentCount%40==0){
				f_DestruirEnemigosSinColor();
			}
			
			
		}		
		
		protected function MouseDown(event:MouseEvent):void
		{
			
			upKeyDown=true;
			stage.addEventListener(Event.ENTER_FRAME,subirUp,false,0,true);

		}
		
		protected function subirUp(event:Event):void
		{
			jump_dis=0.075;
			//mainJumping=false;
			if(!mainJumping){
				mainJumping=true;
			}
			f_CrearImpulso();
			
			
		}		
		
		private function f_CrearImpulso():void
		{
			_impulso = new mc_laser();
			_impulso.x=_player.x+_impulso.width+13;
			_impulso.y=_player.y+_player.height;
			_impulso.addEventListener(Event.ENTER_FRAME,moverimpulso,false,0,true);
			this.addChild(_impulso);
			
		}		
		
		protected function moverimpulso(event:Event):void
		{
			if(event.target.y<stage.stageHeight){
			event.target.y+=10;
			}else{
			event.target.removeEventListener(Event.ENTER_FRAME,moverimpulso);
			removeChild(event.target as mc_laser);
			}
			
		}
		
		protected function MouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			upKeyDown=false;
			stage.removeEventListener(Event.ENTER_FRAME,subirUp);
			jump_dis=1;
			
			
		}
		
		
		protected function checkKeysUp(event:KeyboardEvent):void
		{
			if(event.keyCode == 38 || event.keyCode == 87 || event.keyCode == 32){
				upKeyDown = false;
			}
			
			if(event.keyCode == 39 || event.keyCode == 68){
				rightKeyDown = false;
				//	mc_player._Animacion_();
			}
			
			/*if(event.keyCode == 40 || event.keyCode == 83){
				mc_player._Animacion_();
				dash_flag=false;
			}*/
		}
		
		protected function checkKeysDown(event:KeyboardEvent):void
		{
			if(event.keyCode == 38 || event.keyCode == 87 || event.keyCode == 32 ){
				upKeyDown = true;
			}
			
			if(event.keyCode == 39 || event.keyCode == 68){
				rightKeyDown = true;
				
			}
			//enemigo abajo
			if(event.keyCode == 40 || event.keyCode == 83){
				f_CambiarColor();
				//f_CrearEnemigoSinColor();
			}
			if(event.keyCode ==9){
				f_DestruirEnemigosSinColor();
				
			}
			if(event.keyCode==20){
				f_InvocarRoca();
			}
		}
		
		private function f_CambiarColor():void
		{
			if(_enemigo_color==1 && _vida_color==2){
				_enemigo_color=2;
				_vida_color=1;
				_indicador.gotoAndStop(_enemigo_color);
				_indicador_vida.gotoAndStop(_vida_color);
			}else{
				_enemigo_color=1;
				_vida_color=2;
				_indicador.gotoAndStop(_enemigo_color);
				_indicador_vida.gotoAndStop(_vida_color);
			}
			
			
			
				
				//_indicador_vida.gotoAndStop(_vida_color);
			
			_indicador_vida.gotoAndStop(_vida_color);
			
		}
		
		private function f_InvocarRoca():void
		{
			_roca = new C_enemigo(ObtenerColor(1,2),6);
			_roca.x=600;
			_roca.y=0-_roca.height;
			_roca.addEventListener(Event.ENTER_FRAME,moverRoca,false,0,true);
			this.addChild(_roca);
		}
		
		protected function moverRoca(event:Event):void
		{
			if(event.target.y<463){
				event.target.y+=25;	
			}else{
				event.target.x-=Math.ceil(velocidad_enemigo*1.5*parallax);
			}
			
		}
		
		private function f_DestruirEnemigosSinColor():void
		{
			for(var i:int=0;i<arreglo_enemigosSColor.length;i++){
				arreglo_enemigosSColor[i].removeEventListener(Event.ADDED_TO_STAGE,MoverEnemigoSC);
				arreglo_enemigosSColor[i].removeEventListener(Event.ENTER_FRAME,LanzarRayo);
				TweenMax.to(arreglo_enemigosSColor[i], 1, {x:-200 });
			}
			arreglo_enemigosSColor = [];
			
		}		
		
		protected function moveChar(event:Event):void
		{
			if(upKeyDown || mainJumping ){
				mainJump();
				
			}
		}
		
		protected function CrearEnemigos(event:Event):void
		{
			//if(Math.random()>0.95){
				//Crear Enemigo 
			//	f_CrearEnemigo();	
		//	}
			
			/*if(Math.random()>0.99){
				f_CrearEnemigoSinColor();
			}*/
			
		}
		
		private function f_CrearEnemigoSinColor():void
		{
			_enemigo_sinColor = new C_enemigo(1,4);
			_enemigo_sinColor.y=0-_enemigo_sinColor.height;
			_enemigo_sinColor.x=600;
			_enemigo_sinColor.scaleX=_enemigo_sinColor.scaleY=2;
			_enemigo_sinColor.addEventListener(Event.ADDED_TO_STAGE,MoverEnemigoSC,false,0,true);
			_enemigo_sinColor.addEventListener(Event.ENTER_FRAME,LanzarRayo,false,0,true);
			arreglo_enemigosSColor.push(_enemigo_sinColor);
			this.addChild(_enemigo_sinColor);
			
		}
		
		protected function LanzarRayo(event:Event):void
		{
			contador_rayo++;
			if(contador_rayo%100==0){
				f_CrearTayo(event.target.x,event.target.y);
			}
			
		}
		
		private function f_CrearTayo(posX:int,posY:int):void
		{
			_rayo = new C_enemigo(ObtenerColor(1,2),5);
			_rayo.x=posX;
			_rayo.y=posY;
			_rayo.scaleX=_rayo.scaleY=2;
			_rayo.addEventListener(Event.ADDED_TO_STAGE,Moverrayo,false,0,true);
			_rayo.addEventListener(Event.ENTER_FRAME,validarColision,false,0,true);
			this.addChild(_rayo);
			
		}
		
		protected function validarColision(event:Event):void
		{
			
			if(event.target.hitTestObject(_player)){
				
				if(event.target.color==_enemigo_color){
					//_player.gotoAndStop(3);	
					f_CrearExplo(_player.x,_player.y);	
					event.target.removeEventListener(Event.ENTER_FRAME,validarColision);
					event.target.removeEventListener(Event.ADDED_TO_STAGE,Moverrayo);
					this.removeChild(event.target as C_enemigo);
					
					_vida--;
					myText.text = String(_vida);
					
					if(_vida<1){
						f_CrearMensaje();	
						myTimer.stop();		
					}
					
				}
				if(event.target.color==_vida_color){
					//_player.gotoAndStop(3);	
					//f_CrearExplo(_player.x,_player.y);
					TweenMax.to(event.target, 1, {x:_player.x+_player.width/2, y:_player.y+_player.height/2, scaleX:0, scaleY:0, tint:0xffffff});
					//event.target.addveEventListener(Event.ENTER_FRAME,validarColisionRayo,false,0,true);
					event.target.removeEventListener(Event.ENTER_FRAME,validarColision);
					event.target.removeEventListener(Event.ADDED_TO_STAGE,Moverrayo);	
					
					//this.removeChild(event.target as C_enemigo);
					_score+=100;
					myTextScore.text=String(_score);
				}
				
				
				
			}
		}
		
	/*	protected function validarColisionRayo(event:Event):void
		{
			if(event.target.hitTestObject(_enemigo_sinColor)){
				_enemigo_sinColor.x=stage.stageWidth;
				event.target.alpha=0;
				event.target.removeEventListener(Event.ENTER_FRAME,validarColisionRayo);
			}
			
		}*/
		
		protected function Moverrayo(event:Event):void
		{
			TweenMax.to(event.target, 1.5, {x:0-(event.target.width*2),y:_player.y+_player.height});
			
		}
		
		private function f_CrearEnemigo():void
		{
			var Tipo_enemigo:int = ObtenerColor(1,3);
			_enemigo_ = new C_enemigo(ObtenerColor(1,2),Tipo_enemigo);
			
			_enemigo_.x=stage.stageWidth;
			
			
			if(Tipo_enemigo==1){
				_enemigo_.y=(463+_player.height/2)+10 ;
				//Ajustar tamaño origianl
				_enemigo_.scaleX=_enemigo_.scaleY=2;
				//----------------------------------	
			}
			if(Tipo_enemigo==2){
				_enemigo_.y=433;
				_enemigo_.scaleX=_enemigo_.scaleY=2;
			}
			
			if(Tipo_enemigo==3){
				_enemigo_.y=ObtenerColor(200,400);
				_enemigo_.scaleX=_enemigo_.scaleY=2;
			}
			
			/*if(Tipo_enemigo==4){
				_enemigo_.y=ObtenerColor(150,350);
				_enemigo_.scaleX=_enemigo_.scaleY=1.75;
			}*/
		
			trace("El color de este enemigo es: " + _enemigo_.color);
			/*if(Tipo_enemigo!=4){*/
			_enemigo_.addEventListener(Event.ENTER_FRAME,MovimientoEnemigo,false,0,true);
		/*	}else{
			_enemigo_.addEventListener(Event.ADDED_TO_STAGE,MoverEnemigoSC,false,0,true);	
			}*/
			this.addChild(_enemigo_);
			
		}		
		
		protected function MoverEnemigoSC(event:Event):void
		{
			// TODO Auto-generated method stub
			TweenMax.to(event.target, 1, {y:ObtenerColor(200,400)});
			
		}
		
		protected function MovimientoEnemigo(event:Event):void
		{
			//haciendo el movimiento
			if(event.target.x>0-event.target.width){
				
			if(event.target.tipo==3){
				event.target.x-=Math.ceil((velocidad_enemigo*1.25)*parallax);	
			}else{
				event.target.x-=Math.ceil(velocidad_enemigo*parallax);
			}
				
			
			}else{
			//removiendo del escenario si salio de la pantalla	
			event.target.removeEventListener(Event.ENTER_FRAME,MovimientoEnemigo);	
			this.removeChild(event.target as C_enemigo);	
			trace("Enemigo Removido");
			}
			
			//codigo de impacto
			if(event.target.hitTestObject(_player)){
				
				if(event.target.color==_enemigo_color){
				//_player.gotoAndStop(3);	
				f_CrearExplo(_player.x,_player.y);	
				event.target.removeEventListener(Event.ENTER_FRAME,MovimientoEnemigo);	
				this.removeChild(event.target as C_enemigo);
				
				_vida--;
				myText.text = String(_vida);
				
				if(_vida<1){
					f_CrearMensaje();	
					myTimer.stop();		
				}
				
				}
				if(event.target.color==_vida_color){
					//_player.gotoAndStop(3);	
					//f_CrearExplo(_player.x,_player.y);
					event.target.removeEventListener(Event.ENTER_FRAME,MovimientoEnemigo);	
					TweenMax.to(event.target, 1, {x:_player.x+_player.width/2, y:_player.y+_player.height/2, scaleX:0, scaleY:0, tint:0xffffff});
					//this.removeChild(event.target as C_enemigo);
					
					/*if(_vida<10){
						_vida++;
						myText.text = String(_vida);
					}*/
					_score+=100;
					myTextScore.text=String(_score);
				}
				
				
				
			}
			
			
			
			
			
		}
		
		private function f_CrearMensaje():void
		{
			_mensaje = new mc_mensaje();
			_mensaje.x=stage.stageWidth/2-_mensaje.width/2;
			_mensaje.y=stage.stageHeight/2-_mensaje.height/2;
			this.addChild(_mensaje);
			
		}
		
		private function f_CrearExplo(posX:int,posY:int):void
		{
			_explo = new particula_expo();
			_explo.x=posX+200;
			_explo.y=posY+_explo.height*2;
			_explo.scaleX=_explo.scaleY=0;
			_explo.addEventListener(Event.ADDED_TO_STAGE,CrecerExplo,false,0,true);
			this.addChild(_explo);
			
		}
		
		protected function CrecerExplo(event:Event):void
		{
			TweenMax.to(event.target, 0.5, {scaleX:2.5,scaleY:2.5,ease:Cubic.easeOut});
			
		}
		
		private function ObtenerColor(Low:int, High:int):int
		{
			
			return Math.floor(Math.random()*(1+High-Low))+Low;
		}		
		
		private function f_CrearCiudad():void
		{
			_cielo = new f_cielo();
			this.addChild(_cielo);
			
			_pista = new f_mc_pista();
			_pista.y=stage.stageHeight-_pista.height;
			_pista.x=0;
			this.addChild(_pista);
			
			_front2 = new f_front2();
			_front2.y=_pista.y-_front2.height;
			_front2.x=0;
			this.addChild(_front2);
			
			_front1 = new f_front1();
			_front1.y=_pista.y-_front1.height;
			_front1.x=0;
			this.addChild(_front1);
			
			_player= new mc_jugador();
			_player.x=104.75;
			_player.y=463.3;
			//_player.scaleX=_player.scaleY=0.5;
			this.addChild(_player);
			
			_indicador = new mcx_indicador_malos();
			_indicador.x=(stage.stageWidth-stage.stageWidth/4)-_indicador.width/2;
			_indicador.y=10;
			_indicador.gotoAndStop(_enemigo_color);
			this.addChild(_indicador);
			
			_indicador_vida = new mc_barra_coger();
			_indicador_vida.x=stage.stageWidth/4-_indicador_vida.width/2;
			_indicador_vida.y=10;
			_indicador_vida.gotoAndStop(_vida_color);
			this.addChild(_indicador_vida);
			
			myFormat = new TextFormat();
			myFormat.size = 40;
			myFormat.align=TextFormatAlign.CENTER;
			
			myText = new TextField();
			myText.defaultTextFormat = myFormat;
			myText.textColor = 0xFF0000;
			myText.text = String(_vida);
			myText.y=10;
			myText.x=stage.stageWidth/2-myText.width/2;
			
			this.addChild(myText);
			
			myFormatScore = new TextFormat();
			myFormatScore.size = 30;
			myFormatScore.align=TextFormatAlign.CENTER;
			
			myTextScore = new TextField();
			myTextScore.defaultTextFormat = myFormatScore;
			myTextScore.textColor = 0xFFFFFF;
			myTextScore.text = String(_score);
			myTextScore.y=myText.y+50;
			myTextScore.x=stage.stageWidth/2-myTextScore.width/2;
			
			this.addChild(myTextScore);
				
			
		}
		
		
		
		protected function MoverTodo(event:Event):void
		{
			_pista.x-=Math.ceil(speed*parallax);
			if(_pista.x<-stage.stageWidth)_pista.x=0;
			
			_front1.x-=Math.ceil(speed*(parallax*0.5));
			if(_front1.x<-stage.stageWidth)_front1.x=0;
			
			_front2.x-=Math.ceil(speed*((parallax*0.5)*0.5));
			if(_front2.x<-stage.stageWidth)_front2.x=0;
			
			_cielo.x-=Math.ceil(speed*((parallax*0.5)*0.5)*0.5);
			if(_cielo.x<-stage.stageWidth)_cielo.x=0;
			
			//Incrementar velocidad
			contador++
			if(contador%100==0){
				if(speed<50){
				speed++;
				if(speed==15){
					//cambio de sprite
					flag_correr=true;
					_player.gotoAndStop(2);
					}
				}
			}
			
			//Incremento de velocida de obstaculos
			//velocidad_enemigo
			if(contador%200==0){
				//Cambiando el color del enemigo que nos hace daño
				_enemigo_color=ObtenerColor(1,2);
				_indicador.gotoAndStop(_enemigo_color);
				trace("EL NUEVO COLOR ES: " + _enemigo_color);				
				//-------------------------------------------------
				if(_enemigo_color==1){
					_vida_color=2;
					//_indicador_vida.gotoAndStop(_vida_color);
				}else {
						_vida_color=1;
				}
				_indicador_vida.gotoAndStop(_vida_color);
				//-------------------------------------------------
				if(velocidad_enemigo<15){
				velocidad_enemigo++;
				}
			}
		}
		
		private function mainJump():void
		{
			
			
			if(!mainJumping){	
				
				//---------------------------
				//Animacion salto_player.Animacion_();
				_player.gotoAndStop(3);
				//---------------------------
				
				mainJumping = true;
				jumpSpeed = jumpSpeedLimit*-jump_dis;
				_player.y += jumpSpeed;		
			} else {
				
				if(jumpSpeed < 0){
					jumpSpeed *= 1 - jumpSpeedLimit/250;
					if(jumpSpeed > -jumpSpeedLimit/5){
						jumpSpeed *= -jump_dis;
					}
				}
				if(jumpSpeed > 0 && jumpSpeed <= jumpSpeedLimit){
					jumpSpeed *= jump_dis + jumpSpeedLimit/20;
				}
				_player.y += jumpSpeed;
				
				if(_player.y >= (stage.stageHeight -35) - _player.height){
					mainJumping = false;
					_player.y = (stage.stageHeight -35) - _player.height;
					
					if(!flag_correr){
					_player.gotoAndStop(1);	
					}else{
					_player.gotoAndStop(2);		
					}
					//Animacion salto _player._Animacion_();	
					
					
				}
			}
			
		}
		
	}
}