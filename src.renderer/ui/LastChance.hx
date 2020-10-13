package ui;

class LastChance extends dn.Process {
	static var CUR : Null<LastChance>;
	var elem : js.jquery.JQuery;

	public function new(str:dn.data.GetText.LocaleString, project:data.Project) {
		super(Editor.ME);

		LastChance.end();
		CUR = this;
		var json = project.toJson();

		elem = new J("xml#lastChance").clone().children().first();
		elem.appendTo(App.ME.jBody);
		elem.find(".action").text(str);

		elem.find("button").click( function(ev) {
			if( !isActive() )
				return;
			Editor.ME.selectProject( data.Project.fromJson(json) );
			ui.modal.Dialog.closeAll();
			N.msg( L.t._("Canceled action: \"::act::\"", {act:str}) );
			hide();
		});

		delayer.addS(hide, 20);
		cd.setF("ignoreFrame",1);

		Editor.ME.ge.addGlobalListener(onGlobalEvent);
	}

	function onGlobalEvent(e:GlobalEvent) {
		switch(e) {
			case ViewportChanged:
			case LevelSelected:
			case LayerInstanceSelected:
			case LayerInstanceVisiblityChanged(li):
			case ToolOptionChanged:

			case _:
				LastChance.end();
		}
	}

	public static function end() {
		if( CUR!=null && CUR.isActive() && !CUR.cd.has("ignoreFrame") ) {
			CUR.hide();
		}
	}

	function isActive() {
		return !destroyed && !cd.has("hiding");
	}

	function hide() {
		if( !isActive() )
			return;

		cd.setS("hiding",Const.INFINITE);
		elem.slideUp(100, function(_) destroy());
	}

	override function onDispose() {
		super.onDispose();

		Editor.ME.ge.removeListener(onGlobalEvent);
		elem.remove();
		elem = null;

		if( CUR==this )
			CUR = null;
	}
}