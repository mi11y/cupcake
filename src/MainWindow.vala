namespace Cupcake {
    public class MainWindow : Gtk.ApplicationWindow {

        private Cupcake.Application app;
        private TelegramLib telegram_lib;

        // Widgets
        private Gtk.Label message_text = null;
        private Adw.Carousel carousel;

        // Constants
        private const string TD_LIB_THREAD = "td_lib_thread";

        // Threads
        private Thread<void> td_lib_thread = null;

        public MainWindow () { }

        construct {
            application = ((Gtk.Application)(GLib.Application.get_default()));
            app = (Cupcake.Application) application;
            telegram_lib = new TelegramLib (this);

            carousel = new Adw.Carousel () {
                hexpand = true,
                vexpand = true,
                valign = Gtk.Align.CENTER
            };

            var welcome_view = new Cupcake.WelcomeView ();

            telegram_lib.waiting_for_telegram.connect (welcome_view.start_progress_bar_thread);
            telegram_lib.done_waiting_for_telegram.connect (welcome_view.stop_progress_bar_thread);

            carousel.append (welcome_view);
            
            this.child = carousel;
            this.default_height = 500;
            this.default_width = 500;
            this.title = "Cupcake";

            td_lib_thread = new Thread<void> (TD_LIB_THREAD, begin_telegram_lib);
        }

        public void update_label_text(string new_label) {
            message_text.set_label (new_label);
        }

        private void begin_telegram_lib() {
            telegram_lib.begin ();
        }
    }
}