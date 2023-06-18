namespace Cupcake {
    public class Application : Gtk.Application {
        public Application() {
            Object (
                application_id: "com.github.mi11y.cupcake",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        protected override void startup () {
            base.startup ();
    
            var granite_settings = Granite.Settings.get_default ();
            var gtk_settings = Gtk.Settings.get_default ();
    
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
    
            granite_settings.notify["prefers-color-scheme"].connect (() => {
                gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
            });
        }
        
        protected override void activate() {
            if(active_window == null) {
                add_window(new MainWindow());
            }
            active_window.present();
        }

        public static int main(string[] args) {
            return new Cupcake.Application().run(args);
        }
    }
}
