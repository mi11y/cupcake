namespace Cupcake {
    public class Application : Gtk.Application {
        public Application() {
            Object (
                application_id: "com.github.mi11y.cupcake",
                flags: ApplicationFlags.FLAGS_NONE
            );
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
