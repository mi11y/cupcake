namespace Cupcake {
    public class MainWindow : Gtk.ApplicationWindow {

        private Cupcake.Application app;

        // Widgets
        private Gtk.Label message_text = null;

        // Constants
        private const string TD_LIB_THREAD = "td_lib_thread";

        // Threads
        private Thread<void> td_lib_thread = null;

        public MainWindow() { }

        construct {
            application = ((Gtk.Application)(GLib.Application.get_default()));
            app = (Cupcake.Application) application;

            td_lib_thread = new Thread<void>(TD_LIB_THREAD, begin_telegram_lib);
            message_text = new Gtk.Label("Nothing to see here...");    
            this.child = message_text;
            this.default_height = 500;
            this.default_width = 500;
            this.title = "Cupcake";
        }

        public void update_label_text(string new_label) {
            message_text.set_label(new_label);
        }

        private void begin_telegram_lib() {
            new TelegramLib(this).begin();
        }
    }
}