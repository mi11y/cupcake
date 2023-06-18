namespace Cupcake {
    public class WelcomeView : Gtk.Box {

        private string title = _("Welcome!");
        private string loading_description = _("Hang tight, we're getting set up with Telegram.");
        private string ask_for_phone_number = _("Telegram wants you to please confirm your country code and phone number.");

        // Constants
        private const string PROGRESS_BAR_THREAD = "welcome_view_progress_bar";

        // Widgets
        private Gtk.Label description_label;
        private Gtk.ProgressBar progress_bar;
        private Gtk.Box header_area;

        // Threads
        private Thread<void> progress_bar_thread = null;

        private bool busy = true;

        public WelcomeView() { }

        construct {
            var title_label = new Gtk.Label (title) {
                halign = Gtk.Align.CENTER,
                justify = Gtk.Justification.CENTER,
                wrap = true,
                max_width_chars = 50,
                use_markup = true
            };
            title_label.add_css_class (Granite.STYLE_CLASS_H1_LABEL);

            description_label = new Gtk.Label (loading_description) {
                halign = Gtk.Align.CENTER,
                justify = Gtk.Justification.CENTER,
                wrap = true,
                max_width_chars = 50,
                use_markup = true
            };
            description_label.add_css_class (Granite.STYLE_CLASS_DIM_LABEL);

            progress_bar = new Gtk.ProgressBar ();

            header_area = new Gtk.Box (Gtk.Orientation.VERTICAL, 3);

            header_area.append (title_label);
            header_area.append (description_label);
            header_area.append (progress_bar);

            append (header_area);
        }

        public void start_progress_bar_thread () {
            progress_bar_thread = new Thread<void> (PROGRESS_BAR_THREAD, pulse_forever);
        }

        public void stop_progress_bar_thread () {
            busy = false;
            description_label.set_label (ask_for_phone_number);
            header_area.remove (progress_bar);
            
        }

        public void pulse_forever () {
            while(busy) {
                progress_bar.pulse ();
            }
            Thread.exit (null);
        }
    }
}