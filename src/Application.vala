public class Cupcake : Gtk.Application {
    public Cupcake() {
        Object (
            application_id: "com.github.mi11y.cupcake",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate() {
        var login_button = new Gtk.Button.with_label("Sign In") {
            margin_top = 12,
            margin_bottom = 12,
            margin_start = 12,
            margin_end = 12
        };
        
        login_button.clicked.connect(() => {
            login_button.label = "Login?";
            login_button.sensitive = false;
        });
        
        var main_window = new Gtk.ApplicationWindow(this) {
            default_height = 500,
            default_width = 500,
            title = "Cupcake"
        };
        main_window.child = login_button;
        main_window.present();
    }
    
    public static int main(string[] args) {
        return new Cupcake().run(args);
    }
}
