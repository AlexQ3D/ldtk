import dn.data.GetText;

class Lang {
    // Text constants
    public static var _Duplicate = ()->t._("Duplicate");
    public static var _Delete = ()->t._("Delete");


    // Misc
    static var _initDone = false;
    static var DEFAULT = "en";
    public static var CUR = "??";
    public static var t : GetText;


    public static function init(?lid:String) {
        if( _initDone )
            return;

        _initDone = true;
        CUR = lid==null ? DEFAULT : lid;

		t = new GetText();
		t.readMo( hxd.Res.load("lang/"+CUR+".mo").entry.getBytes() );
    }

    public static function untranslated(str:Dynamic) : LocaleString {
        init();
        return t.untranslated(str);
    }

    public static function getLayerType(type:data.LedTypes.LayerType) : LocaleString {
        return switch type {
            case IntGrid: Lang.t._("Integer grid");
            case AutoLayer: Lang.t._("Auto-layer");
            case Entities: Lang.t._("Entities");
            case Tiles: Lang.t._("Tiles");
        }
    }

    public static function getFieldType(type:data.LedTypes.FieldType) : LocaleString {
        return switch type {
            case F_Int: t._("Integer");
            case F_Color: t._("Color");
            case F_Float: t._("Float");
            case F_String(multilines): multilines ? t._("Multi-lines") : t._("String");
            case F_Bool: t._("Boolean");
            case F_Point: t._("Point");
            case F_Enum(name): name==null ? t._("Enum") : t._("Enum.::e::", { e:name });
        }
    }

    public static function getFieldTypeShortName(type:data.LedTypes.FieldType) : LocaleString {
        return switch type {
            case F_Int: t._("123");
            case F_Color: t._("Red");
            case F_Float: t._("1.0");
            case F_String(multilines): t._("\"Ab\"");
            case F_Bool: t._("✔");
            case F_Point: t._("X::sep::Y", { sep:Const.POINT_SEPARATOR });
            case F_Enum(name): t._("Enu");
        }
    }
}