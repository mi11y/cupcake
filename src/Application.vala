public class Cupcake : Gtk.Application {
    private const string TD_LIB_THREAD = "td_lib_thread";
    private Gtk.Label message_text = null;
    private Thread<void> td_lib_thread = null;

    public Cupcake() {
        Object (
            application_id: "com.github.mi11y.cupcake",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate() {
        td_lib_thread = new Thread<void>(TD_LIB_THREAD, begin_telegram_lib);
        message_text = new Gtk.Label("Nothing to see here...");    
        var main_window = new Gtk.ApplicationWindow(this) {
            default_height = 500,
            default_width = 500,
            title = _("Cupcake")
        };
        main_window.child = message_text;
        main_window.present();
    }

    public void updateLabelText(string new_label) {
        message_text.set_label(new_label);
    }

    private void begin_telegram_lib() {
        new TelegramLib(this).begin();
    }
    
    public static int main(string[] args) {
        return new Cupcake().run(args);
    }
}
