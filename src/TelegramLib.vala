public errordomain TelegramLibError {
	INVALID_FORMAT
}

public class TelegramLib : Object {

    // Main Window
    private Cupcake.MainWindow cupcake_window = null;

    // State Classes
    private AuthorizationState authorization_state;

    // Constants
    public const double WAIT_TIMEOUT = 10.0;

    // Identifiers
    private int client_id = 0;

    public TelegramLib(Cupcake.MainWindow cupcake_window) { 
        Object();
    }

    construct {
        // We need a client id (aka instance id) to deal with TDLib. 
        client_id = TDJsonApi.create_client_id();

        authorization_state = new AuthorizationState(client_id);

        //  Disable default TDLib log stream
        TDJsonApi.execute("{\"@type\": \"setLogStream\", \"log_stream\": {\"@type\": \"logStreamEmpty\"}}");
    
        //  Set log callback 
        TDJsonApi.set_log_message_callback(1024, (TDJsonApi.log_message_callback_ptr) log_callback);
    
        //  Set TDLib log verbosity level to 1023 (log everything)
        TDJsonApi.execute("{\"@type\": \"setLogVerbosityLevel\", \"new_verbosity_level\": 1023}");

        TDJsonApi.send(client_id, "{\"@type\": \"getOption\", \"name\": \"version\"}");
    }

    public void begin() {
        Json.Parser json_parser = new Json.Parser();
        while(true) {
            string raw_json = TDJsonApi.receive(WAIT_TIMEOUT);
            if(raw_json == null) { continue; }
            try {
                json_parser.load_from_data(raw_json);
                Json.Node root_node = json_parser.get_root();
                process(root_node);
            } catch (Error e) {
                cupcake_window.update_label_text(e.message);
            }
        }
    }

    private void process(Json.Node response_node) throws TelegramLibError.INVALID_FORMAT {
        if (response_node.get_node_type() != Json.NodeType.OBJECT) {
            throw new TelegramLibError.INVALID_FORMAT("Unexpected element type %s", response_node.type_name());
        }

        unowned Json.Object json_object = response_node.get_object();

        string response_type = json_object.get_string_member("@type");
        switch (response_type) {
            case "updateAuthorizationState":
                authorization_state.handle_update_authorization_state(json_object);
                break;
            default:
                break;
        }
    }


    public static void log_callback(int log_level, string message){
        print("LOG: "+ message + "\n");
    }
}