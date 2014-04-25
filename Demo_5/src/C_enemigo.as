package
{
	import flash.display.Sprite;
	
	public class C_enemigo extends Sprite
	{
		private var _enemigo:_enemigo_mc;
		private var _enemigo_2:mc_enemig_alto;
		private var _enemigo_v1:mc_enemigo_volador;
		private var _enemigo_noc:enemigo_sinColor;
		private var _roca:mc_roca;
		private var _rayo:mc_rayo;
		private var _color:int;
		private var _tipo:int;
		
		public function C_enemigo(_color_:int,tipo:int)
		{
			super();
			f_crearEnemigo(_color_,tipo);
			_color=_color_;
			_tipo=tipo;
		}
		
		public function get tipo():int
		{
			return _tipo;
		}

		public function set tipo(value:int):void
		{
			_tipo = value;
		}

		public function get color():int
		{
			return _color;
		}

		public function set color(value:int):void
		{
			_color = value;
		}

		private function f_crearEnemigo(_color_:int,tipo:int):void
		{
			if(tipo==1){
			_enemigo = new _enemigo_mc();
			_enemigo.gotoAndStop(_color_);
			this.addChild(_enemigo);
			}
			if(tipo==2){
				_enemigo_2 = new mc_enemig_alto();
				_enemigo_2.gotoAndStop(_color_);
				this.addChild(_enemigo_2);	
			}
			
			if(tipo==3){
				_enemigo_v1 = new mc_enemigo_volador();
				_enemigo_v1.gotoAndStop(_color_);
				this.addChild(_enemigo_v1);	
			}
			
			if(tipo==4){
				_enemigo_noc = new enemigo_sinColor();
				this.addChild(_enemigo_noc);
			}
			
			if(tipo==5){
				_rayo = new mc_rayo();
				_rayo.gotoAndStop(_color_);
				this.addChild(_rayo);
			}
			
			if(tipo==6){
				_roca = new mc_roca();
				_roca.gotoAndStop(_color_);
				this.addChild(_roca);
			}
			
		}
	}
}